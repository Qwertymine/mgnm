local buffers = {}
local lent_buffers = {}

local function get_buffer(size)
	local hash = minetest.hash_node_pos(size)
	if not buffers[hash] then
		buffers[hash] = {}
	end
	local buffers = buffers[hash]
	if #buffers == 0 then
		return {size=size}
	end
	local buffer = buffers[#buffers]
	buffers[#buffers] = nil
	lent_buffers[buffer] = buffer
	return buffer
end
mgnm.get_buffer = get_buffer

local function is_buffer(buffer)
	if not buffer
	or not lent_buffers[buffer] then
		return false
	end
	return true
end
mgnm.is_buffer = is_buffer

local function return_buffer(buffer)
	if not is_buffer then
		return
	end
	-- Avoid interfering with later uses
	buffer.minp = nil

	lent_buffers[buffer] = nil
	local hash = minetest.hash_node_pos(buffer.size)
	buffers[hash][#buffers[hash]+1] = buffer
end
mgnm.return_buffer = return_buffer

