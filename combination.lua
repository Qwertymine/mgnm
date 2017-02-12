mgnm.combinations = {}

local get_buffer = mgnm.get_buffer
local return_buffer = mgnm.return_buffer

mgnm.combination = mgnm.meta_self({
	-- noises
	-- size
	-- dims
	-- minp
	init = function(self,minp)
		if not self:invalid(minp) then
			return
		end
		self.minp = minp

		local noises = {}
		for name,noise in pairs(self.noises) do
			noises[name] = noise
			if noise:invalid(minp) then
				noises[name]:init()
				noises[name] = setmetatable(
					get_buffer(noise.size,noise.dims)
					,noise)
				noises[name]:map(minp)
			end
		end

		self:combiner(noises)

		for _,table in pairs(noises) do
			return_buffer(table)
		end
	end,
	map = function(self,minp)
		return self:init(minp)
	end,
})
setmetatable(mgnm.combination,mgnm.noise_area)

mgnm.combine = function(self,def)
	if not mgnm.is_vector(def.size)
	or not def.combiner
	or type(def.combiner) ~= "function" then
		return nil
	end

	if mgnm.all[def] then
		return mgnm.all[def]
	end

	local c = setmetatable({noises = {},},mgnm.combination)
	c.size = def.size
	c.dims = def.dims
	c.combiner = def.combiner
	mgnm.all[def] = c
	mgnm.combinations[def] = c

	for noise,ndef in pairs(def) do
		c.noises[noise] = mgnm.meta_self(mgnm:auto(ndef))
	end

	return c
end
