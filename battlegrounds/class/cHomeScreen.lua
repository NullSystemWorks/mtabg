HomeScreen = {}

local Music = Music.mainMenu

local homescreenPed = Ped(0, 1724.22998, -1647.8363, 20.2283)
homescreenPed:setInterior(18)
homescreenPed:setRotation(0, 0, 80.0553)

local fontHeader = GuiFont("/font/etelka.ttf", 13)
local fontPlayButton = GuiFont("/font/etelka.ttf", 25)

local imgBackground =
	GuiStaticImage(0.00, 0.00, 1.00, 1.00, "gui/img/pixel.png", true)
imgBackground:setProperty("ImageColours",
	"tl:00000000 tr:000000 bl:000000 br:000000")

local imgStatsPanel = GuiStaticImage(0.00, 0.02, 1.00, 0.06,
	"gui/img/pixel.png", true, imgBackground)
imgStatsPanel:setProperty("ImageColours",
	"tl:66B7B7B7 tr:66B7B7B7 bl:66B7B7B7 br:66B7B7B7")

local lblHomeButton = GuiLabel(0.33, 0.29, 0.16, 0.45,
	str("mainMenuHomeButton"), true, imgStatsPanel)
lblHomeButton:setHorizontalAlign("center", false)
lblHomeButton:setVerticalAlign("center")
lblHomeButton:setFont(fontHeader)

local lblSkinButton = GuiLabel(0.49, 0.29, 0.16, 0.45,
	str("mainMenuCharacterButton"), true, imgStatsPanel)
lblSkinButton:setHorizontalAlign("center", false)
lblSkinButton:setVerticalAlign("center")
lblSkinButton:setFont(fontHeader)
lblSkinButton:setColor(197, 197, 197)

local lblSoonButton = GuiLabel(0.65, 0.29, 0.16, 0.45,
	str("mainMenuSoonButton"), true, imgStatsPanel)
lblSoonButton:setHorizontalAlign("center", false)
lblSoonButton:setVerticalAlign("center")
lblSoonButton:setFont(fontHeader)
lblSoonButton:setColor(197, 197, 197)

local lblStatsButton = GuiLabel(0.81, 0.29, 0.16, 0.45,
	str("mainMenuStatisticsButton"), true, imgStatsPanel)
lblStatsButton:setHorizontalAlign("center", false)
lblStatsButton:setVerticalAlign("center")
lblStatsButton:setFont(fontHeader)
lblStatsButton:setColor(197, 197, 197)

local lblPlayerName = GuiLabel(0.64, 0.11, 0.24, 0.05, str("mainMenuPlayerName",
	localPlayer.name):gsub("#%x%x%x%x%x%x", ""), true, imgBackground)
lblPlayerName:setVerticalAlign("center")
lblPlayerName:setFont(fontHeader)
lblPlayerName:setColor(0, 0, 0)

local imgCoin = GuiStaticImage(0.87, 0.11, 0.05, 0.05,
	"gui/img/battlepointsicon.png", true, imgBackground)

local lblCoinCount = GuiLabel(0.95, 0.11, 0.12, 0.05, "0", true, imgBackground)
lblCoinCount:setVerticalAlign("center")
lblCoinCount:setFont(fontHeader)
lblCoinCount:setColor(0, 0, 0)

local imgPlayButton = GuiStaticImage(0.00, 0.00, 0.30, 0.15,
	"gui/img/button.png", true, imgBackground)

local lblPlayButtonShadow = GuiLabel(0.05, 0.19, 0.58, 0.30,
	str("mainMenuPlayButtonShadow"), true, imgPlayButton)
lblPlayButtonShadow:setColor(0, 0, 0)
lblPlayButtonShadow:setHorizontalAlign("left", false)
lblPlayButtonShadow:setVerticalAlign("center")
lblPlayButtonShadow:setFont(fontPlayButton)

local lblPlayButton = GuiLabel(0.06, 0.20, 0.58, 0.30,
	str("mainMenuPlayButton"), true, imgPlayButton)
