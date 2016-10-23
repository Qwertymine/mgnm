mgnm.groups = {}

mgnm.noise_group = mgnm.meta_self({
	--minp
	minp = mgnm.invalid_pos,
	init = function(self,minp)
		if not self:invalid(minp) then
			return
		end

		for _,noise in pairs(self) do
			noise:init(minp)
		end
	end,
	invalid = function(self,minp)
		return not vector.equal(self.minp,minp)
	end,
	map = function(self,minp)
		if not self:invalid(minp) then
			return
		end

		for _,noise in pairs(self) do
			noise:map(minp)
		end
	end,
})
		

mgnm.group = function(group)
	if not group then
		return
	end

	if mgnm.all[group] then
		return mgnm.all[group]
	end

	local g = setmetatable({},mgnm.noise_group)
	mgnm.all[group] = g
	mgnm.groups[group] = g

	for noise,def in pairs(group) do
		g[noise] = mgnm.auto(def)
	end

	return g
end
