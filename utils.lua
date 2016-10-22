-- Calculate the mapchunk size from settings
local mc_length = tonumber(minetest.setting_get("chunksize")) * 16
mgnm.mapchunk_size = {x=mc_length,y=mc_length,z=mc_length,} -- Typically 80^3

local emerge_length = mc_length + 2 * 16
mgnm.emerged_size = {x=emerge_length,y=emerge_length,z=emerge_length,}

mgnm.invalid_pos = {x=math.huge,y=math.huge,z=math.huge}

-- Used for setting up meta tables
mgnm.meta_self = function(meta)
	meta.__index = meta
	return meta
end
