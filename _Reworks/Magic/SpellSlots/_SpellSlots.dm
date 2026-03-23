/obj/Skills/var
    SpellSlot=0;//hands down the worst way to do this, but unfortunately, we don't use inheritance well for our skills system so it's just gonna have to work

/mob/proc/getSpellSlots()
    var/list/slots = list()
    for(var/obj/Skills/s in src)
        if(s.SpellSlot) slots |= s;
    return slots.len > 0 ? slots : 0;

/mob/verb/find_spell_slots()
    set category="Debug"
    set name = "DEBUG: Find Spell Slots"
    var/list/slots = getSpellSlots()
    if(!slots)
        src << "no slots"
        return;
    for(var/x in slots)
        src << "slot found: [x]";

//water
/obj/Skills/Buffs/SlotlessBuffs/Magic/Water
    Wetten_Socks
        SpellSlot=1;
/obj/Skills/AutoHit/Magic/Water
    Riptide
        SpellSlot=1;
/obj/Skills/Projectile/Magic/Water
    Frost_Shamshir
        SpellSlot=1;

//fire
/obj/Skills/AutoHit/Magic/Fire
    Inferno_Cannon
        SpellSlot=1;
/obj/Skills/Projectile/Fire//line, specifically
    idkyet
        SpellSlot=1;
/obj/Skills/Projectile/Fire//projectile version
    idkyet2
        SpellSlot=1;

//earth
/obj/Skills/AutoHit/Magic/Earth//aoe
    idkyet
        SpellSlot=1;
/obj/Skills/Buffs/SlotlessBuffs/Magic/Earth
    idkyet2
        SpellSlot=1;//buff
    idkyet3
        SpellSlot=1;//debuff

//air
/obj/Skills/AutoHit/Magic/Air
    idkyet
        SpellSlot=1;
/obj/Skills/Buffs/SlotlessBuffs/Magic/Air
    idkyet2
        SpellSlot=1;
/obj/Skills/Projectile/Magic/Air
    idkyet3//line
        SpellSlot=1;

//light
/obj/Skills/Buffs/SlotlessBuffs/Magic/Light
    idkyet
        SpellSlot=1;
/obj/Skills/Projectile/Magic/Light//line
    idkyet2
        SpellSlot=1;
    idkyet3//projectile
        SpellSlot=1;

//time
/obj/Skills/AutoHit/Magic/Time
    idkyet//aoe
        SpellSlot=1;
/obj/Skills/Buffs/SlotlessBuffs/Magic/Time
    idkyet2//buff
        SpellSlot=1;
    idkyet3//debuff
        SpellSlot=1;

//dark
/obj/Skills/AutoHit/Magic/Dark
    idkyet
        SpellSlot=1;
/obj/Skills/Projectile/Magic/Dark
    idkyet2//line
        SpellSlot=1;
    idkyet3
        SpellSlot=1;

//space
/obj/Skills/AutoHit/Magic/Space
    idkyet
        SpellSlot=1;
    idkyet2
        SpellSlot=1;
/obj/Skills/Buffs/SlotlessBuffs/Magic/Space
    idkyet3
        SpellSlot=1;