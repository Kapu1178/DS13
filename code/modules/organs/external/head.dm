/obj/item/organ/external/head
	organ_tag = BP_HEAD
	icon_name = "head"
	name = "head"
	slot_flags = SLOT_BELT
	max_damage = 95
	min_broken_damage = 50
	w_class = ITEM_SIZE_NORMAL
	body_part = HEAD
	parent_organ = BP_CHEST
	joint = "jaw"
	amputation_point = "neck"
	encased = "skull"
	artery_name = "cartoid artery"
	cavity_name = "cranial"

	divider_component_type = /mob/living/simple_animal/necromorph/divider_component/head

	base_miss_chance = 20

	limb_flags = ORGAN_FLAG_CAN_AMPUTATE | ORGAN_FLAG_GENDERED_ICON | ORGAN_FLAG_HEALS_OVERKILL

	var/normal_eyes = TRUE	//Not exclusive with glowing eyes
	var/glowing_eyes = FALSE
	var/can_intake_reagents = 1
	var/eye_icon_location = 'icons/mob/human_races/species/default_eyes.dmi'
	var/has_lips = 1
	var/forehead_graffiti
	var/graffiti_style
	var/tmp/last_cached_eye_colour
	var/tmp/last_eye_cache_key
	var/apply_eye_colour = TRUE
	limb_height = new /vector2(1.65,1.85)	//20cm tall

/obj/item/organ/external/head/proc/get_eye_cache_key()
	last_cached_eye_colour = rgb(128,0,0)
	if(owner)
		var/obj/item/organ/internal/eyes/eyes = owner.internal_organs_by_name[owner.species.vision_organ ? owner.species.vision_organ : BP_EYES]
		if(eyes) last_cached_eye_colour = rgb(eyes.eye_colour[1], eyes.eye_colour[2], eyes.eye_colour[3])
	last_eye_cache_key = "[type]-[eye_icon_location]-[last_cached_eye_colour]"
	return last_eye_cache_key

/obj/item/organ/external/head/proc/get_eye_overlay()
	if(glowing_eyes && owner && !owner.stat && !owner.lying) //Eyes only glow when the head is attached to an alive, conscious creature
		var/icon/I = get_eyes()
		if(I)
			var/cache_key = "[last_eye_cache_key]-glow"
			if(!human_icon_cache[cache_key])
				var/mutable_appearance/eye_glow = mutable_appearance(I)
				eye_glow.plane = ABOVE_LIGHTING_PLANE
				eye_glow.layer = LIGHTING_SECONDARY_LAYER
				human_icon_cache[cache_key] = eye_glow
			return human_icon_cache[cache_key]

/obj/item/organ/external/head/proc/get_eyes()
	if(eye_icon_location)
		var/cache_key = get_eye_cache_key()
		if(!human_icon_cache[cache_key])
			var/icon/eyes_icon = icon(icon = eye_icon_location, icon_state = "eyes")
			if(apply_eye_colour)
				eyes_icon.Blend(last_cached_eye_colour, ICON_ADD)
			human_icon_cache[cache_key] = eyes_icon
		return human_icon_cache[cache_key]

/obj/item/organ/external/head/examine(mob/user)
	. = ..()

	if(forehead_graffiti && graffiti_style)
		to_chat(user, "<span class='notice'>It has \"[forehead_graffiti]\" written on it in [graffiti_style]!</span>")

/obj/item/organ/external/head/proc/write_on(var/mob/penman, var/style)
	var/head_name = name
	var/atom/target = src
	if(owner)
		head_name = "[owner]'s [name]"
		target = owner

	if(forehead_graffiti)
		to_chat(penman, "<span class='notice'>There is no room left to write on [head_name]!</span>")
		return

	var/graffiti = sanitizeSafe(input(penman, "Enter a message to write on [head_name]:") as text|null, MAX_NAME_LEN)
	if(graffiti)
		if(!target.Adjacent(penman))
			to_chat(penman, "<span class='notice'>[head_name] is too far away.</span>")
			return

		if(owner && owner.check_head_coverage())
			to_chat(penman, "<span class='notice'>[head_name] is covered up.</span>")
			return

		penman.visible_message("<span class='warning'>[penman] begins writing something on [head_name]!</span>", "You begin writing something on [head_name].")

		if(do_after(penman, 3 SECONDS, target))
			if(owner && owner.check_head_coverage())
				to_chat(penman, "<span class='notice'>[head_name] is covered up.</span>")
				return

			penman.visible_message("<span class='warning'>[penman] writes something on [head_name]!</span>", "You write something on [head_name].")
			forehead_graffiti = graffiti
			graffiti_style = style

