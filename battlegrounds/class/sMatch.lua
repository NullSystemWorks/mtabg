Match = {}
local match_mt = {__index = Match}

local weatherOfTheStaticMatchClass = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22}

local vehiclesOfTheStaticMatchClass = {
	{x = -1399.9912109375, y = -238.28125, z = 6.0068759918213},
	{x = -2878.1240234375, y = -848.697265625, z = 7.195188999176},
	{x = -2240.0341796875, y = -2658.552734375, z = 58.462493896484},
	{x = -812.1396484375, y = -796.693359375, z = 152.40826416016},
	{x = -1570.76171875, y = 371.099609375, z = 7.1875},
	{x = -2488.0390625, y = 88.6708984375, z = 25.530117034912},
	{x = -1571.16796875, y = -2735.0595703125, z = 48.540679931641},
	{x = 127.3486328125, y = -261.5166015625, z = 1.578125},
	{x = 2357.771484375, y = 123.212890625, z = 27.097827911377},
	{x = 2452.8525390625, y = -2029.310546875, z = 13.546875},
	{x = 2054.533203125, y = -1040.9189453125, z = 34.506607055664},
	{x = 2854.1318359375, y = 2407.6044921875, z = 10.8203125},
	{x = 1400.8798828125, y = 1693.12109375, z = 10.8203125},
	{x = -544.3828125, y = 2012.5791015625, z = 60.1875},
	{x = 5, y = 5, z = 3},
}

function Match.new()
	local newInst =
	{
		zone = false,
		participants = {},
		participantCount = 0,
		lootSpots = {},
		vehicles = {},
		dimension = 0,
		weather = 0,
		isRunning = false,
	}
	setmetatable(newInst, match_mt)
	newInst:createVehicles()
	newInst.lootSpots = LootSpot.createAll(newInst)
	newInst.zone = Zone.new(newInst)
	return newInst
end

function Match:destroy()
	self:removeAllParticipants()
	self:setRunning(false)
	self:destroyAllVehicles()
	self:destroyAllLootSpots()
	self.zone:destroy()
end

function Match.getRandomPlaceInTheSky()
	return math.random(-2500, 2500), math.random(-2500, 2500), 1000
end

function Match:getZone()
	return self.zone
end

function Match:getRunning()
	return self.isRunning
end

function Match:setRunning(_isRunning)
	self.isRunning = _isRunning
end

function Match:getDimension()
	return self.dimension
end

function Match:getPlayerCount()
	return self.participantCount
end

function Match:setPlayerCount(_count)
	self.participantCount = _count
end

function Match:getParticipants()
	return self.participants
end

function Match:addLootSpot(lootSpot)
	table.insert(self.lootSpots, lootSpot)
end

function Match:addPlayer(player)
	self:removePlayer(player)
	player:giveParachute()
	player:setPosition(Match.getRandomPlaceInTheSky())
	player:setDimension(self:getDimension())
	player:setMatch(self)
	self.zone:sendSizesToPlayer(player)
	self:setPlayerCount(self:getPlayerCount() + 1)
	self.participants[player] = true
	iprint("Match playerCount is now: " ..self:getPlayerCount())
end

function Match:removePlayer(player)
	if player:getInMatch() then
		player:clearMatchData()
		self:setPlayerCount(self:getPlayerCount() - 1)
		self.participants[player] = nil
		iprint("Match playerCount is now: " ..self:getPlayerCount())
	end
end

function Match:sendAliveCount()
	for player in pairs(self:getParticipants()) do
		iprint("Sending alive count to " ..player.name.. ": " ..self:getPlayerCount())
		player.remote:send("onSendClientAliveCount", self:getPlayerCount())
	end
end

function Match:getWeather()
	return self.weather
end

function Match:setWeather(_weather)
	self.weather = _weather
	self:sendWeather()
end

function Match:sendWeather()
	for player in pairs(self:getParticipants()) do
		player:setWeather(self:getWeather())
	end
end

function Match:getLastPlayer()
	iprint("Players left: " ..self.participantCount)
	for player in pairs(self:getParticipants()) do
		return player
	end
end

function Match:isLastPlayer()
	return self:getPlayerCount() < 2
end

function Match:shouldEnd()
	return self:isLastPlayer()
end

function Match:pushDeathNotification(deadName, killerName)
	for player in pairs(self:getParticipants()) do
		player.remote:send("onShowDeathMessage", self:getPlayerCount(), deadName, killerName)
	end
end

function Match:isWinnerAlive()
	return self:getPlayerCount() > 0
end

function Match:endIfWinner()
	if self:shouldEnd() then
		self:removeWinner()
		self:destroy()
	end
end

function Match:removeWinner()
	if self:isWinnerAlive() then
		local winner = self:getLastPlayer()
		winner:accountWin()
		winner:moveToNowhere()
		winner:showEndScreen()
		self:removePlayer(winner)
		iprint("Winner is alive")
	else
		iprint("Winner died")
	end
end

function Match:setRandomWeather()
	local weatherCount = #weatherOfTheStaticMatchClass
	local chosenWeather = math.random(weatherCount)
	self:setWeather(weatherOfTheStaticMatchClass[chosenWeather])
end

function Match:getVehicleCount()
	return #self.vehicles
end

function Match:createVehicles()
	for _, vehicle in ipairs(vehiclesOfTheStaticMatchClass) do
		local vehicle = Vehicle.new(vehicle.x, vehicle.y, vehicle.z, self:getDimension())
		table.insert(self.vehicles, vehicle)
	end
	iprint(self:getVehicleCount().. " vehicles created")
end

function Match:destroyAllVehicles()
	for _, vehicle in ipairs(self.vehicles) do
		vehicle:destroy()
	end
	iprint("Destroyed vehicles")
	self.vehicles = {}
end

function Match:destroyAllLootSpots()
	for i, lootSpot in ipairs(self.lootSpots) do
		lootSpot:destroy()
		self.lootSpots[i] = nil
	end
end

function Match:removeAllParticipants()
	for player in pairs(self:getParticipants()) do
		self:removePlayer(player)
	end
end
