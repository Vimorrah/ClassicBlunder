race
	fae
		name = "Fae"
		desc = "Typically small creatures with an innate gift for magic. Mana runs in their veins like blood."
		visual = 'Dragon.png' //remind me to find a picture of a pixie or smth and slap it here.
		//This race isn't finished yet, please don't include them into the game until they are. I am just putting them in the code so others can balance them.
		//They should get innovation stuff SPECIFICALLY FOR magic. Will do that later.
		power = 1
		strength = 1.25
		endurance = 1.25
		speed = 1.75
		force = 1.75
		offense = 1.25
		defense = 1.5
		anger = 1.5
		regeneration = 2
		recovery = 2
		imagination = 2 // Since they are a very magical race by default I wasn't sure if this hsould be raised, or not. Prob should be bad/middling at tech.

		onFinalization(mob/user)
			user.Class = input(user,"What type of Fae are you?", "Fae Species") in list("Pixie","Goblin")//I may add other types like Dryads later. Went with my 2 favorite types for now.
			switch(user.Class)
				if("Pixie") //Your typical butterfly-winged little tricksters. Forcies
					skills = list(/obj/Skills/Buffs/SlotlessBuffs/Autonomous/FaeBuffs/Pixie_Mania) //give them Hideous Laughter once its coded.
					passives["Flow"] = 1
					passives["ManaGeneration"] = 1
					passives["QuickCast"] = 1
				if("Goblin") //Playable Raccoons with a need for speed.
					skills = list(/obj/Skills/Buffs/SlotlessBuffs/Autonomous/FaeBuffs/Fury_of_the_Small) //Give them Pack Tactics once its coded.
					passives["Instinct"] = 1
					passives["ManaSteal"] = 1
					passives["BlurringStrikes"] = 1

			..()
