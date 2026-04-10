// Shadow shit

mob/proc/ShadowbringerPassiveActive()
	if(HasPassive("Shadowbringer"))
		return TRUE
	if(passive_handler)
		if(passive_handler.passives["Shadowbringer"] || passive_handler.tmp_passives["Shadowbringer"])
			return TRUE
	return FALSE

mob/Players
	var/tmp/mutable_appearance/ShadowbringerShadowAppearance

mob/Players/proc/Shadowbringer_ShouldCastShadow()
	if(AdminInviso)
		return FALSE
	if(invisibility > 0)
		return FALSE
	return TRUE

mob/Players/proc/Shadowbringer_ClearShadowOverlay()
	if(ShadowbringerShadowAppearance)
		overlays -= ShadowbringerShadowAppearance
		underlays -= ShadowbringerShadowAppearance
		ShadowbringerShadowAppearance = null

mob/proc/Shadowbringer_IconHeight()
	. = bound_height
	if(!.)
		. = world.icon_size

mob/Players/proc/Shadowbringer_RefreshShadowOverlay()
	if(!Shadowbringer_ShouldCastShadow())
		Shadowbringer_ClearShadowOverlay()
		return
	Shadowbringer_ClearShadowOverlay()
	var/mutable_appearance/MA = new(src)
	var/matrix/T = matrix()
	T.Scale(1, -1)
	MA.transform = T
	var/h = Shadowbringer_IconHeight()
	MA.pixel_y -= h
	MA.color = rgb(28, 28, 38)
	MA.alpha = 150
	MA.layer = MOB_LAYER - 0.01
	ShadowbringerShadowAppearance = MA
	underlays += MA

proc/Shadowbringer_Process()
	if(WorldLoading)
		return
	var/list/lit = list()
	for(var/mob/Players/S in players)
		if(!S.ShadowbringerPassiveActive())
			continue
		if(!S.Shadowbringer_ShouldCastShadow())
			continue
		lit[S] = 1
		for(var/mob/Players/P in view(S))
			if(!P.Shadowbringer_ShouldCastShadow())
				continue
			lit[P] = 1
	for(var/mob/Players/M in players)
		if(lit[M])
			M.Shadowbringer_RefreshShadowOverlay()
		else
			M.Shadowbringer_ClearShadowOverlay()
