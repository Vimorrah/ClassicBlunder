ascension/sub_ascension/demi_fiend/musubi
	passives = list("Musubi" = 1)
ascension/sub_ascension/demi_fiend/shijima
	passives = list("Shijima" = 1)
ascension/sub_ascension/demi_fiend/yosuga
	passives = list("Yosuga" = 1)

ascension
	demi_fiend
		postAscension(mob/owner)
			owner.refreshMagatama()
			if(owner.passive_handler?.Get("Musubi"))
				owner.StrAscension  += strength
				owner.EndAscension  += endurance
				owner.ForAscension  += force
				owner.OffAscension  += offense
				owner.DefAscension  += defense
				owner.SpdAscension  += speed
				owner.RecovAscension += recovery
			..()

		revertAscension(mob/owner)
			if(owner.passive_handler?.Get("Musubi"))
				owner.StrAscension  -= strength
				owner.EndAscension  -= endurance
				owner.ForAscension  -= force
				owner.OffAscension  -= offense
				owner.DefAscension  -= defense
				owner.SpdAscension  -= speed
				owner.RecovAscension -= recovery
			..()
		one
			unlock_potential = ASCENSION_ONE_POTENTIAL
			choices = list("Reason of Musubi" = /ascension/sub_ascension/demi_fiend/musubi, "Reason of Shijima" = /ascension/sub_ascension/demi_fiend/shijima, "Reason of Yosuga" = /ascension/sub_ascension/demi_fiend/yosuga)
			choiceTitle = "Choose Your Reason"
			choiceMessage = "Your conviction takes shape. Which Reason will guide your path?\n\nMusubi: Freedom from constraint—swap Magatama at will and craft without escalating cost. You gain only passives from Magatama, never their skills.\nShijima: Unity through diversity—equip multiple Magatama, gaining an extra slot each ascension (scaling halved).\nYosuga: Strength unchained—amplify Magatama passive scaling (1.25x at ascension 1, +0.25x per ascension)."
			on_ascension_message = "Your demonic power awakens further. What Reason drives you?"
			passives = list()
			strength = 0.25
			endurance = 0.25
			speed = 0.25
			force = 0.25
			offense = 0.25
			defense = 0.25
		two
			unlock_potential = ASCENSION_TWO_POTENTIAL
			passives = list()
			strength = 0.25
			endurance = 0.25
			speed = 0.25
			force = 0.25
			offense = 0.25
			defense = 0.25
		three
			unlock_potential = ASCENSION_THREE_POTENTIAL
			passives = list()
			strength = 0.25
			endurance = 0.25
			speed = 0.25
			force = 0.25
			offense = 0.25
			defense = 0.25
		four
			unlock_potential = ASCENSION_FOUR_POTENTIAL
			passives = list()
			strength = 0.25
			endurance = 0.25
			speed = 0.25
			force = 0.25
			offense = 0.25
			defense = 0.25
		five
			unlock_potential = ASCENSION_FIVE_POTENTIAL
			passives = list()
			strength = 0.25
			endurance = 0.25
			speed = 0.25
			force = 0.25
			offense = 0.25
			defense = 0.25
		six
			unlock_potential = ASCENSION_SIX_POTENTIAL
			passives = list()
			strength = 0.25
			endurance = 0.25
			speed = 0.25
			force = 0.25
			offense = 0.25
			defense = 0.25
