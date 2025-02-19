// simulated/floor is currently plating by default, but there really should be an explicit plating type.
/turf/simulated/floor/plating
	name = "plating"
	icon = 'icons/turf/flooring/plating.dmi'
	icon_state = "plating"
	layer = PLATING_LAYER



/turf/simulated/floor/concrete
	name = "concrete"
	desc = "Stone-like artificial material."
	icon = 'icons/turf/flooring/misc.dmi'
	icon_state = "concrete"
	initial_flooring = /decl/flooring/concrete

/turf/simulated/floor/bluegrid
	name = "mainframe floor"
	icon = 'icons/turf/flooring/circuit.dmi'
	icon_state = "bcircuit"
	initial_flooring = /decl/flooring/reinforced/circuit
	light_range = 2
	light_power = 1
	light_color = COLOR_BLUE

/turf/simulated/floor/bluegrid/airless
	initial_gas = null

/turf/simulated/floor/greengrid
	name = "mainframe floor"
	icon = 'icons/turf/flooring/circuit.dmi'
	icon_state = "gcircuit"
	initial_flooring = /decl/flooring/reinforced/circuit/green
	light_range = 2
	light_power = 1
	light_color = COLOR_GREEN

/turf/simulated/floor/blackgrid
	name = "mainframe floor"
	icon = 'icons/turf/flooring/circuit.dmi'
	icon_state = "rcircuit"
	initial_flooring = /decl/flooring/reinforced/circuit/red
	light_range = 2
	light_power = 1
	light_color = COLOR_RED

/turf/simulated/floor/greengrid/airless
	initial_gas = null

/turf/simulated/floor/wood
	name = "wooden floor"
	icon = 'icons/turf/flooring/wood.dmi'
	icon_state = "wood"
	initial_flooring = /decl/flooring/wood

/turf/simulated/floor/grass
	name = "grass patch"
	icon = 'icons/turf/flooring/grass.dmi'
	icon_state = "grass0"
	initial_flooring = /decl/flooring/grass

/turf/simulated/floor/carpet
	name = "brown carpet"
	icon = 'icons/turf/flooring/carpet.dmi'
	icon_state = "brown"
	initial_flooring = /decl/flooring/carpet

/turf/simulated/floor/carpet/blue
	name = "blue carpet"
	icon_state = "blue1"
	initial_flooring = /decl/flooring/carpet/blue

/turf/simulated/floor/carpet/blue2
	name = "pale blue carpet"
	icon_state = "blue2"
	initial_flooring = /decl/flooring/carpet/blue2

/turf/simulated/floor/carpet/purple
	name = "purple carpet"
	icon_state = "purple"
	initial_flooring = /decl/flooring/carpet/purple

/turf/simulated/floor/carpet/orange
	name = "orange carpet"
	icon_state = "orange"
	initial_flooring = /decl/flooring/carpet/orange

/turf/simulated/floor/carpet/green
	name = "green carpet"
	icon_state = "green"
	initial_flooring = /decl/flooring/carpet/green

/turf/simulated/floor/carpet/red
	name = "red carpet"
	icon_state = "red"
	initial_flooring = /decl/flooring/carpet/red

/turf/simulated/floor/reinforced
	name = "reinforced floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "reinforced"
	initial_flooring = /decl/flooring/reinforced

/turf/simulated/floor/reinforced/airless
	initial_gas = null

/turf/simulated/floor/reinforced/airmix
	initial_gas = list("oxygen" = MOLES_O2ATMOS, "nitrogen" = MOLES_N2ATMOS)

/turf/simulated/floor/reinforced/nitrogen
	initial_gas = list("nitrogen" = ATMOSTANK_NITROGEN)

/turf/simulated/floor/reinforced/hydrogen
	initial_gas = list("hydrogen" = ATMOSTANK_HYDROGEN)

/turf/simulated/floor/reinforced/oxygen
	initial_gas = list("oxygen" = ATMOSTANK_OXYGEN)

/turf/simulated/floor/reinforced/phoron
	initial_gas = list(MATERIAL_PHORON = ATMOSTANK_PHORON)

/turf/simulated/floor/reinforced/nitrogen/engine
	name = "engine floor"
	initial_gas = list("nitrogen" = MOLES_N2STANDARD)

/turf/simulated/floor/reinforced/phoron/fuel
	initial_gas = list(MATERIAL_PHORON = ATMOSTANK_PHORON_FUEL)

/turf/simulated/floor/reinforced/hydrogen/fuel
	initial_gas = list("hydrogen" = ATMOSTANK_HYDROGEN_FUEL)

