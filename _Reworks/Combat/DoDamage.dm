/mob/proc/inStasis()
	return Stasis
// AI HANDLING
/mob/proc/handleAI(mob/defender)
	var/mob/Player/AI/aiTarget
	if(istype(defender, /mob/Player/AI))
		aiTarget = defender
		if(aiTarget.ai_adapting_power && !aiTarget.ai_power_adapted)
			aiTarget.ai_power_adapted = 1
			aiTarget.SetTarget(src)
			aiTarget.AIAvailablePower()
		if(!aiTarget.ai_team_fire && aiTarget.AllianceCheck(src))
			return FALSE
	return TRUE

/* DAMAGE HANDLING */

/mob/proc/newDoDamage(mob/defender, val, unarmed, sword, secondhit, thirdhit, trueMult, spiritAtk, destructive, autohit)
	if(inStasis() || defender.inStasis())
		return 0;
	if(defender == src)
		DEBUGMSG("Defender was src, and so newDoDamage stopped early")
		DamageSelf(val)
		return 0;
	else if(defender == null)
		return 0;
	if(!handleAI(defender)) // handles ai
		return 0;
	if(unarmed || sword)
		triggerLimit("Physical")
		triggerLimit("Sword")
		triggerLimit("Unarmed")
	if(spiritAtk)
		triggerLimit("Spirit")
	if(AttackQueue)
		if(AttackQueue.Quaking)
			Quake(AttackQueue.Quaking)
	#if DEBUG_DAMAGE
	log2text("Damage", "Before BalanceDamage", "damageDebugs.txt", "[src.ckey]/[src.name]")
	log2text("Damage", val,"damageDebugs.txt", "[src.ckey]/[src.name]")
	#endif
	val *= glob.WorldDamageMult
	if(val <= 0)
		#if DEBUG_DAMAGE
		log2text("Damage", "was negative", "damageDebugs.txt", "[src.ckey]/[src.name]")
		log2text("Damage", val,"damageDebugs.txt", "[src.ckey]/[src.name]")
		#endif
		val = 0.015
		#if DEBUG_DAMAGE
		log2text("Damage", val,"damageDebugs.txt", "[src.ckey]/[src.name]")
		#endif
	#if DEBUG_DAMAGE
	log2text("Damage", "After BalanceDamage", "damageDebugs.txt", "[src.ckey]/[src.name]")
	log2text("Damage", val,"damageDebugs.txt", "[src.ckey]/[src.name]")
	#endif
	val /= getInfatuation(defender)
	#if DEBUG_DAMAGE
	log2text("Damage", "After Infatuation", "damageDebugs.txt", "[src.ckey]/[src.name]")
	log2text("Damage", val,"damageDebugs.txt", "[src.ckey]/[src.name]")
	#endif
	var/preCrit = val
	if((unarmed || sword) || (spiritAtk && !autohit && passive_handler["IceHerald"]) || (autohit && passive_handler["DemonicInfusion"]))
		val = getCritAndBlock(defender, val)
		if(val > preCrit)
			if(passive_handler["Wuju"] == 1)
				val += glob.BASE_WUJUDAMAGE
			var/obj/Effects/crit/p = new()
			p.Target = defender
			defender.vis_contents += p
			flick("crit", p)
		else
			if(val < preCrit)
				var/obj/Effects/critB/p = new()
				p.Target = defender
				defender.vis_contents += p
				flick("critblock", p)


	#if DEBUG_DAMAGE
	log2text("Damage", "After CritAndBlock", "damageDebugs.txt", "[src.ckey]/[src.name]")
	log2text("Damage", val,"damageDebugs.txt", "[src.ckey]/[src.name]")
	#endif
	// VALUE THINGS ABOVE (THE PURE DAMAGE)
	trueMult += getIntimDMGReduction(defender)
	#if DEBUG_DAMAGE
	log2text("trueMult", "After Intim", "damageDebugs.txt", "[src.ckey]/[src.name]")
	log2text("trueMult", trueMult,"damageDebugs.txt", "[src.ckey]/[src.name]")
	#endif
	// gain red/dmg from intim
	trueMult += getSPPower()
	#if DEBUG_DAMAGE
	log2text("trueMult", "After SP", "damageDebugs.txt", "[src.ckey]/[src.name]")
	log2text("trueMult", trueMult,"damageDebugs.txt", "[src.ckey]/[src.name]")
	#endif

	trueMult += GetDesperationBonus(defender)
	#if DEBUG_DAMAGE
	log2text("trueMult", "After Desperation", "damageDebugs.txt", "[src.ckey]/[src.name]")
	log2text("trueMult", trueMult,"damageDebugs.txt", "[src.ckey]/[src.name]")
	#endif

	if(passive_handler.Get("Powerhouse"))
		var/boon = round(src.Energy/100 * passive_handler.Get("Powerhouse"),0.1)
		trueMult += boon



	var/puredmg = HasPureDamage() ? HasPureDamage() : 0
	if(!glob.PURE_MOD_POST_CALC)
		puredmg *= glob.PURE_MODIFIER
	trueMult += puredmg

	var/lifeFiberRending = passive_handler.Get("Life Fiber Rending")
	lifeFiberRending *= glob.LIFE_FIBER_RENDING_MODIFIER
	if(lifeFiberRending)
		if(defender.KamuiType == "Senketsu" || defender.Secret == "Vampire" || defender.GetSlotless("Life Fiber Hybrid"))
			trueMult += lifeFiberRending
	#if DEBUG_DAMAGE
	log2text("trueMult", "After Puredmg", "damageDebugs.txt", "[src.ckey]/[src.name]")
	log2text("trueMult", trueMult,"damageDebugs.txt", "[src.ckey]/[src.name]")
	#endif
	var/purered = defender.HasPureReduction() ? defender.HasPureReduction() : 0
	if(!glob.PURE_MOD_POST_CALC)
		purered *= glob.PURE_MODIFIER
	if(passive_handler.Get("Aspect of Death"))
		purered*=0.75
	trueMult -= purered
	// Unbroken for Makyos
	var/unbrokenVal = defender.passive_handler.Get("Unbroken")
	if(unbrokenVal)
		if(!glob.PURE_MOD_POST_CALC)
			unbrokenVal *= glob.PURE_MODIFIER
		trueMult -= unbrokenVal
		if(defender.unbreakable_tracking)
			// Cap at 40 so half never exceeds +20 DamageMult, subject to change
			defender.unbroken_absorbed = min(defender.unbroken_absorbed + (val * 0.1 * unbrokenVal), 40)
	// Inevitable
	if(unarmed || sword)
		var/inevVal = passive_handler.Get("Inevitable")
		if(inevVal)
			trueMult += 5 * inevVal
	#if DEBUG_DAMAGE
	log2text("trueMult", "After Purered", "damageDebugs.txt", "[src.ckey]/[src.name]")
	log2text("trueMult", trueMult,"damageDebugs.txt", "[src.ckey]/[src.name]")
	#endif

	trueMult += getTypeBonus(unarmed, spiritAtk)
	#if DEBUG_DAMAGE
	log2text("trueMult", "After TypeBonus", "damageDebugs.txt", "[src.ckey]/[src.name]")
	log2text("trueMult", trueMult,"damageDebugs.txt", "[src.ckey]/[src.name]")
	#endif
	trueMult += getDuelistBonus(defender)
	#if DEBUG_DAMAGE
	log2text("trueMult", "After DuelistBoon", "damageDebugs.txt", "[src.ckey]/[src.name]")
	log2text("trueMult", trueMult,"damageDebugs.txt", "[src.ckey]/[src.name]")
	#endif
	trueMult -= defender.getDuelistBonus(src)
	#if DEBUG_DAMAGE
	log2text("trueMult", "After DuelistRed", "damageDebugs.txt", "[src.ckey]/[src.name]")
	log2text("trueMult", trueMult,"damageDebugs.txt", "[src.ckey]/[src.name]")
	#endif