lblPlayButton:setColor(255, 255, 255)
lblPlayButton:setHorizontalAlign("left", false)
lblPlayButton:setVerticalAlign("center")
lblPlayButton:setFont(fontPlayButton)

local imgStatsBackground = GuiStaticImage(0.30, 0.27, 0.69, 0.66,
	"gui/img/pixel.png", true, imgBackground)
imgStatsBackground:setProperty("ImageColours",
	"tl:B2040404 tr:B2040404 bl:B2040404 br:B2040404")

local lblStatsGamesPlayed = GuiLabel(0.02, 0.22, 0.18, 0.07,
	str("statisticsMenuGamesPlayed"), true, imgStatsBackground)
lblStatsGamesPlayed:setVerticalAlign("center")

local lblStatsWins = GuiLabel(0.02, 0.29, 0.18, 0.07, str("statisticsMenuWins"),
	true, imgStatsBackground)
lblStatsWins:setVerticalAlign("center")

local lblStatsLosses = GuiLabel(0.02, 0.36, 0.18, 0.07,
	str("statisticsMenuLosses"), true, imgStatsBackground)
lblStatsLosses:setVerticalAlign("center")

local lblStatsWinLossRatio = GuiLabel(0.02, 0.43, 0.18, 0.07,
	str("statisticsMenuWinLossRatio"), true, imgStatsBackground)
lblStatsWinLossRatio:setVerticalAlign("center")

local lblStatsKills = GuiLabel(0.02, 0.50, 0.18, 0.07,
	str("statisticsMenuKills"), true, imgStatsBackground)
lblStatsKills:setVerticalAlign("center")

local lblStatsDeaths = GuiLabel(0.02, 0.56, 0.18, 0.07,
	str("statisticsMenuDeaths"), true, imgStatsBackground)
lblStatsDeaths:setVerticalAlign("center")

local lblStatsKillDeathRatio = GuiLabel(0.02, 0.63, 0.18, 0.07,
	str("statisticsMenuKillDeathRatio"), true, imgStatsBackground)
lblStatsKillDeathRatio:setVerticalAlign("center")

local lblStatsHeadshots = GuiLabel(0.02, 0.70, 0.18, 0.07,
	str("statisticsMenuHeadshots"), true, imgStatsBackground)
lblStatsHeadshots:setVerticalAlign("center")

local lblStatsCoins = GuiLabel(0.02, 0.77, 0.22, 0.07,
	str("statisticsMenuBattlePointsBalance"), true, imgStatsBackground)
lblStatsCoins:setVerticalAlign("center")

local lblStatsCoinsSpent = GuiLabel(0.02, 0.84, 0.22, 0.07,
	str("statisticsMenuBattlePointsSpent"), true, imgStatsBackground)
lblStatsCoinsSpent:setVerticalAlign("center")

local lblStatsPlayerName = GuiLabel(0.38, 0.00, 0.29, 0.07,
	str("statisticsMenuPlayerName", localPlayer.name):gsub("#%x%x%x%x%x%x", ""),
	true, imgStatsBackground)
lblStatsPlayerName:setVerticalAlign("center")

local lblStatsGamesPlayed_value =
	GuiLabel(0.24, 0.22, 0.18, 0.07, "0", true, imgStatsBackground)
lblStatsGamesPlayed_value:setVerticalAlign("center")

local lblStatsWins_value =
	GuiLabel(0.24, 0.29, 0.18, 0.07, "0", true, imgStatsBackground)
lblStatsWins_value:setVerticalAlign("center")

local lblStatsLosses_value =
	GuiLabel(0.24, 0.36, 0.18, 0.07, "0", true, imgStatsBackground)
lblStatsLosses_value:setVerticalAlign("center")

local lblStatsWinlossratio_value =
	GuiLabel(0.24, 0.43, 0.18, 0.07, "0", true, imgStatsBackground)
lblStatsWinlossratio_value:setVerticalAlign("center")

