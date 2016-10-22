mgnm.noise_defs = {}

local function get2dMap(self,minp)
	return self.noise:get2dMap_flat(minp,self)
end

local function get3dMap(self,minp)
	return self.noise:get3dMap_flat(minp,self)
end

local noise_buffer = mgnm.meta_self({
	-- inherits size
	-- noise
	-- minp
	minp = mgnm.invalid_pos,
	-- def
	init = function(self,minp)
		if not self.noise then
			self:setup()
		end
		if minp then
			return self:map(minp)
		end
	end,
	setup = function(self)
		self.noise = assert(minetest.get_perlin_map(self.def,self.def.size))
		if self.size.z then
			self.get_noise = get3dMap
		else
			self.get_noise = get2dMap
		end
	end,
	-- Requires that init() has been called at least once
	map = function(self,minp)
		if not vector.equal(self.minp,minp) then
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
setmetatable(noise_buffer,mgnm.buffer)

local function is_vector(vec)
	if not vec
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

local function buffer(noise)
	if not is_vector(noise.size) then
		return nil
	end

	local n = setmetatable(n,noise_buffer)
	n.size = noise.size
	n.def = noise

	mgnm.all[noise] = n
	mgnm.noise_defs[noise] = n
	return n
end

mgnm.noise = function(self,noise)
	if mgnm.all[noise_def] then
		return mgnm.all[noise_def]
	end

	return buffer(noise)
end
	
