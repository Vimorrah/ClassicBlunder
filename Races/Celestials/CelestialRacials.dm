mob/proc/warp_strike_restore_color()
	set waitfor = FALSE
	if(!src) return
	var/fade_ticks = 8
	var/list/color_list = islist(src.MobColor) ? src.MobColor : list(1,0,0, 0,1,0, 0,0,1, 0,0,0)
	var/r_end = length(color_list) >= 10 ? color_list[10] : 0
	var/g_end = length(color_list) >= 11 ? color_list[11] : 0
	var/b_end = length(color_list) >= 12 ? color_list[12] : 0
	for(var/tick = 0 to fade_ticks - 1)
		if(!src) return
		var/t = (tick + 1) / fade_ticks
		var/r = 1 - t * (1 - r_end)
		var/g = 1 - t * (1 - g_end)
		var/b = 1 - t * (1 - b_end)
		animate(src, color=list(1,0,0, 0,1,0, 0,0,1, r, g, b), time=1)
		sleep(1)
	if(src)
		animate(src, color=color_list, time=1)

mob/proc/GrantCelestialWeapon(path)
	if(!path) return
	var/obj/Items/I = locate(path) in src.contents
	if(!I)
		I = new path
		I.Move(src)
		I.Ascended = src.AscensionsAcquired
		I.Owner = src.key
		src << "<font color='#ffe4b5'><b>[I.name]</b> materializes in a flash of divine light!</font>"
	else
		I.Ascended = src.AscensionsAcquired
		I.AlignEquip(src)
mob/proc/ReclaimCelestialWeapon(path)
	if(!path) return
	if(locate(path) in src.contents)
		src << "[path] is already in your possession."
		return
	var/obj/Items/I
	for(var/obj/Items/G in world)
		if(istype(G, path) && G.Owner == src.key)
			I = G
			break
	if(I)
		I.Move(src)
		I.Ascended = src.AscensionsAcquired
		src << "<font color='#ffe4b5'><b>[I.name]</b></font> returns to your side in a flash of light!"
		return
	I = new path(src)
	I.Owner = src.key
	I.Ascended = src.AscensionsAcquired
	I.AlignEquip(src)
	src << "<font color='#ffe4b5'><b>[I.name]</b></font> rematerializes from the heavens!"

mob/proc/ChooseCelestialWeapon()
	var/list/AllWeapons = list(\
		"Light Celestial Blade I" = /obj/Items/Sword/Celestial/Light/Light_Celestial_Blade_I,\
		"Light Celestial Blade II" = /obj/Items/Sword/Celestial/Light/Light_Celestial_Blade_II,\
		"Light Celestial Blade III" = /obj/Items/Sword/Celestial/Light/Light_Celestial_Blade_III,\
		"Medium Celestial Blade I" = /obj/Items/Sword/Celestial/Medium/Medium_Celestial_Blade_I,\
		"Medium Celestial Blade II" = /obj/Items/Sword/Celestial/Medium/Medium_Celestial_Blade_II,\
		"Medium Celestial Blade III" = /obj/Items/Sword/Celestial/Medium/Medium_Celestial_Blade_III,\
		"Heavy Celestial Blade I" = /obj/Items/Sword/Celestial/Heavy/Heavy_Celestial_Blade_I,\
		"Heavy Celestial Blade II" = /obj/Items/Sword/Celestial/Heavy/Heavy_Celestial_Blade_II,\
		"Heavy Celestial Blade III" = /obj/Items/Sword/Celestial/Heavy/Heavy_Celestial_Blade_III,\
		"Celestial Wand I" = /obj/Items/Enchantment/Staff/Celestial/Wand/Celestial_Wand_I,\
		"Celestial Wand II" = /obj/Items/Enchantment/Staff/Celestial/Wand/Celestial_Wand_II,\
		"Celestial Wand III" = /obj/Items/Enchantment/Staff/Celestial/Wand/Celestial_Wand_III,\
		"Celestial Rod I" = /obj/Items/Enchantment/Staff/Celestial/Rod/Celestial_Rod_I,\
		"Celestial Rod II" = /obj/Items/Enchantment/Staff/Celestial/Rod/Celestial_Rod_II,\
		"Celestial Rod III" = /obj/Items/Enchantment/Staff/Celestial/Rod/Celestial_Rod_III,\
		"Celestial Staff I" = /obj/Items/Enchantment/Staff/Celestial/Staff_Class/Celestial_Staff_I,\
		"Celestial Staff II" = /obj/Items/Enchantment/Staff/Celestial/Staff_Class/Celestial_Staff_II,\
		"Celestial Staff III" = /obj/Items/Enchantment/Staff/Celestial/Staff_Class/Celestial_Staff_III)
	while(src && src.client)
		var/list/available = list()
		for(var/wname in AllWeapons)
			var/path = AllWeapons[wname]
			if(!locate(path) in src.contents)
				available[wname] = path
		if(!available.len)
			src << "<font color='#ffe4b5'>You have already obtained all celestial armaments.</font>"
			return
		var/choice = input(src, "Choose a celestial weapon to manifest.", "Master of Arms") as null|anything in available
		if(!choice) return
		var/chosen_path = available[choice]
		if(!chosen_path) continue
		if(locate(chosen_path) in src.contents)
			src << "<font color='#ffe4b5'>You already possess that weapon. Choose another.</font>"
			continue
		src.GrantCelestialWeapon(chosen_path)
		return

