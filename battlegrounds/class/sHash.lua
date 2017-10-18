Hash = {}

local THREAD_WAKE_TIME = 50
local THREAD_WORK_COUNT = 5000
local HASH_COUNT = 250000

local queue = Queue.new()
local isIdle = true
local currentClient
local thread

function Hash.enqueue(password, salt, callback, player, alphaKey)
	if not player.account:getInHashQueue() then
		queue:push({password, salt, callback, player, alphaKey})
		player.account:setInHashQueue(true)
		iprint("Player " ..player.name.. " joined the hash queue")
	else
		iprint("Warning: Player " ..player.name.. " tried to enter the hash queue twice!")
	end
end

function Hash.clearThread()
	if not Hash.getIdle() then
		thread:destroy()
		thread = nil
		Hash.setCurrentClient(nil)
		Hash.setIdle(true)
	end
end

function Hash.hashNext()
	if queue:doesHaveNext() then
		local nextInLine = queue:pop()
		Hash.setIdle(false)
		iprint("Now hashing for " ..nextInLine[4].name)
		thread = Thread.new(Hash.compute, THREAD_WAKE_TIME)
		thread:start(unpack(nextInLine))
	else
		iprint("No more players waiting in the hash queue")
	end
end

function Hash.getIdle()
	return isIdle
end

function Hash.setIdle(_idle)
	isIdle = _idle
end

function Hash.getCurrentClient()
	return currentClient
end

function Hash.setCurrentClient(_player)
	currentClient = _player
end

function Hash.compute(password, salt, callback, player, alphaKey)
	local hash = hash
	local mod = math.mod
	local getTickCount = getTickCount
	Hash.setCurrentClient(player)
	local iterationCount = 1 --how many iterations
	local totalIterationTime = 0 --total computational time
	local partialIterationTime = 0 --time for single iteration round
	local startTime = getTickCount() --start of the proccess
	local cycleStartTime = getTickCount() --start of the cycle
	local saltyPass = salt .. password
	local hashedString = hash("sha256", saltyPass) --hash for the fisrt time
	for i=1, HASH_COUNT do
		hashedString = hash("sha256", hashedString .. saltyPass ) --hash
		iterationCount = iterationCount + 1 --count how many hashes
		if mod(iterationCount, THREAD_WORK_COUNT) == 0 then --stop periodically
			player.remote:send("onLoginLoadingBarSetProgress", (i + 1)*100/HASH_COUNT)
			partialIterationTime = getTickCount() - cycleStartTime --store time for this iteration round
			totalIterationTime = totalIterationTime + partialIterationTime --add to total
			partialIterationTime = 0 --reset this iteration time
			coroutine.yield() --suspend proccess
			cycleStartTime = getTickCount() --get start time for new cycle
		end
	end
	partialIterationTime = getTickCount() - cycleStartTime --time for last iteration round
	totalIterationTime = totalIterationTime + partialIterationTime --add time for last execution
	local totalDuration = getTickCount() - startTime --computational time + sleep time
	iprint("Hashed " ..iterationCount.. " times in " ..totalIterationTime.. "ms") --output processing time
	iprint(string.format( "Hashing password took: %dms. Thread: %d%%",
	totalDuration, totalIterationTime/(totalDuration)*100))
	callback(player, salt.. "$" ..hashedString, alphaKey)
	Hash.removePlayerFromQueue(player)
end

function Hash.generateSalt()
	return hash("sha1", math.random())
end

function Hash.getSalt(hash)
	return split(hash, "$")[1]
end

function Hash.removePlayerFromQueue(player)
	player.account:setInHashQueue(false)
	if Hash.getCurrentClient() == player then
		Hash.clearThread()
		iprint("Stopped hashing for " ..player.name)
		Hash.hashNext()
	else
		for position, queuedHash in pairs(queue.queue) do
			if queuedHash[4] == player then
				queue:removeElementsOnPositions(position)
				iprint("Removed " ..player.name.. " from the hashing queue")
			end
		end
	end
end

function Hash.getHash(password, salt, callback, player, alphaKey)
	Hash.enqueue(password, salt, callback, player, alphaKey)
	if Hash.getIdle() then
		Hash.hashNext()
	end
end

local function handleResourceStop()
	Hash.clearThread()
end
addEventHandler("onResourceStop", resourceRoot, handleResourceStop)
