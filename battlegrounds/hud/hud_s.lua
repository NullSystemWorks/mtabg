--[[
	
				MTA:BG
			MTA Battlegrounds
	Developed By: L, CiBeR, neves768, 1BOY

]]--

--[[
CURRENT PROBLEMS:

- Endposition of both zones are predictable (since zones spawn at specific location and get smaller from there)
POSSIBLE SOLUTION: let safeZone create somewhere within dangerZone

- Zones are visible on map only, not GPS, due to sizing issues on GPS
POSSIBLE SOLUTION: edit customblips appropriately

- Markers are needed so players can see outline of dangerZone even if not looking at the map
PROBLEM HERE: markers behave sketchy when beyond a certain radius

]]

local dangerZone
local safeZone
local zoneRadius = 4000
local zoneRadiusOffsetX,zoneRadiusOffsetY = 0,0
local radiusTimer = 480000 --120000 for testing
local firstZone = false
local zoneTimer
local firstWarning,secondWarning,thirdWarning = false,false,false

function createZone()
	firstZone = true
	local x,y = math.random(-2500,2500), math.random(-2500,2500)
	dangerZone = createColCircle(x,y,zoneRadius)
	local initialZoneRadius = zoneRadius-(zoneRadius*0.25)
	safeZone = createColCircle(x,y,initialZoneRadius)
	zoneTimer = setTimer(decreaseZoneSize,radiusTimer,1)
	setTimer(getPlayersInsideZone,5000,0)
	for i, players in ipairs(getElementsByType("player")) do
		if getElementData(players,"participatingInGame") then
			triggerClientEvent("mtabg_createCustomBlip",players,dangerZone,safeZone,zoneRadius,initialZoneRadius,radiusTimer)
		end
	end
end


function decreaseZoneSize()
	if zoneRadius > 39.75 then
		firstZone = false
		local oldX,oldY,oldZ = getElementPosition(dangerZone)
		local oldX2,oldY2,oldZ2 = getElementPosition(safeZone)
		destroyElement(dangerZone)
		destroyElement(safeZone)
		zoneRadius = zoneRadius-(zoneRadius*0.25)
		if radiusTimer > 60000 then
			radiusTimer = radiusTimer-60000
			--zoneRadiusOffsetX,zoneRadiusOffsetY = math.random(zoneRadiusOffsetX,-zoneRadiusOffsetX)-math.random(-30,30),math.random(zoneRadiusOffsetY,-zoneRadiusOffsetY)-math.random(-30,30)
		end
		local initialZoneRadius = zoneRadius-(zoneRadius*0.25)
		dangerZone = createColCircle(oldX,oldY,zoneRadius)
		safeZone = createColCircle(oldX2,oldY2,initialZoneRadius)
		if zoneTimer then killTimer(zoneTimer) end
		zoneTimer = setTimer(decreaseZoneSize,radiusTimer,1)
		for i, players in ipairs(getElementsByType("player")) do
			if getElementData(players,"participatingInGame") then
				triggerClientEvent("mtabg_createCustomBlip",players,dangerZone,safeZone,zoneRadius,initialZoneRadius,radiusTimer)
			end
		end
	end
	firstWarning = false
	secondWarning = false
	thirdWarning = false
end

function sendRadiusTimerToClient()
	if safeZone then
		local timeDetails = getTimerDetails(zoneTimer)
		triggerClientEvent("mtabg_setRadiusTimerToClient",root,timeDetails)
	end
end
--setTimer(sendRadiusTimerToClient,1000,0)


function getPlayersInsideZone()
	if not firstZone then
		if safeZone and dangerZone then
			for i, players in ipairs(getElementsByType("player")) do
				if getElementData(players,"participatingInGame") then
					if isElementWithinColShape(players,safeZone) then
						return
					else
						if isElementWithinColShape(players,dangerZone) then
							return
						else
							for k, data in ipairs(playerDataInfo[players]) do
								if data[2] == "health" then
									if data[3] > 0 then
										data[3] = data[3]-5
										triggerClientEvent("mtabg_setHealthToClient",players,data[3])
										checkPlayerStatus("health",players,false)
									end
								end
							end
						end
					end
				end
			end
		end
	end
end
