local outerBlip = false
local innerBlip = false
local innerZoneX, innerZoneY = 0, 0
local innerZoneRadius = 0
local timerZone

local screenW, screenH = guiGetScreenSize()
local r, g, b = 218, 218, 218
local alpha = 150
local playerAmount = 0
local playersInLobby = 0
local countDown = 120

local maxDistance = 100 --max distance represented by littleDude
local littleDudeDistance = maxDistance --distance from littleDude to safe area
local distanceToSafeArea --distance from player to safe area
local guiPlayerHealth = 100

local lblLittleDudeTimer = GuiLabel(0.02, 0.73, 0.24, 0.03, "", true)

local imgLittleDudeRedBox =
	GuiStaticImage(0.02, 0.71, 0.01, 0.02, "/gui/img/pixel.png", true)
imgLittleDudeRedBox:setProperty("ImageColours",
	"tl:FEFB0000 tr:FEFB0000 bl:FEFB0000 br:FEFB0000")
local imgLittleDudeBlueBox =
	GuiStaticImage(0.25, 0.71, 0.01, 0.02, "/gui/img/pixel.png", true)
imgLittleDudeBlueBox:setProperty("ImageColours",
	"tl:FE000CFA tr:FE000CFA bl:FE000CFA br:FE000CFA")
local imgLittleDude =
	GuiStaticImage(0.02, 0.69, 0.04, 0.04, "gui/img/running.png", true)

imgLittleDudeRedBox:setVisible(false)
imgLittleDudeBlueBox:setVisible(false)
imgLittleDude:setVisible(false)

local lblFuel = GuiLabel(0.02, 0.48, 0.19, 0.04, str("vehicleFuel", 0), true)
lblFuel:setVisible(false)
local fuelAmount = 0
local isPlayerInsideVehicle = false

local function formatMilliseconds(milliseconds)
	if milliseconds then
		local totalseconds = math.floor(milliseconds / 1000)
		local seconds = totalseconds % 60
		local minutes = math.floor(totalseconds / 60)
		minutes = minutes % 60
		return string.format("%02d:%02d", minutes, seconds)
	end
end

local function setRadiusTimerToClient(timer)
	if isTimer(timer) then
		local timeDetails = timer:getDetails()
		local time = formatMilliseconds(timeDetails)
		lblLittleDudeTimer:setText(tostring(time))
	end
end

local function createZone(innerX, innerY,
                          outerX, outerY, innerRadius, outerRadius, timer)
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
	outerBlip = exports.customblips:createCustomBlip(outerX, outerY,
		innerRadius/radiusDivide, innerRadius/radiusDivide,
		"gui/img/radius.png", innerRadius)
	innerBlip = exports.customblips:createCustomBlip(innerX, innerY,
		outerRadius/radiusDivide, outerRadius/radiusDivide,
		"gui/img/radius2.png", outerRadius)
	exports.customblips:setCustomBlipRadarScale(outerBlip, 1)
	exports.customblips:setCustomBlipStreamRadius(outerBlip, 0)
	exports.customblips:setCustomBlipRadarScale(innerBlip, 1)
	exports.customblips:setCustomBlipStreamRadius(innerBlip, 0)
	innerZoneX = innerX
	innerZoneY = innerY
	innerZoneRadius = innerRadius
	maxDistance = outerRadius - innerRadius
	if isTimer(timerZone) then
		timerZone:destroy()
	end
	timerZone = Timer(function() end, timer, 0)
	local timerRadius = Timer(setRadiusTimerToClient, 1000, 0, timerZone)
	if not imgLittleDudeRedBox:getVisible() then
		imgLittleDudeRedBox:setVisible(true)
	end
	if not guiGetVisible(imgLittleDudeBlueBox) then
		imgLittleDudeBlueBox:setVisible(true)
	end
	if not guiGetVisible(imgLittleDude) then
		imgLittleDude:setVisible(true)
	end
	lblLittleDudeTimer:setVisible(true)
end
addEvent("onCreateDangerZone", true)
addEventHandler("onCreateDangerZone", root, createZone)

local helpText = {
	str("lobbyHelpText1"),
	str("lobbyHelpText2"),
	str("lobbyHelpText3"),
	str("lobbyHelpText4"),
	str("lobbyHelpText5"),
	str("lobbyHelpText6")
}

