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
	var/tmp/shadowbringer_cache_key
	var/tmp/shadowbringer_cached_height = 0
	var/tmp/shadowbringer_cached_bottom_gap = 0

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

mob/Players/proc/Shadowbringer_UpdateIconCache()
	var/cache_key = "[icon]-[icon_state]-[dir]"
	if(cache_key == shadowbringer_cache_key)
		return
	shadowbringer_cache_key = cache_key
	var/icon/I = icon(icon, icon_state, dir)
	shadowbringer_cached_height = I.Height()
	shadowbringer_cached_bottom_gap = 0
	var/w = I.Width()
	var/list/sample_x = list(max(1, round(w * 0.25)), max(1, round(w * 0.5)), max(1, round(w * 0.75)))
	for(var/y = 1 to shadowbringer_cached_height)
		for(var/sx in sample_x)
			if(I.GetPixel(sx, y))
				shadowbringer_cached_bottom_gap = y - 1
				return

mob/Players/proc/Shadowbringer_RefreshShadowOverlay()
	if(!Shadowbringer_ShouldCastShadow())
		Shadowbringer_ClearShadowOverlay()
		return
	Shadowbringer_ClearShadowOverlay()
	var/mutable_appearance/MA = new(src)
	var/matrix/T = matrix()
	T.Scale(1, -1)
	MA.transform = T
	Shadowbringer_UpdateIconCache()
	var/h = shadowbringer_cached_height
	if(!h) h = world.icon_size
	var/bottom_gap = shadowbringer_cached_bottom_gap
	MA.pixel_x = 0
	MA.pixel_y = -h + (2 * bottom_gap)
	MA.appearance_flags |= KEEP_TOGETHER
	MA.color = rgb(8, 8, 10)
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
