local vmanip_area = mgnm.meta_self({
	-- data
	get_data = function(self)
		self.data = self.data or mgnm.get_buffer(self.size,self.dims)
		self.vmanip:get_data(self.data)
	end,
	set_data = function(self)
		self.vmanip:set_data(self.data)
		mgnm.return_buffer(self.data)
		self.data = nil
	end,
	-- light
	get_light_data = function(self)
		self.light = self.light or mgnm.get_buffer(self.size,self.dims)
		self.vmanip:get_light_data(self.light)
	end,
	set_light_data = function(self)
		self.vmanip:set_light_data(self.light)
		mgnm.return_buffer(self.light)
		self.light = nil
	end,
	-- p2data
	get_param2_data = function(self)
		self.p2data = self.p2data or mgnm.get_buffer(self.size,self.dims)
		self.vmanip:get_param2_data(self.p2data)
	end,
	set_param2_data = function(self)
		self.vmanip:set_param2_data(self.p2data)
		mgnm.return_buffer(self.p2data)
		self.p2data = nil
	end,
	update_liquids = function(self)
		self.vmanip:update_liquids()
	end,
	write_to_map = function(self)
		self.vmanip:write_to_map()
	end,
})
setmetatable(vmanip_area,mgnm.area)
mgnm.vmanip_area = vmanip_area

--[[
local nvmanip = mgnm.meta_self({
	read_from_map = function(self,p1,p2)
		self.vmanip:read_from_map(p1,p2)
	end,
	update_map = function(self)
		self.vmanip:update_map()
	end,
	get_emerged_area = function(self)
		return self.vmanip:get_emerged_area()
	end,
})
--]]

local mgvmanip = mgnm.meta_self({
	-- minp
	-- emin
	-- emax
	-- vmanip
	size = mgnm.emerged_size,
	dims = 3,
	init = function(self)
		local v, emin, emax = minetest.get_mapgen_object("voxelmanip")
		self.vmanip = v
		self.minp = emin
		self.emin = emin
		self.emax = emax

		return emin,emax
	end,
	tini = function(self)
		self.vmanip = nil
		for k,v in pairs(self) do
			mgnm.return_buffer(v)
			self[v] = nil
		end
	end,
	set_lighting = function(self,light,p1,p2)
		self.vmanip:set_lighting(light,p1,p2)
	end,
	calc_lighting = function(self,p1,p2,propagate_shadow)
		self.vmanip:calc_lighting(p1,p2,propagate_shadow)
	end,
	get_emerged_area = function(self)
		return self.emin, self.emax
	end,
})
setmetatable(mgvmanip,vmanip_area)
mgnm.mg_vmanip_area = mgvmanip

mgnm.mg_vmanip = function(self)
	return setmetatable({},mgvmanip)
end
