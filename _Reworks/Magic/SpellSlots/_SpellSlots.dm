/obj/Skills/var
    SpellElement;//tracks what element a spell belongs to and therefore what kinds of passives can be invested into it (unless you break the rules)
    SpellSlot=0;//hands down the worst way to do this, but unfortunately, we don't use inheritance well for our skills system so it's just gonna have to work
    list/SpellPassives=list();//contains a list of spell passives that are influencing this spell

/mob/proc/getSpellSlots()
    var/list/slots = list()
    for(var/obj/Skills/s in src)
        if(s.SpellSlot) slots |= s;
    return slots.len > 0 ? slots : 0;
/mob/proc/getSpellSlotsWithPassives()
    var/list/slots = list();
    for(var/obj/Skills/s in src)
        if(s.SpellSlot)
            if(s.SpellPassives.len > 0)
                slots |= s;
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