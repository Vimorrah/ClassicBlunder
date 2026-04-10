/mob/Admin3/verb/GiveMazoku()
	var/mob/p = input(src, "Who?") in players
	if(!p.isRace(HUMAN))
		src << "[p] is not Human."
		return
	var/safety = 20
	while(p.transActive > 0 && safety-- > 0)
		var/oldTA = p.transActive
		p.Revert()
		if(p.transActive == oldTA)
			p.transActive = 0
			break
	for(var/transformation/T in p.race.transformations.Copy())
		p.race.transformations -= T
		del T
	p.race.transformations += new /transformation/human/high_tension/mazoku()
	p.race.transformations += new /transformation/human/high_tension_MAX/mazoku()
	p.race.transformations += new /transformation/human/super_high_tension/mazoku()
	p.race.transformations += new /transformation/human/super_high_tension_MAX/mazoku()
	p.race.transformations += new /transformation/human/unlimited_high_tension/mazoku()
	// DT (slot 6) is added later when the player earns DeathDefied via hasMazokuRevival()
	p << "You have been given Mazoku."
	p.passive_handler.Increase("HellPower", 0.25)
	p.passive_handler.Increase("DemonicDurability", 2)
	p.passive_handler.Increase("AbyssMod", 1)
	p.passive_handler.Increase("DormantDemon", 1)
