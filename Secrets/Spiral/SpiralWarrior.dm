#define DARWIN_POKEDEX list("Spiral", "Inorganic", "Cursed", "Stagnant")

obj/Skills/Buffs/SlotlessBuffs/Spiral/ClobberApply
	StrMult=1.25
	ForMult=1.25
	TimerLimit=30
	ActiveMessage="is slugged in the face and focuses!"
	OffMessage="shakes off the effects of getting clobbered."

obj/Skills/Buffs/SlotlessBuffs/Spiral/Clobber
	applyToTarget = new/obj/Skills/Buffs/SlotlessBuffs/Spiral/ClobberApply
	AffectTarget=1
	EndYourself=1
	Range=5
	Cooldown=120
	ActiveMessage="screams LET ME SEE YOU GRIT THOSE TEETH!"
	verb/Clobber()
		set category="Skills"
		if(!usr.Target || usr.Target==usr)
			usr << "You need to target someone else."
			return
		if(!altered)
			adjust(usr)
			applyToTarget?:adjust(usr)
		src.Trigger(usr)

obj/Skills/Buffs/SlotlessBuffs/Spiral/InspiredEvoApply
	PowerGlows=list(1,0.8,0.8, 0,1,0, 0.8,0.8,1, 0,0,0)
	KenWave = 4
	KenWaveIcon='SparkleGreen.dmi'
	HitSpark='Spiral_Hitspark.dmi'
	TopOverlayLock = 'SpiralAura.dmi'
	TopOverlayX = -32
	strAdd = 0
	endAdd = 0
	forAdd = 0
	spdAdd = 0
	offAdd = 0
	defAdd = 0
	TimerLimit=20
	ActiveMessage="screams WHO THE HELL DO YOU THINK WE ARE?"
	OffMessage="limits themselves once again."
	TextColor="green"
	MagicNeeded=0

obj/Skills/Buffs/SlotlessBuffs/Spiral/InspiredEvo
	EndYourself=1
	Cooldown=600
	KenWave=1
	KenWaveIcon='SparkleGreen.dmi'
	KenWaveSize=4
	KenWaveX=105
	KenWaveY=105
	Range=20
	ActiveMessage="screams WHEN THERE'S A WALL IN OUR WAY, WE DRILL RIGHT THROUGH IT!"
	verb/Inspired_Evolution()
		set category="Skills"
		set name="Inspired Evolution"
		var/mob/User = usr
		if(!User.party || !User.party.members || User.party.members.len == 0)
			User << "You need to be in a party to apply Inspired Evolution."
			return
		if(src.cooldown_remaining > 0)
			User << "[src] is on cooldown."
			return
		if(!altered)
			adjust(User)
		for(var/mob/m in User.party.members)
			if(!m || !ismob(m)) continue
			if(m.race.type in INORGANIC_RACES && !m.passive_handler.Get("SpiralEngine"))
				User << "[m] is synthetic and cannot evolve."
				m << "[User] tried to inspire you to evolve, but it failed."
				return
			if(m.race.type in CURSED_RACES || (m.Secret &&  m.Secret != "Spiral"))
				User << "[m]'s biology is warped by the supernatural, they cannot evolve as you do."
				m <<"[User] tried to inspire you to evolve, but your supernatural gifts interferred."
				return
			if(m.race.type in STAGNANT_RACES)
				User <<"[m] is a supernatural entity. They are incapable of change."
				m <<"[User] tried to inspire you to evolve, but your nature prevents you from lowering yourself to their level."
				return
			ActiveMessage="screams WHEN THERE'S A WALL IN OUR WAY, TEAM [User] DRILLS RIGHT THROUGH IT!"
			var/obj/Skills/Buffs/SlotlessBuffs/Spiral/InspiredEvoApply/applyBuff = new
			applyBuff.strAdd = m.StrAscension
			applyBuff.endAdd = m.EndAscension
			applyBuff.forAdd = m.ForAscension
			applyBuff.spdAdd = m.SpdAscension
			applyBuff.offAdd = m.OffAscension
			applyBuff.defAdd = m.DefAscension
			applyBuff.TimerLimit = 20 * (m.AscensionsAcquired+1)
			applyBuff.Trigger(m, 1)
		User.OMessage(1, null, "[User] inspires the evolution of [User.party.members.len == 1 ? "themselves" : "their party"]!")
		src.Cooldown(1, null, User)