local lblStatsKills_value =
	GuiLabel(0.24, 0.50, 0.18, 0.07, "0", true, imgStatsBackground)
lblStatsKills_value:setVerticalAlign("center")

local lblStatsDeaths_value =
	GuiLabel(0.24, 0.56, 0.18, 0.07, "0", true, imgStatsBackground)
lblStatsDeaths_value:setVerticalAlign("center")

local lblStatsKilldeathratio_value =
	GuiLabel(0.24, 0.63, 0.18, 0.07, "0", true, imgStatsBackground)
lblStatsKilldeathratio_value:setVerticalAlign("center")

local lblStatsHeadshots_value =
	GuiLabel(0.24, 0.70, 0.18, 0.07, "0", true, imgStatsBackground)
lblStatsHeadshots_value:setVerticalAlign("center")

local lblStatsCoins_value =
	GuiLabel(0.24, 0.77, 0.22, 0.07, "0", true, imgStatsBackground)
lblStatsCoins_value:setVerticalAlign("center")

local lblStatsCoinsSpent_value =
	GuiLabel(0.24, 0.84, 0.22, 0.07, "0", true, imgStatsBackground)
lblStatsCoinsSpent_value:setVerticalAlign("center")

local lblStatsID = GuiLabel(0.72, 0.93, 0.05, 0.07,
	str("statisticsMenuID"), true, imgStatsBackground)
lblStatsID:setVerticalAlign("center")
local lblStatsID_value = GuiLabel(0.78, 0.93, 0.22, 0.07,
	str("statisticsMenuNA"), true, imgStatsBackground)
lblStatsID_value:setVerticalAlign("center")

local imgSkinsUnavailable = GuiStaticImage(0.21, 0.28, 0.29, 0.04,
	"gui/img/pixel.png", true)
imgSkinsUnavailable:setProperty("ImageColours",
	"tl:E3020202 tr:E3020202 bl:E3020202 br:E3020202")
local lblSkinsUnavaible = GuiLabel(0.00, 0.00, 1.00, 1.00,
	str("skinsMenuNotAvailableYet"), true, imgSkinsUnavailable)
lblSkinsUnavaible:setHorizontalAlign("center", false)
lblSkinsUnavaible:setVerticalAlign("center")

local imgSkinsPreset = GuiStaticImage(0.50, 0.28, 0.28, 0.05,
	"gui/img/pixel.png", true)
imgSkinsPreset:setProperty("ImageColours",
	"tl:DDAFAFAF tr:DDAFAFAF bl:DDAFAFAF br:DDAFAFAF")
local lblSkinsPreset = GuiLabel(0.00, 0.00, 1.00, 1.00,
	str("skinsMenuPresetSkins"), true, imgSkinsPreset)
lblSkinsPreset:setHorizontalAlign("center", false)
lblSkinsPreset:setVerticalAlign("center")

local imgSkinsPrevButton = GuiStaticImage(0.18, 0.32, 0.03, 0.59,
	"gui/img/pixel.png", true)
imgSkinsPrevButton:setProperty("ImageColours",
	"tl:DD484848 tr:DD484848 bl:DD484848 br:DD484848")
local lblPrevSkinButton =
	GuiLabel(0.00, 0.00, 1.00, 1.00, "<-", true, imgSkinsPrevButton)
lblPrevSkinButton:setHorizontalAlign("center", false)
lblPrevSkinButton:setVerticalAlign("center")

local imgSkinsNextButton = GuiStaticImage(0.78, 0.32, 0.03, 0.59,
	"gui/img/pixel.png", true)
imgSkinsNextButton:setProperty("ImageColours",
	"tl:DD484848 tr:DD484848 bl:DD484848 br:DD484848")
local lblSkinNextButton =
	GuiLabel(0.00, 0.00, 1.00, 1.00, "->", true, imgSkinsNextButton)
lblSkinNextButton:setHorizontalAlign("center", false)
lblSkinNextButton:setVerticalAlign("center")

local SkinSelection = {}
function SkinSelection.getVisible()
	return imgSkinsUnavailable:getVisible()
