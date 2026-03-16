//autohits
obj
	Skills
//t1
		AutoHit
			Sonic_Blade
				NeedsSword=1
				Area="Strike"
				PassThrough=1
				Distance=4
				AdaptRate=1
				NoPierce=1
				DamageMult=1.5
				Rush=3
				ControlledRush=1
				Cooldown=30
				EnergyCost=2
				Rounds=3
				ActiveMessage="dashes forward repeatedly with a jousting strike!"
				verb/Sonic_Blade()
					set category="Skills"
					usr.Activate(src)
			Strike_Raid
				NeedsSword=1
				Area="Wave"
				Distance=6
				AdaptRate=1
				Knockback=5
				HitSparkIcon='Hit Effect Pearl.dmi'
				HitSparkX=-32
				HitSparkY=-32
				HitSparkTurns=1
				HitSparkSize=3
				TurfStrike=1
				Slow=1
				DamageMult=2.8
				Cooldown=30
				EnergyCost=3
				ActiveMessage="throws their Keyblade forward!"
				verb/Strike_Raid()
					set category="Skills"
					usr.Activate(src)
			Magnet_Burst
				SignatureTechnique=1
				Area="Circle"
				Distance=7
				AdaptRate = 1
				GuardBreak=1
				DamageMult=3
				PullIn=8
				Cooldown=30
				Shockwaves=3
				Shockwave=4
				BuffAffected = "/obj/Skills/Buffs/SlotlessBuffs/Autonomous/Staggered"
				SpecialAttack=1
				Stunner=3
				HitSparkIcon='BLANK.dmi'
				HitSparkX=0
				HitSparkY=0
				ActiveMessage="draws in everyone nearby with a burst of magnetism!"
				EnergyCost=5
				verb/Magnet_Burst()
					set category="Skills"
					usr.Activate(src)
//t2
			Ripple_Drive
				Area="Circle"
				Distance=5
				AdaptRate = 1
				GuardBreak=1
				DamageMult=6
				Knockback=15
				Cooldown=45
				Shockwaves=3
				Shockwave=4
				BuffAffected = "/obj/Skills/Buffs/SlotlessBuffs/Autonomous/Staggered"
				SpecialAttack=1
				Stunner=3
				HitSparkIcon='BLANK.dmi'
				HitSparkX=0
				HitSparkY=0
				ActiveMessage="unleashes a damaging aura around nearby enemies!"
				EnergyCost=5
				verb/Ripple_Drive()
					set category="Skills"
					usr.Activate(src)
//t3
			Fire_Surge
				Area="Circle"
				PassThrough=0
				Distance=4
				AdaptRate=1
				NoPierce=1
				DamageMult=9
				Rush=6
				ControlledRush=0
				Cooldown=60
				EnergyCost=2
				ActiveMessage="dashes forward, surrounded by flames!"
				verb/Sonic_Blade()
					set category="Skills"
					usr.Activate(src)
			Thunder_Surge
				Area="Circle"
				PassThrough=0
				Distance=4
				AdaptRate=1
				NoPierce=1
				DamageMult=9
				Rush=6
				ControlledRush=0
				Cooldown=60
				EnergyCost=2
				ActiveMessage="dashes forward, surrounded by lightning!"
				verb/Sonic_Blade()
					set category="Skills"
					usr.Activate(src)
//t4
			Raging_Storm
				NeedsSword=1
				Area="Circle"
				AdaptRate=1
				Cooldown = 75
				DamageMult=1.5
				Rounds=20
				ComboMaster=1
				Size=2
				EnergyCost=5
				Icon='TornadoPhoenix.dmi'
				IconX=-8
				IconY=-8
				HitSparkIcon='Slash - Zan.dmi'
				HitSparkX=-16
				HitSparkY=-16
				HitSparkTurns=1
				HitSparkSize=1
				HitSparkDispersion=1
				TurfStrike=1
				ActiveMessage="surrounds themselves in fire!"
				verb/Judgment()
					set category="Skills"
					usr.Activate(src)
			Salvation
				AdaptRate=1
				DamageMult=12
				Area="Circle"
				Distance=8
				Slow=1
				WindUp=1
				WindupIcon='Ripple Radiance.dmi'
				WindupIconUnder=1
				WindupIconX=-32
				WindupIconY=-32
				WindupIconSize=1.3
				HealthRecovery=1
				HealthRecoveryValue=5
				WindupMessage="draws in a large amount of light..."
				ActiveMessage="unleashes a bright flash of light!"
				HitSparkIcon='BLANK.dmi'
				HitSparkX=0
				HitSparkY=0
				TurfStrike=1
				TurfShift='StarPixel.dmi'
				TurfShiftDuration=3
				Cooldown=75
				verb/Salvation()
					set category="Skills"
					usr.Activate(src)
			Ragnarok
				NeedsSword=1
				Area="Arc"
				AdaptRate=1
				DamageMult=2.25
				Rush=5
				ControlledRush=1
				Rounds=5
				ComboMaster=1
				RoundMovement=1
				NoAttackLock=1
				NoLock=1
				Cooldown=60
				Icon='Nest Slash.dmi'
				IconX=-16
				IconY=-16
				Size=2
				Distance=2
				EnergyCost=5
				Launcher=2
				Instinct=1
				ActiveMessage="unleashes a flurry of strikes!"
				FollowUp="/obj/Skills/AutoHit/Ragnarok_Blast"
				adjust(mob/p)
				verb/Ragnarok()
					set category="Skills"
					usr.Activate(src)
			Ragnarok_Blast
				NeedsSword=1
				Area="Around Target"
				Distance=12
				DistanceAround=5
				AdaptRate=1
				Knockback=0
				ComboMaster=1
				HitSparkIcon='Hit Effect Pearl.dmi'
				HitSparkX=-32
				HitSparkY=-32
				HitSparkTurns=1
				HitSparkSize=3
				TurfStrike=1
				Slow=3
				Rounds=5
				Size=3
				DamageMult=2
				ActiveMessage="thrusts their blade forward, magic exploding from the tip of the blade!"