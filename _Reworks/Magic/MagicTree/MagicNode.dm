globalTracker/var/
    list/WaterTreeNodes=list();
    //todo: add the rest
/proc/initMagicNodes()
    initWaterTree();
    initFireTree();
    initWindTree();
    initEarthTree();
    initLightTree();
    initTimeTree();
    initDarkTree();
    initSpaceTree();
/proc/clearMagicNodes()
    glob.WaterTreeNodes=list();//resetti the spaghetti
/proc/
    initWaterTree()
        DEBUGMSG("initializing water tree nodes");
        for(var/t in subtypesof(/magic_node/water_tree))
            DEBUGMSG("adding [t] type");
            var/magic_node/mn = new t;
            glob.WaterTreeNodes[mn.name] = mn;
            DEBUGMSG("node added under name [mn.name]");
    initFireTree()
    initWindTree()
    initEarthTree()
    initLightTree()
    initTimeTree()
    initDarkTree()
    initSpaceTree()


/magic_node/var
    name = "Magic Node";
    xLoc;
    yLoc;
    lockedNodeImage;
    unlockedNodeImage;
    command;
    nodeType;//aoe, autohit, buff, debuff, line, projectile; mage, crown, spell
    list/unlocksNodes=list();
    list/grantsSkills=list();
    list/grantsPassives=list();
    list/grantsKnowledges=list();

/magic_node/water_tree/
    water_entry_node
        name=WATER_NODE_ENTRY;
        xLoc = WATER_NODE_ENTRY_X;
        yLoc = WATER_NODE_ENTRY_Y;
        nodeType = "Autohit"
        lockedNodeImage = LOCKED_AUTOHIT;
        unlockedNodeImage = WATER_UNLOCKED_AUTOHIT;

    water_node_21
        name=WATER_NODE_21;
        xLoc = WATER_NODE_21_X;
        yLoc = WATER_NODE_21_Y;
        nodeType = "Spell Passive"
        lockedNodeImage = LOCKED_SPELLP;
        unlockedNodeImage = WATER_UNLOCKED_SPELLP;
    water_node_22
        name=WATER_NODE_22;
        xLoc = WATER_NODE_22_X;
        yLoc = WATER_NODE_22_Y;
        nodeType = "Spell Passive"
        lockedNodeImage = LOCKED_SPELLP;
        unlockedNodeImage = WATER_UNLOCKED_SPELLP;
    water_node_31
        name=WATER_NODE_31;
        xLoc = WATER_NODE_31_X;
        yLoc = WATER_NODE_31_Y;
        nodeType = "Mage Passive"
        lockedNodeImage = LOCKED_MAGEP;
        unlockedNodeImage = WATER_UNLOCKED_MAGEP;
    water_node_32
        name=WATER_NODE_32;
        xLoc = WATER_NODE_32_X;
        yLoc = WATER_NODE_32_Y;
        nodeType = "Mage Passive"
        lockedNodeImage = LOCKED_MAGEP;
        unlockedNodeImage = WATER_UNLOCKED_MAGEP;
    water_node_41
        name=WATER_NODE_41;
        xLoc = WATER_NODE_41_X;
        yLoc = WATER_NODE_41_Y;
        nodeType = "Debuff"
        lockedNodeImage = LOCKED_DEBUFF;
        unlockedNodeImage = WATER_UNLOCKED_DEBUFF;
    water_node_42
        name=WATER_NODE_42;
        xLoc = WATER_NODE_42_X;
        yLoc = WATER_NODE_42_Y;
        nodeType = "Projectile"
        lockedNodeImage = LOCKED_PROJ;
        unlockedNodeImage = WATER_UNLOCKED_PROJ;
    water_node_center
        name=WATER_NODE_CENTER;
        xLoc = WATER_NODE_CENTER_X;
        yLoc = WATER_NODE_CENTER_Y;
        nodeType = "Mage Passive"
        lockedNodeImage = LOCKED_MAGEP;
        unlockedNodeImage = WATER_UNLOCKED_MAGEP;
    water_node_61
        name=WATER_NODE_61;
        xLoc = WATER_NODE_61_X;
        yLoc = WATER_NODE_61_Y;
        nodeType = "Spell Passive"
        lockedNodeImage = LOCKED_SPELLP;
        unlockedNodeImage = WATER_UNLOCKED_SPELLP;
    water_node_62
        name=WATER_NODE_62;
        xLoc = WATER_NODE_62_X;
        yLoc = WATER_NODE_62_Y;
        nodeType = "Spell Passive"
        lockedNodeImage = LOCKED_SPELLP;
        unlockedNodeImage = WATER_UNLOCKED_SPELLP;
    water_node_top
        name=WATER_NODE_TOP;
        xLoc = WATER_NODE_TOP_X;
        yLoc = WATER_NODE_TOP_Y;
        nodeType = "Mage Passive"
        lockedNodeImage = LOCKED_MAGEP;
        unlockedNodeImage = WATER_UNLOCKED_MAGEP;
    water_node_crowd
        name=WATER_NODE_CROWN;
        xLoc = WATER_NODE_CROWN_X;
        yLoc = WATER_NODE_CROWN_Y;
        nodeType = "Pinnacle"
        lockedNodeImage = LOCKED_PINNACLE;
        unlockedNodeImage = WATER_UNLOCKED_PINNACLE;

magic_node/air_tree
    air_node_south
        name=AIR_NODE_ENTRY
    air_node_south2
        name=AIR_NODE_SOUTH2
    air_node_south3
        name=AIR_NODE_SOUTH3
    air_node_east
        name=AIR_NODE_EAST
    air_node_east2
        name=AIR_NODE_EAST2
    air_node_east3
        name=AIR_NODE_EAST3
    air_node_west
        name=AIR_NODE_WEST
    air_node_west2
        name=AIR_NODE_WEST2
    air_node_west3
        name=AIR_NODE_WEST3
    air_node_north
        name=AIR_NODE_CROWN
    air_node_north2
        name=AIR_NODE_NORTH2
    air_node_north3
        name=AIR_NODE_NORTH3

/mob/var/
    magicKnowledge=list();
    accessedMagicTrees=list();
    acquiredMagicNodes=list();

/mob/proc/
    unlockMagicNode(node as text)
        set name=".unlockMagicNode"
        set hidden = 1;
        if(!node in VALID_MAGIC_NODES) return;
        DEBUGMSG("[src] attempting to unlock [node] magic node");

/mob/verb/
    Unlock_Access_Node(element as text)
        set name = ".unlockAccessNode"
        set hidden = 1;
        if(!element in VALID_MAGIC_ELEMENTS) return;
        DEBUGMSG("[src] attempting to unlock [element] access node");