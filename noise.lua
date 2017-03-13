mgnm.m_noise = mgnm.meta_self{
	--[[ inherits --]] 
	-- size
	-- dims
	-- minp
	--data
	setup = mgnm.empty_func,
	init = function(self,minp)
		if not self.noise then
			self:setup()
		end

		if not minp then
			return
		end

		if self:invalid(minp) then
			self.minp = table.copy(minp)
			self.data = mgbm.get_mg_buffer(self.size, self.dims)
			self.data = self:get_noise(minp, self.data)
		end

		return self.data

	end,
	tini = function(self, minp)
		if self:invalid(minp) then
			return
		end

		mgbm.return_buffer(self.data)
	end,
}
setmetatable(mgnm.m_noise,mgnm.m_area)

mgnm.noise = function(def, self)
	self = self or setmetatable({},mgnm.m_noise)

	mgnm.area(def, self)

	return self
end
