
-- takes a 2 dimensional table with strings, returns a string
-- padding is used to make rows distinguishable
local function column(t, padding)
	padding = padding or "  "

	-- collect lengths
	local h = #t
	local w = #t[1]
	local maxlen = {}
	for j = 1,w do
		local col_width = 0
		for i = 1,h do
			-- length instead of # for UTF-8 support
			local l = t[i][j]:len()
			if l > col_width then
				col_width = l
			end
		end
		maxlen[j] = col_width
	end

	-- generate the string
	local lines = {}
	for i = 1,h do
		local line = {}
		for j = 1,w do
			local text = t[i][j]
			local l = text:len()
			local col_width = maxlen[j]
			-- align right
			line[j] = string.rep(" ", col_width - l) .. text
		end
		lines[i] = table.concat(line, padding)
	end
	return table.concat(lines, "\n")
end

local function analyze(item)
	-- TODO meta overriding
	local name = item:get_name()
	local def = minetest.registered_tools[name]
	if not def then
		return false
	end
	local caps = item:get_tool_capabilities()

	local groupcaps = caps.groupcaps
	local groups = {}
	for group, data in pairs(groupcaps) do
		local lvstats = {}
		for level = 0,data.maxlevel do
			local result = {}
			for v in pairs(data.times) do
				local p = minetest.get_dig_params(
					{[group] = v, level = level},
					caps
				)
				if p.diggable then
					if p.time ~= 0 then
						p.time = string.format("%-5.3g", p.time)
					else
						p.time = "0.15 (immediate)"
					end
				else
					p.time = "not diggable"
				end
				result[v] = p
			end
			lvstats[level] = result
		end
		groups[#groups+1] = {group, lvstats}
	end

	-- TODO format date
	local msg =
		'# Stats for the tool "' .. name .. '" (' .. os.date() .. ")\n\n" ..
		"## Digging speed and wear\n\n" ..
		"The following tables show digging time and wear cost for each \n" ..
		"supported group and level.\n\n"

	-- TODO show whether tool capabilities are overridden in item metadata
	-- add digging speed and wear for each group and level
	local sort_func = function(a, b)
		return a[1] < b[1]
	end
	table.sort(groups, sort_func)
	for i = 1,#groups do
		local v = groups[i]
		local groupname = v[1]
		msg = msg .. "### Group " .. groupname ..
			", values show the digging time\n\n"

		local w = 0
		local w_l = 3
		local lines = {}
		local lvstats = v[2]
		for i = 0, #lvstats do
			local line = {string.format("level=%d", i)}
			local stats = lvstats[i]
			local wear
			for i,v in pairs(stats) do
				wear = v.wear
				line[i + 2] = v.time
				if i > w then
					w = i
				elseif i < w_l then
					w_l = i
				end
			end
			line[2] = string.format("%g", wear / 65535)
			lines[i + 2] = line
		end

		-- add description
		lines[1] = {"", "wear cost"}
		for i = 3, 3 + w - w_l do
			lines[1][i] = string.format("%s=%d", groupname, i + w_l - 3)
		end

		-- fill in missings with empty string
		for i = 2,#lines do
			local line = lines[i]
			for i = 3, w + 2 do
				line[i] = line[i + w_l - 1] or ""
			end
		end
		msg = msg .. column(lines) .. "\n\n\n"
	end

	-- add damage
	if caps.damage_groups then
		msg = msg .. "## Damage\n\n"
		for name,v in pairs(caps.damage_groups) do
			msg = msg .. name .. ":\t" .. v .. "\n"
		end
		msg = msg .. "\n\n"
	end

	msg = msg .. "## Other stats\n\n"

	-- full punch interval TODO what is this
	if caps.full_punch_interval then
		msg = msg .. string.format("full_punch_interval: %g\n",
			caps.full_punch_interval)
	end

	-- TODO what is max_drop_level

	-- add range
	if def.range then
		msg = msg .. "range: " .. def.range .. "\n"
	end

	if def.liquids_pointable then
		msg = msg .. "This tool points liquids.\n"
	end

--~ print(msg)

	return msg
end

--~ minetest.after(0, analyze, ItemStack"default:pick_wood")
