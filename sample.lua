local noise_params = {
	-- REQUIRED FIELDS
	size = {x=5,y=5,z=5},
	dims = 2,
}
local noise = mgnm:noise(noise_params) or mgnm:auto(noise_params)

minetest.register_on_generated(function(minp,maxp)
	noise:init(minp)
	noise[noise:index(x,y,z)]
end)

local ore_noise = {
	coal = nil, -- NoiseDef
	iron = nil, -- NoiseDef
}
local ores = mgnm:group(ore_noise)

local world_noise = {
	coal = ore_noise.coal,
	sand = nil,
}
local world = mgnm:group(world_noise)

local all = {
	world = world_noise,
	ores = ores,
}
all = mgnm:group(all) or mgnm:auto(all)

minetest.register_on_generated(function(minp,maxp)
	ores:init(minp)
	ores.coal[ores.coal:index(x,y,z)]

	world:init(minp)
	world.ores.coal[world.ores.coal:index(x,y,z)]
end)

local vmanip = mgnm:vmanip()

minetest.register_on_generated(function(minp,maxp)
	local emin,emax = vmanip:init()
	vmanip:get_data()

	vmanip.data[vmanip:index(x,y,z)]

	vmanip:set_lighting()
	vmanip.vmanip:set_lighting()
	vmanip:set_data()
	-- Cleanup ANY used tables
	vmanip:tini()
end)

local caves = {
	noise1 = nil, -- NoiseDef
	noise2 = nil, -- NoiseDef
	combiner = function(self,noises) -- Function
		for i,v in ipairs(noises.noise1) do
			self[i] = noises.noise1[i] + noises.noise2[i]
		end
	end,

	size = mgnm.mapchunk_size, -- Size
	dims = 2,
}

local limited_caves = {
	caves = caves,
	limits = nil, -- NoiseDef
	combiner = nil,

	size = mgnm.emerge_size,
	dims = 3,
}

mgnm:combine(limited_caves) or mgnm:auto(limited_caves)

minetest.register_on_generated(function(minp,maxp)
	limited_caves:init(minp)
	limited_caves[index]
end)