/obj/item/organ/external/head/get_agony_multiplier()
	return (owner && owner.headcheck(organ_tag)) ? 1.50 : 1

/obj/item/organ/external/head/robotize(var/company, var/skip_prosthetics, var/keep_organs)
	if(company)
		var/datum/robolimb/R = all_robolimbs[company]
		if(R)
			can_intake_reagents = R.can_eat
			eye_icon_location = R.has_eyes ? initial(eye_icon_location) : null
	. = ..(company, skip_prosthetics, 1)
	has_lips = null

/obj/item/organ/external/head/take_external_damage(var/brute = 0, var/burn = 0, var/damage_flags = 0, var/used_weapon = null, var/allow_dismemberment = TRUE)
	. = ..()
	if (!(status & ORGAN_DISFIGURED))
		if (brute_dam > 30)
			if (prob(50))
				disfigure("brute")
		if (burn_dam > 30)
			disfigure("burn")

/obj/item/organ/external/head/update_icon()

	..()

	if(owner)
		// Base eye icon.
		if (normal_eyes)
			var/icon/I = get_eyes()
			if(I)
				overlays |= I
				mob_icon.Blend(I, ICON_OVERLAY)

		// Floating eyes or other effects.
		var/image/eye_glow = get_eye_overlay()
		if(eye_glow) overlays |= eye_glow

		if(owner.lip_style && !BP_IS_ROBOTIC(src) && (species && (species.appearance_flags & HAS_LIPS)))
			var/icon/lip_icon = new/icon('icons/mob/human_races/species/human/lips.dmi', "lips_[owner.lip_style]_s")
			overlays |= lip_icon
			mob_icon.Blend(lip_icon, ICON_OVERLAY)

		overlays |= get_hair_icon()

	return mob_icon

/obj/item/organ/external/head/proc/get_hair_icon()
	var/mutable_appearance/res = mutable_appearance(species.icon_template,"")
	//Future TODO: Cache the hairstyle in the head so that heads can have hair after severing
	if (owner)
		if(owner.f_style)
			var/datum/sprite_accessory/facial_hair_style = GLOB.facial_hair_styles_list[owner.f_style]
			if(facial_hair_style && facial_hair_style.species_allowed && (species.get_bodytype(owner) in facial_hair_style.species_allowed))
				var/icon/facial_s = new/icon("icon" = facial_hair_style.icon, "icon_state" = "[facial_hair_style.icon_state]_s")
				if(facial_hair_style.do_colouration)
					facial_s.Blend(rgb(owner.r_facial, owner.g_facial, owner.b_facial), facial_hair_style.blend)
				res.overlays |= facial_s

		if(owner.h_style)
			var/icon/grad_s = null
			var/style = owner.h_style
			var/datum/sprite_accessory/hair/hair_style = GLOB.hair_styles_list[style]
			if(owner.head && (owner.head.flags_inv & BLOCKHEADHAIR))
				if(!(hair_style.flags & VERY_SHORT))
					hair_style = GLOB.hair_styles_list["Short Hair"]
			if(hair_style && (species.get_bodytype(owner) in hair_style.species_allowed))
				var/icon/hair_s = new/icon("icon" = hair_style.icon, "icon_state" = "[hair_style.icon_state]_s")
				if(hair_style.do_colouration && islist(h_col) && h_col.len >= 3)
					if(owner.g_style)
						var/datum/sprite_accessory/gradient_style = GLOB.hair_gradient_styles_list[owner.g_style]
						grad_s = new/icon("icon" = gradient_style.icon, "icon_state" = gradient_style.icon_state)
						grad_s.Blend(hair_s, ICON_AND)
						grad_s.Blend(rgb(owner.r_grad, owner.g_grad, owner.b_grad), ICON_MULTIPLY)
					hair_s.Blend(rgb(h_col[1], h_col[2], h_col[3]), hair_style.blend)
					if(!isnull(grad_s))
						hair_s.Blend(grad_s, ICON_OVERLAY)
				res.overlays |= hair_s

	return res

/obj/item/organ/external/head/no_eyes
	eye_icon_location = null


/obj/item/organ/external/head/removed(var/mob/living/user, var/ignore_children = 0)
	var/mob/living/carbon/human/former_owner = owner
	.=..()
	spawn()
		//This immediately updates hud stuff, so people go blind instantly upon head removal, rather than a few seconds later
		if (istype(former_owner) && !QDELETED(former_owner))
			former_owner.handle_disabilities()
			former_owner.handle_regular_hud_updates()