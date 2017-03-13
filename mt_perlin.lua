local function get2dMap(self, minp, buffer)
	return self.noise:get2dMap_flat({x=minp.x,y=minp.z}, buffer)
end

local function get3dMap(self, minp, buffer)
	return self.noise:get3dMap_flat(minp, buffer)
end

mgnm.m_mt_perlin = mgnm.meta_self{
	setup = function(self)
		self.noise = assert(minetest.get_perlin_map(self.def,self.size))

		if self.dims == 3 then
			self.get_noise = get3dMap
		else
			self.get_noise = get2dMap
		end
	end,
}
setmetatable(mgnm.m_mt_perlin,mgnm.m_noise)

mgnm.mt_perlin = function(def, self)
	self = self or setmetatable({}, mgnm.m_mt_perlin)

	assert(type(def.offset) == "number", "Perlin (mt_perlin) offset is not a number!")
	assert(type(def.scale) == "number", "Perlin (mt_perlin) scale is not a number!")
	assert(type(def.seed) == "number", "Perlin (mt_perlin) seed is not a number!")
	assert(mgnm.is_vector(def.spread) == 3, "Spread is not a 3d vector!")
	assert(type(def.octaves) == "number", "Perlin (mt_perlin) octaves is not a number!")
	assert(type(def.persistance) == "number", "Perlin (mt_perlin) persistance is not a number!")
	assert(type(def.lacunarity) == "number", "Perlin (mt_perlin) lacunarity is not a number!")
	assert(def.flags == nil or type(def.flags) == "string", "Perlion (mt_perlin) flags are of an invalid type!")

	assert(def.dims == 2 or def.dims == 3, "Perlin (mt_perlin) dims is not a valid number of dimensions {2,3}!")
	assert(mgnm.is_vector(def.size) == 3, "Perlin (mt_perlin) size is not a vector!")

	mgnm.noise(def, self)

	self.def = def

	return self
end
mgnm.register("mt_perlin", mgnm.mt_perlin)
