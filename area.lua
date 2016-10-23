mgnm.area = mgnm.meta_self({
	-- minp
	-- size
	contains = function(self,x,y,z)
		local minp = self.minp
		local size = self.size
		if x > minp.x and x < minp.x + size.x
		and y > minp.y and y < minp.y + size.y
		and z > minp.z and z < minp.z + size.z then
			return true
		end

		return false
	end,
	containsp = function(self,pos)
		return self:contains(pos.x,pos.y,pos.z)
	end,

	index = function(self,x,y,z)
		local minp = self.minp
		local size = self.size
		x = x - minp.x
		y = (y - minp.y) * size.x
		z = (z - minp.z) * size.x * size.y

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
		return self:i(pos.x,pos.y,pos.z)
	end,
	cindexp = function(self,pos)
		if self:containsp(pos) then
			return self:indexp(pos)
		else
			return nil
		end
	end,
})