obj/Skills/Utility/Recall_Celestial_Armaments
	verb/Recall_Celestial_Armaments()
		set category="Utility"
		set name = "Recall Celestial Armaments"
		if(usr.Dead && !usr.KeepBody)
			usr << "You cannot summon divine artifacts while dead."
			return
		for(var/obj/Items/Sword/Celestial/S in world)
			if(S.Owner == usr.key && !(S in usr.contents))
				S.Move(usr)
				S.Ascended = usr.AscensionsAcquired
				usr << "<font color='#ffe4b5'><b>[S.name]</b></font> returns to your side in a flash of light!"
		for(var/obj/Items/Enchantment/Staff/Celestial/S in world)
			if(S.Owner == usr.key && !(S in usr.contents))
				S.Move(usr)
				S.Ascended = usr.AscensionsAcquired
				usr << "<font color='#ffe4b5'><b>[S.name]</b></font> returns to your side in a flash of light!"
		OMsg(usr, "[usr] calls their sacred armaments home in a blaze of divine light!")

// =============================================
// SWORDS - CELESTIAL BASE
// =============================================
/obj/Items/Sword/Celestial
	Stealable = 0
	Destructable = 0
	Augmented = 1
	ShatterCounter = 800
	ShatterMax = 800
	SubType = "Weapons"
	AlignEquip(mob/A, dontUnEquip = FALSE)
		src.Ascended = A.AscensionsAcquired
		..()
	ObjectUse(mob/Players/User=usr)
		if(src.suffix == "*Equipped (Armory)*")
			if(User.transActive && User.race && User.race.transformations && User.race.transformations[User.transActive] && User.race.transformations[User.transActive].type == /transformation/celestial/Master_of_Arms)
				User << "You cannot unequip armory weapons while Master of Arms is active!"
				return
			src.suffix = null
			if(current_passives)
				User.passive_handler.decreaseList(current_passives)
			return
		if(!src.suffix && User.passive_handler.Get("DivineArmory"))
			var/obj/Items/Sword/sord = User.EquippedSword()
			var/obj/Items/Enchantment/Staff/staf = User.EquippedStaff()
			if((sord && sord != src) || staf)
				src.Ascended = User.AscensionsAcquired
				src.suffix = "*Equipped (Armory)*"
				if(passives)
					current_passives = passives
					User.passive_handler.increaseList(passives)
				return
		..()

