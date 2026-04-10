/mob/tierUpSaga(path)
	..()
	if(path != "Devil Summoner") return

	switch(SagaLevel)

		// basic summoning
		if(1)
			demon_party_cap = 3
			if(!demon_party)      demon_party      = list()
			if(!demon_compendium) demon_compendium = list()

			src.verbs += /mob/proc/verb_SummonDemon
			src.verbs += /mob/proc/verb_CallDemon

			src << "You've formed a pact with demons brought into this world by a certain man."
			src << "You may carry up to <b>3 demons</b> in your party."
			src << "Use <b>Summon Demon</b> to call a demon to your side, and <b>Call Demon</b> to recall them."
			src << "Your summoned demon will follow you and fight your enemies. Meditate for 15 seconds to restore their health if they fall."
			GrantStarterDemons(1)

		// compendium unlocked
		if(2)
			demon_party_cap = 4
			if(!demon_compendium) demon_compendium = list()

			src.verbs += /mob/proc/verb_RecordDemon
			src.verbs += /mob/proc/verb_OpenCompendium

			src << "Party capacity increased to <b>4 demons</b>."
			src << "<b>Compendium</b> unlocked: use <b>Record Demon</b> to store a demon's data, then withdraw them later via <b>Compendium</b>."
			src << "Withdrawing at a demon costs Mana Bits."
			GrantStarterDemons(2)

		// fusion unlocked
		if(3)
			demon_party_cap = 6

			src.verbs += /mob/proc/verb_OpenFusion

			src << "Party capacity increased to <b>6 demons</b>."
			src << "<b>Demon Fusion</b> unlocked: combine two demons to create a stronger one."
			src << "The fused demon is determined by the races and levels of the two ingredients. Both ingredients are consumed."
			GrantStarterDemons(3)

		// racial bonuses while demon is summoned
		if(4)
			demon_party_cap = 8

			src << "Party capacity increased to <b>8 demons</b>."
			src << "Your bond with your demons deepens. The race of your active demon now grants you a <b>passive boon</b> while they are summoned."

		// Fusion-exclusive demons accessible
		if(5)
			demon_party_cap = 10

			src << "Party capacity increased to <b>10 demons</b>."
			src << "Rare entities once thought inaccessible now answer your summons. <b>Fusion-exclusive demons</b> may be obtained through specific fusions."

		// Element fusion
		if(6)
			demon_party_cap = 12

			src << "Party capacity increased to <b>12 demons</b>."
			src << "<b>Element Fusion</b> unlocked: sacrifice an elemental demon (Erthys, Aeros, Aquans, or Flaemis) to rank another demon up or down within its own race."

		// Special fusions
		if(7)
			src << "Your name is spoken in hushed reverence by demons."
			src << "<b>Special Fusions</b> unlocked: certain specific demon pairs yield extraordinary results that cannot be obtained any other way."

		// Overclocking (maybe, idk yet)
		if(8)
			demon_party_cap = 12

			src << "<b>Demon Overclocking</b> unlocked: your summoned demon can temporarily push beyond their limits, briefly supercharging your combat stats."
