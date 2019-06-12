Lobby = {}
local lobby_mt ={__index = Lobby}

local TOTAL_COUNTDOWN_TIME = 300

function Lobby.new()
	local newInst =
	{
		participants = {},
		participantCount = 0,
		posX = 3971,
		posY = 3276,
		posZ = 16,
		dimension = 0,
		interior = 0,
		shouldForceMatchStart = false,
		quickTick = false,
		countownValue = TOTAL_COUNTDOWN_TIME,
	}
	setmetatable(newInst, lobby_mt)
	return newInst
end

lobby = Lobby.new() --FIXME: where should this class be instanced?

--TODO: create destructor

function Lobby:getPlayerCount()
	return self.participantCount
end

function Lobby:setPlayerCount(_count)
	self.participantCount = _count
end

function Lobby:getPlayers()
	return self.participants
end

function Lobby:addPlayer(player, skin)
	self:removePlayer(player)
	player:spawn(0,0,0) --FIXME: find somewhere else to spawn the player, only teleport here
	player:setDimension(self:getDimension())
	player:setInterior(self:getInterior())
	player:setPosition(self:getPosition())
	player:setLobby(self)
	player:setModel(skin)
	self:setPlayerCount(self:getPlayerCount() + 1)
	self.participants[player] = true
	self:sendPlayerCount()
	self:checkIfMatchShouldStart()
	iprint("Lobby playerCount is now: " ..self:getPlayerCount())
end

function Lobby:removePlayer(player)
	if player:getInLobby() then
		player:setLobby(false)
		self:setPlayerCount(self:getPlayerCount() - 1)
		self.participants[player] = nil
		self:sendPlayerCount()
		self:stopCountDownIfInsufficientPlayers()
		iprint("Lobby playerCount is now: " ..self:getPlayerCount())
	end
end

function Lobby:getPosition()
	local x = self.posX + math.random(-10, 10)
	local y = self.posY + math.random(-10, 10)
	local z = self.posZ
	return x, y, z
end

function Lobby:getInterior()
	return self.interior
end

function Lobby:getDimension()
	return self.dimension
end

function Lobby:hasSufficientPlayers()
	return self:getPlayerCount() > 1
end

function Lobby:shouldCountDownTick()
	return self:getForcedTick() or self:hasSufficientPlayers()
end

function Lobby:getCountdown()
	return self.countownValue
end

function Lobby:setCountdown(_value)
	self.countownValue = _value
end

function Lobby:tickCountDown()
	self:setCountdown(self:getCountdown() - 1)
	self:sendCountdown()
end

function Lobby:setForcedTick(forcedTick)
	self.shouldForceMatchStart = forcedTick
end

function Lobby:getForcedTick()
	return self.shouldForceMatchStart
end

function Lobby:setQuickTick(_quickTick)
	self.quickTick = _quickTick
end

function Lobby:getQuickTick()
	return self.quickTick
end

function Lobby:sendPlayerCount()
	for player in pairs(self:getPlayers()) do
		player.remote:send("onSendLobbyCount", self:getPlayerCount())
	end
end

function Lobby:sendInsufficientPlayersMessage()
	for player in pairs(self:getPlayers()) do
		player.remote:send("onSendCountdownMessage", "insufficientPlayers")
		player.remote:send("onUpdateLobbyCountdown", "N/A")
	end
end

function Lobby:sendMatchAlreadyRunningMessage()
	for player in pairs(self:getPlayers()) do
		player.remote:send("onSendCountdownMessage", "matchRunning")
		self:sendPlayerCount()
	end
end

function Lobby:sendCountdownMessage()
	for player in pairs(self:getPlayers()) do
		player.remote:send("onSendCountdownMessage", self:getCountdown())
	end
end

function Lobby:sendCountdown()
	for player in pairs(self:getPlayers()) do
		player.remote:send("onUpdateLobbyCountdown", self:getCountdown())
	end
end

function Lobby:stopCountDownIfInsufficientPlayers()
	if not self:shouldCountDownTick() then
		self:stopCountDown()
		self:sendInsufficientPlayersMessage()
	end
end

function Lobby:checkIfMatchShouldStart()
	if self:shouldCountDownTick() then
		self:startCountDown()
	else
		self:sendInsufficientPlayersMessage()
	end
end

function Lobby:resetCountDown()
	self:stopCountDown()
	self:setForcedTick(false)
	self:setQuickTick(false)
	self:setCountdown(TOTAL_COUNTDOWN_TIME)
end

local countdownTimer --FIXME: share this timer between all lobby instances
function Lobby:stopCountDown()
	if isTimer(countdownTimer) then
		killTimer(countdownTimer)
	end
end

function Lobby:startCountDown()
	self:stopCountDown()
	self:sendCountdownMessage()
	countdownTimer = setTimer(function()
		self:tickCountDown()
		if self:getCountdown() == 0 then
			if self:shouldCountDownTick() then
				self:startMatch()
				self:resetCountDown()
			end
		elseif math.mod(self:getCountdown(), 20) == 0 and self:getCountdown() <= 100 then
			self:sendCountdownMessage()
		end
	end, self:getQuickTick() and 50 or 1000, TOTAL_COUNTDOWN_TIME)
end

function Lobby:startMatch()
	local match = Match.new()
	for player in pairs(self:getPlayers()) do
		self:removePlayer(player)
		match:addPlayer(player)
	end
	match:setRandomWeather()
	self:sendPlayerCount()
	match:sendAliveCount()
	match:setRunning(true)
end
