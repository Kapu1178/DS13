/datum/antagonist/proc/add_antagonist(var/datum/mind/player, var/ignore_role, var/do_not_equip, var/move_to_spawn, var/do_not_announce, var/preserve_appearance)

	if(!can_become_antag(player, ignore_role))
		return 0

	//If the passed player is a ghost, manifest them into a mob, then the mind becomes the mind attached to that new mob
	if(isghostmind(player))
		var/mob/living/M = create_default(player.ghost)
		player = M.mind

		//Create default used to set these so we set them here too
		ignore_role = TRUE
		do_not_equip = FALSE
		move_to_spawn = TRUE

	if(!add_antagonist_mind(player, ignore_role))
		return

	//do this again, just in case
	if(flags & ANTAG_OVERRIDE_JOB)
		player.assigned_role = role_text
		player.role_alt_title = null
	player.set_special_role(role_text)

	create_antagonist(player, move_to_spawn, do_not_announce, preserve_appearance)
	skill_setter.initialize_skills(player.current.skillset)
	if(!do_not_equip)
		equip(player.current)

	player.current.faction = faction

	pending_antagonists -= player

	//At least one was spawned, thats a success in our book
	last_spawn_data["success"] = TRUE
	var/list/spawns = last_spawn_data["spawns"]
	spawns |= "\ref[player]"
	return TRUE

/datum/antagonist/proc/add_antagonist_mind(var/datum/mind/player, var/ignore_role, var/nonstandard_role_type, var/nonstandard_role_msg)
	if(!istype(player))
		return 0
	if(!player.current)
		return 0
	if(player in current_antagonists)
		return 0

	current_antagonists |= player

	if(faction_verb && player.current)
		add_verb(player.current, faction_verb)

	if(CONFIG_GET(flag/objectives_disabled) == CONFIG_OBJECTIVE_VERB)
		add_verb(player.current, /mob/proc/add_objectives)

	add_verb(player.current, /client/proc/aooc)

	spawn(1 SECOND) //Added a delay so that this should pop up at the bottom and not the top of the text flood the new antag gets.
		to_chat(player.current, "<span class='notice'>Once you decide on a goal to pursue, you can optionally display it to \
			everyone at the end of the shift with the <b>Set Ambition</b> verb, located in the IC tab.  You can change this at any time, \
			and it otherwise has no bearing on your round.</span>")
	add_verb(player.current, /mob/living/proc/write_ambition)

	// Handle only adding a mind and not bothering with gear etc.
	if(nonstandard_role_type)
		faction_members |= player
		to_chat(player.current, "<span class='danger'><font size=3>You are \a [nonstandard_role_type]!</font></span>")
		player.set_special_role(nonstandard_role_type)
		if(nonstandard_role_msg)
			to_chat(player.current, "<span class='notice'>[nonstandard_role_msg]</span>")
		update_icons_added(player)
	return 1

/datum/antagonist/proc/remove_antagonist(datum/mind/player, show_message,implanted)
	if(!istype(player))
		return 0
	if(player.current && faction_verb)
		remove_verb(player.current, faction_verb)
	if(player in current_antagonists)
		to_chat(player.current, "<span class='danger'><font size = 3>You are no longer a [role_text]!</font></span>")
		current_antagonists -= player
		faction_members -= player
		player.set_special_role(null)
		update_icons_removed(player)
		BITSET(player.current.hud_updateflag, SPECIALROLE_HUD)

		//Reset their skills to be job-appropriate.
		if(player.current)
			player.current.reset_skillset()

		if(!is_special_character(player))
			remove_verb(player.current, list(/mob/living/proc/write_ambition, /client/proc/aooc))
			player.ambitions = ""
		return 1
	return 0
