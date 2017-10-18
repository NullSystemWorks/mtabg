local Test = {}

--MEMORY TESTS
function Test.gc()
	local ramBeforeGC = collectgarbage("count")
	collectgarbage()
	collectgarbage()
	iprint(ramBeforeGC, ramBeforeGC - collectgarbage("count"))
end

function Test.testAccount()
	for i=1,100000 do
		local remote = Remote.getSuperFromRemote(getElementsByType("player")[1]).remote
		local account = Account.new(remote)
		account:destroy()
	end
end

function Test.testPlayer()
	for i=1,1000 do
		client = getElementsByType("player")[1]
		local player = Player.new(client)
		player:destroy()
	end
end

function Test.testVehicle()
	for i=1,1000 do
		local vehicle = Vehicle.new(0,0,3,0)
		vehicle:destroy()
	end
end

function Test.testModel()
	for i=1,1000 do
		local model = WorldObject.new(2969,0,0,3)
		model:destroy()
	end
end

function Test.testLootSpot()
	local match = Remote.getSuperFromRemote(getElementsByType("player")[1]):getMatch()
	for i=1,10000 do
		local lootSpot = LootSpot.new(0,0,0,match)
		lootSpot:destroy()
	end
end

function Test.testMatch()
	for i=0,12 do
		local match = Match.new()
		match:destroy()
	end
end

function Test.testDeadPlayer()
	for i=1,1000 do
		local deadPlayer = DeadPlayer.new(Remote.getSuperFromRemote(getElementsByType("player")[1]))
		deadPlayer:destroy()
	end
end

local function test(_, funcName)
	Test.gc()
	local gcCount = collectgarbage("count")*1024
	Test[funcName]()
	Test.gc()
	iprint("RAM delta: " ..(collectgarbage("count")*1024 - gcCount))
end
-- addCommandHandler("testMatch", test)
-- addCommandHandler("testLootSpot", test)
-- addCommandHandler("testModel", test)
-- addCommandHandler("testAccount", test)
-- addCommandHandler("testVehicle", test)
-- addCommandHandler("testPlayer", test)
-- addCommandHandler("testDeadPlayer", test)


--Queue test
local function testQueue()
	local queue = Queue.new()
	local function printQueue()
		for i,v in ipairs(queue.queue) do
			print(i,v)
		end
	end
	print("Queue at the start: ")
	printQueue()
	queue:push("1")
	queue:push("2")
	queue:push("3")
	print("Queue after insert: ")
	printQueue()
	print("Popped " ,queue:pop())
	print("Queue after pop: ")
	printQueue()
	queue:push("4")
	print("Queue after insert 4: ")
	printQueue()
	print("Popped " ,queue:pop())
	print("Queue after pop: ")
	printQueue()
	print("Popped " ,queue:pop())
	print("Queue after pop: ")
	printQueue()
	print("Popped " ,queue:pop())
	print("Queue after pop: ")
	printQueue()
	print("Popped " ,queue:pop())
	print("Queue after pop: ")
	printQueue()
end
