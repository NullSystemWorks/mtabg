Thread = {}
local thread_mt = {__index = Thread}

local threadID = 1
local threads = {}

local function getNewID()
	repeat
		if threadID <= 10e14 then --https://www.lua.org/pil/2.3.html
			threadID = 1
		else
			threadID = threadID + 1
		end
	until not threads[threadID]
	return threadID
end

function Thread.new(func, wakeTime)
	wakeTime = math.max(wakeTime, 50)
	local newInst =
	{
		hasStarted = false,
		wakeTime = wakeTime,
		id = getNewID(),
		thread = coroutine.create(func),
		timer,
	}
	setmetatable(newInst, thread_mt)
	threads[newInst.id] = newInst
	-- iprint("Created thread " ..newInst.id)
	return newInst
end

function Thread:destroy()
	-- iprint("Destroyed thread " ..self.id)
	if isTimer(self.timer) then
		self.timer:destroy()
	end
	threads[self.id] = nil
	self.thread = nil
end

local function resume(threadID)
	local self = threads[threadID]
	if coroutine.status(self.thread) == "suspended" then --work left to do
		coroutine.resume(self.thread)
	else --job done
		self:destroy()
	end
end

function Thread:start(...)
	if not self.hasStarted then
		self.timer = Timer(resume, self.wakeTime, 0, self.id)
		coroutine.resume(self.thread, unpack(arg))
		self.hasStarted = true
	end
end
