/obj/aiming_overlay
	name = ""
	desc = "Stick 'em up!"
	icon = 'icons/effects/Targeted.dmi'
	icon_state = "locking"
	anchored = 1
	density = 0
	opacity = 0
	layer = ABOVE_HUMAN_LAYER
	simulated = 0
	mouse_opacity = 0

	var/mob/living/aiming_at   // Who are we currently targeting, if anyone?
	var/obj/item/aiming_with   // What are we targeting with?
	var/mob/living/owner       // Who do we belong to?
	var/locked =    0          // Have we locked on?
	var/lock_time = 0          // When -will- we lock on?
	var/active =    0          // Is our owner intending to take hostages?
	var/target_permissions = TARGET_CAN_RADIO // Permission bitflags.

/obj/aiming_overlay/New(var/newowner)
	..()
	owner = newowner
	forceMove(null)
	verbs.Cut()

/obj/aiming_overlay/proc/toggle_permission(var/perm)

	if(target_permissions & perm)
		target_permissions &= ~perm
	else
		target_permissions |= perm

	var/message = "no longer permitted to "
	var/use_span = "warning"
	if(target_permissions & perm)
		message = "now permitted to "
		use_span = "notice"

	switch(perm)
		if(TARGET_CAN_MOVE)
			message += "move"
		if(TARGET_CAN_CLICK)
			message += "use items"
		if(TARGET_CAN_RADIO)
			message += "use a radio"
		else
			return

	var/aim_message = "<span class='[use_span]'>[aiming_at ? "\The [aiming_at] is" : "Your targets are"] [message].</span>"
	to_chat(owner, aim_message)
	if(aiming_at)
		to_chat(aiming_at, "<span class='[use_span]'>You are [message].</span>")
/obj/aiming_overlay/Process()
	if(!owner)
		qdel(src)
		return
	..()
	update_aiming()

/obj/aiming_overlay/Destroy()
	cancel_aiming(1)
	owner = null
	return ..()

/obj/aiming_overlay/proc/update_aiming_deferred()
	set waitfor = 0
	sleep(0)
	update_aiming()

/obj/aiming_overlay/proc/update_aiming()
	SIGNAL_HANDLER
	if(!owner)
		qdel(src)
		return

	if(!aiming_at)
		cancel_aiming()
		return

	if(!locked && lock_time >= world.time)
		locked = 1
		update_icon()

	var/cancel_aim = 1

	if(!(aiming_with in owner) || (istype(owner, /mob/living/carbon/human) && (owner.l_hand != aiming_with && owner.r_hand != aiming_with)))
		to_chat(owner, "<span class='warning'>You must keep hold of your weapon!</span>")
	else if(owner.eye_blind)
		to_chat(owner, "<span class='warning'>You are blind and cannot see your target!</span>")
	else if(!aiming_at || !istype(aiming_at.loc, /turf))
		to_chat(owner, "<span class='warning'>You have lost sight of your target!</span>")
	else if(owner.incapacitated() || owner.lying || owner.restrained())
		to_chat(owner, "<span class='warning'>You must be conscious and standing to keep track of your target!</span>")
	else if(aiming_at.is_invisible_to(owner))
		to_chat(owner, "<span class='warning'>Your target has become invisible!</span>")
	else if(!(aiming_at in view(owner)))
		to_chat(owner, "<span class='warning'>Your target is too far away to track!</span>")
	else
		cancel_aim = 0

	forceMove(get_turf(aiming_at))

	if(cancel_aim)
		cancel_aiming()
		return

	if(!owner.incapacitated() && owner.client)
		spawn(0)
			owner.set_dir(get_dir(get_turf(owner), get_turf(src)))

/obj/aiming_overlay/proc/aim_at(var/mob/target, var/obj/thing)

	if(!owner)
		return

	if(owner.incapacitated())
		to_chat(owner, "<span class='warning'>You cannot aim a gun in your current state.</span>")
		return
	if(owner.lying)
		to_chat(owner, "<span class='warning'>You cannot aim a gun while prone.</span>")
		return
	if(owner.restrained())
		to_chat(owner, "<span class='warning'>You cannot aim a gun while handcuffed.</span>")
		return

	if(aiming_at)
		if(aiming_at == target)
			return
		cancel_aiming(1)
		owner.visible_message("<span class='danger'>\The [owner] turns \the [thing] on \the [target]!</span>")
	else
		owner.visible_message("<span class='danger'>\The [owner] aims \the [thing] at \the [target]!</span>")

	to_chat(target, "<span class='danger'>You now have a gun pointed at you. No sudden moves!</span>")
	aiming_with = thing
	aiming_at = target
	if(istype(aiming_with, /obj/item/gun))
		playsound(get_turf(owner), 'sound/weapons/TargetOn.ogg', 50,1)

	forceMove(get_turf(target))
	START_PROCESSING(SSobj, src)

	aiming_at.aimed |= src
	toggle_active(1)
	locked = 0
	update_icon()
	lock_time = world.time + 35
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, .proc/update_aiming)
	RegisterSignal(aiming_at, COMSIG_MOVABLE_MOVED, .proc/target_moved)
	RegisterSignal(aiming_at, COMSIG_PARENT_QDELETING, .proc/cancel_aiming)

/obj/aiming_overlay/update_icon()
	if(locked)
		icon_state = "locked"
	else
		icon_state = "locking"

/obj/aiming_overlay/proc/toggle_active(var/force_state = null)
	if(!isnull(force_state))
		if(active == force_state)
			return
		active = force_state
	else
		active = !active

	if(!active)
		cancel_aiming()

	if(owner.client)
		owner.hud_used?.gun_setting_icon.icon_state = "gun[active]"

/obj/aiming_overlay/proc/cancel_aiming(var/no_message = 0)
	SIGNAL_HANDLER
	if(!aiming_with || !aiming_at)
		return
	if(istype(aiming_with, /obj/item/gun))
		playsound(get_turf(owner), 'sound/weapons/TargetOff.ogg', 50,1)
	if(!no_message)
		owner.visible_message("<span class='notice'>\The [owner] lowers \the [aiming_with].</span>")

	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)
	if(aiming_at)
		UnregisterSignal(aiming_at, list(COMSIG_MOVABLE_MOVED, COMSIG_PARENT_QDELETING))
		aiming_at.aimed -= src
		aiming_at = null

	aiming_with = null
	forceMove(null)
	STOP_PROCESSING(SSobj, src)

/obj/aiming_overlay/proc/target_moved()
	SIGNAL_HANDLER
	update_aiming()
	INVOKE_ASYNC(src, .proc/trigger, TARGET_CAN_MOVE)
