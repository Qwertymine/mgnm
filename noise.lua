mgnm.noise_defs = {}

local function get2dMap(self,minp)
	return self.noise:get2dMap_flat({x=minp.x,y=minp.z},self)
end

local function get3dMap(self,minp)
	return self.noise:get3dMap_flat(minp,self)
end

local function setup(self)
	self.noise = assert(minetest.get_perlin_map(self.def,self.def.size))
	if self.dims == 3 then
		self.get_noise = get3dMap
	else
		self.get_noise = get2dMap
	end
end

mgnm.noise_area = mgnm.meta_self({
	-- inherits size
	-- noise
	-- minp
	minp = mgnm.invalid_pos,
	-- def
	init = function(self,minp)
		if not self.noise then
			setup(self)
		end
		if minp then
			return self:map(minp)
		end
	end,
	invalid = function(self,minp)
		return not vector.equals(self.minp,minp)
	end,
	-- Requires that init() has been called at least once
	map = function(self,minp)
		if self:invalid(minp) then
			self.minp = table.copy(minp)
			self:get_noise(minp)
		end
	end,
	get = function(self,x,y,z)
		return self[self:index(x,y,z)]
	end,
	getp = function(self,pos)
		return self[self:indexp(pos)]
	end,
})
setmetatable(mgnm.noise_area,mgnm.area)

mgnm.noise = function(self,noise)
	if mgnm.all[noise_def] then
		return mgnm.all[noise_def]
	end

	if not mgnm.is_vector(noise.size) then
		return nil
	end

	local n = setmetatable({},mgnm.noise_area)
	n.size = noise.size
	n.def = noise

	mgnm.all[noise] = n
	mgnm.noise_defs[noise] = n
	return n
end
	
