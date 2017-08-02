--[[
	
				MTA:BG
			MTA Battlegrounds
	Developed By: L, CiBeR, neves768, 1BOY

]]--

local dangerBlip = false
local safeBlip = false
local x,y,z = 0,0,0
local x2,y2,z2 = 0,0,0
local dangerZoneRadius = 0
local safeZoneRadius = 0
function createCustomBlip(dangerZone,safeZone,radius,initialZoneRadius)
	if dangerBlip then
		exports.customblips:destroyCustomBlip(dangerBlip)
		exports.customblips:destroyCustomBlip(safeBlip)
	end
	x,y,z = getElementPosition(dangerZone)
	x2,y2,z2 = getElementPosition(safeZone)
	dangerBlip = exports.customblips:createCustomBlip(x,y,radius/4,radius/4,"hud/radius.png",radius)
	safeBlip = exports.customblips:createCustomBlip(x2,y2,initialZoneRadius/4,initialZoneRadius/4,"hud/radius2.png",initialZoneRadius)
	exports.customblips:setCustomBlipRadarScale(dangerBlip,1)
	exports.customblips:setCustomBlipStreamRadius(dangerBlip,0)
	exports.customblips:setCustomBlipRadarScale(safeBlip,1)
	exports.customblips:setCustomBlipStreamRadius(safeBlip,0)
	dangerZoneRadius = radius
	safeZoneRadius = initialZoneRadius
end
addEvent("mtabg_createCustomBlip",true)
addEventHandler("mtabg_createCustomBlip",root,createCustomBlip)

local screenW, screenH = guiGetScreenSize()
local r,g,b = 218,218,218
local alpha = 150
local playerAmount = 0
local gameStatus = false
function displayStatus()
	if gameStatus then
		if not inventoryIsShowing then
			if alpha > 150 then
				alpha = math.max(170,alpha-1)
			end
			dxDrawLine((screenW * 0.2612) - 1, (screenH * 0.9017) - 1, (screenW * 0.2612) - 1, screenH * 0.9450, tocolor(0, 0, 0, 150), 1, true)
			dxDrawLine(screenW * 0.7688, (screenH * 0.9017) - 1, (screenW * 0.2612) - 1, (screenH * 0.9017) - 1, tocolor(0, 0, 0, 150), 1, true)
			dxDrawLine((screenW * 0.2612) - 1, screenH * 0.9450, screenW * 0.7688, screenH * 0.9450, tocolor(0, 0, 0, 150), 1, true)
			dxDrawLine(screenW * 0.7688, screenH * 0.9450, screenW * 0.7688, (screenH * 0.9017) - 1, tocolor(0, 0, 0, 150), 1, true)
			dxDrawRectangle(screenW * 0.2612, screenH * 0.9017, screenW * (0.5075/(100/guiPlayerHealth)), screenH * 0.0433, tocolor(r,g,b, alpha), true)
			
			dxDrawText("ALIVE:", (screenW * 0.8488) - 1, (screenH * 0.0483) - 1, (screenW * 0.9375) - 1, (screenH * 0.1050) - 1, tocolor(0, 0, 0, 255), 2.00, "default", "left", "top", false, false, false, false, false)
			dxDrawText("ALIVE:", (screenW * 0.8488) + 1, (screenH * 0.0483) - 1, (screenW * 0.9375) + 1, (screenH * 0.1050) - 1, tocolor(0, 0, 0, 255), 2.00, "default", "left", "top", false, false, false, false, false)
			dxDrawText("ALIVE:", (screenW * 0.8488) - 1, (screenH * 0.0483) + 1, (screenW * 0.9375) - 1, (screenH * 0.1050) + 1, tocolor(0, 0, 0, 255), 2.00, "default", "left", "top", false, false, false, false, false)
			dxDrawText("ALIVE:", (screenW * 0.8488) + 1, (screenH * 0.0483) + 1, (screenW * 0.9375) + 1, (screenH * 0.1050) + 1, tocolor(0, 0, 0, 255), 2.00, "default", "left", "top", false, false, false, false, false)
			dxDrawText("ALIVE:", screenW * 0.8488, screenH * 0.0483, screenW * 0.9375, screenH * 0.1050, tocolor(255, 255, 255, 255), 2.00, "default", "left", "top", false, false, false, false, false)
			dxDrawText(playerAmount, (screenW * 0.9437) - 1, (screenH * 0.0483) - 1, (screenW * 1.0325) - 1, (screenH * 0.1050) - 1, tocolor(0, 0, 0, 255), 2.00, "default", "left", "top", false, false, false, false, false)
			dxDrawText(playerAmount, (screenW * 0.9437) + 1, (screenH * 0.0483) - 1, (screenW * 1.0325) + 1, (screenH * 0.1050) - 1, tocolor(0, 0, 0, 255), 2.00, "default", "left", "top", false, false, false, false, false)
			dxDrawText(playerAmount, (screenW * 0.9437) - 1, (screenH * 0.0483) + 1, (screenW * 1.0325) - 1, (screenH * 0.1050) + 1, tocolor(0, 0, 0, 255), 2.00, "default", "left", "top", false, false, false, false, false)
			dxDrawText(playerAmount, (screenW * 0.9437) + 1, (screenH * 0.0483) + 1, (screenW * 1.0325) + 1, (screenH * 0.1050) + 1, tocolor(0, 0, 0, 255), 2.00, "default", "left", "top", false, false, false, false, false)
			dxDrawText(playerAmount, screenW * 0.9437, screenH * 0.0483, screenW * 1.0325, screenH * 0.1050, tocolor(255, 255, 255, 255), 2.00, "default", "left", "top", false, false, false, false, false)
		end
	end