end

function SkinSelection.setVisible(visible)
	imgSkinsUnavailable:setVisible(visible)
	imgSkinsPreset:setVisible(visible)
	imgSkinsPrevButton:setVisible(visible)
	imgSkinsNextButton:setVisible(visible)
end

imgBackground:setVisible(false)
local function hideStatsPanel() --TODO: StatsPanel.setVisible(bool)
	imgStatsBackground:setVisible(false)
	SkinSelection.setVisible(false)
end
hideStatsPanel()

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		local battlegroundsVersion = "MTA:Battlegrounds 0.1.0a"
		local versionLabel = GuiLabel(1, 1, 0.3,0.3, battlegroundsVersion, true)
		versionLabel:setSize(versionLabel:getTextExtent(),
		                     versionLabel:getFontHeight(), false)
		local x, y = versionLabel:getSize(true)
		versionLabel:setPosition(1-x, 1-y*1.8, true)
		versionLabel:setAlpha(0.5)
	end
)

function HomeScreen.getVisible()
	return imgBackground:getVisible()
end

function HomeScreen.setVisible(visible)
	imgBackground:setVisible(visible)
end

local screenX, screenY = guiGetScreenSize()
function HomeScreen.show()
	local number = math.random(1, 2)
	Music.play()
	Camera.setMatrix(1720.41125, -1646.7942, 21.0576,
	                 1721.21911, -1647.3781, 20.9919, 0, 70)
	localPlayer:setDimension(0)
	localPlayer:setInterior(18)
	showCursor(true)
	triggerServerEvent("onAskServerForAccountStats", localPlayer)
	localPlayer:disableHudComponents("radar", "clock", "health",
	                                 "area_name", "money")
	Inventory.setVisible(false)
	setWeather(0)
end

local selectedOption = lblHomeButton
local function changeColorOfOptionOnMouseOver(guiLabel, state)
	if state then
		if selectedOption ~= guiLabel then
			guiLabel:setColor(255, 255, 255)
		end
	else
		if selectedOption ~= guiLabel then
			guiLabel:setColor(197, 197, 197)
		end
	end
end

local function changeColorOfArrowCharacterScreen(guiLabel, state)
	if state then
		if guiLabel == lblPrevSkinButton then
			imgSkinsPrevButton:setProperty("ImageColours",
				"tl:E3020202 tr:E3020202 bl:E3020202 br:E3020202")
		else
			imgSkinsNextButton:setProperty("ImageColours",
				"tl:E3020202 tr:E3020202 bl:E3020202 br:E3020202")
		end
	else
		if guiLabel == lblPrevSkinButton then
			imgSkinsPrevButton:setProperty("ImageColours",
				"tl:DD484848 tr:DD484848 bl:DD484848 br:DD484848")
		else
			imgSkinsNextButton:setProperty("ImageColours",
				"tl:DD484848 tr:DD484848 bl:DD484848 br:DD484848")
		end
	end
end

local function getCurrentSelectedOption(guiLabel)
	if selectedOption == guiLabel then
		guiLabel:setColor(255, 255, 255)
	end
end

local function changeColorOfSelectedOptionHome()
	changeColorOfOptionOnMouseOver(source, true)
end
addEventHandler("onClientMouseEnter", lblHomeButton,
                changeColorOfSelectedOptionHome, false)

local function changeColorOfDeselectedOptionHome()
	changeColorOfOptionOnMouseOver(source, false)
	getCurrentSelectedOption(source)
end
addEventHandler("onClientMouseLeave", lblHomeButton,
                changeColorOfDeselectedOptionHome, false)

local function changeColorOfSelectedOptionCharacter()
	changeColorOfOptionOnMouseOver(source, true)
end
addEventHandler("onClientMouseEnter", lblSkinButton,
                changeColorOfSelectedOptionCharacter, false)

local function changeColorOfDeselectedOptionCharacter()
	changeColorOfOptionOnMouseOver(source, false)
	getCurrentSelectedOption(source)
