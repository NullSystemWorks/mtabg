Zone = {}
local zone_mt = {__index = Zone}

local BASE_TIME = 300000
local MINIMUM_TIME = 60000
local BASE_RADIUS = 4000
local MINIMUN_RADIUS = 100

local harmTimer
local instancesTicking = {}
local tickingCount = 0

function Zone.new(match)
	local newInst =
	{
		match = match,
		name = "Gas",
		innerX = 0,
		innerY = 0,
		outerX = 0,
		outerY = 0,
		outerRadius = BASE_RADIUS,
		secondsSinceLastShrink = 0,
		totalTimeBeforeShrink = BASE_TIME,
	}
	setmetatable(newInst, zone_mt)
	newInst:setTicking(true)
	return newInst
end

function Zone:destroy()
	self:setTicking(false)
	instancesTicking[self] = nil
	self.match = nil
end

function Zone:getInnerAreaPosition()
	return self.innerX, self.innerY
end

function Zone:getOuterAreaPosition()
	return self.outerX, self.outerY
end

function Zone:getInnerRadius()
	return self:getOuterRadius()*.75
end

function Zone:getOuterRadius()
	return self.outerRadius
end

function Zone:setOuterRadius(_radius)
	self.outerRadius = _radius >= MINIMUN_RADIUS and _radius or MINIMUN_RADIUS
end

function Zone:getSecondsSinceLastShrink()
	return self.secondsSinceLastShrink
end

function Zone:setSecondsSinceLastShrink(_seconds)
	self.secondsSinceLastShrink = _seconds
end

function Zone:setTimeBeforeShrink(_time)
	self.totalTimeBeforeShrink = _time >= MINIMUM_TIME and _time or MINIMUM_TIME
end

function Zone:getTotalTimeBeforeShrink()
	return self.totalTimeBeforeShrink
end

function Zone:harmPlayersOutsideOuterArea()
	for player in pairs(self.match:getParticipants()) do
		if self:isPlayerOutsideOuterArea(player) then
			player:harm(5)
		end
	end
end

function Zone:isPlayerOutsideOuterArea(player)
	local pX = player:getPosition().x
	local pY = player:getPosition().y
	local sX, sY = self:getOuterAreaPosition()
	local distance = getDistanceBetweenPoints2D(pX, pY, sX, sY)
	return distance > self:getOuterRadius()
end

function Zone:sendSizesToAllPlayers()
	for player in pairs(self.match:getParticipants()) do
		self:sendSizesToPlayer(player)
	end
end

function Zone:sendSizesToPlayer(player)
	local innerX, innerY = self:getInnerAreaPosition()
	local outerX, outerY = self:getOuterAreaPosition()
	player.remote:send("onCreateDangerZone",
		innerX, innerY,
		outerX, outerY,
		self:getInnerRadius(),
		self:getOuterRadius(),
		self:getTotalTimeBeforeShrink()
	)
end

function Zone:sendNoZoneToPlayer(player)
	player.remote:send("onCreateDangerZone", false)
end

function Zone:shrink()
	self:setOuterRadius(self:getOuterRadius()*.75)
	self:setTimeBeforeShrink(self:getTotalTimeBeforeShrink()*.75)
	self:setSecondsSinceLastShrink(0)
	self:sendSizesToAllPlayers()
end

function Zone:getTicking()
	return instancesTicking[self] and true or false
end

local function tickTimer()
	for self in pairs(instancesTicking) do
		self:harmPlayersOutsideOuterArea()
		if self:shouldShrink() then
			self:shrink()
		end
		self:setSecondsSinceLastShrink(self:getSecondsSinceLastShrink() + 1000)
	end
end

function Zone:shouldShrink()
	return self:getSecondsSinceLastShrink() >= self:getTotalTimeBeforeShrink()
end

function Zone:setTicking(_ticking)
	if _ticking then
		if not instancesTicking[self] then
			if tickingCount == 0 then
				harmTimer = Timer(tickTimer, 1000, 0)
			end
			instancesTicking[self] = true
			tickingCount = tickingCount + 1
		end
	else
		if instancesTicking[self] then
			if tickingCount == 1 then
				harmTimer:destroy()
			end
			instancesTicking[self] = nil
			tickingCount = tickingCount - 1
		end
	end
end
