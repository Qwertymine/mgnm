local buffers = {}
local lent_buffers = {}

local function hash_pos(size,dims)
	local z = 0
	if dims == 3
	and size.z then
		z = size.z
	end
	return (z + 32768)*65536*65536 + (size.y + 32768)*65536 + (size.x + 32768)
end

mgnm.get_buffer = function(size,dims)
	local hash = hash_pos(size,dims)
	if not buffers[hash] then
		buffers[hash] = {}
	end
	local buffers = buffers[hash]
	if #buffers == 0 then
		return {size=size,dims=dims}
	end
	local buffer = buffers[#buffers]
	buffers[#buffers] = nil
	lent_buffers[buffer] = buffer
	return buffer
end

mgnm.is_buffer = function(buffer)
	if not buffer
	or not lent_buffers[buffer] then
		return false
	end
	return true
end

local is_buffer = mgnm.is_buffer
mgnm.return_buffer = function(buffer)
	if not is_buffer(buffer) then
		return
	end
	-- Avoid interfering with later uses
	buffer.minp = nil

	lent_buffers[buffer] = nil
	local hash = hash_pos(buffer.size,buffer.dims)
	buffers[hash][#buffers[hash]+1] = buffer
end