end
addEventHandler("onClientMouseLeave", lblSkinButton,
                changeColorOfDeselectedOptionCharacter, false)

local function changeColorOfSelectedOptionRewards()
	changeColorOfOptionOnMouseOver(source, true)
end
addEventHandler("onClientMouseEnter", lblSoonButton,
                changeColorOfSelectedOptionRewards, false)

local function changeColorOfDeselectedOptionRewards()
	changeColorOfOptionOnMouseOver(source, false)
	getCurrentSelectedOption(source)
end
addEventHandler("onClientMouseLeave", lblSoonButton,
                changeColorOfDeselectedOptionRewards, false)

local function changeColorOfSelectedOptionStatistics()
	changeColorOfOptionOnMouseOver(source, true)
end
addEventHandler("onClientMouseEnter", lblStatsButton,
                changeColorOfSelectedOptionStatistics, false)

local function changeColorOfDeselectedOptionStatistics()
	changeColorOfOptionOnMouseOver(source, false)
	getCurrentSelectedOption(source)
end
addEventHandler("onClientMouseLeave", lblStatsButton,
                changeColorOfDeselectedOptionStatistics, false)

local function changeColorOfSelectedArrowCharacter()
	changeColorOfArrowCharacterScreen(source, true)
end
addEventHandler("onClientMouseEnter", lblPrevSkinButton,
                changeColorOfSelectedArrowCharacter, false)

local function changeColorOfDeselectedArrowCharacter()
	changeColorOfArrowCharacterScreen(source, false)
end
addEventHandler("onClientMouseLeave", lblPrevSkinButton,
                changeColorOfDeselectedArrowCharacter, false)

local function changeColorOfSelectedOptionPlay()
	source:setColor(255, 0, 0)
	imgPlayButton:setProperty("ImageColours",
		"tl:FFFFD700 tr:FFFFD700 bl:FFFFD700 br:FFFFD700")
end
addEventHandler("onClientMouseEnter", lblPlayButton,
                changeColorOfSelectedOptionPlay, false)

local function changeColorOfDeselectedOptionPlay()
	source:setColor(255, 255, 255)
	imgPlayButton:setProperty("ImageColours",
		"tl:FFFFFFFF tr:FFFFFFFF bl:FFFFFFFF br:FFFFFFFF")
end
addEventHandler("onClientMouseLeave", lblPlayButton,
                changeColorOfDeselectedOptionPlay, false)

addEventHandler("onClientGUIClick", imgStatsPanel,
	function()
		guiMoveToBack(imgStatsPanel)
	end
)

local sm = {}
sm.moov = 0
sm.object1, sm.object2 = nil, nil

local function removeCamHandler()
	if(sm.moov == 1)then
		sm.moov = 0
	end
end

local function camRender()
	if(sm.moov == 1) then
		--OOP method returns vector3 instead of 3 numbers
		local p1 = sm.object1:getPosition()
		local p2 = sm.object2:getPosition()
		Camera.setMatrix(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z)
	end
end
addEventHandler("onClientPreRender", root, camRender)

local function smoothMoveCamera(x1, y1, z1, x1t, y1t, z1t,
                                x2, y2, z2, x2t, y2t, z2t, time)
	if(sm.moov == 1)then return false end
	sm.object1 = Object(1337, x1, y1, z1)
	sm.object2 = Object(1337, x1t, y1t, z1t)
	sm.object1:setAlpha(0)
	sm.object2:setAlpha(0)
	sm.object1:setScale(0.01)
	sm.object2:setScale(0.01)
	sm.object1:move(time, x2, y2, z2, 0, 0, 0, "InOutQuad")
	sm.object2:move(time, x2t, y2t, z2t, 0, 0, 0, "InOutQuad")
	sm.moov = 1
	Timer(removeCamHandler, time, 1)
	Timer(destroyElement, time, 1, sm.object1)
	Timer(destroyElement, time, 1, sm.object2)
	return true
end