// =============================================
// SWORDS - LIGHT CLASS
// =============================================
	Light
		Light_Celestial_Blade_I
			name = "Light Celestial Blade I"
			desc = "A swift celestial sword. (Placeholder)"
			icon = 'LightSword.dmi'
			Class = "Light"
			passives = list("Godspeed" = 1)
			DamageEffectiveness = 1.025
			AccuracyEffectiveness = 0.9
			SpeedEffectiveness = 1.25
			ObjectUse(mob/Players/User=usr)
				src.passives = list("Godspeed" = (User.Potential / 10))
				..()
		Light_Celestial_Blade_II
			name = "Light Celestial Blade II"
			desc = "A swift celestial sword. (Placeholder)"
			icon = 'LightSword.dmi'
			Class = "Light"
			passives = list("Duelist" = 1)
			DamageEffectiveness = 1.025
			AccuracyEffectiveness = 0.9
			SpeedEffectiveness = 1.25
			ObjectUse(mob/Players/User=usr)
				src.passives = list("Duelist" = 1 + (User.Potential / 25))
				..()

		Light_Celestial_Blade_III
			name = "Light Celestial Blade III"
			desc = "A swift celestial sword. (Placeholder)"
			icon = 'LightSword.dmi'
			Class = "Light"
			passives = list("DoubleStrike" = 1)
			DamageEffectiveness = 1.025
			AccuracyEffectiveness = 0.9
			SpeedEffectiveness = 1.25
			ObjectUse(mob/Players/User=usr)
				src.passives = list("DoubleStrike" = 1 + (User.Potential / 50))
				..()

// =============================================
// SWORDS - MEDIUM CLASS
// =============================================
	Medium
		Medium_Celestial_Blade_I
			name = "Medium Celestial Blade I"
			desc = "A balanced celestial sword. (Placeholder)"
			icon = 'MediumSword.dmi'
			Class = "Medium"
			passives = list("Half-Sword" = 1)
			DamageEffectiveness = 1.05
			AccuracyEffectiveness = 0.875
			SpeedEffectiveness = 1
			ObjectUse(mob/Players/User=usr)
				src.passives = list("Half-Sword" = 1 + (User.Potential / 50))
				..()
		Medium_Celestial_Blade_II
			name = "Medium Celestial Blade II"
			desc = "A balanced celestial sword. (Placeholder)"
			icon = 'MediumSword.dmi'
			Class = "Medium"
			passives = list("SpiritSword" = 1)
			DamageEffectiveness = 1.05
			AccuracyEffectiveness = 0.875
			SpeedEffectiveness = 1
			ObjectUse(mob/Players/User=usr)
				src.passives = list("SpiritSword" = (User.Potential / 50))
				..()
		Medium_Celestial_Blade_III
			name = "Medium Celestial Blade III"
			desc = "A balanced celestial sword. (Placeholder)"
			icon = 'MediumSword.dmi'
			Class = "Medium"
			passives = list("Steady" = 1)
			DamageEffectiveness = 1.05
			AccuracyEffectiveness = 0.875
			SpeedEffectiveness = 1
			ObjectUse(mob/Players/User=usr)
				src.passives = list("Steady" = (User.Potential / 10))
				..()

// =============================================
// SWORDS - HEAVY CLASS
// =============================================
	Heavy
		Heavy_Celestial_Blade_I
			name = "Heavy Celestial Blade I"
			desc = "A powerful celestial sword. (Placeholder)"
			icon = 'Sheath Taco In Sword.dmi'
			Class = "Heavy"
			passives = list("SweepingStrike" = 1)
			DamageEffectiveness = 1.1
			AccuracyEffectiveness = 0.8
			SpeedEffectiveness = 0.8
		Heavy_Celestial_Blade_II
			name = "Heavy Celestial Blade II"
			desc = "A powerful celestial sword. (Placeholder)"
			icon = 'Sheath Taco In Sword.dmi'
			Class = "Heavy"
			passives = list("Extend" = 1)
			DamageEffectiveness = 1.1
			AccuracyEffectiveness = 0.8
			SpeedEffectiveness = 0.8
			ObjectUse(mob/Players/User=usr)
				src.passives = list("Extend" = 1 + (User.Potential / 50))
				..()
		Heavy_Celestial_Blade_III
			name = "Heavy Celestial Blade III"
			desc = "A powerful celestial sword. (Placeholder)"
			icon = 'Sheath Taco In Sword.dmi'
			Class = "Heavy"
			passives = list("Brutalize" = 1)
			DamageEffectiveness = 1.1
			AccuracyEffectiveness = 0.8
			SpeedEffectiveness = 0.8
			ObjectUse(mob/Players/User=usr)
				src.passives = list("Brutalize" = 1 + (User.Potential / 25))
				..()