// LIGHT VS DARK CALCULATIONS

	trueMult += getLightDarkCalc("Offense")
	#if DEBUG_DAMAGE
	log2text("trueMult", "After LightDarkCalc", "damageDebugs.txt", "[src.ckey]/[src.name]")
	log2text("trueMult", trueMult,"damageDebugs.txt", "[src.ckey]/[src.name]")
	#endif
	trueMult += defender.getLightDarkCalc("Defense")
	#if DEBUG_DAMAGE
	log2text("trueMult", "After LightDarkCalc", "damageDebugs.txt", "[src.ckey]/[src.name]")
	log2text("trueMult", trueMult,"damageDebugs.txt", "[src.ckey]/[src.name]")
	#endif
	if(defender.CheckSlotless("Heartless") && src.CheckActive("Keyblade"))
		trueMult += src.SagaLevel
	if(src.CheckSlotless("Heartless") && defender.CheckActive("Keyblade"))
		trueMult -= src.SagaLevel
// END LIGHT VS DARK CALCULATIONS
//move timestop + world dmg mult to after true mult is applied

	trueMult+=ElementalCheck(src,defender)
	#if DEBUG_DAMAGE
	log2text("trueMult", "After ElementalCheck", "damageDebugs.txt", "[src.ckey]/[src.name]")
	log2text("trueMult", trueMult,"damageDebugs.txt", "[src.ckey]/[src.name]")
	#endif

	applySoftCC(defender, val)
	applyAdditonalDebuffs(defender, val)
	#if DEBUG_DAMAGE
	log2text("trueMult", "After Debuffs", "damageDebugs.txt", "[src.ckey]/[src.name]")
	log2text("trueMult", trueMult,"damageDebugs.txt", "[src.ckey]/[src.name]")
	#endif
	trueMult += styleModifiers(defender)
	#if DEBUG_DAMAGE
	log2text("trueMult", "After StyleModifiers", "damageDebugs.txt", "[src.ckey]/[src.name]")
	log2text("trueMult", trueMult,"damageDebugs.txt", "[src.ckey]/[src.name]")
	#endif
	trueMult += attackModifiers(defender)
	#if DEBUG_DAMAGE
	log2text("trueMult", "After AttackModifiers", "damageDebugs.txt", "[src.ckey]/[src.name]")
	log2text("trueMult", trueMult,"damageDebugs.txt", "[src.ckey]/[src.name]")
	#endif

	if(defender.DefianceRetaliate&&!defender.CheckSlotless("Great Ape"))
		if(Health>defender.Health)
			trueMult -= defender.DefianceRetaliate
			#if DEBUG_DAMAGE
			log2text("trueMult", "After Defiance", "damageDebugs.txt", "[src.ckey]/[src.name]")
			log2text("trueMult", trueMult,"damageDebugs.txt", "[src.ckey]/[src.name]")
			#endif
	if(glob.PURE_MOD_POST_CALC)
		trueMult *= glob.PURE_MODIFIER
	if(glob.GOD_KI_AFFECTS_DAMAGE)
		trueMult += godKiModifiers(defender)
