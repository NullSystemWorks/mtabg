--[[
	
				MTA:BG
			MTA Battlegrounds
	Developed By: L, CiBeR, neves768, 1BOY

]]--

local theZone
local zoneRadius = 3000
local radiusTimer = 300000
function createZone(plr)
	local x,y = math.random(-2500,2500), math.random(-2500,2500)
	theZone = createColCircle(x,y,zoneRadius)
	local x,y,z = getElementPosition(theZone)
	outputServerLog("Zone has been created: "..tostring(x)..", "..tostring(y))
	setTimer(decreaseZoneSize,radiusTimer,0)
	triggerClientEvent("mtabg_createCustomBlip",root,theZone,zoneRadius) 
end
addCommandHandler("zone",createZone)

function decreaseZoneSize()
	if zoneRadius > 39.75 then
		local oldX,oldY,oldZ = getElementPosition(theZone)
		destroyElement(theZone)
		zoneRadius = zoneRadius-(zoneRadius*0.25)
		if radiusTimer > 60000 then
			radiusTimer = radiusTimer-60000
		end
		theZone = createColSphere(oldX,oldY,oldZ,zoneRadius)
		outputServerLog("Zonesize has been decreased!")
		triggerClientEvent("mtabg_createCustomBlip",root,theZone,zoneRadius)
	end
end
