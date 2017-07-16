--[[
	
				MTA:BG
			MTA Battlegrounds
	Developed By: L, CiBeR, neves768, 1BOY

]]--

local theZone
local theMarker
local zoneRadius = 3000
local radiusTimer = 20000
local firstZone = false
function createZone()
	firstZone = true
	local x,y = math.random(-2500,2500), math.random(-2500,2500)
	theZone = createColCircle(x,y,zoneRadius)
	--theMarker = createMarker(x,y,1000,"checkpoint",zoneRadius,0,0,255,255)
	local x,y,z = getElementPosition(theZone)
	outputServerLog("Zone has been created: "..tostring(x)..", "..tostring(y).."Marker Size: "..tostring(getMarkerSize(theMarker)))
	setTimer(decreaseZoneSize,radiusTimer,0)
	setTimer(getPlayersInsideZone,5000,0)
	triggerClientEvent("mtabg_createCustomBlip",root,theZone,zoneRadius) 
end
addCommandHandler("zone",createZone)

function decreaseZoneSize()
	if zoneRadius > 39.75 then
		firstZone = false
		local oldX,oldY,oldZ = getElementPosition(theZone)
		destroyElement(theZone)
		zoneRadius = zoneRadius-(zoneRadius*0.25)
		if radiusTimer > 60000 then
			radiusTimer = radiusTimer-60000
		end
		--setMarkerSize(theMarker,zoneRadius)
		theZone = createColSphere(oldX,oldY,oldZ,zoneRadius)
		triggerClientEvent("mtabg_createCustomBlip",root,theZone,zoneRadius)
	end
end

function getPlayersInsideZone()
	if not firstZone then
		if theZone then
			for i, players in ipairs(getElementsByType("player")) do
				if isElementWithinColShape(players,theZone) then
					return
				else
					for k, data in ipairs(playerDataInfo[players]) do
						if data[2] == "health" then
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
