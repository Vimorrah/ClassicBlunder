/mob/var/tmp/
    magicTreeDisplayed=0;

/mob/proc/showMagicTree()
    changeTreeImage();
    setAccessNode();
    setTreeSelectNodes();
    skinShow(MAGIC_TREE);
/mob/proc/setMagicTreeToElement()
    DEBUGMSG("setting [src]'s magic tree displayed")
    switch(magicTreeDisplayed)
        if("Water") setMagicTreeToWater();
        if("Fire") setMagicTreeToFire();
        if("Air") setMagicTreeToAir();
        if("Earth") setMagicTreeToEarth();
        if("Light") setMagicTreeToLight();
        if("Time") setMagicTreeToTime();
        if("Dark") setMagicTreeToDark();
        if("Space") setMagicTreeToSpace();
        else setMagicTreeToWater();//default

/mob/proc/
    setMagicTreeToWater()
        hideRevealedButtons();
        DEBUGMSG("setting to water tree");
        magicTreeDisplayed="Water";
        showWaterTree();
    showWaterTree()
        DEBUGMSG("attempting to show water tree");
        showMagicTree();
        for(var/mname in glob.WaterTreeNodes)
            var/magic_node/mn = glob.WaterTreeNodes[mname];
            toggleMagicTreeButton(mn);
    hideWaterTree()
        for(var/mname in glob.WaterTreeNodes)
            skinHide(mname);


/mob/proc/
    setMagicTreeToFire()
        hideRevealedButtons();
        magicTreeDisplayed="Fire";
        showMagicTree();
        //for fire buttons
    hideFireTree()

/mob/proc/
    setMagicTreeToAir()
        hideRevealedButtons();
        magicTreeDisplayed="Air";
        showMagicTree();
    hideAirTree()

/mob/proc/
    setMagicTreeToEarth()
        hideRevealedButtons();
        magicTreeDisplayed="Earth";
        showMagicTree();
    hideEarthTree()

/mob/proc/
    setMagicTreeToLight()
        hideRevealedButtons();
        magicTreeDisplayed="Light";
        showMagicTree();
    hideLightTree()

/mob/proc/
    setMagicTreeToTime()
        hideRevealedButtons();
        magicTreeDisplayed="Time";
        showMagicTree();
    hideTimeTree()

/mob/proc/
    setMagicTreeToDark()
        hideRevealedButtons();
        magicTreeDisplayed="Dark";
        showMagicTree();
    hideDarkTree()

/mob/proc/
    setMagicTreeToSpace()
        hideRevealedButtons();
        magicTreeDisplayed="Space";
        showSpaceTree();
    showSpaceTree()
        showMagicTree();
    hideSpaceTree()

/mob/verb/
    Show_Magic_Tree()
        set category="Utility"
        setMagicTreeToElement();

    Show_Water_Tree()
        set hidden=1;
        set name=".ShowWaterTree"
        setMagicTreeToWater();
    
    Show_Fire_Tree()
        set hidden=1;
        set name=".ShowFireTree"
        setMagicTreeToFire();
    
    Show_Air_Tree()
        set hidden=1;
        set name=".ShowAirTree";
        setMagicTreeToAir();
    
    Show_Earth_Tree()
        set hidden=1;
        set name=".ShowEarthTree";
        setMagicTreeToEarth();
    
    Show_Light_Tree()
        set hidden=1;
        set name=".ShowLightTree";
        setMagicTreeToLight();
    
    Show_Time_Tree()
        set hidden=1;
        set name=".ShowTimeTree";
        setMagicTreeToTime();
    
    Show_Dark_Tree()
        set hidden=1;
        set name=".ShowDarkTree";
        setMagicTreeToDark();
    
    Show_Space_Tree()
        set hidden=1;
        set name=".ShowSpaceTree";
        setMagicTreeToSpace();

#ifdef DEBUGGING
/mob/verb/
    DEBUG_MAGIC_TREE()
        set category="Debug"
        for(var/x in glob.WaterTreeNodes)
            src << "[x] is defined in water tree nodes.";
    DEBUG_INIT_MAGIC_TREE()
        set category="Debug"
        initMagicNodes();
    DEBUG_CLEAR_MAGIC_TREE()
        set category="Debug"
        clearMagicNodes();
#endif
        