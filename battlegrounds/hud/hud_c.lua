--[[
	
				MTA:BG
			MTA Battlegrounds
	Developed By: L, CiBeR, neves768, 1BOY

]]--

local zoneBlip = false
function createCustomBlip(zone,radius)
	if zoneBlip then
		exports.customblips:destroyCustomBlip(zoneBlip)
	end
	local x,y,z = getElementPosition(zone)
	zoneBlip = exports.customblips:createCustomBlip(x,y,radius/4,radius/4,"hud/radius.png",radius)
	exports.customblips:setCustomBlipRadarScale(zoneBlip,1)
end
addEvent("createCustomBlip",true)
addEventHandler("createCustomBlip",root,createCustomBlip)