//		trueMult += maouKiModifiers(defender)
	#if DEBUG_DAMAGE
	log2text("trueMult", "After GodKiModifiers", "damageDebugs.txt", "[src.ckey]/[src.name]")
	log2text("trueMult", trueMult,"damageDebugs.txt", "[src.ckey]/[src.name]")
	#endif
	trueMult += finalModifiers(defender)
	#if DEBUG_DAMAGE
	log2text("trueMult", "After FinalModifiers", "damageDebugs.txt", "[src.ckey]/[src.name]")
	log2text("trueMult", trueMult,"damageDebugs.txt", "[src.ckey]/[src.name]")
	#endif
	val = calculateTrueMult(trueMult, val)

	if(passive_handler.Get("Ruckus"))
		if(defender.race.name == passive_handler.Get("RuckusRace")) // this should technically work
			val *= 1 + (0.1 * passive_handler.Get("Ruckus"))
		else
			val *= 1 - (0.05 * passive_handler.Get("Ruckus"))

	if(passive_handler.Get("Undying Rage"))
		val*=0.1
	var/miraclechance = (100-defender.Health)*0.6
	if(defender.passive_handler.Get("Miracle"))
		if(defender.Health<30)
			if( prob(miraclechance))
				val=0
	if(HasEmptySeat())
		passive_handler.Increase("AlphainForce", val)
	#if DEBUG_DAMAGE
	log2text("Damage", "After TrueMult", "damageDebugs.txt", "[src.ckey]/[src.name]")
	log2text("Damage", val,"damageDebugs.txt", "[src.ckey]/[src.name]")
	#endif
	if(!checkPurity(defender))
		DEBUGMSG("[defender] is too pure to hit at the end of newdodamage");
		#if DEBUG_DAMAGE
		log2text("Damage", "Purity moment", "damageDebugs.txt", "[src.ckey]/[src.name]")
		log2text("Damage", val,"damageDebugs.txt", "[src.ckey]/[src.name]")
		#endif
		return 0
	return val


/mob/proc/checkPurity(mob/defender)
	if(HasPurity())
		if(HasHolyMod())
			if(HasBeyondPurity())
				return TRUE
			if(!defender.IsEvil())
				return FALSE
	return TRUE

/mob/proc/fieldAndDefense(mob/defender, unarmed, sword, spiritAtk, val)
	if(!val) return
	if(defender.UsingVoidDefense())
		if(defender.TotalFatigue>0)
			defender.HealFatigue(val/3)
		else
			defender.HealWounds(val/3)
		defender.HealEnergy(val/2)
		defender.HealMana(val/2)

	if(defender.passive_handler.Get("Gluttony"))
		var/value = defender.passive_handler.Get("Gluttony") * (glob.FIELD_MODIFIERS + glob.GLUTTONY_MODIFIER)
		WoundSelf(value * val )
		GainFatigue(value * val)


	if(defender.HasDeathField() && (unarmed || sword))
		var/deathFieldValue = defender.GetDeathField() * glob.FIELD_MODIFIERS // should be 0.01(?), 15 = 15% dmg takebnn reflective if they do 100
		WoundSelf(deathFieldValue * min(1/val,1))
	if(defender.HasVoidField()&&spiritAtk)
		var/voidFieldValue = defender.GetVoidField() * glob.FIELD_MODIFIERS
		GainFatigue(voidFieldValue * min(1/val,1))




/mob/proc/finalizeDamage(mob/defender, val, unarmed, sword, secondhit, thirdhit, trueMult, spiritAtk, destructive)


/mob/proc/calculateTrueMult(trueMult, val)
	var/extra = 0.1*trueMult
	#if DEBUG_DAMAGE
	log2text("Damage", "Final Damage Before TrueMult", "damageDebugs.txt", "[src.ckey]/[src.name]")
	log2text("Damage", val,"damageDebugs.txt", "[src.ckey]/[src.name]")
	#endif
	if(trueMult>0) // altered
		val *= 1+extra
	else if(trueMult<0) // altered
		val/= 1+(-extra)
	return val