local statistics = {}
local temporarySkinTable = {0, 1, 2, 7, 9, 10}
local function getStatisticsFromServer(stats)
	statistics = stats
	lblCoinCount:setText(tostring(stats.coins))
end
addEvent("onGetAccountStatsFromServer", true)
addEventHandler("onGetAccountStatsFromServer",
                localPlayer, getStatisticsFromServer)

local function showStatistics()
	lblStatsGamesPlayed_value:setText(statistics.gamesPlayed)
	lblStatsWins_value:setText(statistics.wins)
	lblStatsLosses_value:setText(statistics.losses)
	lblStatsKills_value:setText(statistics.kills)
	lblStatsDeaths_value:setText(statistics.deaths)
	lblStatsHeadshots_value:setText(statistics.headshots)
	lblStatsCoins_value:setText(statistics.coins)
	lblStatsCoinsSpent_value:setText(statistics.coinsSpent)

	local deaths = statistics.deaths == 0 and 1 or statistics.deaths
	local losses = statistics.losses == 0 and 1 or statistics.losses
	lblStatsKilldeathratio_value:setText(statistics.kills/deaths)
	lblStatsWinlossratio_value:setText(statistics.wins/losses)
	imgStatsBackground:setVisible(true)
end

local smoothMoveForward = false
local function openUpSelectedOption(theOption)
	--OOP method returns vector3 instead of 3 numbers
	local a, b, c, d, e, f = getCameraMatrix(localPlayer)
	if theOption == lblHomeButton then
		-- HOME OPTION CODE
		if imgStatsBackground:getVisible() then
			imgStatsBackground:setVisible(false)
		end
		if SkinSelection.getVisible() then
			SkinSelection.setVisible(false)
		end
		if not smoothMoveForward then
			smoothMoveCamera(a, b, c, d, e, f,
			                 1720.41125, -1646.7942, 21.0576,
			                 1721.21911, -1647.3781, 20.9919, 1000)
			smoothMoveForward = true
		end
	elseif theOption == lblSkinButton then
		if imgStatsBackground:getVisible() then
			imgStatsBackground:setVisible(false)
		end
		SkinSelection.setVisible(true)
		-- CHARACTER OPTION CODE
		if not smoothMoveForward then
			smoothMoveCamera(a, b, c, d, e, f,
			                 1720.41125, -1646.7942, 21.0576,
			                 1721.21911+1, -1647.3781+0.1, 20.9919, 1000)
			smoothMoveForward = true
		end
	elseif theOption == lblStatsButton then
		if SkinSelection.getVisible() then
			SkinSelection.setVisible(false)
		end
		smoothMoveCamera(a, b, c, d, e, f,
		                 1720.41125, -1646.7942, 21.0576,
		                 1721.21911, -1647.3781, 20.9919, 1000)
		showStatistics()
	else
		-- IN CASE ALL FAILS,  SEND TO HOME
		if imgStatsBackground:getVisible() then
			imgStatsBackground:setVisible(false)
		end
		if SkinSelection.getVisible() then
			SkinSelection.setVisible(false)
		end
		smoothMoveCamera(a, b, c, d, e, f,
		                 1720.41125, -1646.7942, 21.0576,
		                 1721.21911, -1647.3781, 20.9919, 1000)
		smoothMoveForward = false
	end
	setTimer(function() smoothMoveForward = false end, 500, 1)
end

local function sendPlayerToOptionOnPress(button)
	if button == "left" then
		selectedOption:setColor(197, 197, 197)
		imgStatsPanel:moveToBack()
		source:setColor(255, 255, 255)
		selectedOption = source
		openUpSelectedOption(selectedOption)
	end
end
addEventHandler("onClientGUIClick", lblHomeButton,
                sendPlayerToOptionOnPress, false)
addEventHandler("onClientGUIClick", lblSkinButton,
                sendPlayerToOptionOnPress, false)
addEventHandler("onClientGUIClick", lblSoonButton,
                sendPlayerToOptionOnPress, false)
addEventHandler("onClientGUIClick", lblStatsButton,
                sendPlayerToOptionOnPress, false)

