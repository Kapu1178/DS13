/datum/artifact_effect/teleport
	name = "teleport"
	effect_type = EFFECT_BLUESPACE

/datum/artifact_effect/teleport/DoEffectTouch(var/mob/user)
	var/weakness = GetAnomalySusceptibility(user)
	if(prob(100 * weakness))
		to_chat(user, "<span class='warning'>You are suddenly zapped away elsewhere!</span>")
		if (user.buckled)
			user.buckled.unbuckle_mob()

		var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
		sparks.set_up(3, 0, get_turf(user))
		sparks.start()

		var/turf/centre = get_turf(src)
		user.Move(pick(RANGE_TURFS(centre, 50)))

		sparks = new /datum/effect/effect/system/spark_spread()
		sparks.set_up(3, 0, user.loc)
		sparks.start()

/datum/artifact_effect/teleport/DoEffectAura()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/M in range(src.effectrange,T))
			var/weakness = GetAnomalySusceptibility(M)
			if(prob(100 * weakness))
				to_chat(M, "<span class='warning'>You are displaced by a strange force!</span>")
				if(M.buckled)
					M.buckled.unbuckle_mob()

				var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
				sparks.set_up(3, 0, get_turf(M))
				sparks.start()

				M.Move(pick(RANGE_TURFS(T, 50)))
				sparks = new /datum/effect/effect/system/spark_spread()
				sparks.set_up(3, 0, M.loc)
				sparks.start()

/datum/artifact_effect/teleport/DoEffectPulse()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/M in range(src.effectrange, T))
			var/weakness = GetAnomalySusceptibility(M)
			if(prob(100 * weakness))
				to_chat(M, "<span class='warning'>You are displaced by a strange force!</span>")
				if(M.buckled)
					M.buckled.unbuckle_mob()

				var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
				sparks.set_up(3, 0, get_turf(M))
				sparks.start()

				M.Move(pick(RANGE_TURFS(T, 50)))
				sparks = new /datum/effect/effect/system/spark_spread()
				sparks.set_up(3, 0, M.loc)
				sparks.start()
