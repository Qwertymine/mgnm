mgnm.groups = {}

mgnm.m_group = mgnm.meta_self{
	--minp
	minp = mgnm.invalid_pos,
	init = function(self,minp)
		if self:invalid(minp) then
			self.minp = minp

			for _, noise in pairs(self) do
				if mgnm.all[noise] then
					noise:init(minp)
				end
			end
		end

		noises = {}
		for id, noise in pairs(self) do
			if mgnm.all[noise] then
				noises[id] = noise:init(minp)
			end
		end

		return noises
	end,
	tini = function(self, minp)
		if self:invalid(minp) then
			return
		end

		for id, noise in pairs(self) do
			-- Shared noises need to be maintained
			if mgnm.all[noise] and not noise.shared then
				noise:tini(minp)
			end
		end

		self.data = nil
		self.minp = nil
	end,

	invalid = function(self,minp)
		return not vector.equals(self.minp,minp)
	end,
}
		

mgnm.group = function(def, self)
	self = self or setmetatable({},mgnm.m_group)

	for noise, def in pairs(def) do
		if type(def) == "table" then
			self[noise] = mgnm.get(def)
		end
	end

	return self
end

mgnm.register("group", mgnm.group)
