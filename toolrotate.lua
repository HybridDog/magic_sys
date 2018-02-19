
local known_tools = {}
local function try_itemrotate(player)
	if not player then
		return
	end
	local inv = player:get_inventory()
	local list = inv:get_list"main"
	-- get_width doesn't seem to work
	--~ local w = inv:get_width"main"
	--~ local h = math.floor(inv:get_size"main" / w)
	local w = 8
	local h = 4

	-- search vertically
	local x = player:get_wield_index() - 1
	local y = 0
	local found_tools,n = {y * w + x},1
	while y < h do
		y = y + 1
		local i = y * w + x
		local item = list[i + 1]
		if not known_tools[item:get_name()] then
			y = y - 1
			break
		end
		n = n+1
		found_tools[n] = i
	end

	-- do nothing if there's no tool below the wielded one
	if n == 1 then
		return
	end

	-- test for tools one column further
	local can_right
	local xs = x+1
	local i = xs
	for _ = 0, y do
		i = i + w
		local item = list[i+1]
		if not known_tools[item:get_name()] then
			can_right = true
			break
		end
	end

	if can_right then
		-- search horizontally
		local i = y * w + x
		for _ = x, w-1 do
			i = i+1
			local item = list[i+1]
			if not known_tools[item:get_name()] then
				break
			end
			n = n+1
			found_tools[n] = i
		end
	end

	-- abort if toolrotating couldn't be initiated (e.g. not enough points)
	if not magic_sys.before_toolrotate(player, n) then
		return
	end

	-- perform item rotation
	local first_tool = list[found_tools[1]+1]
	for i = 1, n-1 do
		list[found_tools[i]+1] = list[found_tools[i+1]+1]
	end
	list[found_tools[n]+1] = first_tool

	-- update the player inventory
	inv:set_list("main", list)
end


-- override the tools when the first player joins
local tools_overridden = false
minetest.register_on_prejoinplayer(function()
	if tools_overridden then
		return
	end
	tools_overridden = true

	for name,def in pairs(minetest.registered_tools) do
		known_tools[name] = true
		-- on_drop defaults to minetest.item_drop via metatable
		local orig_drop_func = def["on_drop"]
		minetest.override_item(name, {
			on_drop = function(stack, player, pt)
				local keys = player:get_player_control()
				if not keys.aux1 then
					return orig_drop_func(stack, player, pt)
				end
				return try_itemrotate(player)
			end
		})
	end
end)
