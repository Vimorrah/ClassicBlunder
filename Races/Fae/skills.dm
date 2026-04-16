/obj/Skills/Buffs/SlotlessBuffs/Autonomous/
	FaeBuffs //These are jsut concepts right now. Numbers will be adjusted by staff before implimented.
		NeedsHealth = 50
		TooMuchHealth = 75
				//insert line about deactivating at 0 mana here.
		TextColor=rgb(95, 60, 95)
		ActiveMessage="is consumed by magical vigor!"
		OffMessage = "Their mana-enhanced power fades..."
		adjust(mob/p)

		Fury_of_the_Small //Angry Short Person Syndrome
			NeedsHealth = 50
			TooMuchHealth = 75
			//insert line about deactivating at 0 mana here.
			ActiveMessage = "channels the fury of short people!"
			OffMessage = "is no longer angry, but still short..."
			adjust(mob/p)
				if(altered) return
				var/asc = p.AscensionsAcquired
				spdAdd = 0.15 * asc
				passives = list("ManaStats" = (1+(asc/2)), "Fury" = (1+(asc/2)), "Brutalize" = (0.5*(asc+1)),\
								"SpiritHand" = (0.5*(asc+1)), "SpiritSword" = (0.5*(asc+1)) )
			Trigger(mob/User, Override = FALSE)
				if(!User.BuffOn(src))
					adjust(User)
				..()

		Pixie_Mania // Manic Pixie Dream Girl
			NeedsHealth = 50
			TooMuchHealth = 75
			//insert line about deactivating at 0 mana here.
			ActiveMessage = "becomes consumed by a fit of manic laughter!"
			OffMessage = "regains their sanity..."
			adjust(mob/p)
				if(altered) return
				var/asc = p.AscensionsAcquired
				spdAdd = 0.15 * asc
				passives = list("ManaStats" = (1+(asc/2)), "DebuffResistance" = (0.5*(asc+1)), "Reversal" = (0.5*(asc+1)),\
								"TurningCharge" = 1, "MovingCharge" = 1 ) //Does Moving Charge make Turning Charge irrelevant? I have NO IDEA.
			Trigger(mob/User, Override = FALSE)
				if(!User.BuffOn(src))
					adjust(User)
				..()

//Insert Fae-Specific spells here. These should all cost Mana.
//Hideous Laughter: circle-AoE that does little-to-no damage, brief stun from laughing, then applies a debuff. Pixies
//Pack Tactics: Party-wide buff to hitting and dodging. Goblin. Maybe make Goblins have a stronger effect from it. Together... Goblin...strong.