/turf/simulated/floor/reinforced/carbon_dioxide
	initial_gas = list("carbon_dioxide" = ATMOSTANK_CO2)

/turf/simulated/floor/reinforced/n20
	initial_gas = list("sleeping_agent" = ATMOSTANK_NITROUSOXIDE)



//Tiled floor + sub-types

/turf/simulated/floor/tiled
	name = "steel floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "steel"
	initial_flooring = /decl/flooring/tiling

/turf/simulated/floor/tiled/dark
	name = "dark floor"
	icon_state = "dark"
	initial_flooring = /decl/flooring/tiling/dark

/turf/simulated/floor/tiled/dark/monotile
	name = "floor"
	icon_state = "monotiledark"
	initial_flooring = /decl/flooring/tiling/mono/dark

/turf/simulated/floor/tiled/dark/airless
	initial_gas = null

/turf/simulated/floor/tiled/white
	name = "white floor"
	icon_state = "white"
	initial_flooring = /decl/flooring/tiling/white

/turf/simulated/floor/tiled/white/monotile
	name = "floor"
	icon_state = "monotile"
	initial_flooring = /decl/flooring/tiling/mono/white

/turf/simulated/floor/tiled/monofloor
	name = "floor"
	icon_state = "steel_monofloor"
	initial_flooring = /decl/flooring/tiling/mono

/turf/simulated/floor/tiled/white/airless
	name = "airless floor"
	initial_gas = null
	temperature = TCMB

/turf/simulated/floor/tiled/freezer
	name = "tiles"
	icon_state = "freezer"
	initial_flooring = /decl/flooring/tiling/freezer

/turf/simulated/floor/tiled/techmaint
	name = "floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "techmaint"
	initial_flooring = /decl/flooring/tiling/new_tile/techmaint

/turf/simulated/floor/tiled/monofloor
	name = "floor"
	icon_state = "monofloor"
	initial_flooring = /decl/flooring/tiling/new_tile/monofloor

/turf/simulated/floor/tiled/techfloor
	name = "floor"
	icon = 'icons/turf/flooring/techfloor.dmi'
	icon_state = "techfloor_gray"
	initial_flooring = /decl/flooring/tiling/tech

/turf/simulated/floor/tiled/monotile
	name = "floor"
	icon_state = "steel_monotile"
	initial_flooring = /decl/flooring/tiling/mono

/turf/simulated/floor/tiled/steel_grid
	name = "floor"
	icon_state = "steel_grid"
	initial_flooring = /decl/flooring/tiling/new_tile/steel_grid

/turf/simulated/floor/tiled/steel_ridged
	name = "floor"
	icon_state = "steel_ridged"
	initial_flooring = /decl/flooring/tiling/new_tile/steel_ridged

/turf/simulated/floor/tiled/old_tile
	name = "floor"
	icon_state = "tile_full"
	initial_flooring = /decl/flooring/tiling/new_tile

/turf/simulated/floor/tiled/old_cargo
	name = "floor"
	icon_state = "cargo_one_full"
	initial_flooring = /decl/flooring/tiling/new_tile/cargo_one

/turf/simulated/floor/tiled/kafel_full
	name = "floor"
	icon_state = "kafel_full"
	initial_flooring = /decl/flooring/tiling/new_tile/kafel

/turf/simulated/floor/tiled/techfloor/grid
	name = "floor"
	icon_state = "techfloor_grid"
	initial_flooring = /decl/flooring/tiling/tech/grid

/turf/simulated/floor/lino
	name = "lino"
	icon = 'icons/turf/flooring/linoleum.dmi'
	icon_state = "lino"
	initial_flooring = /decl/flooring/linoleum

//ATMOS PREMADES
/turf/simulated/floor/reinforced/airless
	name = "vacuum floor"
	initial_gas = null
	temperature = TCMB

/turf/simulated/floor/airless
	name = "airless plating"
	initial_gas = null
	temperature = TCMB

/turf/simulated/floor/tiled/airless
	name = "airless floor"
	initial_gas = null
	temperature = TCMB

/turf/simulated/floor/bluegrid/airless
	name = "airless floor"
	initial_gas = null
	temperature = TCMB

/turf/simulated/floor/greengrid/airless
	name = "airless floor"
	initial_gas = null
	temperature = TCMB

/turf/simulated/floor/greengrid/nitrogen
	initial_gas = list("nitrogen" = MOLES_N2STANDARD)

// Placeholders
/turf/simulated/floor/airless/lava
	name = "lava"
	icon = 'icons/turf/flooring/lava.dmi'
	icon_state = "lava"
	footstep = FOOTSTEP_LAVA
	barefootstep = FOOTSTEP_LAVA
	clawfootstep = FOOTSTEP_LAVA
	heavyfootstep = FOOTSTEP_LAVA

