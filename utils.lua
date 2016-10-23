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
	meta.__index = meta
	return meta
end

local function is_vector(vec)
	if not vec
	or not typeof(vec) == "table"
	or not vec.x
	or not vec.y then
		return false
	end

	if typeof(vec.x) ~= "number"
	or typeof(vec.y) ~= "number" then
		return false
	end

	if vec.z and typeof(vec.z) ~= "number" then
		return false
	end

	return true
end
mgnm.is_vector = is_vector

-- [[  SIMPLIFIED CREATION FUNCTION  ]] --
-- Automatic type detection
mgnm.auto = function(self,def)
	if not def
	or typeof(def) ~= "table" 
	or is_vector(def) then
		return nil
	end

	if mgnm.all[def] then
		return mgnm.all[def]
	end

	if def.combiner and typeof(def.combiner) == "function" then
		return mgnm:combine(def)
	end

	if def.size and is_vector(def.size) then
		return mgnm:noise(def)
	end

	return mgnm:group(def)
end
