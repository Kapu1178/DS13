proc/sql_poll_population()
	if(!sqllogging)
		return
	var/admincount = GLOB.admins.len
	var/playercount = 0
	for(var/mob/M in GLOB.player_list)
		if(M.client)
			playercount += 1
	if(!SSdbcore.Connect())
		log_game("SQL ERROR during population polling. Failed to connect.")
	else
		var/sqltime = time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")
		var/datum/db_query/query = SSdbcore.NewQuery("INSERT INTO `tgstation`.`population` (`playercount`, `admincount`, `time`) VALUES ([playercount], [admincount], '[sqltime]')")
		if(!query.Execute())
			var/err = query.ErrorMsg()
			log_game("SQL ERROR during population polling. Error : \[[err]\]\n")
		qdel(query)


proc/sql_report_round_start()
	// TODO
	if(!sqllogging)
		return
proc/sql_report_round_end()
	// TODO
	if(!sqllogging)
		return

proc/sql_report_death(var/mob/living/carbon/human/H)
	if(!sqllogging)
		return
	if(!H)
		return
	if(!H.key || !H.mind)
		return

	var/area/placeofdeath = get_area(H)
	var/podname = placeofdeath ? placeofdeath.name : "Unknown area"

	var/laname
	var/lakey
	if(H.last_attacker_)
		laname = H.last_attacker_.name
		lakey = H.last_attacker_.client.key
	var/sqltime = time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")
	var/coord = "[H.x], [H.y], [H.z]"
//	log_debug("INSERT INTO death (name, byondkey, job, special, pod, tod, laname, lakey, gender, bruteloss, fireloss, brainloss, oxyloss) VALUES ('[sqlname]', '[sqlkey]', '[sqljob]', '[sqlspecial]', '[sqlpod]', '[sqltime]', '[laname]', '[lakey]', '[H.gender]', [H.bruteloss], [H.getFireLoss()], [H.getBrainLoss()], [H.getOxyLoss()])")

	if(!SSdbcore.Connect())
		log_game("SQL ERROR during death reporting. Failed to connect.")
		return
	var/datum/db_query/query = SSdbcore.NewQuery("INSERT INTO death (name, byondkey, job, special, pod, tod, laname, lakey, gender, bruteloss, fireloss, brainloss, oxyloss, coord) VALUES (':sqlname', ':sqlkey', ':sqljob', ':sqlspecial', ':sqlpod', '[sqltime]', ':laname', ':lakey', '[H.gender]', [H.getBruteLoss()], [H.getFireLoss()], [H.getBrainLoss()], [H.getOxyLoss()], '[coord]')",
	list(
		"sqlname" = H.real_name,
		"sqlkey" = H.key,
		"sqlpod" = podname,
		"sqlspecial" = H.mind.special_role,
		"sqljob" = H.mind.assigned_role,
		"laname" = laname,
		"lakey" = lakey
	))
	if(!query.Execute())
		var/err = query.ErrorMsg()
		log_game("SQL ERROR during death reporting. Error : \[[err]\]\n")
	qdel(query)


proc/sql_report_cyborg_death(var/mob/living/silicon/robot/H)
	if(!sqllogging)
		return
	if(!H)
		return
	if(!H.key || !H.mind)
		return

	var/area/placeofdeath = get_area(H)
	var/podname = placeofdeath ? placeofdeath.name : "Unknown area"

	var/laname
	var/lakey
	if(H.last_attacker_)
		laname = H.last_attacker_.name
		lakey = H.last_attacker_.client.key
	var/sqltime = time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")
	var/coord = "[H.x], [H.y], [H.z]"
//	log_debug("INSERT INTO death (name, byondkey, job, special, pod, tod, laname, lakey, gender, bruteloss, fireloss, brainloss, oxyloss) VALUES ('[sqlname]', '[sqlkey]', '[sqljob]', '[sqlspecial]', '[sqlpod]', '[sqltime]', '[laname]', '[lakey]', '[H.gender]', [H.bruteloss], [H.getFireLoss()], [H.getBrainLoss()], [H.getOxyLoss()])")

	if(!SSdbcore.Connect())
		log_game("SQL ERROR during death reporting. Failed to connect.")
		return
	var/datum/db_query/query = SSdbcore.NewQuery("INSERT INTO death (name, byondkey, job, special, pod, tod, laname, lakey, gender, bruteloss, fireloss, brainloss, oxyloss, coord) VALUES (':sqlname', ':sqlkey', ':sqljob', ':sqlspecial', ':sqlpod', '[sqltime]', ':laname', ':lakey', '[H.gender]', [H.getBruteLoss()], [H.getFireLoss()], [H.getBrainLoss()], [H.getOxyLoss()], '[coord]')",
	list(
		"sqlname" = H.real_name,
		"sqlkey" = H.key,
		"sqlpod" = podname,
		"sqlspecial" = H.mind.special_role,
		"sqljob" = H.mind.assigned_role,
		"laname" = laname,
		"lakey" = lakey,
	))
	if(!query.Execute())
		var/err = query.ErrorMsg()
		log_game("SQL ERROR during death reporting. Error : \[[err]\]\n")
	qdel(query)


proc/statistic_cycle()
	if(!sqllogging)
		return
	while(1)
		sql_poll_population()
		sleep(6000)

//This proc is used for feedback. It is executed at round end.
proc/sql_commit_feedback()
	if(!blackbox)
		log_game("Round ended without a blackbox recorder. No feedback was sent to the database.")
		return

	//content is a list of lists. Each item in the list is a list with two fields, a variable name and a value. Items MUST only have these two values.
	var/list/datum/feedback_variable/content = blackbox.get_round_feedback()

	if(!content)
		log_game("Round ended without any feedback being generated. No feedback was sent to the database.")
		return

	if(!SSdbcore.Connect())
		log_game("SQL ERROR during feedback reporting. Failed to connect.")
		return

	var/datum/db_query/max_query = SSdbcore.NewQuery("SELECT MAX(roundid) AS max_round_id FROM erro_feedback")
	max_query.Execute()

	var/newroundid

	while(max_query.NextRow())
		newroundid = max_query.item[1]
	qdel(max_query)

	if(!(isnum(newroundid)))
		newroundid = text2num(newroundid)

	if(isnum(newroundid))
		newroundid++
	else
		newroundid = 1

	for(var/datum/feedback_variable/item in content)
		var/variable = item.get_variable()
		var/value = item.get_value()

		var/datum/db_query/query = SSdbcore.NewQuery("INSERT INTO erro_feedback (id, roundid, time, variable, value) VALUES (null, [newroundid], Now(), '[variable]', '[value]')")
		if(!query.Execute())
			var/err = query.ErrorMsg()
			log_game("SQL ERROR during death reporting. Error : \[[err]\]\n")
		qdel(query)
