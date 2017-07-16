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
	exports.customblips:setCustomBlipStreamRadius(zoneBlip,0)
end
addEvent("mtabg_createCustomBlip",true)
addEventHandler("mtabg_createCustomBlip",root,createCustomBlip)

local screenW, screenH = guiGetScreenSize()
local r,g,b = 218,218,218
local alpha = 150
function displayStatus()
	if not inventoryIsShowing then
		if alpha > 150 then
			alpha = math.max(170,alpha-1)
		end
		dxDrawLine((screenW * 0.2612) - 1, (screenH * 0.9017) - 1, (screenW * 0.2612) - 1, screenH * 0.9450, tocolor(0, 0, 0, 150), 1, true)
		dxDrawLine(screenW * 0.7688, (screenH * 0.9017) - 1, (screenW * 0.2612) - 1, (screenH * 0.9017) - 1, tocolor(0, 0, 0, 150), 1, true)
		dxDrawLine((screenW * 0.2612) - 1, screenH * 0.9450, screenW * 0.7688, screenH * 0.9450, tocolor(0, 0, 0, 150), 1, true)
		dxDrawLine(screenW * 0.7688, screenH * 0.9450, screenW * 0.7688, (screenH * 0.9017) - 1, tocolor(0, 0, 0, 150), 1, true)
		dxDrawRectangle(screenW * 0.2612, screenH * 0.9017, screenW * (0.5075/(100/guiPlayerHealth)), screenH * 0.0433, tocolor(r,g,b, alpha), true)
	end
end
addEventHandler("onClientRender", root,displayStatus)

function setHealthToClient(value)
	guiPlayerHealth = tonumber(value)
	r,g,b = 255,170,170
	alpha = 255
	setTimer(function()
		r,g,b = 218,218,218
	end,2000,1)
end
addEvent("mtabg_setHealthToClient",true)
addEventHandler("mtabg_setHealthToClient",root,setHealthToClient)




