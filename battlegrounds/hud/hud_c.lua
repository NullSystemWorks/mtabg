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
	dangerBlip = exports.customblips:createCustomBlip(x,y,radius/4.2,radius/4.2,"hud/radius.png",radius)
	safeBlip = exports.customblips:createCustomBlip(x2,y2,initialZoneRadius/4.2,initialZoneRadius/4.2,"hud/radius2.png",initialZoneRadius)
	exports.customblips:setCustomBlipRadarScale(dangerBlip,1)
	exports.customblips:setCustomBlipStreamRadius(dangerBlip,0)
	exports.customblips:setCustomBlipRadarScale(safeBlip,1)
	exports.customblips:setCustomBlipStreamRadius(safeBlip,0)
	dangerZoneRadius = radius
	safeZoneRadius = initialZoneRadius
end
addEvent("mtabg_createCustomBlip",true)
addEventHandler("mtabg_createCustomBlip",root,createCustomBlip)

function formatMilliseconds(milliseconds) 
    local totalseconds = math.floor( milliseconds / 1000 ) 
    local seconds = totalseconds % 60 
    local minutes = math.floor( totalseconds / 60 ) 
    minutes = minutes % 60 
    return string.format( "%02d:%02d", minutes, seconds)   
end 

local screenW, screenH = guiGetScreenSize()
local r,g,b = 218,218,218
local alpha = 150
local playerAmount = 0
local gameStatus = false
local countDown = 10
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
			if guiPlayerHealth < 0 then
				guiPlayerHealth = 0 
			end
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
	else
		if playerAmount > 0 then
			if not countdownTimer then
				countdownTimer = setTimer(function()
					countDown = countDown-1
					if countDown == 0 then
						if playerAmount <= 1 then
							triggerServerEvent("mtabg_startGame",root)
							killTimer(countdownTimer)
						else
							outputChatBox("Not enough players, resetting countdown!",255,0,0,false)
							killTimer(countdownTimer)
							countDown = 10
						end
					end
				end,1000,10)
			end
		else
			if isTimer(countdownTimer) then killTimer(countdownTimer) end
		end
	
		dxDrawText("COUNTDOWN:", screenW * 0.6350, screenH * 0.1683, screenW * 0.8413, screenH * 0.2250, tocolor(255, 255, 255, 255), 2.00, "default", "right", "top", false, false, false, false, false)
		dxDrawText("PLAYERS:", screenW * 0.6350, screenH * 0.2250, screenW * 0.8413, screenH * 0.2817, tocolor(255, 255, 255, 255), 2.00, "default", "right", "top", false, false, false, false, false)
		dxDrawText(countDown.." SEC.", screenW * 0.8538, screenH * 0.1683, screenW * 0.9825, screenH * 0.2250, tocolor(255, 255, 255, 255), 2.00, "default", "left", "top", false, false, false, false, false)
		dxDrawText(playerAmount, screenW * 0.8538, screenH * 0.2250, screenW * 0.9825, screenH * 0.2817, tocolor(255, 255, 255, 255), 2.00, "default", "left", "top", false, false, false, false, false)
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

endScreen = {
    label = {},
    button = {},
	image = {}
}

function showEndScreen(rank)
local text = ""
	if rank ~= 1 then
		text = "BETTER LUCK NEXT TIME!"
	else
		text = "A WINNER IS YOU!"
	end
	endScreen.image[1] = guiCreateStaticImage(0.00, 0.00, 1.00, 1.17, "/gui/images/solo_slot.png", true)
	endScreen.image[2] = guiCreateStaticImage(0.83, 0.87, 0.15, 0.06,"/gui/images/solo_slot.png", true)
	guiSetProperty(endScreen.image[1], "ImageColours", "tl:EB000000 tr:EB000000 bl:EB000000 br:EB000000")

	endScreen.label[1] = guiCreateLabel(0.02, 0.06, 0.38, 0.08, getPlayerName(localPlayer), true, endScreen.image[1])
	endScreen.label[2] = guiCreateLabel(0.02, 0.14, 1, 0.09, text, true, endScreen.image[1])
	guiLabelSetVerticalAlign(endScreen.label[2], "center")
	endScreen.label[3] = guiCreateLabel(0.05, 0.39, 0.20, 0.04, "RANK:", true, endScreen.image[1])
	guiLabelSetHorizontalAlign(endScreen.label[3], "center", false)
	endScreen.label[4] = guiCreateLabel(0.05, 0.47, 0.20, 0.04, "KILLS:", true, endScreen.image[1])
	guiLabelSetHorizontalAlign(endScreen.label[4], "center", false)
	endScreen.label[5] = guiCreateLabel(0.25, 0.39, 0.20, 0.04, "#"..rank, true, endScreen.image[1])
	endScreen.label[6] = guiCreateLabel(0.25, 0.47, 0.20, 0.04, "N/A", true, endScreen.image[1])
	endScreen.label[7] = guiCreateLabel(0.83, 0.87, 0.15, 0.06, "Back to Lobby", true, endScreen.image[1])
	guiLabelSetHorizontalAlign(endScreen.label[7], "center", false)
	guiLabelSetVerticalAlign(endScreen.label[7], "center")  
	
	guiLabelSetColor(endScreen.label[2],255,255,0)
	
	guiSetFont(endScreen.label[1],inventoryGUI.font[4])
	guiSetFont(endScreen.label[2],inventoryGUI.font[3])
	guiSetFont(endScreen.label[7],inventoryGUI.font[1])
	for i=3,6 do
		guiSetFont(endScreen.label[i],inventoryGUI.font[2])
	end
	guiBringToFront(endScreen.label[7])
end
addEvent("mtabg_showEndscreen",true)
addEventHandler("mtabg_showEndscreen",root,showEndScreen)

function setRadiusTimerToClient(timer)
	local time = formatMilliseconds(timer)
	guiSetText(zoneIndicators.label[1],tostring(time))
end
addEvent("mtabg_setRadiusTimerToClient",true)
addEventHandler("mtabg_setRadiusTimerToClient",root,setRadiusTimerToClient)

zoneIndicators = {
	label = {},
	image = {},
}

zoneIndicators.label[1] = guiCreateLabel(0.02, 0.73, 0.24, 0.03, "", true)
zoneIndicators.image[1] = guiCreateStaticImage(0.02, 0.71, 0.01, 0.02, "/gui/images/solo_slot.png", true)
guiSetProperty(zoneIndicators.image[1], "ImageColours", "tl:FEFB0000 tr:FEFB0000 bl:FEFB0000 br:FEFB0000")
zoneIndicators.image[2] = guiCreateStaticImage(0.25, 0.71, 0.01, 0.02, "/gui/images/solo_slot.png", true)
guiSetProperty(zoneIndicators.image[2], "ImageColours", "tl:FE000CFA tr:FE000CFA bl:FE000CFA br:FE000CFA")
zoneIndicators.image[3] = guiCreateStaticImage(0.00, 0.69, 0.04, 0.04, "/hud/running.png", true)
guiSetProperty(zoneIndicators.image[3], "ImageColours", "tl:FEFEFEFF tr:FEFEFEFF bl:FEFEFEFF br:FEFEFEFF")   


-- Currently not working
function calculateZoneIndicatorDistance()
	local dX,dY,dZ = getElementPosition(localPlayer)
	local safeZoneDistance = getDistanceBetweenPoints3D(dX,dY,dZ,x2,y2,z2)
	safeZoneDistance = safeZoneDistance-safeZoneRadius
	guiSetPosition(zoneIndicators.image[3],math.min(0.25,math.max(1,safeZoneDistance*0.25)),0.69,true)
end