/turf/simulated/floor/ice
	name = "ice"
	icon = 'icons/turf/snow.dmi'
	icon_state = "ice"

/turf/simulated/floor/snow
	name = "snow"
	icon = 'icons/turf/snow.dmi'
	icon_state = "snow"

/turf/simulated/floor/snow/New()
	icon_state = pick("snow[rand(1,12)]","snow0")
	..()

/turf/simulated/floor/light
/turf/simulated/floor/airless/ceiling

/turf/simulated/floor/beach
	name = "beach"
	icon = 'icons/misc/beach.dmi'

/turf/simulated/floor/beach/sand
	name = "sand"
	icon_state = "sand"

/turf/simulated/floor/beach/sand/desert
	icon_state = "desert"
	has_resources = 1

/turf/simulated/floor/beach/sand/desert/New()
	icon_state = "desert[rand(0,5)]"
	..()

/turf/simulated/floor/beach/coastline
	name = "coastline"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "sandwater"
	turf_flags = TURF_IS_WET

/turf/simulated/floor/beach/water
	name = "water"
	icon_state = "water"
	turf_flags = TURF_IS_WET

/turf/simulated/floor/beach/water/update_dirt()
	return	// Water doesn't become dirty

/turf/simulated/floor/beach/water/ocean
	icon_state = "seadeep"

/turf/simulated/floor/beach/water/New()
	..()
	overlays += image("icon"='icons/misc/beach.dmi',"icon_state"="water5","layer"=MOB_LAYER+0.1)

//ds13 floors
/turf/simulated/floor/dank
	name = "grim floor"
	icon = 'icons/turf/floors_ds13.dmi'
	icon_state = "dank_tile"
	initial_flooring = /decl/flooring/tiling_ds

	desc = "The naked, ancient hull."

/turf/simulated/floor/dank/roller
	name = "roller floor"
	icon_state = "dank_roller"
	initial_flooring = /decl/flooring/tiling_ds/roller

/turf/simulated/floor/dank/heavy
	name = "grim heavy floor"
	icon_state = "dank_tile_heavy"
	initial_flooring = /decl/flooring/tiling_ds/heavy

/turf/simulated/floor/dank/medical
	name = "grim medical floor"
	icon_state = "dank_tile_medical"
	initial_flooring = /decl/flooring/tiling_ds/medical

/turf/simulated/floor/dank/mono
	name = "grim floor"
	icon_state = "dank_tile_mono"
	initial_flooring = /decl/flooring/tiling_ds/mono

/turf/simulated/floor/dank/bathr
	name = "bathroom tiles"
	icon_state = "bathroom"
	initial_flooring = /decl/flooring/tiling_ds/bathroom

/turf/simulated/floor/dank/rivets
	name = "riveted plating"
	icon_state = "rivets"
	initial_flooring = /decl/flooring/complex/tiling_ds/rivets

/turf/simulated/floor/dank/slashed
	name = "slashed plating"
	icon_state = "slashed"
	initial_flooring = /decl/flooring/complex/tiling_ds/slashed

/turf/simulated/floor/dank/slashed/odd
	name = "slashed plating"
	icon_state = "slashed_odd"
	initial_flooring = /decl/flooring/complex/tiling_ds/slashed/odd

/turf/simulated/floor/dank/tramcorner
	name = "tram floor"
	icon_state = "tramcorner"
	initial_flooring = /decl/flooring/tiling_ds/tramcorner

/turf/simulated/floor/dank/trammiddle
	name = "tram floor"
	icon_state = "trammiddle"
	initial_flooring = /decl/flooring/tiling_ds/trammiddle

/turf/simulated/floor/dank/tramwarning
	name = "tram floor"
	icon_state = "tramwarning"
	initial_flooring = /decl/flooring/tiling_ds/tramwarning

/turf/simulated/floor/dank/tramgrating
	name = "railway"
	icon_state = "tramgrating"
	initial_flooring = /decl/flooring/tiling_ds/tramgrating

// FLOOR UPDATE 2 : ELECTRIC BOOGALLOO
/turf/simulated/floor/dank/tech
	name = "tech plating"
	icon_state = "tech"
	initial_flooring = /decl/flooring/complex/tiling_ds/tech

/turf/simulated/floor/dank/hardwood
	name = "hardwood"
	icon_state = "hardwood"
	initial_flooring = /decl/flooring/complex/tiling_ds/hardwood

/turf/simulated/floor/dank/hardwood/alt
	icon_state = "hardwood_alt"
	initial_flooring = /decl/flooring/complex/tiling_ds/hardwood/alt