local currentSkinID = 1
local function changeCharacterOnArrowClick(guiLabel, state)
	if state then
		if source == lblSkinNextButton then
			currentSkinID = currentSkinID + 1
			if currentSkinID > #temporarySkinTable then
				currentSkinID = 1
			end
		else
			currentSkinID = currentSkinID - 1
			if currentSkinID <= 0 then
				currentSkinID = #temporarySkinTable
			end
		end
		homescreenPed:setModel(temporarySkinTable[currentSkinID])
	end
end
addEventHandler("onClientGUIClick", lblPrevSkinButton,
                changeCharacterOnArrowClick, false)
addEventHandler("onClientGUIClick", lblSkinNextButton,
                changeCharacterOnArrowClick, false)

local savedTime
local function fadeInCamera()
	Timer(function()
		iprint("Fading "..((getTickCount() - savedTime)/1000).." seconds after")
		showChat(true)
		Camera.fade(true, 0.5)
	end, 1000, 1)
	removeEventHandler("onSetInLobby", localPlayer, fadeInCamera)
end

local FADEOUT_TIME = 200
local function sendPlayerToLobby(button)
	if button == "left" then
		Timer(function()
			triggerServerEvent("onSendPlayerToLobby", localPlayer,
			                   temporarySkinTable[currentSkinID])
			Camera.setTarget(localPlayer)
		end, FADEOUT_TIME + 100, 1)
		Camera.fade(false, FADEOUT_TIME*0.001)
		LanguageSelection.setShowing(false)
		imgBackground:setVisible(false)
		hideStatsPanel()
		Music.stop()
		showCursor(false)
		savedTime = getTickCount()
		addEventHandler("onSetInLobby", localPlayer, fadeInCamera)
	end
end
addEventHandler("onClientGUIClick", lblPlayButton, sendPlayerToLobby, false)

local function moveBackgroundBack()
	imgBackground:moveToBack()
end
addEventHandler("onClientGUIClick", imgBackground, moveBackgroundBack, false)

local function changeLanguage(newLang)
	lblHomeButton:setText(str("mainMenuHomeButton"))
	lblSkinButton:setText(str("mainMenuCharacterButton"))
	lblSoonButton:setText(str("mainMenuSoonButton"))
	lblStatsButton:setText(str("mainMenuStatisticsButton"))
	lblPlayerName:setText(str("mainMenuPlayerName",
	                          localPlayer.name):gsub("#%x%x%x%x%x%x", ""))
	lblPlayButtonShadow:setText(str("mainMenuPlayButtonShadow"))
	lblPlayButton:setText(str("mainMenuPlayButton"))
	lblStatsGamesPlayed:setText(str("statisticsMenuGamesPlayed"))
	lblStatsWins:setText(str("statisticsMenuWins"))
	lblStatsLosses:setText(str("statisticsMenuLosses"))
	lblStatsWinLossRatio:setText(str("statisticsMenuWinLossRatio"))
	lblStatsKills:setText(str("statisticsMenuKills"))
	lblStatsDeaths:setText(str("statisticsMenuDeaths"))
	lblStatsKillDeathRatio:setText(str("statisticsMenuKillDeathRatio"))
	lblStatsHeadshots:setText(str("statisticsMenuHeadshots"))
	lblStatsCoins:setText(str("statisticsMenuBattlePointsBalance"))
	lblStatsCoinsSpent:setText(str("statisticsMenuBattlePointsSpent"))
	lblStatsPlayerName:setText(str("statisticsMenuPlayerName",
	                               localPlayer.name):gsub("#%x%x%x%x%x%x", ""))
	lblStatsID:setText(str("statisticsMenuID"))
	lblStatsID_value:setText(str("statisticsMenuNA"))
	lblSkinsUnavaible:setText(str("skinsMenuNotAvailableYet"))
	lblSkinsPreset:setText(str("skinsMenuPresetSkins"))
end
addEventHandler("onUserLanguageChange", resourceRoot, changeLanguage)
