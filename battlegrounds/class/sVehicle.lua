ClassStash.save("Vehicle")
local MtaVehicle = ClassStash.get("Vehicle")

Vehicle = {}
setmetatable(Vehicle, {__index = Element})
local vehicle_mt = {__index = Vehicle}

local vehiclesBurningFuelCount = 0
local vehiclesBurningFuel = {}
local vehicleCount = 0

local DEFAULT_VEHICLE_MODEL = 551
local FUEL_CONSUMPTION = 1

function Vehicle.new(x, y, z, dimension, id)
	local id = id or DEFAULT_VEHICLE_MODEL
	local mtaVehicle = MtaVehicle(id, x, y, z)
	local name = mtaVehicle.name
	vehicleCount = vehicleCount + 1

	local newInst =
	{
		remote = Remote.new(mtaVehicle),
		type = "Vehicle",
		name = name,
		needsFuel = true,
		isBurningFuel = false,
		fuel = math.random(10, 100),
	}
	setmetatable(newInst, vehicle_mt)
	newInst.remote:setSuper(newInst)
	newInst:setDimension(dimension)
	return newInst
end

function Vehicle:destroy()
	if self:doesNeedFuel() then
		self:setBurningFuel(false)
		self.remote:getRemote():destroy()
		self.remote:destroy()
		vehicleCount = vehicleCount - 1
	end
end

function Vehicle.isVehicle(element)
	if element then
		return Vehicle.doesNeedFuel(element)
	else
		return false
	end
end

function Vehicle.getCount()
	return vehicleCount
end

local fuelTimer
function Vehicle.startFuelTimer()
	fuelTimer = Timer(
	function()
		for vehicle in pairs(vehiclesBurningFuel) do
			vehicle:consumeFuelIfMovingAndUpdateDriverGui()
		end
	end, 5000, 0)
end

function Vehicle.stopFuelTimer()
	if isTimer(fuelTimer) then
		fuelTimer:destroy()
	end
	fuelTimer = nil
end

function Vehicle.getBurningFuelCount()
	return vehiclesBurningFuelCount
end

function Vehicle.setBurningFuelCount(_count)
	vehiclesBurningFuelCount = _count
end

function Vehicle.startMonitoringFuelIfFirstBurner()
	if Vehicle.getBurningFuelCount() == 1 then
		Vehicle.startFuelTimer()
		iprint("Started monitoring fuel")
	end
end

function Vehicle.stopMonitoringFuelIfNoBurner()
	if Vehicle.getBurningFuelCount() == 0 then
		Vehicle.stopFuelTimer()
		iprint("Stopped monitoring fuel")
	end
end

function Vehicle:getOccupant(seat)
	local remoteOccupant = self.remote:getRemote():getOccupant(seat)
	return Remote.getSuperFromRemote(remoteOccupant)
end

function Vehicle:getEngineState()
	return self.remote:getRemote():getEngineState()
end

function Vehicle:setEngineState(_state)
	self.remote:getRemote():setEngineState(_state)
end

function Vehicle:doesNeedFuel()
	return self.needsFuel and true or false
end

function Vehicle:getFuel()
	return self.fuel
end

function Vehicle:setFuel(_fuel)
	self.fuel = _fuel
end

function Vehicle:insertToBurningFuelTable()
	self.isBurningFuel = true
	vehiclesBurningFuel[self] = true
	Vehicle.setBurningFuelCount(Vehicle.getBurningFuelCount() + 1)
end

function Vehicle:removeFromBurningFuelTable()
	self.isBurningFuel = false
	vehiclesBurningFuel[self] = nil
	Vehicle.setBurningFuelCount(Vehicle.getBurningFuelCount() - 1)
end

function Vehicle:getBurningFuel()
	return self.isBurningFuel
end

function Vehicle:setBurningFuel(_burningFuel)
	if _burningFuel and not self:getBurningFuel() then
		self:insertToBurningFuelTable()
		iprint(self.name.. " now burns fuel")
		Vehicle.startMonitoringFuelIfFirstBurner()
	elseif not _burningFuel and self:getBurningFuel() then
		self:removeFromBurningFuelTable()
		iprint(self.name.. " no longer burns fuel")
		Vehicle.stopMonitoringFuelIfNoBurner()
		self:setEngineState(false) --FIXME: this should be done clientside
	end
end

function Vehicle:hasEnoughFuel()
	return self:getFuel() > 0
end

function Vehicle:stopBurningIfNoFuel()
	if not self:hasEnoughFuel() then
		self:setBurningFuel(false)
	end
end

function Vehicle:consumeFuel()
	local previousFuel = self:getFuel()
	local currentFuel = math.max(previousFuel - FUEL_CONSUMPTION, 0)
	self:setFuel(currentFuel)
	iprint("Took fuel from: " ..self.name.. ". " ..self:getFuel().. " fuel left")
end

function Vehicle:isMoving()
	local speed = self:getSpeed()
	return speed > 0
end

function Vehicle:consumeFuelIfMovingAndUpdateDriverGui()
	if self:getEngineState() and self:isMoving() then
		self:stopBurningIfNoFuel()
		if self:getBurningFuel() then
			self:consumeFuel()
			self:sendFuelGuiToDriver()
		end
	end
end

function Vehicle:sendFuelGuiToDriver(player)
	local driver = player or self:getOccupant(0)
	driver.remote:send("onUpdateVehicleGui", self:getFuel())
end

function Vehicle:closeFuelGuiForDriver(player)
	local driver = player or self:getOccupant(0)
	driver.remote:send("onUpdateVehicleGui", false)
	iprint("Closed fuel Gui for " ..driver.name)
end

local function handleEnterVehicle(_, seat)
	local self = Remote.getSuperFromRemote(source)
	if Vehicle.isVehicle(self) then
		if seat == 0 and self:getFuel() then
			self:stopBurningIfNoFuel()
			self:sendFuelGuiToDriver()
			if self:hasEnoughFuel() then
				self:setBurningFuel(true)
			else
				self:setEngineState(false)
			end
		end
	end
end
addEventHandler("onVehicleEnter", root, handleEnterVehicle)

local function handleLeaveVehicle(mtaPlayer, seat)
	local player = Remote.getSuperFromRemote(mtaPlayer)
	local self = Remote.getSuperFromRemote(source)
	if Vehicle.isVehicle(self) then
		if seat == 0 and self:doesNeedFuel() then
			self:setBurningFuel(false)
			self:closeFuelGuiForDriver(player)
		end
	end
end
addEventHandler("onVehicleExit", root, handleLeaveVehicle)

local function handleVehicleExplosion()
	local self = Remote.getSuperFromRemote(source)
	if Vehicle.isVehicle(self) then
		-- driver:kill() --FIXME: should not waste the ped
		if self:doesNeedFuel() then
			self:setBurningFuel(false)
			if self:getOccupant(0) then
				self:closeFuelGuiForDriver()
			end
		end
	end
end
addEventHandler("onVehicleExplode", root, handleVehicleExplosion)
