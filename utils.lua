-- [[  SIZE / POSITION CONSTANTS  ]] --
-- Calculate the mapchunk size from settings
local mc_length = tonumber(minetest.setting_get("chunksize")) * 16
mgnm.mapchunk_size = {x=mc_length,y=mc_length,z=mc_length,} -- Typically 80^3

local emerge_length = mc_length + 2 * 16
mgnm.emerged_size = {x=emerge_length,y=emerge_length,z=emerge_length,}

mgnm.invalid_pos = {x=math.huge,y=math.huge,z=math.huge}

-- [[  UTILITY FUNCTIONS  ]] --
-- Used for setting up meta tables
mgnm.meta_self = function(meta)
	if not meta
	or type(meta) ~= "table" then
		return meta
	end
	meta.__index = meta
	return meta
end

mgnm.empty_func = function()
end

mgnm.is_vector = function(vec)
	if not type(vec) == "table"
	or not type(vec.x) == "number"
	or not type(vec.z) == "number" then
		return nil
	end

	if type(vec.y) == "number" then
		return 3		-- It is a 3d vector
	else
		return 2
	end
end
