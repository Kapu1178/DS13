/decl/hierarchy/outfit/tunnel_clown
	name = "Tunnel clown"
	uniform = /obj/item/clothing/under/rank/clown
	shoes = /obj/item/clothing/shoes/clown_shoes
	gloves = /obj/item/clothing/gloves/thick
	mask = /obj/item/clothing/mask/gas/clown_hat
	head = /obj/item/clothing/head/chaplain_hood
	l_ear = /obj/item/radio/headset
	suit = /obj/item/clothing/suit/chaplain_hoodie
	r_pocket = /obj/item/bikehorn
	r_hand = /obj/item/material/twohanded/fireaxe

	id_slot = slot_wear_id
	id_type = /obj/item/card/id/centcom/station
	id_pda_assignment = "Tunnel Clown!"

/decl/hierarchy/outfit/masked_killer
	name = "Masked killer"
	uniform = /obj/item/clothing/under/deadspace/planet_cracker
	shoes = /obj/item/clothing/shoes/white
	gloves = /obj/item/clothing/gloves/latex
	mask = /obj/item/clothing/mask/surgical
	head = /obj/item/clothing/head/welding
	l_ear = /obj/item/radio/headset
	suit = /obj/item/clothing/suit/apron
	l_pocket = /obj/item/material/hatchet/tacknife
	r_pocket = /obj/item/tool/scalpel
	r_hand = /obj/item/material/twohanded/fireaxe

/decl/hierarchy/outfit/masked_killer/post_equip(var/mob/living/carbon/human/H)
	..()
	var/victim = get_mannequin(H.ckey)
	for(var/obj/item/carried_item in H.get_equipped_items(TRUE))
		carried_item.add_blood(victim) //Oh yes, there will be blood.. just not blood from the killer because that's odd

/decl/hierarchy/outfit/reaper
	name = "Reaper"
	uniform = /obj/item/clothing/under/suit_jacket{ starting_accessories=list(/obj/item/clothing/accessory/wcoat) }
	shoes = /obj/item/clothing/shoes/black
	gloves = /obj/item/clothing/gloves/thick
	l_ear = /obj/item/radio/headset
	glasses = /obj/item/clothing/glasses/sunglasses
	l_pocket = /obj/item/energy/sword

	id_slot = slot_wear_id
	id_type = /obj/item/card/id/syndicate/station_access
	pda_slot = slot_belt
	pda_type = /obj/item/modular_computer/pda/heads

/decl/hierarchy/outfit/reaper/post_equip(var/mob/living/carbon/human/H)
	..()
	var/obj/item/storage/secure/briefcase/sec_briefcase = new(H)
	for(var/obj/item/briefcase_item in sec_briefcase)
		qdel(briefcase_item)
	for(var/i=3, i>0, i--)
		sec_briefcase.contents += new /obj/item/spacecash/ewallet/random/c10000
	sec_briefcase.contents += new /obj/item/gun/energy/crossbow
	sec_briefcase.contents += new /obj/item/gun/projectile/revolver/mateba
	sec_briefcase.contents += new /obj/item/ammo_magazine/c50
	sec_briefcase.contents += new /obj/item/plastique
	H.equip_to_slot_or_del(sec_briefcase, slot_l_hand)
