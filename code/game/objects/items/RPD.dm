

/*
CONTAINS:
RPD
*/

#define PAINT_MODE -2
#define EATING_MODE -1
#define ATMOS_MODE 0
#define METER_MODE 1
#define DISPOSALS_MODE 2

#define CATEGORY_ATMOS 0
#define CATEGORY_DISPOSALS 1

/datum/pipe_info
	var/id=-1
	var/categoryId
	var/dir=SOUTH
	var/dirtype = PIPE_BENDABLE
	var/icon
	var/icon_state
	var/selected=0

/datum/pipe_info/pipe
	categoryId = CATEGORY_ATMOS
	icon = 'icons/obj/atmospherics/pipes/pipe_item.dmi'

/datum/pipe_info/pipe/New(obj/machinery/atmospherics/path)
	id = path
	icon_state = initial(path.pipe_state)
	dirtype = initial(path.construction_type)

/datum/pipe_info/proc/Render(dispenser,label)

/datum/pipe_info/pipe/Render(dispenser,label,dir=NORTH)
	return "<li><a href='?src=[REF(dispenser)];makepipe=[id];dir=[dir];type=[dirtype]'>[label]</a></li>"

/datum/pipe_info/meter
	categoryId = CATEGORY_ATMOS
	icon = 'icons/obj/atmospherics/pipes/simple.dmi'
	icon_state = "meterX"

/datum/pipe_info/meter/New()
	return

/datum/pipe_info/meter/Render(dispenser,label)
	return "<li><a href='?src=[REF(dispenser)];makemeter=1;type=[dirtype]'>[label]</a></li>" //hardcoding is no

GLOBAL_LIST_INIT(disposalpipeID2State, list(
	"pipe-s",
	"pipe-c",
	"pipe-j1",
	"pipe-j2",
	"pipe-y",
	"pipe-t",
	"disposal",
	"outlet",
	"intake",
	"pipe-j1s",
	"pipe-j2s"))

/datum/pipe_info/disposal
	categoryId = CATEGORY_DISPOSALS
	icon = 'icons/obj/atmospherics/pipes/disposal.dmi'

/datum/pipe_info/disposal/New(var/pid,var/dt)
	id=pid
	icon_state=GLOB.disposalpipeID2State[pid+1]
	dir = SOUTH
	dirtype=dt
	if(pid<DISP_END_BIN || pid>DISP_END_CHUTE)
		icon_state = "con[icon_state]"

/datum/pipe_info/disposal/Render(dispenser,label)
	return "<li><a href='?src=[REF(dispenser)];dmake=[id];type=[dirtype]'>[label]</a></li>" //avoid hardcoding.