// =============================================
// STAVES - CELESTIAL BASE
// =============================================
/obj/Items/Enchantment/Staff/Celestial
	Stealable = 0
	Destructable = 0
	Augmented = 1
	ShatterCounter = 800
	ShatterMax = 800
	SubType = "Spell Focii"
	AlignEquip(mob/A, dontUnEquip = FALSE)
		src.Ascended = A.AscensionsAcquired
		..()
	ObjectUse(mob/Players/User=usr)
		if(src.suffix == "*Equipped (Armory)*")
			if(User.transActive && User.race && User.race.transformations && User.race.transformations[User.transActive] && User.race.transformations[User.transActive].type == /transformation/celestial/Master_of_Arms)
				User << "You cannot unequip armory weapons while Master of Arms is active!"
				return
			src.suffix = null
			if(current_passives)
				User.passive_handler.decreaseList(current_passives)
			return
		if(!src.suffix && User.passive_handler.Get("DivineArmory"))
			var/has_weapon = User.EquippedSword() || User.EquippedStaff()
			if(has_weapon)
				src.Ascended = User.AscensionsAcquired
				src.suffix = "*Equipped (Armory)*"
				if(passives)
					current_passives = passives
					User.passive_handler.increaseList(passives)
				return
		..()

// =============================================
// STAVES - WAND CLASS
// =============================================
	Wand
		Celestial_Wand_I
			name = "Celestial Wand I"
			desc = "A nimble celestial focus. (Placeholder)"
			icon = 'MageStaff.dmi'
			Class = "Wand"
			passives = list("QuickCast" = 1)
			DamageEffectiveness = 0.95
			AccuracyEffectiveness = 1.2
			SpeedEffectiveness = 1.2
			ObjectUse(mob/Players/User=usr)
				src.passives = list("QuickCast" = (User.Potential / 25))
				..()
		Celestial_Wand_II
			name = "Celestial Wand II"
			desc = "A nimble celestial focus. (Placeholder)"
			icon = 'MageStaff.dmi'
			Class = "Wand"
			passives = list("ManaStats" = 1)
			DamageEffectiveness = 0.95
			AccuracyEffectiveness = 1.2
			SpeedEffectiveness = 1.2
			ObjectUse(mob/Players/User=usr)
				src.passives = list("ManaStats" = (User.Potential / 10))
				..()
		Celestial_Wand_III
			name = "Celestial Wand III"
			desc = "A nimble celestial focus. (Placeholder)"
			icon = 'MageStaff.dmi'
			Class = "Wand"
			passives = list("SoulFire" = 1)
			DamageEffectiveness = 0.95
			AccuracyEffectiveness = 1.2
			SpeedEffectiveness = 1.2
			ObjectUse(mob/Players/User=usr)
				src.passives = list("SoulFire" = 1 + (User.Potential / 25))
				..()


// =============================================
// STAVES - ROD CLASS
// =============================================
	Rod
		Celestial_Rod_I
			name = "Celestial Rod I"
			desc = "A versatile celestial focus. (Placeholder)"
			icon = 'MageStaff.dmi'
			Class = "Rod"
			passives = list("SpiritFlow" = 1)
			DamageEffectiveness = 1
			AccuracyEffectiveness = 1
			SpeedEffectiveness = 0.85
			ObjectUse(mob/Players/User=usr)
				src.passives = list("SpiritFlow" = 1 + (User.Potential / 25))
				..()
		Celestial_Rod_II
			name = "Celestial Rod II"
			desc = "A versatile celestial focus. (Placeholder)"
			icon = 'MageStaff.dmi'
			Class = "Rod"
			passives = list("ManaSteal" = 5)
			DamageEffectiveness = 1
			AccuracyEffectiveness = 1
			SpeedEffectiveness = 0.85
			ObjectUse(mob/Players/User=usr)
				src.passives = list("ManaSteal" = 5 + (User.Potential / 4))
				..()
		Celestial_Rod_III
			name = "Celestial Rod III"
			desc = "A versatile celestial focus. (Placeholder)"
			icon = 'MageStaff.dmi'
			Class = "Rod"
			passives = list("VoidField" = 1)
			DamageEffectiveness = 1
			AccuracyEffectiveness = 1
			SpeedEffectiveness = 0.85
			ObjectUse(mob/Players/User=usr)
				src.passives = list("VoidField" = (User.Potential / 10))
				..()

