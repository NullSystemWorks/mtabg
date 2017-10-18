local outerBlip = false
local innerBlip = false
local innerZoneX, innerZoneY = 0, 0
local innerZoneRadius = 0
local zoneTimer

local screenW, screenH = guiGetScreenSize()
local r,g,b = 218,218,218
local alpha = 150
local playerAmount = 0
local playersInLobby = 0
local countDown = 120 -- 180

local maxDistance = 100 --max distance represented by littleDude
local littleDudeDistance = maxDistance --relative distance from littleDude to safe area
local distanceToSafeArea --distance from player to safe area
local guiPlayerHealth = 100

fuelLabel = guiCreateLabel(0.02, 0.48, 0.19, 0.04, str("vehicleFuel", 0), true)
guiSetVisible(fuelLabel,false)
local fuelAmount = 0
local isPlayerInsideVehicle = false

function createZone(innerX, innerY, outerX, outerY, innerRadius, outerRadius, timer)
	if outerBlip then
		exports.customblips:destroyCustomBlip(outerBlip)
		exports.customblips:destroyCustomBlip(innerBlip)
	end
	if not innerX then
		outerBlip = false
		innerBlip = false
		return
	end
	local radiusDivide = 1
	local screenX, screenY = guiGetScreenSize()
	if screenX == 800 then
		radiusDivide = 4.2
	elseif screenX == 1024 then
		radiusDivide = 3.28
	elseif screenX == 1366 then
		radiusDivide = 3.2
	elseif screenX == 1920 then
		radiusDivide = 2.34
	end
	outerBlip = exports.customblips:createCustomBlip(outerX, outerY,innerRadius/radiusDivide,innerRadius/radiusDivide,"gui/img/radius.png",innerRadius)
	innerBlip = exports.customblips:createCustomBlip(innerX, innerY,outerRadius/radiusDivide,outerRadius/radiusDivide,"gui/img/radius2.png",outerRadius)
	exports.customblips:setCustomBlipRadarScale(outerBlip,1)
	exports.customblips:setCustomBlipStreamRadius(outerBlip,0)
	exports.customblips:setCustomBlipRadarScale(innerBlip,1)
	exports.customblips:setCustomBlipStreamRadius(innerBlip,0)
	innerZoneX = innerX
	innerZoneY = innerY
	innerZoneRadius = innerRadius
	maxDistance = outerRadius - innerRadius
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
addEvent("onCreateDangerZone",true)
addEventHandler("onCreateDangerZone",root,createZone)

function formatMilliseconds(milliseconds)
	if milliseconds then
		local totalseconds = math.floor( milliseconds / 1000 )
		local seconds = totalseconds % 60
		local minutes = math.floor( totalseconds / 60 )
		minutes = minutes % 60
		return string.format( "%02d:%02d", minutes, seconds)
	end
end


local lobbyLabel = {}
local helpText = {
	str("lobbyHelpText1"),
	str("lobbyHelpText2"),
	str("lobbyHelpText3"),
	str("lobbyHelpText4"),
	str("lobbyHelpText5"),
	str("lobbyHelpText6")
}

local countdown = ""
lobbyLabel[1] = guiCreateLabel(0.02, 0.31, 0.32, 0.05, "", true)
lobbyLabel[2] = guiCreateLabel(0.02, 0.36, 0.32, 0.05, "", true)
lobbyLabel[3] = guiCreateLabel(0.26, 0.70, 0.48, 0.13, "", true)
lobbyLabel[4] = guiCreateLabel(0.02, 0.46, 0.32, 0.29, "", true)
lobbyLabel["font_big"] = guiCreateFont("/font/tahomab.ttf",20)
lobbyLabel["font_small"] = guiCreateFont("/font/tahomab.ttf",12)
guiLabelSetHorizontalAlign(lobbyLabel[3], "center", true)
guiLabelSetVerticalAlign(lobbyLabel[3], "center")
guiLabelSetHorizontalAlign(lobbyLabel[4], "left", true)
guiSetVisible(lobbyLabel[1],false)
guiSetVisible(lobbyLabel[2],false)
guiSetVisible(lobbyLabel[3],false)
guiSetVisible(lobbyLabel[4],false)
guiSetFont(lobbyLabel[1],lobbyLabel["font_big"])
guiSetFont(lobbyLabel[2],lobbyLabel["font_big"])
guiSetFont(lobbyLabel[3],lobbyLabel["font_big"])
guiSetFont(lobbyLabel[4],lobbyLabel["font_small"])