local countdown = ""
local lblLobbyCountdown = GuiLabel(0.02, 0.31, 0.32, 0.05, "", true)
local lblLobbyPlayerCount = GuiLabel(0.02, 0.36, 0.32, 0.05, "", true)
local lblLobbyNotification = GuiLabel(0.26, 0.70, 0.48, 0.13, "", true)
local lblLobbyHelp = GuiLabel(0.02, 0.46, 0.32, 0.29, "", true)
local fontLobbyBig = GuiFont("/font/tahomab.ttf", 20)
local fontLobbySmall = GuiFont("/font/tahomab.ttf", 12)
lblLobbyNotification:setHorizontalAlign("center", true)
lblLobbyNotification:setVerticalAlign("center")
lblLobbyHelp:setHorizontalAlign("left", true)
lblLobbyCountdown:setVisible(false)
lblLobbyPlayerCount:setVisible(false)
lblLobbyNotification:setVisible(false)
lblLobbyHelp:setVisible(false)
lblLobbyCountdown:setFont(fontLobbyBig)
lblLobbyPlayerCount:setFont(fontLobbyBig)
lblLobbyNotification:setFont(fontLobbyBig)
lblLobbyHelp:setFont(fontLobbySmall)


local function displayHealthGUI()
	if HomeScreen.getVisible() then
		return
	end
	if localPlayer:getInLobby() then
		lblLobbyCountdown:setVisible(true)
		lblLobbyPlayerCount:setVisible(true)
		lblLobbyNotification:setVisible(true)
		lblLobbyHelp:setVisible(true)
		lblLobbyCountdown:setText(str("lobbyCountdownTimer",
		                              tostring(countdown)))
		lblLobbyPlayerCount:setText(str("lobbyPlayerCount",
		                                tostring(playersInLobby)))
	else
		lblLobbyCountdown:setVisible(false)
		lblLobbyPlayerCount:setVisible(false)
		lblLobbyNotification:setVisible(false)
		lblLobbyHelp:setVisible(false)
	end
	if localPlayer:getInMatch() then
		if not Inventory.getVisible() then
			if alpha > 150 then
				alpha = math.max(170, alpha-1)
			end
			dxDrawLine((screenW * 0.2612) - 1, (screenH * 0.9017) - 1,
			           (screenW * 0.2612) - 1, screenH * 0.9450,
			           tocolor(0, 0, 0, 150), 1, true)
			dxDrawLine(screenW * 0.7688, (screenH * 0.9017) - 1,
			           (screenW * 0.2612) - 1, (screenH * 0.9017) - 1,
			           tocolor(0, 0, 0, 150), 1, true)
			dxDrawLine((screenW * 0.2612) - 1, screenH * 0.9450,
			           screenW * 0.7688, screenH * 0.9450,
			           tocolor(0, 0, 0, 150), 1, true)
			dxDrawLine(screenW * 0.7688, screenH * 0.9450,
			           screenW * 0.7688, (screenH * 0.9017) - 1,
			           tocolor(0, 0, 0, 150), 1, true)
			if guiPlayerHealth < 0 then
				guiPlayerHealth = 0 --FIXME: possible division by zero
			end
			dxDrawRectangle(screenW * 0.2612, screenH * 0.9017,
			                screenW * (0.5075/(100/guiPlayerHealth)),
			                screenH * 0.0433, tocolor(r, g, b,  alpha), true)
			if playerAmount > 0 then
				dxDrawText(str("matchAliveCount"), (screenW * 0.8488) - 1,
				           (screenH * 0.0483) - 1, (screenW * 0.9375) - 1,
				           (screenH * 0.1050) - 1, tocolor(0, 0, 0, 255),
				           2.00, "default", "left", "top",
				           false, false, false, false, false)
				dxDrawText(str("matchAliveCount"), (screenW * 0.8488) + 1,
				           (screenH * 0.0483) - 1, (screenW * 0.9375) + 1,
				           (screenH * 0.1050) - 1, tocolor(0, 0, 0, 255),
				           2.00, "default", "left", "top",
				           false, false, false, false, false)
				dxDrawText(str("matchAliveCount"), (screenW * 0.8488) - 1,
				           (screenH * 0.0483) + 1, (screenW * 0.9375) - 1,
				           (screenH * 0.1050) + 1, tocolor(0, 0, 0, 255),
				           2.00, "default", "left", "top",
				           false, false, false, false, false)
				dxDrawText(str("matchAliveCount"), (screenW * 0.8488) + 1,
				           (screenH * 0.0483) + 1, (screenW * 0.9375) + 1,
				           (screenH * 0.1050) + 1, tocolor(0, 0, 0, 255),
				           2.00, "default", "left", "top",
				           false, false, false, false, false)
				dxDrawText(str("matchAliveCount"), screenW * 0.8488,
				           screenH * 0.0483, screenW * 0.9375,
				           screenH * 0.1050, tocolor(255, 255, 255, 255),
				           2.00, "default", "left", "top",
				           false, false, false, false, false)
				dxDrawText(playerAmount, (screenW * 0.9437) - 1,
				           (screenH * 0.0483) - 1, (screenW * 1.0325) - 1,
				           (screenH * 0.1050) - 1, tocolor(0, 0, 0, 255),
				           2.00, "default", "left", "top",
				           false, false, false, false, false)
				dxDrawText(playerAmount, (screenW * 0.9437) + 1,
				           (screenH * 0.0483) - 1, (screenW * 1.0325) + 1,
				           (screenH * 0.1050) - 1, tocolor(0, 0, 0, 255),
				           2.00, "default", "left", "top",
				           false, false, false, false, false)
				dxDrawText(playerAmount, (screenW * 0.9437) - 1,
				           (screenH * 0.0483) + 1, (screenW * 1.0325) - 1,
				           (screenH * 0.1050) + 1, tocolor(0, 0, 0, 255),
				           2.00, "default", "left", "top",
				           false, false, false, false, false)
				dxDrawText(playerAmount, (screenW * 0.9437) + 1,
				           (screenH * 0.0483) + 1, (screenW * 1.0325) + 1,
				           (screenH * 0.1050) + 1, tocolor(0, 0, 0, 255),
				           2.00, "default", "left", "top",
				           false, false, false, false, false)
				dxDrawText(playerAmount, screenW * 0.9437,
				           screenH * 0.0483, screenW * 1.0325,
				           screenH * 0.1050, tocolor(255, 255, 255, 255),
				           2.00, "default", "left", "top",
				           false, false, false, false, false)
			end
			if isPlayerInsideVehicle then
				if not Inventory.getVisible() then
					if not guiGetVisible(lblFuel) then
						lblFuel:setVisible(true)
						lblFuel:setText(str("vehicleFuel",
						                    tostring(fuelAmount)))
					end
					lblFuel:setText(str("vehicleFuel", tostring(fuelAmount)))
					dxDrawLine((screenW * 0.0220) - 1, (screenH * 0.5078) - 1,
					           (screenW * 0.0220) - 1, screenH * 0.5326,
					           tocolor(0, 0, 0, 255), 1, true)
					dxDrawLine(screenW * 0.2101, (screenH * 0.5078) - 1,
					           (screenW * 0.0220) - 1, (screenH * 0.5078) - 1,
					           tocolor(0, 0, 0, 255), 1, true)
					dxDrawLine((screenW * 0.0220) - 1, screenH * 0.5326,
					           screenW * 0.2101, screenH * 0.5326,
					           tocolor(0, 0, 0, 255), 1, true)
					dxDrawLine(screenW * 0.2101, screenH * 0.5326,
					           screenW * 0.2101, (screenH * 0.5078) - 1,
					           tocolor(0, 0, 0, 255), 1, true)
					dxDrawRectangle(screenW * 0.0220, screenH * 0.5078,
					                screenW * (0.1881/(100/fuelAmount)),
					                screenH * 0.0247,
					                tocolor(255, 255, 255, 255), true)
				end
			end
		else
			--TODO: armor GUI should probably be handled elsewhere
			-- local armorValue = getPedArmor(localPlayer)
			-- if armorValue <= 0 then
				--show armor picture
				--show armor progress bar
			-- else
				--set armor progress bar to armorValue
			-- end
		end
	end
