obj/structure/firedoor_assembly
	name = "\improper emergency shutter assembly"
	desc = "It can save lives."
	icon = 'icons/obj/doors/hazard/door.dmi'
	icon_state = "construction"
	anchored = 0
	opacity = 0
	density = 1
	var/wired = 0

obj/structure/firedoor_assembly/update_icon()
	if(anchored)
		icon_state = "door_anchored"
	else
		icon_state = "construction"

obj/structure/firedoor_assembly/attackby(var/obj/item/C, mob/user as mob)
	if(isCoil(C) && !wired && anchored)
		var/obj/item/stack/cable_coil/cable = C
		if (cable.get_amount() < 1)
			to_chat(user, "<span class='warning'>You need one length of coil to wire \the [src].</span>")
			return
		user.visible_message("[user] wires \the [src].", "You start to wire \the [src].")
		if(do_after(user, 40, src) && !wired && anchored)
			if (cable.use(1))
				wired = 1
				to_chat(user, "<span class='notice'>You wire \the [src].</span>")

	else if(isWirecutter(C) && wired )
		playsound(src.loc, 'sound/items/Wirecutter.ogg', 100, 1)
		user.visible_message("[user] cuts the wires from \the [src].", "You start to cut the wires from \the [src].")

		if(do_after(user, 40, src))
			if(!src) return
			to_chat(user, "<span class='notice'>You cut the wires!</span>")
			new/obj/item/stack/cable_coil(src.loc, 1)
			wired = 0

	else if(istype(C, /obj/item/airalarm_electronics) && wired)
		if(anchored)
			playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
			user.visible_message("<span class='warning'>[user] has inserted a circuit into \the [src]!</span>",
								  "You have inserted the circuit into \the [src]!")
			new /obj/machinery/door/firedoor(src.loc)
			qdel(C)
			qdel(src)
		else
			to_chat(user, "<span class='warning'>You must secure \the [src] first!</span>")
	else if(isWrench(C))
		anchored = !anchored
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		user.visible_message("<span class='warning'>[user] has [anchored ? "" : "un" ]secured \the [src]!</span>",
							  "You have [anchored ? "" : "un" ]secured \the [src]!")
		update_icon()
	else if(!anchored && isWelder(C))
		if(C.use_tool(user, src, WORKTIME_SLOW, QUALITY_WELDING, FAILCHANCE_NORMAL))
			user.visible_message("<span class='warning'>[user] has dissassembled \the [src].</span>",
								"You have dissassembled \the [src].")
			new /obj/item/stack/material/steel(src.loc, 2)
			qdel(src)
		else
			to_chat(user, "<span class='notice'>You need more welding fuel.</span>")
	else
		..(C, user)