//find these defines in code\game\machinery\pipe\consruction.dm
GLOBAL_LIST_INIT(RPD_recipes, list(
	"Pipes" = list(
		"Pipe"				= new /datum/pipe_info/pipe(/obj/machinery/atmospherics/pipe/simple),
		"Manifold"			= new /datum/pipe_info/pipe(/obj/machinery/atmospherics/pipe/manifold),
		"Manual Valve"		= new /datum/pipe_info/pipe(/obj/machinery/atmospherics/components/binary/valve),
		"Digital Valve"		= new /datum/pipe_info/pipe(/obj/machinery/atmospherics/components/binary/valve/digital),
		"4-Way Manifold"	= new /datum/pipe_info/pipe(/obj/machinery/atmospherics/pipe/manifold4w),
		"Layer Manifold"	= new /datum/pipe_info/pipe(/obj/machinery/atmospherics/pipe/layer_manifold),
	),
	"Devices" = list(
		"Connector"      = new /datum/pipe_info/pipe(/obj/machinery/atmospherics/components/unary/portables_connector),
		"Unary Vent"     = new /datum/pipe_info/pipe(/obj/machinery/atmospherics/components/unary/vent_pump),
		"Gas Pump"       = new /datum/pipe_info/pipe(/obj/machinery/atmospherics/components/binary/pump),
		"Passive Gate"   = new /datum/pipe_info/pipe(/obj/machinery/atmospherics/components/binary/passive_gate),
		"Volume Pump"    = new /datum/pipe_info/pipe(/obj/machinery/atmospherics/components/binary/volume_pump),
		"Scrubber"       = new /datum/pipe_info/pipe(/obj/machinery/atmospherics/components/unary/vent_scrubber),
		"Injector"       = new /datum/pipe_info/pipe(/obj/machinery/atmospherics/components/unary/outlet_injector),
		"Meter"          = new /datum/pipe_info/meter(),
		"Gas Filter"     = new /datum/pipe_info/pipe(/obj/machinery/atmospherics/components/trinary/filter),
		"Gas Mixer"      = new /datum/pipe_info/pipe(/obj/machinery/atmospherics/components/trinary/mixer),
	),
	"Heat Exchange" = list(
		"Pipe"           = new /datum/pipe_info/pipe(/obj/machinery/atmospherics/pipe/heat_exchanging/simple),
		"Manifold"       = new /datum/pipe_info/pipe(/obj/machinery/atmospherics/pipe/heat_exchanging/manifold),
		"4-Way Manifold" = new /datum/pipe_info/pipe(/obj/machinery/atmospherics/pipe/heat_exchanging/manifold4w),
		"Junction"       = new /datum/pipe_info/pipe(/obj/machinery/atmospherics/pipe/heat_exchanging/junction),
		"Heat Exchanger" = new /datum/pipe_info/pipe(/obj/machinery/atmospherics/components/unary/heat_exchanger),
	),
	"Disposal Pipes" = list(
		"Pipe"          = new /datum/pipe_info/disposal(DISP_PIPE_STRAIGHT,	PIPE_BINARY),
		"Bent Pipe"     = new /datum/pipe_info/disposal(DISP_PIPE_BENT,		PIPE_TRINARY),
		"Junction"      = new /datum/pipe_info/disposal(DISP_JUNCTION,		PIPE_TRINARY),
		"Y-Junction"    = new /datum/pipe_info/disposal(DISP_YJUNCTION,		PIPE_TRINARY),
		"Trunk"         = new /datum/pipe_info/disposal(DISP_END_TRUNK,		PIPE_TRINARY),
		"Bin"           = new /datum/pipe_info/disposal(DISP_END_BIN,		PIPE_QUAD),
		"Outlet"        = new /datum/pipe_info/disposal(DISP_END_OUTLET,	PIPE_UNARY),
		"Chute"         = new /datum/pipe_info/disposal(DISP_END_CHUTE,		PIPE_UNARY),
		"Sort Junction" = new /datum/pipe_info/disposal(DISP_SORTJUNCTION,	PIPE_TRINARY),
	)
))

/obj/item/pipe_dispenser
	name = "Rapid Piping Device (RPD)"
	desc = "A device used to rapidly pipe things."
	icon = 'icons/obj/tools.dmi'
	icon_state = "rpd"
	flags_1 = CONDUCT_1
	force = 10
	throwforce = 10
	throw_speed = 1
	throw_range = 5
	w_class = WEIGHT_CLASS_NORMAL
	materials = list(MAT_METAL=75000, MAT_GLASS=37500)
	origin_tech = "engineering=4;materials=2"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0, fire = 100, acid = 50)
	resistance_flags = FIRE_PROOF
	var/datum/effect_system/spark_spread/spark_system
	var/working = 0
	var/p_type = /obj/machinery/atmospherics/pipe/simple
	var/p_conntype = PIPE_BENDABLE
	var/p_dir = 1
	var/p_flipped = 0
	var/p_class = ATMOS_MODE
	var/list/paint_colors = list(
		"grey"		= rgb(255,255,255),
		"red"		= rgb(255,0,0),
		"blue"		= rgb(0,0,255),
		"cyan"		= rgb(0,256,249),
		"green"		= rgb(30,255,0),
		"yellow"	= rgb(255,198,0),
		"purple"	= rgb(130,43,255)
	)
	var/paint_color="grey"
	var/screen = CATEGORY_ATMOS //Starts on the atmos tab.
	var/piping_layer = PIPING_LAYER_DEFAULT

/obj/item/pipe_dispenser/New()
	. = ..()
	spark_system = new /datum/effect_system/spark_spread
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