// =============================================
// STAVES - STAFF CLASS
// =============================================
	Staff_Class
		Celestial_Staff_I
			name = "Celestial Staff I"
			desc = "A mighty celestial focus. (Placeholder)"
			icon = 'MageStaff.dmi'
			Class = "Staff"
			passives = list("ThunderHerald" = 1)
			DamageEffectiveness = 1.1
			AccuracyEffectiveness = 0.85
			SpeedEffectiveness = 0.65
		Celestial_Staff_II
			name = "Celestial Staff II"
			desc = "A mighty celestial focus. (Placeholder)"
			icon = 'MageStaff.dmi'
			Class = "Staff"
			passives = list("IceHerald" = 1)
			DamageEffectiveness = 1.1
			AccuracyEffectiveness = 0.85
			SpeedEffectiveness = 0.65
		Celestial_Staff_III
			name = "Celestial Staff III"
			desc = "A mighty celestial focus. (Placeholder)"
			icon = 'MageStaff.dmi'
			Class = "Staff"
			passives = list("DemonicInfusion" = 1)
			DamageEffectiveness = 1.1
			AccuracyEffectiveness = 0.85
			SpeedEffectiveness = 0.65

// Master of Arms Warp Strike - Heavy Strike replacement that fires a homing weapon throw and teleports behind target on hit
obj/Skills/Projectile
	Warp_Strike_MasterOfArms
		name = "Divine Warp Strike"
		HomingCharge = 2
		IconLock = 'Blast2.dmi'
		Variation = 4
		Distance = 25
		Deflectable = FALSE
		DamageMult = 3
		WarpUser = 1
		WarpUserBehind = 1
		WarpUserFlashChange = 1
		ProjectileSpin = 40
		Cooldown = 30
		EnergyCost = 5

// WarpPoint timed buff - granted when Divine Warp Strike projectile hits an enemy
// Provides the WarpPoint passive for 30 seconds. On expiry, clears the saved warp location.
obj/Skills/Buffs/SlotlessBuffs/Autonomous/WarpPoint_Buff
	name = "Warp Point"
	Cooldown = 1
	AlwaysOn = 1
	NeedsPassword = 1
	passives = list("WarpPoint" = 1)
	TimerLimit = 30
	ActiveMessage = "locks in a warp point!"
	OffMessage = "loses their warp point."
	HandleBuffDeactivation(mob/source)
		if(source)
			source.warp_strike_saved_loc = null
		..()

// Flashback - auto-triggered on a successful grab while the WarpPoint passive is active.
// Deals minor damage to the grabbed target and teleports the user back to their saved warp location.
obj/Skills/Grapple/Flashback
	name = "Flashback"
	Cooldown = 0
	DamageMult = 4
	StrRate = 1
	ThrowMult = 0
	ThrowAdd = 0
	UnarmedOnly = 0
	TriggerMessage = "flashes back to their warp point, leaving"
	proc/FlashbackTrigger(mob/User, mob/Target)
		if(!User || !Target || !User.warp_strike_saved_loc)
			return
		var/userPower = User.getPower(Target)
		var/statPower = User.getStatDmg2(unarmed=1) * StrRate
		var/endFactor = Target.getEndStat(1)
		var/Damage = (userPower**glob.DMG_POWER_EXPONENT) * (glob.CONSTANT_DAMAGE_EXPONENT+glob.GRAPPLE_EFFECTIVNESS) ** -(endFactor**glob.DMG_END_EXPONENT / statPower**glob.DMG_STR_EXPONENT)
		Damage *= User.GetDamageMod()
		Damage *= DamageMult
		var/extra = User.passive_handler.Get("Muscle Power") / glob.MUSCLE_POWER_DIVISOR
		Damage *= (glob.GRAPPLE_MELEE_BOON + extra)
		Damage *= glob.GRAPPLE_DAMAGE_MULT
		User.DoDamage(Target, Damage, 1, 0)
		OMsg(User, "[User] [TriggerMessage] [Target] behind!")
		var/turf/dest = User.warp_strike_saved_loc
		if(Target.grabbed == User)
			Target.grabbed = null
		if(User.Grab == Target)
			User.Grab = null
		// Flash white, teleport, then fade the glow back out - mirroring WarpUserFlashChange
		animate(User, color=list(1,0,0, 0,1,0, 0,0,1, 1,1,1), time=2)
		sleep(2)
		User.loc = dest
		User.warp_strike_restore_color()
