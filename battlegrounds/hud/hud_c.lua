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
local zoneTimer

local screenW, screenH = guiGetScreenSize()
local r,g,b = 218,218,218
local alpha = 150
local playerAmount = 0
local gameStatus = false
local countDown = 180 -- 180

local maxDistance = 100 --max distance represented by littleDude
local littleDudeDistance = maxDistance --relative distance from littleDude to safe area
local distanceToSafeArea --distance from player to safe area
local screenx, screeny = guiGetScreenSize() --screen size
local safeAreaCol



function createCustomBlip(dangerZone,safeZone,radius,initialZoneRadius,timer)
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
	safeAreaCol = false
	maxDistance = radius-safeZoneRadius
	safeAreaCol = safeZone
	if isTimer(zoneTimer) then killTimer(zoneTimer) end
	zoneTimer = setTimer(function() end,timer,0)
	local radiusTimer = setTimer(setRadiusTimerToClient,1000,0,zoneTimer)
	for i=1,3 do
		if not guiGetVisible(zoneIndicators.image[i]) then
			guiSetVisible(zoneIndicators.image[i],true)
		end
	end
end
addEvent("mtabg_createCustomBlip",true)
addEventHandler("mtabg_createCustomBlip",root,createCustomBlip)

function formatMilliseconds(milliseconds)
	if milliseconds then
		local totalseconds = math.floor( milliseconds / 1000 ) 
		local seconds = totalseconds % 60 
		local minutes = math.floor( totalseconds / 60 ) 
		minutes = minutes % 60 
		return string.format( "%02d:%02d", minutes, seconds)
	end
end 

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
						if playerAmount > 1 then
							killTimer(countdownTimer)
						else
							outputChatBox("Not enough players, resetting countdown!",255,0,0,false)
							killTimer(countdownTimer)
							countDown = 180
						end
					end
				end,1000,180)
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
	if isTimer(timer) then
		local timeDetails = getTimerDetails(timer)
		local time = formatMilliseconds(timeDetails)
		guiSetText(zoneIndicators.label[1],tostring(time))
	end
end
addEvent("mtabg_setRadiusTimerToClient",true)
addEventHandler("mtabg_setRadiusTimerToClient",root,setRadiusTimerToClient)

zoneIndicators = {
	label = {},
	image = {},
}

zoneIndicators.label[1] = guiCreateLabel(0.02, 0.73, 0.24, 0.03, "", true)
zoneIndicators.image[1] = guiCreateStaticImage (0.02, 0.71, 0.01, 0.02, "/gui/images/solo_slot.png", true) --starting position
guiSetProperty(zoneIndicators.image[1], "ImageColours", "tl:FEFB0000 tr:FEFB0000 bl:FEFB0000 br:FEFB0000")
zoneIndicators.image[2] = guiCreateStaticImage (0.25, 0.71, 0.01, 0.02, "/gui/images/solo_slot.png", true) --finishing position
guiSetProperty(zoneIndicators.image[2], "ImageColours", "tl:FE000CFA tr:FE000CFA bl:FE000CFA br:FE000CFA")
zoneIndicators.image[3] = guiCreateStaticImage (0.02, 0.69, 0.04, 0.04, "hud/running.png", true) --our littledude

for i=1,3 do
	guiSetVisible(zoneIndicators.image[i],false)
end

local function mapValues(x, in_min, in_max, out_min, out_max) --rescales values
	return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
end

local getDistanceBetweenPoints2D = getDistanceBetweenPoints2D
local localPlayer = localPlayer
local math = math
local function calculateLittleDudeDistance()
	local px, py = localPlayer.position.x, localPlayer.position.y --player coordinates
	local sx,sy
	if safeAreaCol then
		sx, sy = safeAreaCol.position.x, safeAreaCol.position.y --safe area coords
	end
	distanceToSafeArea = (getDistanceBetweenPoints2D(px, py, sx, sy) - safeZoneRadius > 0) and
	getDistanceBetweenPoints2D(px, py, sx, sy) - safeZoneRadius or 0 --show positive or 0
	if distanceToSafeArea > maxDistance then --if too far
		return 0 --stay at max
	else
		return mapValues(distanceToSafeArea, 0, maxDistance, 0.23, 0.02) --calculate relative distance
	end
end

local guiSetPosition = guiSetPosition
local dxDrawText = dxDrawText
local function moveLittleDude() --moves littleDude
	if gameStatus then
		littleDudeDistance = calculateLittleDudeDistance()
		guiSetPosition(zoneIndicators.image[3], littleDudeDistance, 0.69, true) --set littleDudes position
		--dxDrawText(math.floor(distanceToSafeArea), screenx*(littleDudeDistance + 0.027) , screeny*0.96) --draw distance
	end
end
addEventHandler("onClientRender", root, moveLittleDude)




