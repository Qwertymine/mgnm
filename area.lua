mgnm.m_area = mgnm.meta_self{
	-- minp
	minp = mgnm.invalid_pos,

	-- size
	-- dims
	contains = function(self,x,y,z)
		local minp = self.minp
		local size = self.size
		if x < minp.x or x > minp.x + size.x then
			return false
		end

		if  self.dims == 2
		and y < minp.z or y > minp.z + size.z then
			return false
		end

		if self.dims == 3
		and y < minp.y or y > minp.y + size.y
		or  z < minp.z or z > minp.z + size.z then
			return false
		end

		return true
	end,
	containsp = function(self,pos)
		if dims == 2 and pos.z then
			return self:contains(pos.x,pos.z)
		end
		return self:contains(pos.x,pos.y,pos.z)
	end,

	index = function(self,x,y,z)
		local minp = self.minp
		local size = self.size
		x = (x - minp.x) + 1

		if self.dims == 3 then
			y = (y - minp.y) * size.x
			z = (z - minp.z) * size.x * size.y
		else
			y = (y - minp.z) * size.x
			z = 0
		end

		return x + y + z
	end,
	cindex = function(self,x,y,z)
		if self.contains(x,y,z) then
			return self:index(x,y,z)
		else
			return nil
		end
	end,

	indexp = function(self,pos)
		if dims == 2 and pos.z then
			return self:index(pos.x,pos.z)
		end
		return self:index(pos.x,pos.y,pos.z)
	end,
	cindexp = function(self,pos)
		if self:containsp(pos) then
			return self:indexp(pos)
		else
			return nil
		end
	end,

	invalid = function(self,minp)
		return not vector.equals(self.minp,minp)
	end,
}

mgnm.area = function(def, self)
	assert(type(def) == "table", "Area definition is not a table")

	self = self or setmetatable({}, mgnm.m_area)

	assert(mgnm.is_vector(def.size)
	     , "Area definition requires size vector")

	self.size = def.size

	assert(def.dims and (def.dims == 2 or def.dims == 3)
	     , "Area dims is not a valid number {2, 3}!")

	self.dims = def.dims
end

mgnm.register("area", mgnm.area)
