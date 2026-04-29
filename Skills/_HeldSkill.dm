// AutoHits and Projectiles apply this by setting HeldSkill = TRUE
// The skill's verb should call usr.BeginHeldSkill(src) instead of
// usr.Activate(src). The system installs a temporary KEY+UP macro
// on whichever key the player has the skill bound to, so they only
// need to bind the skill itself - no second macro required.
// Override OnHeldRelease(mob/p, benefit) to execute the skill.

// ChargeBenefit is 0-1 (progress through ChargePeriod)
// During the SweetSpot window it is multiplied by SweetSpotBenefit,
// which can push it above 1.0.

/obj/Skills
	var/HeldSkill        = FALSE  // Enable held-charge behavior for this skill
	var/ChargePeriod     = 3      // Max hold time in seconds, hold too long = fizzle
	var/SweetSpot        = 0      // Seconds from charge start when sweet spot opens (0 = disabled)
	var/SweetSpotBenefit = 1.5    // ChargeBenefit multiplier inside the sweet spot window
	var/ChargeOverlay    = null   // Icon displayed on mob while charging
	var/ChargeWaveIcon   = 'Icons/Effects/KenShockwave.dmi'  // Icon for periodic charge shockwave
	var/ChargeWaveBlend  = 1      // Blend mode for the periodic charge shockwave
	var/ChargeBenefit    = 0      // Set on release
	var/HeldVerbName     = null   // Optional override for macro detection;
	                              // defaults to Z.name if null

/obj/Skills/proc/OnHeldRelease(mob/p, var/benefit)
	// Override in individual skills to execute the charged attack.

// Charge state

/mob
	var/tmp/obj/Skills/held_skill         = null
	var/tmp/held_charge_start             = 0
	var/tmp/image/held_charge_overlay_ref = null
	var/tmp/held_skill_macro_active       = FALSE

// normalizes a name for case/underscore-tolerant comparison

/proc/_normalizeHeldName(s)
	if(!s) return ""
	s = replacetext(s, "_", " ")
	return lowertext(s)

// BeginHeldSkill is called by the skill's verb instead of Activate

/mob/proc/BeginHeldSkill(var/obj/Skills/Z)
	if(held_skill) return  // Already charging something
	if(!Z || !Z.HeldSkill) return
	var/client/C = client
	if(!C) return

	// Find which key the player has bound this skill to
	var/key = findHeldSkillKey(C, Z)
	if(!key)
		src << "<font color='red'>Bind [Z.name] to a key first.</font>"
		return

	// Install a temporary KEY+UP macro pointing at Release_Held_Skill
	installHeldReleaseMacro(C, key)

	held_skill        = Z
	held_charge_start = world.time
	Z.ChargeBenefit   = 0

	if(Z.ChargeOverlay)
		var/image/I = image(Z.ChargeOverlay)
		I.layer = MOB_LAYER + 0.1
		held_charge_overlay_ref = I
		overlays += I

	spawn() ChargeLoop(Z)

// findHeldSkillKey searches every macro set the player has for a
// macro whose command matches this skill's verb, and returns the key.

/mob/proc/findHeldSkillKey(client/C, obj/Skills/Z)
	var/raw_search = Z.HeldVerbName ? Z.HeldVerbName : Z.name
	if(!raw_search) return null
	var/search = _normalizeHeldName(raw_search)

	var/list/sets = params2list(winget(C, null, "macro"))
	for(var/set_name in sets)
		var/macros_str = winget(C, set_name, "macros")
		if(!macros_str) continue

		var/list/macro_ids = splittext(macros_str, ";")
		if(macro_ids.len <= 1)
			macro_ids = splittext(macros_str, ",")

		for(var/raw_id in macro_ids)
			var/macro_id = "[raw_id]"
			if(!macro_id) continue

			var/qualified = "[set_name].[macro_id]"
			var/cmd = winget(C, qualified, "command")
			if(!cmd) cmd = winget(C, macro_id, "command")
			if(!cmd) continue

			if(findtext(_normalizeHeldName(cmd), search))
				var/key = winget(C, qualified, "name")
				if(!key) key = winget(C, macro_id, "name")
				// Skip release-form macros
				if(key && !findtext(key, "+UP"))
					return key

	return null

