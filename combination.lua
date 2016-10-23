mgnm.combinations = {}

local get_buffer = mgnm.get_buffer
local return_buffer = mgnm.return_buffer

mgnm.combination = mgnm.meta_self({
	-- noises
	-- size
	-- minp
	init = function(self,minp)
		if not self:invalid(minp) then
			return
		end

		local noises = {}
		for name,noise in pairs(self.noises) do
			if noise:invalid(minp) then
				noises[name] = setmetatable(get_buffer(noise.size))
				noises[name]:init(minp)
			end
		end

		self:combiner(minp,noises)

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
	or typeof(def.combiner) ~= "function" then
		return nil
	end

	if mgnm.all[def] then
		return mgnm.all[def]
	end

	local c = setmetatable({noises = {},size=def.size},mgnm.combination)
	c.combiner = def.combiner
	mgnm.all[def] = c
	mgnm.combinations[def] = c

	for noise,ndef in pairs(def) do
		noises[noise] = mgnm:auto(ndef)
	end

	return c
end
