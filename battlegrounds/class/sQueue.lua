Queue = {}
local queue_mt = {__index = Queue}

function Queue.new()
	local newInst =
	{
		queue = {}
	}
	setmetatable(newInst, queue_mt)
	return newInst
end

function Queue:push(thingy)
	table.insert(self.queue, thingy)
end

function Queue:pop()
	return table.remove(self.queue, 1)
end

function Queue:getCount()
	return #self.queue
end

function Queue:doesHaveNext()
	return #self.queue > 0
end

function Queue:removeElementsOnPositions(...)
	for i = #arg, 1, -1 do
		table.remove(self.queue, arg[i])
	end
end
