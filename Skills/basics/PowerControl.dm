mob/proc/PowerUp() // Handles Normal (read: Not Kaioken/Shin) power up related code
    if("PowerUp")
        if(src.KO)return
        if(Secret == "Heavenly Restriction" && secretDatum?:hasRestriction("Power Control")) return
        if(src.PoweringDown)return
        if(CheckSlotless("Great Ape"))
            CanTransform()
            return
        if(passive_handler.Get("Piloting"))return
        if(src.passive_handler.Get("Kaioken"))
            KaiokenPowerUp() // This proc is at line 101
            return
        if(Secret == "Shin" && ((usingShinBuff() && !MangOnCD())|| usingMangBuff()) && ActiveBuff)
            MangPowerUp() // This proc is at line 189
        if(src.CheckActive("Ki Control")||(src.CheckSpecial("One Hundred Percent Power")&&src.transUnlocked<4)||(src.CheckSpecial("Fifth Form")&&src.transUnlocked<4))
            if(src.transActive()<src.transUnlocked)
                if(src.isRace(HUMAN))
                    return
                src.Transform()
            return
        if(src.HasPULock()||src.HasGatesPULock())
            return
        if(src.PoweringUp==1)
            if(src.transActive()<src.transUnlocked)
                if(src.isRace(HUMAN))
                    return
                src.PoweringUp=0
                src.Transform()
                return
        if(!src.PoweringUp)
            src.PoweringUp=1
            if(src.PowerControl>=100)
                if(src.Saga=="Cosmo")
                    OMsg(src, "[src] ignites their Cosmo!!")
                else if(src.custom_powerup)
                    if(customPUnameInclude)
                        OMsg(src, "[src] [src.custom_powerup]")
                    else
                        OMsg(src, "[src.custom_powerup]")
                else
                    OMsg(src, "[src] begins gathering power!!")
                src.Auraz("Add")
            else
                src.PowerControl=100
                src << "You return to normal power."
                src.PoweringUp=0

// Handles Normal Power Down related code
mob/proc/PowerDown()
    if("PowerDown")
        if(src.KO)
            return
        if(Secret == "Heavenly Restriction" && secretDatum?:hasRestriction("Power Control")) return
        if(CheckSlotless("Great Ape"))
            return
        if(passive_handler.Get("Piloting"))
            return
        if(src.passive_handler.Get("Kaioken"))
            KaiokenPowerDown() // This Proc is at line 156
            return
        if(Secret == "Shin" && usingMangBuff())
            MangPowerDown() // This proc is at line 202
            if(GetMangLevel()==0)
                MangToShin()
            return
        if(src.HasPULock()||src.HasGatesPULock())
            return
        if(src.PoweringUp)
            src.PoweringUp=0
            src << "You stop powering up."
            src.Auraz("Remove")
            return
        else
            if(src.CheckActive("Ki Control"))
                for(var/obj/Skills/Buffs/ActiveBuffs/Ki_Control/KC in src)
                    src.UseBuff(KC)
                    return
            if(src.CheckSpecial("One Hundred Percent Power"))
                for(var/obj/Skills/Buffs/SpecialBuffs/OneHundredPercentPower/FF in src)
                    src.UseBuff(FF)
                    return
            if(src.CheckSpecial("Fifth Form"))
                for(var/obj/Skills/Buffs/SpecialBuffs/FifthForm/FF in src)
                    src.UseBuff(FF)
                    return
            if(src.HasKiControl() && src.PowerControl > 100)
                src.PowerControl=100
                src.Auraz("Remove")
                src << "You return to normal power."
                return
            if(transActive&&!src.HasNoRevert())
                for(var/obj/Skills/Buffs/B in src)
                    if(src.BuffOn(B)&&B.Transform&&!B.AlwaysOn)
                        B.Trigger(src)
                        return
                src.Revert()
                src << "You revert from your transformed state."
                return
            else
                if(src.PowerControl!=1)
                    src.PowerControl=1
                    src << "You restrain your power..."
                    src.Auraz("Remove")
                    return