/turf/simulated/floor/dank/golf_gray
	name = "golf gray"
	icon_state = "golf_gray"
	initial_flooring = /decl/flooring/complex/tiling_ds/golf_gray

/turf/simulated/floor/dank/golf_brown
	name = "golf brown"
	icon_state = "golf_brown"
	initial_flooring = /decl/flooring/complex/tiling_ds/golf_brown

/turf/simulated/floor/dank/maint_left
	name = "maint left"
	icon_state = "maint_left"
	initial_flooring = /decl/flooring/complex/tiling_ds/maint/left

/turf/simulated/floor/dank/maint
	name = "maint central"
	icon_state = "maint_center"
	initial_flooring = /decl/flooring/complex/tiling_ds/maint

/turf/simulated/floor/dank/maint_right
	name = "maint right"
	icon_state = "maint_right"
	initial_flooring = /decl/flooring/complex/tiling_ds/maint/right

/turf/simulated/floor/dank/ornate1
	name = "ornate 1"
	icon_state = "1_ornate"
	initial_flooring = /decl/flooring/complex/tiling_ds/ornate1

/turf/simulated/floor/dank/ornate2
	name = "ornate 2"
	icon_state = "2_ornate"
	initial_flooring = /decl/flooring/complex/tiling_ds/ornate2

/turf/simulated/floor/dank/ornate3
	name = "ornate 3"
	icon_state = "3_ornate"
	initial_flooring = /decl/flooring/complex/tiling_ds/ornate3

/turf/simulated/floor/dank/ornate4
	name = "ornate 4"
	icon_state = "4_ornate"
	initial_flooring = /decl/flooring/complex/tiling_ds/ornate4

/turf/simulated/floor/dank/ornate5
	name = "ornate 5"
	icon_state = "5_ornate"
	initial_flooring = /decl/flooring/complex/tiling_ds/ornate5

/turf/simulated/floor/dank/ornate6
	name = "ornate 6"
	icon_state = "6_ornate"
	initial_flooring = /decl/flooring/complex/tiling_ds/ornate6

/turf/simulated/floor/dank/ornate7
	name = "ornate 7"
	icon_state = "7_ornate"
	initial_flooring = /decl/flooring/complex/tiling_ds/ornate7

/turf/simulated/floor/dank/ornate8
	name = "ornate 8"
	icon_state = "8_ornate"
	initial_flooring = /decl/flooring/complex/tiling_ds/ornate8

/turf/simulated/floor/dank/rectangles
	name = "rectangles"
	icon_state = "rectangles"
	initial_flooring = /decl/flooring/complex/tiling_ds/rectangles

/turf/simulated/floor/dank/slides
	name = "slides"
	icon_state = "slides"
	initial_flooring = /decl/flooring/complex/tiling_ds/slides

/turf/simulated/floor/dank/slides_end
	name = "slides_end"
	icon_state = "slides_end"
	initial_flooring = /decl/flooring/complex/tiling_ds/slides/end

/turf/simulated/floor/dank/grate
	name = "grate"
	icon_state = "grate"
	initial_flooring = /decl/flooring/complex/tiling_ds/grate

/turf/simulated/floor/dank/grater
	name = "grater"
	icon_state = "grater"
	initial_flooring = /decl/flooring/complex/tiling_ds/grater

/turf/simulated/floor/dank/cable
	name = "cable"
	icon_state = "cable"
	initial_flooring = /decl/flooring/complex/tiling_ds/cable

/turf/simulated/floor/dank/cable/start
	name = "cable_start"
	icon_state = "cable_start"
	initial_flooring = /decl/flooring/complex/tiling_ds/cable/start

/turf/simulated/floor/dank/cable/end
	name = "cable_end"
	icon_state = "cable_end"
	initial_flooring = /decl/flooring/complex/tiling_ds/cable/end

/turf/simulated/floor/dank/grille_spare_1
	name = "grille-spare1"
	icon_state = "grille-spare1"
	initial_flooring = /decl/flooring/complex/tiling_ds/grille_spare1

/turf/simulated/floor/dank/grille_spare_4
	name = "grille-spare4"
	icon_state = "grille-spare4"
	initial_flooring = /decl/flooring/complex/tiling_ds/grille_spare4

/turf/simulated/floor/dank/grille_spare_3
	name = "grille-spare3"
	icon_state = "grille-spare3"
	initial_flooring = /decl/flooring/complex/tiling_ds/grille_spare3

/turf/simulated/floor/dank/grille_spare_2
	name = "grille-spare2"
	icon_state = "grille-spare2"
	initial_flooring = /decl/flooring/complex/tiling_ds/grille_spare2
