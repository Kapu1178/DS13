GLOBAL_LIST_INIT(registered_weapons, list())
GLOBAL_LIST_INIT(registered_cyborg_weapons, list())

/obj/item/gun/energy
	name = "energy gun"
	desc = "A basic energy-based gun."
	icon_state = "energy"
	fire_sound = 'sound/weapons/Taser.ogg'
	fire_sound_text = "laser blast"

	var/obj/item/cell/power_supply //What type of power cell this uses
	var/removeable_cell = FALSE	//If true, the cell can be removed and replaced
	var/charge_cost = 20 //How much energy is needed to fire.
	var/max_shots = 10 //Determines the capacity of the weapon's power cell. Specifying a cell_type overrides this value.
	var/cell_type = null
	projectile_type = /obj/item/projectile/beam/practice
	var/modifystate
	var/charge_meter = 1	//if set, the icon state will be chosen based on the current charge

	//self-recharging
	var/self_recharge = 0	//if set, the weapon will recharge itself
	var/use_external_power = 0 //if set, the weapon will look for an external power source to draw from, otherwise it recharges magically
	var/recharge_time = 4
	var/charge_tick = 0



/obj/item/gun/energy/unload_ammo(mob/user, var/allow_dump)
	if(power_supply && removeable_cell)
		user.put_in_hands(power_supply)
		user.visible_message("[user] removes [power_supply] from [src].", "<span class='notice'>You remove [power_supply] from [src].</span>")
		playsound(loc, mag_remove_sound, 50, 1)
		power_supply.update_icon()
		power_supply = null

/obj/item/gun/energy/load_ammo(var/obj/item/A, mob/user)
	if (istype(A, /obj/item/cell))
		if (power_supply)
			return	//Already got a cell


		if (cell_type && !istype(A, cell_type))
			to_chat(user, SPAN_WARNING("That is the wrong type for this weapon!"))
			return

		if(!user.unEquip(A, src))
			return

		power_supply = A
		.=..()

/obj/item/gun/energy/attackby(var/obj/item/A as obj, mob/user as mob)
	load_ammo(A, user)

/obj/item/gun/energy/attack_hand(mob/user as mob)
	if(user.get_inactive_hand() == src && removeable_cell)
		unload_ammo(user)
	else
		return ..()


/obj/item/gun/energy/switch_firemodes()
	. = ..()
	if(.)
		update_icon()

/obj/item/gun/energy/emp_act(severity)
	..()
	update_icon()

/obj/item/gun/energy/New()
	..()
	if(cell_type)
		power_supply = new cell_type(src)
	else
		power_supply = new /obj/item/cell/device/variable(src, max_shots*charge_cost)
	if(self_recharge)
		START_PROCESSING(SSobj, src)
	update_icon()

/obj/item/gun/energy/Destroy()
	QDEL_NULL(power_supply)
	if(self_recharge)
		STOP_PROCESSING(SSobj, src)
	.=..()

/obj/item/gun/energy/get_cell()
	return power_supply

/obj/item/gun/energy/Process()
	if(self_recharge) //Every [recharge_time] ticks, recharge a shot for the cyborg
		charge_tick++
		if(charge_tick < recharge_time) return 0
		charge_tick = 0

		if(!power_supply || power_supply.charge >= power_supply.maxcharge)
			return 0 // check if we actually need to recharge

		if(use_external_power)
			var/obj/item/cell/external = get_external_power_supply()
			if(!external || !external.use(charge_cost)) //Take power from the borg...
				return 0

		power_supply.give(charge_cost) //... to recharge the shot
		update_icon()
	return 1

/obj/item/gun/energy/consume_next_projectile()
	if(!power_supply) return null
	if(!power_supply.checked_use(charge_cost)) return null
	if (projectile_type)
		return new projectile_type(src)
	else
		return TRUE	//If this gun doesnt use a projectile, just return true to indicate we consumed the power

/obj/item/gun/energy/proc/get_external_power_supply()
	if(isrobot(src.loc))
		var/mob/living/silicon/robot/R = src.loc
		return R.cell
	if(istype(src.loc, /obj/item/rig_module))
		var/obj/item/rig_module/module = src.loc
		if(module.holder && module.holder.wearer)
			var/mob/living/carbon/human/H = module.holder.wearer
			if(istype(H) && H.back)
				var/obj/item/rig/suit = H.back
				if(istype(suit))
					return suit.cell
	return null

/obj/item/gun/energy/examine(mob/user)
	. = ..(user)
	if(!power_supply)
		to_chat(user, "Seems like it's dead.")
		return
	var/shots_remaining = round(power_supply.charge / charge_cost)
	to_chat(user, "Has [shots_remaining] shot\s remaining.")
	return

/obj/item/gun/energy/has_ammo()
	if(!power_supply)
		return FALSE
	return (power_supply.charge >= charge_cost)


/obj/item/gun/energy/update_icon()
	..()
	if(charge_meter && power_supply)
		var/ratio = power_supply.percent()

		//make sure that rounding down will not give us the empty state even if we have charge for a shot left.
		if(power_supply.charge < charge_cost)
			ratio = 0
		else
			ratio = max(round(ratio, 25), 25)

		if(modifystate)
			icon_state = "[modifystate][ratio]"
		else
			icon_state = "[initial(icon_state)][ratio]"
