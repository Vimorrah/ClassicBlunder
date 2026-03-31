/mob/var/tmp/ApathyDamageBonus = 0

mob
	proc
		isInHighTension()
			if(!passive_handler || !passive_handler.Get("DeathDefied")) return FALSE
			if(!istype(race, HUMAN)) return FALSE
			if(transActive < 1) return FALSE
			return TRUE

		getMazokuSinBonusMult()
			if(!isInHighTension())
				if(ApathyDamageBonus != 0)
					ApathyDamageBonus = 0
				return 0

			var/mult = 0

			// ApathyFactor
			if(ApathyDamageBonus > 0)
				mult += ApathyDamageBonus

			// HopeFactor
			if(passive_handler && passive_handler.Get("HopeFactor") && Health < 50)
				var/hope_bonus = ((50 - Health) / 40.0) * 3 * passive_handler.Get("HopeFactor")
				mult += hope_bonus

			if(mult < 0)
				mult = 0
			if(mult > 3)
				mult = 3

			return mult

		applyApathyBonus(amount)
			if(amount <= 0) return
			if(!isInHighTension()) return
			if(!passive_handler || !passive_handler.Get("ApathyFactor")) return
			ApathyDamageBonus = min(3, ApathyDamageBonus + amount * 0.01)

		resetApathyBonus()
			ApathyDamageBonus = 0

/mob/proc/MazokuEffects()

/transformation/human/revert(mob/user)
	..()
	if(!user || user.transActive >= 1) return
	user.resetApathyBonus()

// Mazoku (HopeFactor) exclusive Queue technique
obj/Skills/Queue/Kibou_ou_Hope
	name = "Kibou ou Hope"
	DamageMult = 20
	Cooldown = 60
	EnergyCost = 5
	Duration = 10
	WaveHit = 1
	UnarmedOnly = 1
	ActiveMessage = "embraces a dream that exists beyond hope..."
	HitMessage = "goes beyond their limits and seizes the future in their hands!"
	verb/Kibou_ou_Hope()
		set category = "Skills"
		if(!usr.isInHighTension())
			usr << "You cannot use this power right now."
			return
		if(!usr.passive_handler || !usr.passive_handler.Get("HopeFactor"))
			usr << "You cannot use this power right now."
			return
		var/healthDiff = 0
		if(usr.Target && istype(usr.Target, /mob/Players) && usr.Target != usr)
			healthDiff = max(0, usr.Target:Health - usr.Health)
		src.DamageMult = 20 + (healthDiff * 2)
		usr.SetQueue(src)