// Handles Kaioken Power Up related code
mob/proc/KaiokenPowerUp()
    if(src.passive_handler.Get("Kaioken"))
        var/Mastery
        for(var/obj/Skills/Buffs/SpecialBuffs/Kaioken/KK in src)
            Mastery=KK.Mastery
        if(src.Kaioken<2+Mastery)
            if(src.passive_handler.Get("Super Kaioken"))
                switch(src.Kaioken)
                    if(0)
                        src.Kaioken=1
                        src <<"<b>Super Kaioken!</b>"
                    if(1)
                        src.Kaioken=2
                        src <<"<b>Super Kaioken Times Three!</b>"
                    if(2)
                        src.Kaioken=3
                        src <<"<b>Super Kaioken Times Four!</b>"
                    if(3)
                        src.Kaioken=4
                        src <<"<b>Super Kaioken Times Ten!</b>"
                    if(4)
                        src.Kaioken=5
                        src <<"<b>Super Kaioken Times Twenty!</b>"
                    if(5)
                        if(src.passive_handler.Get("Kaioken Blue"))
                            src.Kaioken=6
                            src <<"<b>Maximum Kaioken Blue!!!!!!</b>"
                        else
                            src << "You're at your maximum level of Kaioken."
                    if(6)
                        src<<"You cannot push your power any further."

            else
                switch(src.Kaioken)
                    if(0)
                        src.Kaioken=1
                        src <<"<b>Kaioken!</b>"
                    if(1)
                        src.Kaioken=2
                        src <<"<b>Kaioken Times Three!</b>"
                    if(2)
                        src.Kaioken=3
                        src <<"<b>Kaioken Times Four!</b>"
                    if(3)
                        src.Kaioken=4
                        src <<"<b>Kaioken Times Ten!</b>"
                    if(4)
                        src.Kaioken=5
                        src <<"<b>Kaioken Times Twenty!</b>"
                    if(5)
                        src << "You're at your maximum level of Kaioken."
        else
            src << "You don't have enough mastery of Kaioken to push it further."

// Handles Kaioken Power Down related code
mob/proc/KaiokenPowerDown()
    if(src.passive_handler.Get("Kaioken"))
        switch(src.Kaioken)
            if(1)
                src.Kaioken=0
                src <<"<b>You fully relax your Kaioken!</b>"
            if(2)
                src.Kaioken=1
                src <<"<b>You relax your Kaioken to its minimum!</b>"
            if(3)
                src.Kaioken=2
                src <<"<b>You relax your Kaioken to three times!</b>"
            if(4)
                src.Kaioken=3
                src <<"<b>You relax your Kaioken to four times!</b>"
            if(5)
                src.Kaioken=4
                src << "<b>You relax your Kaioken to ten times!</b>"
            if(6)
                src.Kaioken=5
                src << "<b>You relax your Kaioken to twenty times!</b>"
        return
    /*src << "You douse your Kaioken..."
    src.SpecialBuff.Trigger(src)
    sleep()
    if(src.CheckActive("Ki Control"))
        for(var/obj/Skills/Buffs/ActiveBuffs/Ki_Control/KC in src)
            src.UseBuff(KC)
    return*/


// Handles Mang Power Up related code
mob/proc/MangPowerUp()
    if(MangManaCost())
        if(ShinActive() || MangActive()) // First we check if they are using one of the right buffs
            if(GetMangMastery() >= GetMangLevel()+1) // Then we check if they have enough mastery to go higher
                src.AddMangLevel() // Then we add! Yay!
        if(ShinActive())
            endShinBuff()
        if(GetMangLevel())
            startMangBuff()


// Handles Mang Power Down related code
mob/proc/MangPowerDown()
    if(!GetMangLevel()) // Checks what level your mang is at.
        src <<"<b>You have not manifested any Mang!</b>"
    if(MangActive()) // Reduces your active mang level
        ReduceMangLevel()
    if(!GetMangLevel()) // Turns Mang off if it hits 0?
        endMangBuff()
        startShinBuff()