end
addEventHandler("onClientRender", root,displayStatus)

function setHealthToClient(value)
	if gameStatus then
		guiPlayerHealth = tonumber(value)
		r,g,b = 255,170,170
		alpha = 255
		setTimer(function()
			r,g,b = 218,218,218
		end,2000,1)
	end
end
addEvent("mtabg_setHealthToClient",true)
addEventHandler("mtabg_setHealthToClient",root,setHealthToClient)

function setPlayerAmountToClient(value,status)
	playerAmount = tonumber(value)
	gameStatus = status
end
addEvent("mtabg_setPlayerAmountToClient",true)
addEventHandler("mtabg_setPlayerAmountToClient",root,setPlayerAmountToClient)

--[[
zoneIndicators = {
	label = {},
	image = {},
}

zoneIndicators.label[1] = guiCreateLabel(0.02, 0.73, 0.24, 0.03, "MM:SS", true)
zoneIndicators.image[1] = guiCreateStaticImage(0.02, 0.71, 0.01, 0.02, "/gui/images/solo_slot.png", true)
guiSetProperty(zoneIndicators.image[1], "ImageColours", "tl:FEFB0000 tr:FEFB0000 bl:FEFB0000 br:FEFB0000")
zoneIndicators.image[2] = guiCreateStaticImage(0.25, 0.71, 0.01, 0.02, "/gui/images/solo_slot.png", true)
guiSetProperty(zoneIndicators.image[2], "ImageColours", "tl:FE000CFA tr:FE000CFA bl:FE000CFA br:FE000CFA")
zoneIndicators.image[3] = guiCreateStaticImage(0.00, 0.69, 0.04, 0.04, "/hud/running.png", true)
guiSetProperty(zoneIndicators.image[3], "ImageColours", "tl:FEFEFEFF tr:FEFEFEFF bl:FEFEFEFF br:FEFEFEFF")   

function calculateZoneIndicatorDistance()
	local dX,dY,dZ = getElementPosition(localPlayer)
	local safeZoneDistance = getDistanceBetweenPoints3D(dX,dY,dZ,x2,y2,z2)
	safeZoneDistance = safeZoneDistance-safeZoneRadius
	guiSetPosition(zoneIndicators.image[3],math.min(0.25,math.max(1,safeZoneDistance*0.25)),0.69,true)
end
]]