end
addEventHandler("onClientRender", root, displayHealthGUI)

local currentHelpTextIndex
local function updateHelpText()
	if currentHelpTextIndex then
		lblLobbyHelp:setText(helpText[currentHelpTextIndex])
	end
end

local function setRandomHelpText()
	if localPlayer:getInLobby() then
		currentHelpTextIndex = math.random(#helpText)
		updateHelpText()
	end
end
Timer(setRandomHelpText, 10000, 0)


local function updateVehicleGui(fuel)
	if not fuel then
		isPlayerInsideVehicle = false
		fuelAmount = 0
		lblFuel:setVisible(false)
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
	Timer(function()
		r, g, b = 218, 218, 218
	end, 2000, 1)
end
addEvent("onSendPlayerHealth", true)
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

local lastNotificationNumber
local timerLobbyNotification
local function clearLobbyLabelNumber()
	if isTimer(timerLobbyNotification) then
		timerLobbyNotification:destroy()
	end
	timerLobbyNotification = Timer(
		function()
			lblLobbyNotification:setText("")
			timerLobbyNotification = nil
			lastNotificationNumber = nil
		end, 3000, 1)
end

local function showMatchStartNotification(number)
	number = number or lastNotificationNumber
	lastNotificationNumber = number
	if number == "insufficientPlayers" then
		lblLobbyNotification:setText(str("lobbyinsufficientPlayersError"))
	elseif number == "matchRunning" then
		lblLobbyNotification:setText(str("lobbyMatchAlreadyRunningError"))
	elseif number ~= nil then
		lblLobbyNotification:setText(str("lobbyStartMatchCountdown",
		                                 tostring(number)))
		clearLobbyLabelNumber()
	end
end
addEvent("onSendCountdownMessage", true)
addEventHandler("onSendCountdownMessage", root, showMatchStartNotification)

local function setAliveCount(amount)
	playerAmount = amount
end
addEvent("onSendClientAliveCount", true)
addEventHandler("onSendClientAliveCount", root, setAliveCount)

local rank = ""

local fontEndScreenButtonHome = GuiFont("/font/etelka.ttf", 11)
local fontEndScreenDefault = GuiFont("/font/etelka.ttf", 15)
local fontEndScreenWinnerLoser = GuiFont("/font/etelka.ttf", 20)
local fontEndScreenPlayerName = GuiFont("/font/etelka.ttf", 25)

local imgEndScreenBackground =
	GuiStaticImage(0.00, 0.00, 1.00, 1.17, "/gui/img/pixel.png", true)
imgEndScreenBackground:setProperty("ImageColours",
               "tl:EB000000 tr:EB000000 bl:EB000000 br:EB000000")
local imgEndScreenButtonHome =
	GuiStaticImage(0.73, 0.87, 0.20, 0.06,"/gui/img/pixel.png", true)
local lblEndScreenPlayerName = GuiLabel(0.02, 0.06, 0.38, 0.08,
	localPlayer.name, true, imgEndScreenBackground)
local lblEndScreenWinnerLoser =
	GuiLabel(0.02, 0.14, 1, 0.09, "", true, imgEndScreenBackground)
lblEndScreenWinnerLoser:setVerticalAlign("center")
local lblEndScreenRank = GuiLabel(0.05, 0.39, 0.20, 0.04,
	str("endScreenRank"), true, imgEndScreenBackground)
lblEndScreenRank:setHorizontalAlign("center", false)
local lblEndScreenKills = GuiLabel(0.05, 0.47, 0.20, 0.04,
	str("endScreenKills"), true, imgEndScreenBackground)
lblEndScreenKills:setHorizontalAlign("center", false)
local lblEndScreenRankNumber =
	GuiLabel(0.25, 0.39, 0.20, 0.04, "# ", true, imgEndScreenBackground)
local lblEndScreenKillNumber =
	GuiLabel(0.25, 0.47, 0.20, 0.04, "N/A", true, imgEndScreenBackground)
local lblEndScreenButtonHome =
	GuiLabel(0.73, 0.87, 0.20, 0.06,
	         str("endScreenBackToHomeButton"), true, imgEndScreenBackground)
lblEndScreenButtonHome:setHorizontalAlign("center", true)
lblEndScreenButtonHome:setVerticalAlign("center")
guiLabelSetColor(lblEndScreenWinnerLoser, 255, 255, 0)
lblEndScreenPlayerName:setFont(fontEndScreenPlayerName)
lblEndScreenWinnerLoser:setFont(fontEndScreenWinnerLoser)
lblEndScreenButtonHome:setFont(fontEndScreenButtonHome)

lblEndScreenRank:setFont(fontEndScreenDefault)
lblEndScreenKills:setFont(fontEndScreenDefault)
lblEndScreenRankNumber:setFont(fontEndScreenDefault)
lblEndScreenKillNumber:setFont(fontEndScreenDefault)
imgEndScreenBackground:setVisible(false)
imgEndScreenButtonHome:setVisible(false)

local endScreenRank = 0
local function updateEndScreenText()
	if endScreenRank <= 1 then
		lblEndScreenWinnerLoser:setText(str("endScreenYouWon"))
	else
		lblEndScreenWinnerLoser:setText(str("endScreenYouLost"))
	end
	lblEndScreenRankNumber:setText("#"..tostring(endScreenRank))
end

local function showEndScreen(rank)
	endScreenRank = rank
	updateEndScreenText()
	imgEndScreenBackground:setVisible(true)
	imgEndScreenButtonHome:setVisible(true)
	lblEndScreenButtonHome:bringToFront()
	showCursor(true)
	playerAmount = 0
	countDown = 120
	Inventory.setVisible(false)
	if imgLittleDudeRedBox then
		imgLittleDudeRedBox:setVisible(false)
	end
	if imgLittleDudeBlueBox then
		imgLittleDudeBlueBox:setVisible(false)
	end
	if imgLittleDude then
		imgLittleDude:setVisible(false)
	end
end
addEvent("onShowEndScreen", true)
addEventHandler("onShowEndScreen", root, showEndScreen)

local function showDeathMessage(aliveCount, killedName, killerName)
	if killerName then
		Notification.send(
			str("matchPlayerKilled", killedName, killerName, aliveCount))
	else
		Notification.send(str("matchPlayerDied", killedName, aliveCount))
	end
end
addEvent("onShowDeathMessage", true)
addEventHandler("onShowDeathMessage", localPlayer, showDeathMessage)

local function onMouseOverBackToHomeScreenLabelSelect()
imgEndScreenButtonHome:setProperty("ImageColours",
	               "tl:B93C3C3C tr:B93C3C3C bl:B93C3C3C br:B93C3C3C")
end
addEventHandler("onClientMouseEnter", lblEndScreenButtonHome,
                onMouseOverBackToHomeScreenLabelSelect, false)

local function onMouseOverBackToHomeScreenLabelDeselect()
imgEndScreenButtonHome:setProperty("ImageColours",
	               "tl:FFFFFFFF tr:FFFFFFFF bl:FFFFFFFF br:FFFFFFFF")
end
addEventHandler("onClientMouseLeave", lblEndScreenButtonHome,
                onMouseOverBackToHomeScreenLabelDeselect, false)

local function sendPlayerBackToHomeScreenOnDeath()
	HomeScreen.setVisible(true)
	LanguageSelection.setShowing(true)
	imgEndScreenBackground:setVisible(false)
	imgEndScreenButtonHome:setVisible(false)
	HomeScreen.show()
	guiPlayerHealth = 100
	lblLittleDudeTimer:setText("")
	lblLittleDudeTimer:setVisible(false)
end
addEventHandler("onClientGUIClick", lblEndScreenButtonHome,
                sendPlayerBackToHomeScreenOnDeath, false)

local mapValues = mapValues
local getDistanceBetweenPoints2D = getDistanceBetweenPoints2D
local localPlayer = localPlayer
local math = math
local function calculateLittleDudeDistance()
	local px, py = localPlayer.position.x, localPlayer.position.y
	--show positive or 0
	distanceToSafeArea =
		(getDistanceBetweenPoints2D(px, py, innerZoneX, innerZoneY)
			- innerZoneRadius) > 0 and
		getDistanceBetweenPoints2D(px, py, innerZoneX, innerZoneY)
			- innerZoneRadius or 0
	if distanceToSafeArea > maxDistance then
		return 0.01 --stay at max
	else
		--calculate relative distance
		return mapValues(distanceToSafeArea, 0, maxDistance, 0.23, 0.01)
	end
end

local guiSetPosition = guiSetPosition
local dxDrawText = dxDrawText
local function moveLittleDude() --moves littleDude
	if localPlayer:getInMatch() then
		littleDudeDistance = calculateLittleDudeDistance()
		guiSetPosition(imgLittleDude, littleDudeDistance, 0.69, true)
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
	lblFuel:setText(str("vehicleFuel"))
	lblFuel:setText(str("vehicleFuel", tostring(fuelAmount)))
	lblEndScreenRank:setText(str("endScreenRank"))
	lblEndScreenKills:setText(str("endScreenKills"))
	lblEndScreenButtonHome:setText(str("endScreenBackToHomeButton"))
	showMatchStartNotification()
	updateEndScreenText()
end
addEventHandler("onUserLanguageChange", resourceRoot, changeLanguage)

local function dumpCamera()
	local x, y, z = getElementPosition(localPlayer)
	local r, v, w = getElementRotation(localPlayer)
	local a, b, c, d, e, f, g, h = getCameraMatrix(localPlayer)
	outputChatBox(tostring(x)..", "..tostring(y)..", "..tostring(z))
	outputChatBox(tostring(r)..", "..tostring(v)..", "..tostring(w))
	outputChatBox(tostring(a)..", "..tostring(b)..", "..tostring(c))
	outputChatBox(tostring(d)..", "..tostring(e)..", "..tostring(f))
	outputChatBox(tostring(g)..", "..tostring(h))
end