function displayHealthGUI()
	if guiGetVisible(homeScreen.staticimage[1]) then return end
	if localPlayer:getInLobby() then
		guiSetVisible(lobbyLabel[1],true)
		guiSetVisible(lobbyLabel[2],true)
		guiSetVisible(lobbyLabel[3],true)
		guiSetVisible(lobbyLabel[4],true)
		guiSetText(lobbyLabel[1], str("lobbyCountdownTimer", tostring(countdown)))
		guiSetText(lobbyLabel[2], str("lobbyPlayerCount", tostring(playersInLobby)))
	else
		guiSetVisible(lobbyLabel[1],false)
		guiSetVisible(lobbyLabel[2],false)
		guiSetVisible(lobbyLabel[3],false)
		guiSetVisible(lobbyLabel[4],false)
	end
	if localPlayer:getInMatch() then
		if not isInventoryShowing() then
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
			if playerAmount > 0 then
				dxDrawText(str("matchAliveCount"), (screenW * 0.8488) - 1, (screenH * 0.0483) - 1, (screenW * 0.9375) - 1, (screenH * 0.1050) - 1, tocolor(0, 0, 0, 255), 2.00, "default", "left", "top", false, false, false, false, false)
				dxDrawText(str("matchAliveCount"), (screenW * 0.8488) + 1, (screenH * 0.0483) - 1, (screenW * 0.9375) + 1, (screenH * 0.1050) - 1, tocolor(0, 0, 0, 255), 2.00, "default", "left", "top", false, false, false, false, false)
				dxDrawText(str("matchAliveCount"), (screenW * 0.8488) - 1, (screenH * 0.0483) + 1, (screenW * 0.9375) - 1, (screenH * 0.1050) + 1, tocolor(0, 0, 0, 255), 2.00, "default", "left", "top", false, false, false, false, false)
				dxDrawText(str("matchAliveCount"), (screenW * 0.8488) + 1, (screenH * 0.0483) + 1, (screenW * 0.9375) + 1, (screenH * 0.1050) + 1, tocolor(0, 0, 0, 255), 2.00, "default", "left", "top", false, false, false, false, false)
				dxDrawText(str("matchAliveCount"), screenW * 0.8488, screenH * 0.0483, screenW * 0.9375, screenH * 0.1050, tocolor(255, 255, 255, 255), 2.00, "default", "left", "top", false, false, false, false, false)
				dxDrawText(playerAmount, (screenW * 0.9437) - 1, (screenH * 0.0483) - 1, (screenW * 1.0325) - 1, (screenH * 0.1050) - 1, tocolor(0, 0, 0, 255), 2.00, "default", "left", "top", false, false, false, false, false)
				dxDrawText(playerAmount, (screenW * 0.9437) + 1, (screenH * 0.0483) - 1, (screenW * 1.0325) + 1, (screenH * 0.1050) - 1, tocolor(0, 0, 0, 255), 2.00, "default", "left", "top", false, false, false, false, false)
				dxDrawText(playerAmount, (screenW * 0.9437) - 1, (screenH * 0.0483) + 1, (screenW * 1.0325) - 1, (screenH * 0.1050) + 1, tocolor(0, 0, 0, 255), 2.00, "default", "left", "top", false, false, false, false, false)
				dxDrawText(playerAmount, (screenW * 0.9437) + 1, (screenH * 0.0483) + 1, (screenW * 1.0325) + 1, (screenH * 0.1050) + 1, tocolor(0, 0, 0, 255), 2.00, "default", "left", "top", false, false, false, false, false)
				dxDrawText(playerAmount, screenW * 0.9437, screenH * 0.0483, screenW * 1.0325, screenH * 0.1050, tocolor(255, 255, 255, 255), 2.00, "default", "left", "top", false, false, false, false, false)
			end
			if isPlayerInsideVehicle then
				if not inventoryIsShowing then
					if not guiGetVisible(fuelLabel) then
						guiSetVisible(fuelLabel,true)
						guiSetText(fuelLabel,str("vehicleFuel", tostring(fuelAmount)))
					end
					guiSetText(fuelLabel, str("vehicleFuel", tostring(fuelAmount)))
					dxDrawLine((screenW * 0.0220) - 1, (screenH * 0.5078) - 1, (screenW * 0.0220) - 1, screenH * 0.5326, tocolor(0, 0, 0, 255), 1, true)
					dxDrawLine(screenW * 0.2101, (screenH * 0.5078) - 1, (screenW * 0.0220) - 1, (screenH * 0.5078) - 1, tocolor(0, 0, 0, 255), 1, true)
					dxDrawLine((screenW * 0.0220) - 1, screenH * 0.5326, screenW * 0.2101, screenH * 0.5326, tocolor(0, 0, 0, 255), 1, true)
					dxDrawLine(screenW * 0.2101, screenH * 0.5326, screenW * 0.2101, (screenH * 0.5078) - 1, tocolor(0, 0, 0, 255), 1, true)
					dxDrawRectangle(screenW * 0.0220, screenH * 0.5078, screenW * (0.1881/(100/fuelAmount)), screenH * 0.0247, tocolor(255, 255, 255, 255), true)
				end
			end
		else
			local armorValue = getPedArmor(localPlayer)
			if armorValue <= 0 then
				guiSetVisible(inventoryGUI.staticimage[10],false)
				guiSetVisible(inventoryGUI.progressbar[2],false)
			else
				guiProgressBarSetProgress(inventoryGUI.progressbar[2],armorValue)
			end
		end
	end
