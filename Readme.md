# Magic for minetest

This mod attempts to add magic abilities and more to minetest.<br/>
Adding things which annoy players, e.g. lots of nodes, should be avoided.
Instead, this mod tries to implement magic based comfort while the player does
not need to use it. He/She should be able to decide to simply ignore everything
that this mod adds.<br/>
Additionally, features of this mod don't need to be available everywhere, e.g.
tree capitation. This allows adding complicated features because implementing
the whole mod is not required (e.g. treecapitator, cave_lighting, replacer).


### Features

#### tool rotation

While wielding a tool, hold e (the running key aux1) and press q (the drop key)
to rotate tools.<br/>
First, vertically the items below the wielded item are searched for tools, then
items horizontally to the right are searched. After that the tools are cycled,
i.e. your wielded item becomes the item below the wielded one, the item below
becomes the next one etc., the last item of the chain is set to the previously
wielded item.<br/>
Tool rotation costs 5 cracky_dug points.


### Points

There are … types of points: komfort, zerstoerung,

#### komfort

This category refers to points regarding hassle.

##### cracky_dug

You can get cracky_dug points by digging nodes of the cracky group, e.g. stone.
You get more points for a higher cracky_digging level and for harder nodes.


TODO:
* get_width of the player inventory doesn't work (toolrotate)
* Saving the points only when shutting down is quite unsafe (points)
* Find a befitting way to inform players about their points
	use sth like message:format("a   d  %g", number) for this
* add automatic tool switching
* add treecapitator tool enchanting
* add cave_lighting magic
* add replacer field replacing mode
* fire and ice staff
* tool capabilities enchanting (1.5 ^ level)
* point gathering level (e.g. 1.5 ^ level times as much as with default level)
	for point types, i.e. implement abilities.lua
* teleport magic
* allow enchanting only when achievements were met
* matter transformation magic
* tool analyzer:
	* show if the tool capabilities are changed by item metadata
	* fix screwdriver as tool output
	* fix date format
	* explain full punch interval
	* max_drop_level
	* disallow putting more than one book
	* disallow swapping the item with an invalid one
	* make it require points and e.g. an award
	* fix appearance
* add an invisibility spell
