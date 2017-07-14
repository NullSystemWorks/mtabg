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
addEvent("mtabg_createCustomBlip",true)
addEventHandler("mtabg_createCustomBlip",root,createCustomBlip)

local screenW, screenH = guiGetScreenSize()
function displayStatus()
	dxDrawLine((screenW * 0.2612) - 1, (screenH * 0.9017) - 1, (screenW * 0.2612) - 1, screenH * 0.9450, tocolor(0, 0, 0, 255), 1, true)
	dxDrawLine(screenW * 0.7688, (screenH * 0.9017) - 1, (screenW * 0.2612) - 1, (screenH * 0.9017) - 1, tocolor(0, 0, 0, 255), 1, true)
	dxDrawLine((screenW * 0.2612) - 1, screenH * 0.9450, screenW * 0.7688, screenH * 0.9450, tocolor(0, 0, 0, 255), 1, true)
	dxDrawLine(screenW * 0.7688, screenH * 0.9450, screenW * 0.7688, (screenH * 0.9017) - 1, tocolor(0, 0, 0, 255), 1, true)
	dxDrawRectangle(screenW * 0.2612, screenH * 0.9017, screenW * (0.5075/(100/guiPlayerHealth)), screenH * 0.0433, tocolor(218, 218, 218, 254), true)
end
addEventHandler("onClientRender", root,displayStatus)
