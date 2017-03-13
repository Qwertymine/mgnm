mgnm.m_combine = mgnm.meta_self{
	-- noises
	-- size
	-- dims
	-- minp
	init = function(self,minp)
		if not self:invalid(minp) then
			return self.data
		end

		self.minp = minp

		local noises = self.noises:init(minp)
		self.data = mgbm.get_mg_buffer(self.size, self.dims)
		self.data = self:combiner(noises, self.data)

		self.noises:tini(minp)

		return self.data
	end,
	tini = function(self, minp)
		if self:invalid(minp) then
			return
		end

		mgbm.return_buffer(self.data)
		self.minp = nil
	end,
}
setmetatable(mgnm.m_combine,mgnm.m_noise)

mgnm.combine = function(def, self)
	assert(type(def.combiner) == "function", "Combine definition requires combiner function")
	assert(type(def.noises) == "table", "Combine definition requires a noises table")

	self = self or setmetatable({},mgnm.m_combine)

	mgnm.area(def, self)
	mgnm.noise(def, self)

	self.noises = mgnm.all[def.noises] or mgnm.group(def.noises)
	self.combiner = def.combiner

	return self
end

mgnm.register("combine", mgnm.combine)
