/mob/proc/
    isShowing(control)
        DEBUGMSG("checking if [control] is being shown");
        return winget(src, control, "is-visible") == "true" ? 1 : 0;
    skinShow(control)
        DEBUGMSG("[src] is showing control [control]");
        winset(src, control, "is-visible=\"true\"");
    skinHide(control)
        DEBUGMSG("[src] is hiding control [control]");
        winset(src, control, "is-visible=\"false\"");

/mob/proc/changeTreeImage()
    var/elementImage = getTreeImage(magicTreeDisplayed);
    DEBUGMSG("[src] is making a magic tree with element [magicTreeDisplayed]");
    var/list/params=list();
    params["image"] = elementImage;
    winset(src, "MagicTree", list2params(params));

/mob/proc/hideRevealedButtons()
    DEBUGMSG("Hiding magic tree buttons that have been revealed ([magicTreeDisplayed] is currently displayed tree)");
    switch(magicTreeDisplayed)
        if("Water") hideWaterTree();
        if("Fire") hideFireTree();
        if("Air") hideAirTree();
        if("Earth") hideEarthTree();
        if("Light") hideLightTree();
        if("Time") hideTimeTree();
        if("Dark") hideDarkTree();
        if("Space") hideSpaceTree();
        if(0) return;
/mob/proc/getTreeImage(element)
    switch(element)
        if("Water") return WATER_TREE_IMAGE;
        if("Fire") return FIRE_TREE_IMAGE;
        if("Air") return AIR_TREE_IMAGE;
        if("Earth") return EARTH_TREE_IMAGE;
        if("Light") return LIGHT_TREE_IMAGE;
        if("Time") return TIME_TREE_IMAGE;
        if("Dark") return DARK_TREE_IMAGE;
        if("Space") return SPACE_TREE_IMAGE;
/mob/proc/getUnlockedAccessNodeImage(element)
    switch(element)
        if("Water") return WATER_UNLOCKED_ACCESS;
        if("Fire") return FIRE_UNLOCKED_ACCESS;
        if("Air") return AIR_UNLOCKED_ACCESS;
        if("Earth") return EARTH_UNLOCKED_ACCESS;
        if("Light") return LIGHT_UNLOCKED_ACCESS;
        if("Time") return TIME_UNLOCKED_ACCESS;
        if("Dark") return DARK_UNLOCKED_ACCESS;
        if("Space") return SPACE_UNLOCKED_ACCESS;
/mob/proc/getLockedAccessNodeImage(element)
    switch(element)
        if("Water") return WATER_LOCKED_ACCESS;
        if("Fire") return FIRE_LOCKED_ACCESS;
        if("Air") return AIR_LOCKED_ACCESS;
        if("Earth") return EARTH_LOCKED_ACCESS;
        if("Light") return LIGHT_LOCKED_ACCESS;
        if("Time") return TIME_LOCKED_ACCESS;
        if("Dark") return DARK_LOCKED_ACCESS;
        if("Space") return SPACE_LOCKED_ACCESS;

/mob/proc/setAccessNode()
    var/element = magicTreeDisplayed;
    DEBUGMSG("setting access node to [element]")
    var/list/params=list();
    params["type"] = "Button";
    params["parent"] = "MagicTree";
    params["pos"] = "284x616";
    params["size"] = "32x32";
    if(element in accessedMagicTrees) params["image"] = getUnlockedAccessNodeImage(element) //node unlocked
    else params["image"] = getLockedAccessNodeImage(element) //node locked
    params["command"] = ".unlockAccessNode \"[element]\"";
    params["name"] = "AccessNode"
    params["is-visible"] = "true";
    winset(src, "AccessNode", list2params(params));

mob/proc/setTreeSelectNodes()
    var/list/elements = VALID_MAGIC_ELEMENTS;
    for(var/e in elements)
        var/list/params=list();
        if(e in accessedMagicTrees) params["image"] = getUnlockedAccessNodeImage(e) //tree unlocked
        else params["image"] = getLockedAccessNodeImage(e) //tree locked
        winset(src, "[e]Tree", list2params(params));


/mob/proc/toggleMagicTreeButton(magic_node/mn, hiding=0)
    DEBUGMSG("making magic button [mn.name]");
    var/list/params=list();
    params["type"] = "Button";
    params["parent"] = "MagicTree";
    params["pos"] = "[mn.xLoc]x[mn.yLoc]";
    params["size"] = "32x32";
    if(mn in acquiredMagicNodes) params["image"] = mn.unlockedNodeImage //node unlocked
    else params["image"] = mn.lockedNodeImage//node locked
    params["command"] = mn.command ? mn.command : ".unlockMagicNode [mn.name]";
    params["name"] = mn.name;
    if(isShowing(mn.name) && hiding) params["is-visible"] = "false";
    else params["is-visible"] = "true";
    winset(src, mn.name, list2params(params));