end
addEventHandler("onClientRender",root,displayHealthGUI)

local currentHelpTextIndex
local function updateHelpText()
	if currentHelpTextIndex then
		guiSetText(lobbyLabel[4],helpText[currentHelpTextIndex])
	end
end

function setRandomHelpText()
	if localPlayer:getInLobby() then
		currentHelpTextIndex = math.random(#helpText)
		updateHelpText()
	end
end
setTimer(setRandomHelpText,10000,0)


local function updateVehicleGui(fuel)
	if not fuel then
		isPlayerInsideVehicle = false
		fuelAmount = 0
		guiSetVisible(fuelLabel,false)
		return
	end
	isPlayerInsideVehicle = true
	fuelAmount = fuel
end
addEvent("onUpdateVehicleGui", true)
addEventHandler("onUpdateVehicleGui", root, updateVehicleGui)

local function setHealthGui(value)
	guiPlayerHealth = value
	r, g, b = 255, 170, 170
	alpha = 255
	setTimer(function()
		r, g, b = 218, 218, 218
	end,2000,1)
end
addEvent("onSendPlayerHealth",true)
addEventHandler("onSendPlayerHealth", localPlayer, setHealthGui)

local function updatePlayersInLobbyCount(_lobbyCount)
	playersInLobby = _lobbyCount
end
addEvent("onSendLobbyCount", true)
addEventHandler("onSendLobbyCount", localPlayer, updatePlayersInLobbyCount)

local function updateLobbyCountdown(number)
	countdown = number
end
addEvent("onUpdateLobbyCountdown", true)
addEventHandler("onUpdateLobbyCountdown", localPlayer, updateLobbyCountdown)

local lobbyLabelNumber
local lobbyLabelNumberTimer
local function clearLobbyLabelNumber()
	if isTimer(lobbyLabelNumberTimer) then
		lobbyLabelNumberTimer:destroy()
	end
	lobbyLabelNumberTimer = Timer(
	function()
		guiSetText(lobbyLabel[3], "")
		lobbyLabelNumberTimer = nil
		lobbyLabelNumber = nil
	end, 3000, 1)
end

function showMatchStartNotification(number)
	number = number or lobbyLabelNumber
	lobbyLabelNumber = number
	if number == "insufficientPlayers" then
		guiSetText(lobbyLabel[3], str("lobbyinsufficientPlayersError"))
	elseif number == "matchRunning" then
		guiSetText(lobbyLabel[3], str("lobbyMatchAlreadyRunningError"))
	elseif number ~= nil then
		guiSetText(lobbyLabel[3], str("lobbyStartMatchCountdown", tostring(number)))
		clearLobbyLabelNumber()
	end
end
addEvent("onSendCountdownMessage",true)
addEventHandler("onSendCountdownMessage",root,showMatchStartNotification)

function onClientBattleGroundsSetAliveCount(amount)
	playerAmount = amount
end
addEvent("onSendClientAliveCount",true)
addEventHandler("onSendClientAliveCount",root,onClientBattleGroundsSetAliveCount)

endScreen = {
	label = {},
	button = {},
	image = {},
	font = {}
}

local rank = ""

endScreen.font[1] = guiCreateFont("/font/etelka.ttf",11)
endScreen.font[2] = guiCreateFont("/font/etelka.ttf",15)
endScreen.font[3] = guiCreateFont("/font/etelka.ttf",20)
endScreen.font[4] = guiCreateFont("/font/etelka.ttf",25)

endScreen.image[1] = guiCreateStaticImage(0.00, 0.00, 1.00, 1.17, "/gui/img/solo_slot.png", true)
endScreen.image[2] = guiCreateStaticImage(0.73, 0.87, 0.20, 0.06,"/gui/img/solo_slot.png", true)
guiSetProperty(endScreen.image[1], "ImageColours", "tl:EB000000 tr:EB000000 bl:EB000000 br:EB000000")
endScreen.label[1] = guiCreateLabel(0.02, 0.06, 0.38, 0.08, getPlayerName(localPlayer), true, endScreen.image[1])
endScreen.label[2] = guiCreateLabel(0.02, 0.14, 1, 0.09, "", true, endScreen.image[1])
guiLabelSetVerticalAlign(endScreen.label[2], "center")
endScreen.label[3] = guiCreateLabel(0.05, 0.39, 0.20, 0.04, str("endScreenRank"), true, endScreen.image[1])
guiLabelSetHorizontalAlign(endScreen.label[3], "center", false)
endScreen.label[4] = guiCreateLabel(0.05, 0.47, 0.20, 0.04, str("endScreenKills"), true, endScreen.image[1])
guiLabelSetHorizontalAlign(endScreen.label[4], "center", false)
endScreen.label[5] = guiCreateLabel(0.25, 0.39, 0.20, 0.04, "# ", true, endScreen.image[1])
endScreen.label[6] = guiCreateLabel(0.25, 0.47, 0.20, 0.04, "N/A", true, endScreen.image[1])
endScreen.label[7] = guiCreateLabel(0.73, 0.87, 0.20, 0.06, str("endScreenBackToHomeButton"), true, endScreen.image[1])
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

local endScreenRank = 0
local function updateEndScreenText()
	if endScreenRank <= 1 then
		guiSetText(endScreen.label[2], str("endScreenYouWon"))
	else
		guiSetText(endScreen.label[2], str("endScreenYouLost"))
	end
	guiSetText(endScreen.label[5],"#"..tostring(endScreenRank))
end

function showEndScreen(rank)
	endScreenRank = rank
	updateEndScreenText()
	guiSetVisible(endScreen.image[1],true)
	guiSetVisible(endScreen.image[2],true)
	guiBringToFront(endScreen.label[7])
	showCursor(true)
	playerAmount = 0
	countDown = 120
	inventoryIsShowing = false
	for i=1,3 do
		if zoneIndicators.image[i] then
			guiSetVisible(zoneIndicators.image[i],false)
		end
	end
end
addEvent("onShowEndScreen", true)
addEventHandler("onShowEndScreen", root, showEndScreen)

local function showDeathMessage(aliveCount, killedName, killerName)
	if killerName then
		Notification.send(str("matchPlayerKilled", killedName, killerName, aliveCount))
	else
		Notification.send(str("matchPlayerDied", killedName, aliveCount))
	end
end
addEvent("onShowDeathMessage", true)
addEventHandler("onShowDeathMessage", localPlayer, showDeathMessage)

function onMouseOverBackToHomeScreenLabelSelect()
	guiSetProperty(endScreen.image[2], "ImageColours", "tl:B93C3C3C tr:B93C3C3C bl:B93C3C3C br:B93C3C3C")
end
addEventHandler("onClientMouseEnter",endScreen.label[7],onMouseOverBackToHomeScreenLabelSelect,false)

function onMouseOverBackToHomeScreenLabelDeselect()
	guiSetProperty(endScreen.image[2], "ImageColours", "tl:FFFFFFFF tr:FFFFFFFF bl:FFFFFFFF br:FFFFFFFF")
end
addEventHandler("onClientMouseLeave",endScreen.label[7],onMouseOverBackToHomeScreenLabelDeselect,false)

function sendPlayerBackToHomeScreenOnDeath()
	guiSetVisible(homeScreen.staticimage[1],true)
	LanguageSelection.setShowing(true)
	guiSetVisible(endScreen.image[1],false)
	guiSetVisible(endScreen.image[2],false)
	sendToHomeScreen()
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

zoneIndicators = {
	label = {},
	image = {},
}

zoneIndicators.label[1] = guiCreateLabel(0.02, 0.73, 0.24, 0.03, "", true)
zoneIndicators.image[1] = guiCreateStaticImage (0.02, 0.71, 0.01, 0.02, "/gui/img/solo_slot.png", true) --starting position
guiSetProperty(zoneIndicators.image[1], "ImageColours", "tl:FEFB0000 tr:FEFB0000 bl:FEFB0000 br:FEFB0000")
zoneIndicators.image[2] = guiCreateStaticImage (0.25, 0.71, 0.01, 0.02, "/gui/img/solo_slot.png", true) --finishing position
guiSetProperty(zoneIndicators.image[2], "ImageColours", "tl:FE000CFA tr:FE000CFA bl:FE000CFA br:FE000CFA")
zoneIndicators.image[3] = guiCreateStaticImage (0.02, 0.69, 0.04, 0.04, "gui/img/running.png", true) --our littledude

for i=1,3 do
	guiSetVisible(zoneIndicators.image[i],false)
end

local mapValues = mapValues
local getDistanceBetweenPoints2D = getDistanceBetweenPoints2D
local localPlayer = localPlayer
local math = math
local function calculateLittleDudeDistance()
	local px, py = localPlayer.position.x, localPlayer.position.y --player coordinates
	distanceToSafeArea = (getDistanceBetweenPoints2D(px, py, innerZoneX, innerZoneY) - innerZoneRadius) > 0 and
	getDistanceBetweenPoints2D(px, py, innerZoneX, innerZoneY) - innerZoneRadius or 0 --show positive or 0
	if distanceToSafeArea > maxDistance then --if too far
		return 0.01 --stay at max
	else
		return mapValues(distanceToSafeArea, 0, maxDistance, 0.23, 0.01) --calculate relative distance
	end
end

local guiSetPosition = guiSetPosition
local dxDrawText = dxDrawText
local function moveLittleDude() --moves littleDude
	if localPlayer:getInMatch() then
		littleDudeDistance = calculateLittleDudeDistance()
		guiSetPosition(zoneIndicators.image[3], littleDudeDistance, 0.69, true) --set littleDudes position
	end
end
addEventHandler("onClientRender", root, moveLittleDude)

local function changeLanguage(newLang)
	helpText = {
		str("lobbyHelpText1"),
		str("lobbyHelpText2"),
		str("lobbyHelpText3"),
		str("lobbyHelpText4"),
		str("lobbyHelpText5"),
		str("lobbyHelpText6")
	}
	updateHelpText()
	fuelLabel:setText(str("vehicleFuel"))
	fuelLabel:setText(str("vehicleFuel", tostring(fuelAmount)))
	endScreen.label[3]:setText(str("endScreenRank"))
	endScreen.label[4]:setText(str("endScreenKills"))
	endScreen.label[7]:setText(str("endScreenBackToHomeButton"))
	showMatchStartNotification()
	updateEndScreenText()
end
addEventHandler("onUserLanguageChange", resourceRoot, changeLanguage)
