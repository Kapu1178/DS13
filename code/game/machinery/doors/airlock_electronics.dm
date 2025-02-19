//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/item/airlock_electronics
	name = "airlock electronics"
	icon = 'icons/obj/doors/door_assembly.dmi'
	icon_state = "door_electronics"
	w_class = ITEM_SIZE_SMALL //It should be tiny! -Agouri

	matter = list(MATERIAL_STEEL = 50,MATERIAL_GLASS = 50)

	req_access = list(access_engineering)

	var/secure = 0 //if set, then wires will be randomized and bolts will drop if the door is broken
	var/list/conf_access = list()
	var/one_access = 0 //if set to 1, door would receive req_one_access instead of req_access
	var/last_configurator = null
	var/locked = 1
	var/lockable = 1


/obj/item/airlock_electronics/attack_self(mob/user as mob)
	if (!ishuman(user) && !istype(user,/mob/living/silicon/robot))
		return ..(user)

	tgui_interact(user)



//tgui interact code generously lifted from tgstation.
/obj/item/airlock_electronics/tgui_interact(mob/user, datum/tgui/ui = null)

	SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "airlock_electronics", src.name)
		ui.open()

/obj/item/airlock_electronics/ui_state(mob/user)
	return GLOB.tgui_hands_state

/obj/item/airlock_electronics/ui_static_data(mob/user)
	var/list/data = list()

	var/list/regions = list()
	for(var/i in ACCESS_REGION_SECURITY to ACCESS_REGION_SUPPLY) //code/game/jobs/_access_defs.dm
		var/list/region = list()
		var/list/accesses = list()
		for(var/j in get_region_accesses(i))
			var/list/access = list()
			access["desc"] = get_access_desc(j)
			access["ref"] = j
			accesses[++accesses.len] = access
		region["name"] = get_region_accesses_name(i)
		region["accesses"] = accesses
		regions[++regions.len] = region

	data["regions"] = regions
	return data

/obj/item/airlock_electronics/ui_data(mob/user)
	var/list/data = list()

	data["accesses"] = conf_access
	data["oneAccess"] = one_access
	data["locked"] = locked
	data["lockable"] = lockable

	return data

/obj/item/airlock_electronics/ui_act(action, params)
	. = ..()
	if(.)
		return

	switch(action)
		if("clear_all")
			conf_access = list()
			one_access = 0
			. = TRUE
		if("grant_all")
			conf_access = get_region_accesses(ACCESS_REGION_ALL)
			. = TRUE
		if("one_access")
			one_access = !one_access
			. = TRUE
		if("set")
			var/access = text2num(params["access"])
			if (!(access in conf_access))
				conf_access += access
			else
				conf_access -= access
			. = TRUE
		if("grant_region")
			var/region = params["region"]
			if(isnull(region))
				return
			conf_access |= get_region_accesses(region)
			. = TRUE
		if("deny_region")
			var/region = params["region"]
			if(isnull(region))
				return
			conf_access -= get_region_accesses(region)
			. = TRUE
		if("unlock")
			if(!lockable)
				return
			if(!req_access || istype(usr,/mob/living/silicon))
				locked = 0
				last_configurator = usr.name
				. = TRUE
			else
				var/obj/item/card/id/I = usr.get_active_hand()
				I = I ? I.GetIdCard() : null
				if(!istype(I, /obj/item/card/id))
					to_chat(usr, "<span class='warning'>[\src] flashes a yellow LED near the ID scanner. Did you remember to scan your ID or PDA?</span>")
					return TRUE
				if (check_access(I))
					locked = 0
					last_configurator = I.registered_name
				else
					to_chat(usr, "<span class='warning'>[\src] flashes a red LED near the ID scanner, indicating your access has been denied.</span>")
					. = TRUE
		if("lock")
			if(!lockable)
				return
			locked = 1
			. = TRUE

/obj/item/airlock_electronics/secure
	name = "secure airlock electronics"
	desc = "designed to be somewhat more resistant to hacking than standard electronics."
	origin_tech = list(TECH_DATA = 2)
	secure = 1

/obj/item/airlock_electronics/brace
	name = "airlock brace access circuit"
	req_access = list()
	locked = 0
	lockable = 0

/obj/item/airlock_electronics/brace/tgui_interact(mob/user, datum/tgui/ui = null)
	SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "airlock_electronics", src.name)
		ui.open()

/obj/item/airlock_electronics/brace/ui_state(mob/user)
	return GLOB.tgui_deep_inventory_state