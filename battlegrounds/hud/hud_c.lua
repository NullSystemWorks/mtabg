--[[

				MTA:BG
			MTA Battlegrounds
	Developed By: Null System Works (L, CiBeR, neves768, 1BOY & expert975)
	
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
local countDown = 120 -- 180

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
	dangerBlip = exports.customblips:createCustomBlip(x,y,radius,radius,"hud/radius.png",screenMapPos1)
	safeBlip = exports.customblips:createCustomBlip(x2,y2,initialZoneRadius,initialZoneRadius,"hud/radius2.png",screenMapPos2)
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
	guiSetVisible(zoneIndicators.label[1],true)
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
	if guiGetVisible(homeScreen.staticimage[1]) then return end
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
		if not getElementData(localPlayer,"participatingInGame") then
			if playerAmount > 0 then
				if not isTimer(countdownTimer) then
					countdownTimer = setTimer(function()
						countDown = math.max(countDown-1,0)
						if countDown == 0 then
							if playerAmount > 0 then -- Must be 1 (= at least 2 players)
								killTimer(countdownTimer)
							else
								outputChatBox("Not enough players, resetting countdown!",255,0,0,false)
								killTimer(countdownTimer)
								countdownTimer = false
								countDown = 120
							end
						end
					end,1000,120)
				end
			else
				if isTimer(countdownTimer) then 
					killTimer(countdownTimer) 
					countdownTimer = false 
					countDown = 120 
				end
			end
			
			dxDrawText("COUNTDOWN:", screenW * 0.6350, screenH * 0.1683, screenW * 0.8413, screenH * 0.2250, tocolor(255, 255, 255, 255), 2.00, "default", "right", "top", false, false, false, false, false)
			dxDrawText("PLAYERS:", screenW * 0.6350, screenH * 0.2250, screenW * 0.8413, screenH * 0.2817, tocolor(255, 255, 255, 255), 2.00, "default", "right", "top", false, false, false, false, false)
			dxDrawText(countDown.." SEC.", screenW * 0.8538, screenH * 0.1683, screenW * 0.9825, screenH * 0.2250, tocolor(255, 255, 255, 255), 2.00, "default", "left", "top", false, false, false, false, false)
			dxDrawText(playerAmount, screenW * 0.8538, screenH * 0.2250, screenW * 0.9825, screenH * 0.2817, tocolor(255, 255, 255, 255), 2.00, "default", "left", "top", false, false, false, false, false)
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

function setPlayerAmountToClient(value,status,countdown)
	playerAmount = tonumber(value)
	gameStatus = status
	countDown = countdown
end
addEvent("mtabg_setPlayerAmountToClient",true)
addEventHandler("mtabg_setPlayerAmountToClient",root,setPlayerAmountToClient)

endScreen = {
    label = {},
    button = {},
	image = {},
	font = {}
}

local text = ""
local rank = ""

endScreen.font[1] = guiCreateFont("/fonts/etelka.ttf",11)
endScreen.font[2] = guiCreateFont("/fonts/etelka.ttf",15)
endScreen.font[3] = guiCreateFont("/fonts/etelka.ttf",20)
endScreen.font[4] = guiCreateFont("/fonts/etelka.ttf",25)

endScreen.image[1] = guiCreateStaticImage(0.00, 0.00, 1.00, 1.17, "/gui/images/solo_slot.png", true)
endScreen.image[2] = guiCreateStaticImage(0.73, 0.87, 0.20, 0.06,"/gui/images/solo_slot.png", true)
guiSetProperty(endScreen.image[1], "ImageColours", "tl:EB000000 tr:EB000000 bl:EB000000 br:EB000000")
endScreen.label[1] = guiCreateLabel(0.02, 0.06, 0.38, 0.08, getPlayerName(localPlayer), true, endScreen.image[1])
endScreen.label[2] = guiCreateLabel(0.02, 0.14, 1, 0.09, "", true, endScreen.image[1])
guiLabelSetVerticalAlign(endScreen.label[2], "center")
endScreen.label[3] = guiCreateLabel(0.05, 0.39, 0.20, 0.04, "RANK:", true, endScreen.image[1])
guiLabelSetHorizontalAlign(endScreen.label[3], "center", false)
endScreen.label[4] = guiCreateLabel(0.05, 0.47, 0.20, 0.04, "KILLS:", true, endScreen.image[1])
guiLabelSetHorizontalAlign(endScreen.label[4], "center", false)
endScreen.label[5] = guiCreateLabel(0.25, 0.39, 0.20, 0.04, "# ", true, endScreen.image[1])
endScreen.label[6] = guiCreateLabel(0.25, 0.47, 0.20, 0.04, "N/A", true, endScreen.image[1])
endScreen.label[7] = guiCreateLabel(0.73, 0.87, 0.20, 0.06, "Back to Home Screen", true, endScreen.image[1])
guiLabelSetHorizontalAlign(endScreen.label[7], "center", true)
guiLabelSetVerticalAlign(endScreen.label[7], "center")
guiLabelSetColor(endScreen.label[2],255,255,0)
guiSetFont(endScreen.label[1],endScreen.font[4])
guiSetFont(endScreen.label[2],endScreen.font[3])
guiSetFont(endScreen.label[7],endScreen.font[1])
for i=3,6 do
	guiSetFont(endScreen.label[i],endScreen.font[2])
end
guiSetVisible(endScreen.image[1],false)
guiSetVisible(endScreen.image[2],false)

function showEndScreen(rank)
	if rank ~= 1 then
		text = "BETTER LUCK NEXT TIME!"
		guiSetText(endScreen.label[2],text)
	else
		text = "A WINNER IS YOU!"
		guiSetText(endScreen.label[2],text)
	end
	guiSetText(endScreen.label[5],"#"..tostring(rank))
	guiSetVisible(endScreen.image[1],true)
	guiSetVisible(endScreen.image[2],true)
	guiBringToFront(endScreen.label[7])
	showCursor(true)
	playerAmount = 0
	gameStatus = false
	countDown = 120
	inventoryIsShowing = false
	for i=1,3 do
		if zoneIndicators.image[i] then
			guiSetVisible(zoneIndicators.image[i],false)
		end
	end
end
addEvent("mtabg_showEndscreen",true)
addEventHandler("mtabg_showEndscreen",root,showEndScreen)

function onMouseOverBackToHomeScreenLabelSelect()
	guiSetProperty(endScreen.image[2], "ImageColours", "tl:B93C3C3C tr:B93C3C3C bl:B93C3C3C br:B93C3C3C")
end
addEventHandler("onClientMouseEnter",endScreen.label[7],onMouseOverBackToHomeScreenLabelSelect,false)

function onMouseOverBackToHomeScreenLabelDeselect()
	guiSetProperty(endScreen.image[2], "ImageColours", "tl:FFFFFFFF tr:FFFFFFFF bl:FFFFFFFF br:FFFFFFFF")
end
addEventHandler("onClientMouseLeave",endScreen.label[7],onMouseOverBackToHomeScreenLabelDeselect,false)


function sendPlayerBackToHomeScreenOnDeath()
	guiSetVisible(endScreen.image[1],false)
	guiSetVisible(endScreen.image[2],false)
	sendToHomeScreen()
	setElementData(localPlayer,"participatingInGame",false)
	guiPlayerHealth = 100
	guiSetText(zoneIndicators.label[1],"")
	guiSetVisible(zoneIndicators.label[1],false)
end
addEventHandler("onClientGUIClick",endScreen.label[7],sendPlayerBackToHomeScreenOnDeath,false)

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

local mapValues = mapValues
local getDistanceBetweenPoints2D = getDistanceBetweenPoints2D
local localPlayer = localPlayer
local math = math
local function calculateLittleDudeDistance()
	local px, py = localPlayer.position.x, localPlayer.position.y --player coordinates
	local sx,sy
	if isElement(safeAreaCol) then
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
