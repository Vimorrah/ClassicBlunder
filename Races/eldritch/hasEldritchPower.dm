/mob/proc/hasEldritchPower()
    if(!WoundIntent) return 0;
    if(isEldritchTrueForm()) return 1;
    if(hasSecret("Eldritch (Shrouded)")) return 1;
    if(isEnlightenedReflected()) return 1;
    return 0;

/mob/proc/isEldritchTrueForm()
    if(hasSecret("Eldritch") && CheckSlotless("True Form")) return 1;
    return 0;
/mob/proc/isEnlightenedReflected()
    if(hasSecret("Eldritch (Reflected)" && get_potential() >= glob.AdvancedElementPotential)) return 1;
    return 0;