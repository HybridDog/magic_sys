
-- load and save points using mod storage
local storage = minetest.get_mod_storage()
local points = storage:get_string"points"
if points ~= "" then
	points = minetest.deserialize(points)
else
	points = {}
end

-- using shutdown is not safe enough
minetest.register_on_shutdown(function()
	storage:set_string("points", minetest.serialize(points))
end)

-- a function to get a reference to the points of a player
function magic_sys.get_points(playername)
	local current_points = points[playername]
	if not current_points then
		current_points = {
			komfort = {
				cracky_dug = 0.0,
			},
			zerstoerung = {
			},
		}
		points[playername] = current_points
	end
	return current_points
end

-- could be used later, when implemented, to trigger saving of the points
function magic_sys.set_points(playername)
end


minetest.register_on_dignode(function(_, oldnode, player)
	if not player
	or not oldnode then
		return
	end
	local cracky_lv = minetest.get_item_group(oldnode.name, "cracky")
	if cracky_lv == 0 then
		return
	end
	local pname = player:get_player_name()
	local points = magic_sys.get_points(pname)

	-- more points for higher level
	local level = magic_sys.get_level(pname, "cracky_digging")
	local points_gathered = 1.5 ^ level

	-- more points for harder nodes
	if cracky_lv == 2 then
		points_gathered = points_gathered * 1.2
	elseif cracky_lv == 1 then
		points_gathered = points_gathered * 2.1
	end

	-- update points
	points.komfort.cracky_dug = points.komfort.cracky_dug + points_gathered
	magic_sys.set_points(pname)
end)
