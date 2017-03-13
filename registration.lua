mgnm.registered = {}

mgnm.register = function(name, r_func)
	assert(name and r_func, "Unable to register noise type!\nName or def not provided")
	assert(type(r_func) == "function", "Registration function is not a function")

	assert(not mgnm.registered[name], "Name:" .. name .. "is already registered")
	mgnm.registered[name] = r_func
end

mgnm.get = function(def)
	assert(type(def) == "table", "Def is not a table!")

	-- Def or table can be used as key
	if mgnm.all[def] then
		return mgnm.all[def]
	end

	assert(def.type and mgnm.registered[def.type]
	     , "Def does not supply a valid type.")

	local self = assert(mgnm.registered[def.type](def), "Noise definition caused unknown error")

	mgnm.all[self] = self
	mgnm.all[def] = self

	return self
end