// installHeldReleaseMacro installs a KEY+UP macro in every macro set,
// pointing to the Release Held Skill verb.

/mob/proc/installHeldReleaseMacro(client/C, key)
	var/list/sets = params2list(winget(C, null, "macro"))
	for(var/set_name in sets)
		winset(C, "heldskill_release_[set_name]", "parent=[set_name];name=[key]+UP;command=Release Held Skill")
	held_skill_macro_active = TRUE

// clearHeldReleaseMacro removes the temporary release macro from all sets

/mob/proc/clearHeldReleaseMacro()
	if(!held_skill_macro_active || !client) return
	var/list/sets = params2list(winget(client, null, "macro"))
	for(var/set_name in sets)
		winset(client, "heldskill_release_[set_name]", "name=")
	held_skill_macro_active = FALSE

// ChargeLoop runs for the duration of the hold

/mob/proc/ChargeLoop(var/obj/Skills/Z)
	var/last_wave_time = world.time

	while(held_skill == Z)
		sleep(2)
		if(held_skill != Z) return

		// Interrupt conditions
		var/obj/Skills/Buffs/SlotlessBuffs/Autonomous/Debuff/Charmed/charm_skill = locate(/obj/Skills/Buffs/SlotlessBuffs/Autonomous/Debuff/Charmed) in src
		if(Stunned || Launched || Stasis > 0 || (charm_skill && BuffOn(charm_skill)))
			FizzleHeldSkill(Z)
			return

		// Overheld fizzle
		if(world.time - held_charge_start > Z.ChargePeriod * 10)
			FizzleHeldSkill(Z)
			return

		// Periodic shockwave
		if(world.time >= last_wave_time + 10)
			last_wave_time = world.time
			KenShockwave(src, icon=Z.ChargeWaveIcon, Size=0.5, Blend=Z.ChargeWaveBlend, Time=8)

// ReleaseHeldSkill is called by the Release_Held_Skill verb (KEY+UP macro)

/mob/proc/ReleaseHeldSkill()
	var/obj/Skills/Z = held_skill
	if(!Z) return

	var/hold_ticks = world.time - held_charge_start

	// Overheld
	if(hold_ticks > Z.ChargePeriod * 10)
		FizzleHeldSkill(Z)
		return

	// ChargeBenefit is 0-1 based on progress through ChargePeriod
	var/benefit = clamp(hold_ticks / (Z.ChargePeriod * 10), 0.0, 1.0)

	// Sweet spot window is SweetSpot to SweetSpot + 0.25s
	if(Z.SweetSpot && hold_ticks >= Z.SweetSpot * 10 && hold_ticks <= Z.SweetSpot * 10 + 3)
		benefit *= Z.SweetSpotBenefit

	Z.ChargeBenefit = benefit
	ClearHeldChargeState()
	Z.OnHeldRelease(src, benefit)

// FizzleHeldSkill for skill being overheld, interrupted, or cancelled

/mob/proc/FizzleHeldSkill(var/obj/Skills/Z)
	if(held_skill != Z) return
	ClearHeldChargeState()
	Z.Cooldown(1, null, src)
	src << "<font color='red'>Your technique fizzled!</font>"

// Cleanup

/mob/proc/ClearHeldChargeState()
	clearHeldReleaseMacro()
	if(held_charge_overlay_ref)
		overlays -= held_charge_overlay_ref
		held_charge_overlay_ref = null
	held_skill        = null
	held_charge_start = 0

// Internal verb fired by the temporary KEY+UP macro the system installs.

/mob/verb/Release_Held_Skill()
	set name = "Release Held Skill"
	set hidden = 1
	set instant = 1
	if(usr.held_skill)
		usr.ReleaseHeldSkill()
