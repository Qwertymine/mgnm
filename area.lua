mgnm.area = mgnm.meta_self({
	-- minp
	-- size
	-- dims
	contains = function(self,x,y,z)
		local minp = self.minp
		local size = self.size
		if x > minp.x and x < minp.x + size.x
		and y > minp.y and y < minp.y + size.y
		and (self.dims == 2 or (z > minp.z and z < minp.z + size.z)) then
			return true
		end

		return false
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

		if z and self.dims == 3 then
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
})
