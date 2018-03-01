
magic_sys = {}

local modpath = minetest.get_modpath"magic_sys" .. "/"

dofile(modpath .. "points.lua")
dofile(modpath .. "abilities.lua")

function magic_sys.before_toolrotate(player, n)
	local pname = player:get_player_name()
	local points = magic_sys.get_points(pname)
	local cracky_dug = points.komfort.cracky_dug
	if cracky_dug < 5.0 then
		minetest.chat_send_player(pname, "You do not have enough cracky_dug " ..
			"points: " .. cracky_dug .. " < 5")
		return false
	end
	cracky_dug = cracky_dug - 5.0
	points.komfort.cracky_dug = cracky_dug
	magic_sys.set_points(pname)
	minetest.chat_send_player(pname, "cracky_dug points: " .. cracky_dug)
	return true
end
dofile(modpath .. "toolrotate.lua")

dofile(modpath .. "tool_analyzer.lua")
