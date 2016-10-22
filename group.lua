mgnm.groups = {}

mgnm.noise_group = mgnm.meta_self({
	init = function(self,minp)
		if vector.equal(self.minp,minp) then
			return
		end

		for _,noise in pairs(self) do
			noise:init(minp)
		end
	end,
	map = function(self,minp)
		if vector.equal(self.minp,minp) then
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

	local g = {}
	mgnm.all[group] = g
	mgnm.groups[group] = g

	for noise,def in pairs(group) do
		g[noise] = mgnm.noise(def)
		if not g[noise] then
			g[noise] = mgnm.group(def)
		end
	end

	return g
end