/obj/item/pipe_dispenser/Destroy()
	qdel(spark_system)
	spark_system = null
	return ..()

/obj/item/pipe_dispenser/attack_self(mob/user)
	show_menu(user)

/obj/item/pipe_dispenser/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] points the end of the RPD down [user.p_their()] throat and presses a button! It looks like [user.p_theyre()] trying to commit suicide...</span>")
	playsound(get_turf(user), 'sound/machines/click.ogg', 50, 1)
	playsound(get_turf(user), 'sound/items/deconstruct.ogg', 50, 1)
	return(BRUTELOSS)

/obj/item/pipe_dispenser/proc/render_dir_img(_dir,pic,title,flipped=0)
	var/selected=" class=\"imglink\""
	if(_dir == p_dir)
		selected=" class=\"imglink selected\""
	return "<a href=\"?src=[REF(src)];setdir=[_dir];flipped=[flipped]\" title=\"[title]\"[selected]\"><img src=\"[pic]\" /></a>"

/obj/item/pipe_dispenser/proc/show_menu(mob/user)
	if(!user || !src)
		return 0
	var/dat = {"<h2>Type</h2>
<b>Utilities:</b>
<ul>"}
	if(p_class != EATING_MODE)
		dat += "<li><a href='?src=[REF(src)];eatpipes=1;type=-1'>Eat Pipes</a></li>"
	else
		dat += "<li><span class='linkOn'>Eat Pipes</span></li>"
	if(p_class != PAINT_MODE)
		dat += "<li><a href='?src=[REF(src)];paintpipes=1;type=-1'>Paint Pipes</a></li>"
	else
		dat += "<li><span class='linkOn'>Paint Pipes</span></li>"
	dat += "</ul>"

	dat += "<b>Category:</b><ul>"
	if(screen == CATEGORY_ATMOS)
		dat += "<span class='linkOn'>Atmospherics</span> <A href='?src=[REF(src)];screen=[CATEGORY_DISPOSALS];dmake=0;type=0'>Disposals</A><BR>"
	else if(screen == CATEGORY_DISPOSALS)
		dat += "<A href='?src=[REF(src)];screen=[CATEGORY_ATMOS];makepipe=[/obj/machinery/atmospherics/pipe/simple];dir=1;type=0'>Atmospherics</A> <span class='linkOn'>Disposals</span><BR>"
	var/generated_layer_list = ""
	var/layers_total = PIPING_LAYER_MAX - PIPING_LAYER_MIN + 1
	for(var/iter = PIPING_LAYER_MIN, iter <= layers_total, iter++)
		if(iter == piping_layer)
			generated_layer_list += "<span class='linkOn'><A href='?src=[REF(src)];setlayer=[iter]'>[iter]</A></span>"
		else
			generated_layer_list += "<A href='?src=[REF(src)];setlayer=[iter]'>[iter]</A>"
	dat += "Atmospherics Piping Layer: [generated_layer_list]<BR>"
	dat += "</ul>"

	var/icon/preview=null
	var/datbuild = ""
	for(var/category in GLOB.RPD_recipes)
		var/list/cat = GLOB.RPD_recipes[category]
		for(var/label in cat)
			var/datum/pipe_info/I = cat[label]
			var/found=0
			if(I.id == p_type)
				if((p_class == ATMOS_MODE || p_class == METER_MODE) && (istype(I, /datum/pipe_info/pipe) || istype(I, /datum/pipe_info/meter)))
					found=1
				else if(p_class == DISPOSALS_MODE && istype(I, /datum/pipe_info/disposal))
					found=1
			if(found)
				preview=new /icon(I.icon,I.icon_state)
			if(screen == I.categoryId)
				if(I.id == p_type && p_class >= 0)
					datbuild += "<span class='linkOn'>[label]</span>"
				else
					datbuild += I.Render(src,label)

		if(length(datbuild) > 0)
			dat += "<b>[category]:</b><ul>"
			dat += datbuild
			datbuild = ""
		dat += "</ul>"

	var/color_css=""
	var/color_picker=""
	for(var/color_name in paint_colors)
		var/color=paint_colors[color_name]
		color_css += {"
			a.color.[color_name] {
				color: [color];
			}
			a.color.[color_name]:hover {
				border:1px solid [color];
			}
			a.color.[color_name].selected {
				background-color: [color];
			}
		"}
		var/selected=""
		if(color_name==paint_color)
			selected = " selected"
		color_picker += {"<a class="color [color_name][selected]" href="?src=[REF(src)];set_color=[color_name]">&bull;</a>"}

	var/dirsel="<h2>Direction</h2>"
	switch(p_conntype)
		if(-1)
			if(p_class==PAINT_MODE)
				dirsel = "<h2>Color</h2>[color_picker]"
			else
				dirsel = ""

		if(PIPE_BINARY) // Straight, N-S, W-E
			if(preview)
				user << browse_rsc(new /icon(preview, dir=NORTH), "vertical.png")
				user << browse_rsc(new /icon(preview, dir=EAST), "horizontal.png")

				dirsel += "<p>"
				dirsel += render_dir_img(1,"vertical.png","Vertical")
				dirsel += render_dir_img(4,"horizontal.png","Horizontal")
				dirsel += "</p>"
			else
				dirsel+={"
		<p>
			<a href="?src=[REF(src)];setdir=1; flipped=0" title="vertical">&#8597;</a>
			<a href="?src=[REF(src)];setdir=4; flipped=0" title="horizontal">&harr;</a>
		</p>
				"}

		if(PIPE_BENDABLE) // Bent, N-W, N-E etc
			if(preview)
				user << browse_rsc(new /icon(preview, dir=NORTH), "vertical.png")
				user << browse_rsc(new /icon(preview, dir=EAST), "horizontal.png")
				user << browse_rsc(new /icon(preview, dir=NORTHWEST),  "nw.png")
				user << browse_rsc(new /icon(preview, dir=NORTHEAST),  "ne.png")
				user << browse_rsc(new /icon(preview, dir=SOUTHWEST),  "sw.png")
				user << browse_rsc(new /icon(preview, dir=SOUTHEAST),  "se.png")

				dirsel += "<p>"
				dirsel += render_dir_img(1,"vertical.png","Vertical")
				dirsel += render_dir_img(4,"horizontal.png","Horizontal")
				dirsel += "<br />"
				dirsel += render_dir_img(9,"nw.png","West to North")
				dirsel += render_dir_img(5,"ne.png","North to East")
				dirsel += "<br />"
				dirsel += render_dir_img(10,"sw.png","South to West")
				dirsel += render_dir_img(6,"se.png","East to South")
				dirsel += "</p>"
			else
				dirsel+={"
		<p>
			<a href="?src=[REF(src)];setdir=1; flipped=0" title="vertical">&#8597;</a>
			<a href="?src=[REF(src)];setdir=4; flipped=0" title="horizontal">&harr;</a>
			<br />
			<a href="?src=[REF(src)];setdir=9; flipped=0" title="West to North">&#9565;</a>
			<a href="?src=[REF(src)];setdir=5; flipped=0" title="North to East">&#9562;</a>
			<br />
			<a href="?src=[REF(src)];setdir=10; flipped=0" title="South to West">&#9559;</a>
			<a href="?src=[REF(src)];setdir=6; flipped=0" title="East to South">&#9556;</a>
		</p>
				"}
		if(PIPE_TRINARY) // Manifold
			if(preview)
				user << browse_rsc(new /icon(preview, dir=NORTH), "s.png")
				user << browse_rsc(new /icon(preview, dir=EAST),  "w.png")
				user << browse_rsc(new /icon(preview, dir=SOUTH), "n.png")
				user << browse_rsc(new /icon(preview, dir=WEST),  "e.png")

				dirsel += "<p>"
				dirsel += render_dir_img(1,"s.png","West South East")
				dirsel += render_dir_img(4,"w.png","North West South")
				dirsel += "<br />"
				dirsel += render_dir_img(2,"n.png","East North West")
				dirsel += render_dir_img(8,"e.png","South East North")
				dirsel += "</p>"
			else
				dirsel+={"
		<p>
			<a href="?src=[REF(src)];setdir=1; flipped=0" title="West, South, East">&#9574;</a>
			<a href="?src=[REF(src)];setdir=4; flipped=0" title="North, West, South">&#9571;</a>
			<br />
			<a href="?src=[REF(src)];setdir=2; flipped=0" title="East, North, West">&#9577;</a>
			<a href="?src=[REF(src)];setdir=8; flipped=0" title="South, East, North">&#9568;</a>
		</p>
				"}
		if(PIPE_TRIN_M) // Mirrored ones
			if(preview)
				user << browse_rsc(new /icon(preview, dir=NORTH), "s.png")
				user << browse_rsc(new /icon(preview, dir=EAST),  "w.png")
				user << browse_rsc(new /icon(preview, dir=SOUTH), "n.png")
				user << browse_rsc(new /icon(preview, dir=WEST),  "e.png")
				user << browse_rsc(new /icon(preview, dir=SOUTHEAST), "sm.png") //each mirror icon is 45 anticlockwise from it's real direction
				user << browse_rsc(new /icon(preview, dir=NORTHEAST),  "wm.png")
				user << browse_rsc(new /icon(preview, dir=NORTHWEST), "nm.png")
				user << browse_rsc(new /icon(preview, dir=SOUTHWEST),  "em.png")

				dirsel += "<p>"
				dirsel += render_dir_img(1,"s.png","West South East")
				dirsel += render_dir_img(4,"w.png","North West South")
				dirsel += "<br />"
				dirsel += render_dir_img(2,"n.png","East North West")
				dirsel += render_dir_img(8,"e.png","South East North")
				dirsel += "<br />"
				dirsel += render_dir_img(6,"sm.png","West South East", 1)
				dirsel += render_dir_img(5,"wm.png","North West South", 1)
				dirsel += "<br />"
				dirsel += render_dir_img(9,"nm.png","East North West", 1)
				dirsel += render_dir_img(10,"em.png","South East North", 1)
				dirsel += "</p>"
			else
				dirsel+={"
		<p>
			<a href="?src=[REF(src)];setdir=1; flipped=0" title="West, South, East">&#9574;</a>
			<a href="?src=[REF(src)];setdir=4; flipped=0" title="North, West, South">&#9571;</a>
			<br />
			<a href="?src=[REF(src)];setdir=2; flipped=0" title="East, North, West">&#9577;</a>
			<a href="?src=[REF(src)];setdir=8; flipped=0" title="South, East, North">&#9568;</a>
			<br />
			<a href="?src=[REF(src)];setdir=6; flipped=1" title="West, South, East">&#9574;</a>
			<a href="?src=[REF(src)];setdir=5; flipped=1" title="North, West, South">&#9571;</a>
			<br />
			<a href="?src=[REF(src)];setdir=9; flipped=1" title="East, North, West">&#9577;</a>
			<a href="?src=[REF(src)];setdir=10; flipped=1" title="South, East, North">&#9568;</a>
		</p>
				"}
		if(PIPE_UNARY) // Stuff with four directions - includes pumps etc.
			if(preview)
				user << browse_rsc(new /icon(preview, dir=NORTH), "n.png")
				user << browse_rsc(new /icon(preview, dir=EAST),  "e.png")
				user << browse_rsc(new /icon(preview, dir=SOUTH), "s.png")
				user << browse_rsc(new /icon(preview, dir=WEST),  "w.png")

				dirsel += "<p>"
				dirsel += render_dir_img(NORTH,"n.png","North")
				dirsel += render_dir_img(EAST, "e.png","East")
				dirsel += render_dir_img(SOUTH,"s.png","South")
				dirsel += render_dir_img(WEST, "w.png","West")
				dirsel += "</p>"
			else
				dirsel+={"
		<p>
			<a href="?src=[REF(src)];setdir=[NORTH]; flipped=0" title="North">&uarr;</a>
			<a href="?src=[REF(src)];setdir=[EAST]; flipped=0" title="East">&rarr;</a>
			<a href="?src=[REF(src)];setdir=[SOUTH]; flipped=0" title="South">&darr;</a>
			<a href="?src=[REF(src)];setdir=[WEST]; flipped=0" title="West">&larr;</a>
		</p>
					"}
		if(PIPE_QUAD) // Single icon_state (eg 4-way manifolds)
			if(preview)
				user << browse_rsc(new /icon(preview), "pipe.png")

				dirsel += "<p>"
				dirsel += render_dir_img(1,"pipe.png","Pipe")
				dirsel += "</p>"
			else
				dirsel+={"
		<p>
			<a href="?src=[REF(src)];setdir=1; flipped=0" title="Pipe">&#8597;</a>
		</p>
				"}


	var/datsytle = {"
<style type="text/css">
	a.imglink {
		padding: none;
		text-decoration:none;
		border-style:none;
		background:none;
		margin: 1px;
	}

	a.imglink:hover {
		background:none;
		color:none;
	}

	a.imglink.selected img {
		border: 1px solid #24722e;
		background: #2f943c;
	}

	a img {
		border: 1px solid #161616;
		background: #40628a;
	}

	a.color {
		padding: 5px 10px;
		font-size: large;
		font-weight: bold;
		border: 1px solid #161616;
	}

	a.selected img,
		a:hover {
			background: #0066cc;
			color: #ffffff;
		}
		[color_css]
</style>"}

	dat = datsytle + dirsel + dat

	var/datum/browser/popup = new(user, "pipedispenser", name, 300, 550)
	popup.set_content(dat)
	popup.open()
	return

/obj/item/pipe_dispenser/Topic(href, href_list)
	if(!usr.canUseTopic(src))
		usr << browse(null, "window=pipedispenser")
		return
	usr.set_machine(src)
	add_fingerprint(usr)
	if(href_list["screen"])
		screen = text2num(href_list["screen"])
		show_menu(usr)

	if(href_list["setdir"])
		p_dir= text2num(href_list["setdir"])
		p_flipped = text2num(href_list["flipped"])
		show_menu(usr)

	if(href_list["setlayer"])
		if(!isnum(href_list["setlayer"]))
			piping_layer = text2num(href_list["setlayer"])
		else
			piping_layer = href_list["setlayer"]
		show_menu(usr)

	if(href_list["eatpipes"])
		p_class = EATING_MODE
		p_conntype=-1
		p_dir=1
		spark_system.start()
		playsound(get_turf(src), 'sound/effects/pop.ogg', 50, 0)
		show_menu(usr)

	if(href_list["paintpipes"])
		p_class = PAINT_MODE
		p_conntype = -1
		p_dir = 1
		spark_system.start()
		playsound(get_turf(src), 'sound/effects/pop.ogg', 50, 0)
		show_menu(usr)

	if(href_list["set_color"])
		paint_color = href_list["set_color"]
		spark_system.start()
		playsound(get_turf(src), 'sound/effects/pop.ogg', 50, 0)
		show_menu(usr)

	if(href_list["makepipe"])
		p_type = text2path(href_list["makepipe"])
		p_dir = text2num(href_list["dir"])
		var/obj/item/pipe/path = text2path(href_list["type"])
		p_conntype = initial(path.RPD_type)
		p_class = ATMOS_MODE
		spark_system.start()
		playsound(get_turf(src), 'sound/effects/pop.ogg', 50, 0)
		show_menu(usr)

	if(href_list["makemeter"])
		p_class = METER_MODE
		p_conntype = -1
		p_dir = 1
		spark_system.start()
		playsound(get_turf(src), 'sound/effects/pop.ogg', 50, 0)
		show_menu(usr)

	if(href_list["dmake"])
		p_type = text2num(href_list["dmake"])
		p_conntype = text2num(href_list["type"])
		p_dir = 1
		p_class = DISPOSALS_MODE
		spark_system.start()
		playsound(get_turf(src), 'sound/effects/pop.ogg', 50, 0)
		show_menu(usr)


/obj/item/pipe_dispenser/pre_attackby(atom/A, mob/user)
	if(!user.IsAdvancedToolUser() || istype(A, /turf/open/space/transit))
		return ..()

	var/atmos_piping_mode = p_class == ATMOS_MODE || p_class == METER_MODE
	var/temp_piping_layer
	if(atmos_piping_mode)
		if(istype(A, /obj/machinery/atmospherics))
			var/obj/machinery/atmospherics/AM = A
			temp_piping_layer = AM.piping_layer
			A = get_turf(user)

	//make sure what we're clicking is valid for the current mode
	var/is_paintable = (p_class == PAINT_MODE && istype(A, /obj/machinery/atmospherics/pipe))
	var/is_consumable = (p_class == EATING_MODE && (istype(A, /obj/item/pipe) || istype(A, /obj/item/pipe_meter) || istype(A, /obj/structure/disposalconstruct)))
	var/can_make_pipe = ((atmos_piping_mode || p_class == DISPOSALS_MODE) && (isturf(A)) || istype(A, /obj/structure/lattice/catwalk) || istype(A, /obj/structure/girder))

	if(!is_paintable && !is_consumable && !can_make_pipe)
		return ..()

	//So that changing the menu settings doesn't affect the pipes already being built.
	var/queued_p_type = p_type
	var/queued_p_dir = p_dir
	var/queued_p_flipped = p_flipped

	. = FALSE
	switch(p_class) //if we've gotten this var, the target is valid
		if(PAINT_MODE) //Paint pipes
			var/obj/machinery/atmospherics/pipe/P = A
			playsound(get_turf(src), 'sound/machines/click.ogg', 50, 1)
			P.paint(paint_colors[paint_color])
			user.visible_message("<span class='notice'>[user] paints \the [P] [paint_color].</span>","<span class='notice'>You paint \the [P] [paint_color].</span>")
			return

		if(EATING_MODE) //Eating pipes
			to_chat(user, "<span class='notice'>You start destroying a pipe...</span>")
			playsound(get_turf(src), 'sound/machines/click.ogg', 50, 1)
			if(do_after(user, 2, target = A))
				activate()
				qdel(A)

		if(ATMOS_MODE) //Making pipes
			to_chat(user, "<span class='notice'>You start building a pipe...</span>")
			playsound(get_turf(src), 'sound/machines/click.ogg', 50, 1)
			if(do_after(user, 2, target = A))
				activate()
				var/obj/item/pipe/P = new(A, queued_p_type, queued_p_dir)
				if(queued_p_flipped)
					var/obj/item/pipe/trinary/flippable/F = P
					F.flipped = queued_p_flipped
				P.update()
				P.add_fingerprint(usr)
				if(!isnull(temp_piping_layer))
					P.setPipingLayer(temp_piping_layer)
				else
					P.setPipingLayer(piping_layer)

		if(METER_MODE) //Making pipe meters
			to_chat(user, "<span class='notice'>You start building a meter...</span>")
			playsound(get_turf(src), 'sound/machines/click.ogg', 50, 1)
			if(do_after(user, 2, target = A))
				activate()
				var/obj/item/pipe_meter/PM = new /obj/item/pipe_meter(A)
				if(!isnull(temp_piping_layer))
					PM.setAttachLayer(temp_piping_layer)
				else
					PM.setAttachLayer(piping_layer)

		if(DISPOSALS_MODE) //Making disposals pipes
			if(isclosedturf(A))
				to_chat(user, "<span class='warning'>\the [src]'s error light flickers; there's something in the way!</span>")
				return
			to_chat(user, "<span class='notice'>You start building a disposals pipe...</span>")
			playsound(get_turf(src), 'sound/machines/click.ogg', 50, 1)
			if(do_after(user, 4, target = A))
				var/obj/structure/disposalconstruct/C = new (A, queued_p_type ,queued_p_dir)

				if(!C.can_place())
					to_chat(user, "<span class='warning'>There's not enough room to build that here!</span>")
					qdel(C)
					return

				activate()

				C.add_fingerprint(usr)
				C.update_icon()
				return

		else
			return ..()


/obj/item/pipe_dispenser/proc/activate()
	playsound(get_turf(src), 'sound/items/deconstruct.ogg', 50, 1)

#undef PAINT_MODE
#undef EATING_MODE
#undef ATMOS_MODE
#undef METER_MODE
#undef DISPOSALS_MODE
#undef CATEGORY_ATMOS
#undef CATEGORY_DISPOSALS