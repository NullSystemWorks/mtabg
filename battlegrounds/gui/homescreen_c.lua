--[[
	
				MTA:BG
			MTA Battlegrounds
	Developed By: Null System Works

]]--


homeScreen = {
    label = {},
    staticimage = {},
	font = {}
}

homeScreen.font[1] = guiCreateFont("/fonts/etelka.ttf",13)
homeScreen.font[2] = guiCreateFont("/fonts/etelka.ttf",25)

homeScreen.staticimage[1] = guiCreateStaticImage(0.00, 0.00, 1.00, 1.00, "gui/images/background_transparent.png", true)
homeScreen.staticimage[2] = guiCreateStaticImage(0.00, 0.02, 1.00, 0.06, "gui/images/solo_slot.png", true, homeScreen.staticimage[1])
guiSetProperty(homeScreen.staticimage[2], "ImageColours", "tl:66B7B7B7 tr:66B7B7B7 bl:66B7B7B7 br:66B7B7B7")
homeScreen.label[1] = guiCreateLabel(0.33, 0.29, 0.16, 0.45, "HOME", true, homeScreen.staticimage[2])
guiLabelSetHorizontalAlign(homeScreen.label[1], "center", false)
guiLabelSetVerticalAlign(homeScreen.label[1], "center")
guiSetFont(homeScreen.label[1],homeScreen.font[1])
homeScreen.label[2] = guiCreateLabel(0.49, 0.29, 0.16, 0.45, "CHARACTER", true, homeScreen.staticimage[2])
guiLabelSetHorizontalAlign(homeScreen.label[2], "center", false)
guiLabelSetVerticalAlign(homeScreen.label[2], "center")
guiSetFont(homeScreen.label[2],homeScreen.font[1])
guiLabelSetColor(homeScreen.label[2],197,197,197)
homeScreen.label[3] = guiCreateLabel(0.65, 0.29, 0.16, 0.45, "SOON", true, homeScreen.staticimage[2])
guiLabelSetHorizontalAlign(homeScreen.label[3], "center", false)
guiLabelSetVerticalAlign(homeScreen.label[3], "center")
guiSetFont(homeScreen.label[3],homeScreen.font[1])
guiLabelSetColor(homeScreen.label[3],197,197,197)
homeScreen.label[4] = guiCreateLabel(0.81, 0.29, 0.16, 0.45, "STATISTICS", true, homeScreen.staticimage[2])
guiLabelSetHorizontalAlign(homeScreen.label[4], "center", false)
guiLabelSetVerticalAlign(homeScreen.label[4], "center")
guiSetFont(homeScreen.label[4],homeScreen.font[1])
guiLabelSetColor(homeScreen.label[4],197,197,197)
homeScreen.label[5] = guiCreateLabel(0.64, 0.11, 0.24, 0.05, tostring(getPlayerName(localPlayer)), true, homeScreen.staticimage[1])
guiLabelSetVerticalAlign(homeScreen.label[5], "center")
guiSetFont(homeScreen.label[5],homeScreen.font[1])
homeScreen.staticimage[4] = guiCreateStaticImage(0.87, 0.11, 0.05, 0.05,"gui/images/battlepointsicon.png",true,homeScreen.staticimage[1])
homeScreen.label[6] = guiCreateLabel(0.95, 0.11, 0.12, 0.05, "0", true, homeScreen.staticimage[1])
guiLabelSetVerticalAlign(homeScreen.label[6], "center")
guiSetFont(homeScreen.label[6],homeScreen.font[1])	
guiLabelSetColor(homeScreen.label[6],0,0,0)
homeScreen.staticimage[3] = guiCreateStaticImage(0.00, 0.00, 0.30, 0.15, "gui/images/button.png", true, homeScreen.staticimage[1])	
homeScreen.label[7] = guiCreateLabel(0.05, 0.19, 0.58, 0.30, "PLAY", true, homeScreen.staticimage[3])
guiLabelSetColor(homeScreen.label[7],0,0,0)
guiLabelSetHorizontalAlign(homeScreen.label[7], "left", false)
guiLabelSetVerticalAlign(homeScreen.label[7], "center")
guiSetFont(homeScreen.label[7],homeScreen.font[2])	
homeScreen.label[8] = guiCreateLabel(0.06, 0.20, 0.58, 0.30, "PLAY", true, homeScreen.staticimage[3])
guiLabelSetColor(homeScreen.label[8],255,255,255)
guiLabelSetHorizontalAlign(homeScreen.label[8], "left", false)
guiLabelSetVerticalAlign(homeScreen.label[8], "center")
guiSetFont(homeScreen.label[8],homeScreen.font[2])

homeScreen.staticimage[5] = guiCreateStaticImage(0.30, 0.27, 0.69, 0.66, "gui/images/solo_slot.png", true, homeScreen.staticimage[1])
guiSetProperty(homeScreen.staticimage[5], "ImageColours", "tl:B2040404 tr:B2040404 bl:B2040404 br:B2040404")
homeScreen.label["gamesplayed"] = guiCreateLabel(0.02, 0.22, 0.18, 0.07, "Games Played:", true, homeScreen.staticimage[5])
guiLabelSetVerticalAlign(homeScreen.label["gamesplayed"], "center")
homeScreen.label["wins"] = guiCreateLabel(0.02, 0.29, 0.18, 0.07, "Wins:", true, homeScreen.staticimage[5])
guiLabelSetVerticalAlign(homeScreen.label["wins"], "center")
homeScreen.label["losses"] = guiCreateLabel(0.02, 0.36, 0.18, 0.07, "Losses:", true, homeScreen.staticimage[5])
guiLabelSetVerticalAlign(homeScreen.label["losses"], "center")
homeScreen.label["winlossratio"] = guiCreateLabel(0.02, 0.43, 0.18, 0.07, "Win/Loss Ratio:", true, homeScreen.staticimage[5])
guiLabelSetVerticalAlign(homeScreen.label["winlossratio"], "center")
homeScreen.label["kills"] = guiCreateLabel(0.02, 0.50, 0.18, 0.07, "Kills:", true, homeScreen.staticimage[5])
guiLabelSetVerticalAlign(homeScreen.label["kills"], "center")
homeScreen.label["deaths"] = guiCreateLabel(0.02, 0.56, 0.18, 0.07, "Deaths:", true, homeScreen.staticimage[5])
guiLabelSetVerticalAlign(homeScreen.label["deaths"], "center")
homeScreen.label["killdeathratio"] = guiCreateLabel(0.02, 0.63, 0.18, 0.07, "Kill/Death Ratio:", true, homeScreen.staticimage[5])
guiLabelSetVerticalAlign(homeScreen.label["killdeathratio"], "center")
homeScreen.label["headshots"] = guiCreateLabel(0.02, 0.70, 0.18, 0.07, "Headshots:", true, homeScreen.staticimage[5])
guiLabelSetVerticalAlign(homeScreen.label["headshots"], "center")
homeScreen.label["battlepoints"] = guiCreateLabel(0.02, 0.77, 0.22, 0.07, "Battle Points Earned:", true, homeScreen.staticimage[5])
guiLabelSetVerticalAlign(homeScreen.label["battlepoints"], "center")
homeScreen.label["battlepointsspent"] = guiCreateLabel(0.02, 0.84, 0.22, 0.07, "Battle Points Spent:", true, homeScreen.staticimage[5])
guiLabelSetVerticalAlign(homeScreen.label["battlepointsspent"], "center")
homeScreen.label[19] = guiCreateLabel(0.38, 0.00, 0.29, 0.07, "Statistics for "..tostring(getPlayerName(localPlayer)), true, homeScreen.staticimage[5])
guiLabelSetVerticalAlign(homeScreen.label[19], "center")

homeScreen.label["gamesplayed_value"] = guiCreateLabel(0.24, 0.22, 0.18, 0.07, "0", true, homeScreen.staticimage[5])
guiLabelSetVerticalAlign(homeScreen.label["gamesplayed_value"], "center")
homeScreen.label["wins_value"] = guiCreateLabel(0.24, 0.29, 0.18, 0.07, "0", true, homeScreen.staticimage[5])
guiLabelSetVerticalAlign(homeScreen.label["wins_value"], "center")
homeScreen.label["losses_value"] = guiCreateLabel(0.24, 0.36, 0.18, 0.07, "0", true, homeScreen.staticimage[5])
guiLabelSetVerticalAlign(homeScreen.label["losses_value"], "center")
homeScreen.label["winlossratio_value"] = guiCreateLabel(0.24, 0.43, 0.18, 0.07, "0", true, homeScreen.staticimage[5])
guiLabelSetVerticalAlign(homeScreen.label["winlossratio_value"], "center")
homeScreen.label["kills_value"] = guiCreateLabel(0.24, 0.50, 0.18, 0.07, "0", true, homeScreen.staticimage[5])
guiLabelSetVerticalAlign(homeScreen.label["kills_value"], "center")
homeScreen.label["deaths_value"] = guiCreateLabel(0.24, 0.56, 0.18, 0.07, "0", true, homeScreen.staticimage[5])
guiLabelSetVerticalAlign(homeScreen.label["deaths_value"], "center")
homeScreen.label["killdeathratio_value"] = guiCreateLabel(0.24, 0.63, 0.18, 0.07, "0", true, homeScreen.staticimage[5])
guiLabelSetVerticalAlign(homeScreen.label["killdeathratio_value"], "center")
homeScreen.label["headshots_value"] = guiCreateLabel(0.24, 0.70, 0.18, 0.07, "0", true, homeScreen.staticimage[5])
guiLabelSetVerticalAlign(homeScreen.label["headshots_value"], "center")
homeScreen.label["battlepoints_value"] = guiCreateLabel(0.24, 0.77, 0.22, 0.07, "0", true, homeScreen.staticimage[5])
guiLabelSetVerticalAlign(homeScreen.label["battlepoints_value"], "center")
homeScreen.label["battlepointsspent_value"] = guiCreateLabel(0.24, 0.84, 0.22, 0.07, "0", true, homeScreen.staticimage[5])
guiLabelSetVerticalAlign(homeScreen.label["battlepointsspent_value"], "center")

homeScreen.label[30] = guiCreateLabel(0.72, 0.93, 0.05, 0.07, "ID:", true, homeScreen.staticimage[5])
guiLabelSetVerticalAlign(homeScreen.label[30], "center")
homeScreen.label[31] = guiCreateLabel(0.78, 0.93, 0.22, 0.07, "0000001", true, homeScreen.staticimage[5])
guiLabelSetVerticalAlign(homeScreen.label[31], "center")   


homeScreen.staticimage[6] = guiCreateStaticImage(0.09, 0.29, 0.08, 0.11, "gui/images/solo_slot.png", true, homeScreen.staticimage[1])
guiSetProperty(homeScreen.staticimage[6], "ImageColours", "tl:B93C3C3C tr:B93C3C3C bl:B93C3C3C br:B93C3C3C")
homeScreen.staticimage[7] = guiCreateStaticImage(0, 0, 1.00, 1.00, "gui/images/legendary_crate.png", true, homeScreen.staticimage[6])

homeScreen.staticimage[8] = guiCreateStaticImage(0.09, 0.41, 0.08, 0.11, "gui/images/solo_slot.png", true, homeScreen.staticimage[1])
guiSetProperty(homeScreen.staticimage[8], "ImageColours", "tl:B93C3C3C tr:B93C3C3C bl:B93C3C3C br:B93C3C3C")
homeScreen.staticimage[9] = guiCreateStaticImage(0, 0, 1, 1, "gui/images/epic_crate.png", true, homeScreen.staticimage[8])

homeScreen.staticimage[10] = guiCreateStaticImage(0.09, 0.53, 0.08, 0.11, "gui/images/solo_slot.png", true, homeScreen.staticimage[1])
guiSetProperty(homeScreen.staticimage[10], "ImageColours", "tl:B93C3C3C tr:B93C3C3C bl:B93C3C3C br:B93C3C3C")
homeScreen.staticimage[11] = guiCreateStaticImage(0.00, 0.00, 1.00, 1.00, "gui/images/uncommon_crate.png", true, homeScreen.staticimage[10])

homeScreen.staticimage[12] = guiCreateStaticImage(0.09, 0.65, 0.08, 0.11, "gui/images/solo_slot.png", true, homeScreen.staticimage[1])
guiSetProperty(homeScreen.staticimage[12], "ImageColours", "tl:B93C3C3C tr:B93C3C3C bl:B93C3C3C br:B93C3C3C")
homeScreen.staticimage[13] = guiCreateStaticImage(0, 0, 1, 1, "gui/images/common_crate.png", true, homeScreen.staticimage[12])

homeScreen.staticimage[14] = guiCreateStaticImage(0.18, 0.29, 0.31, 0.11, "gui/images/solo_slot.png", true, homeScreen.staticimage[1])
guiSetProperty(homeScreen.staticimage[14], "ImageColours", "tl:B93C3C3C tr:B93C3C3C bl:B93C3C3C br:B93C3C3C")
homeScreen.label["legendary"] = guiCreateLabel(0.02, 0.15, 0.94, 0.70, "LEGENDARY CRATES:", true, homeScreen.staticimage[14])
guiLabelSetVerticalAlign(homeScreen.label["legendary"], "center")

homeScreen.staticimage[15] = guiCreateStaticImage(0.18, 0.41, 0.31, 0.11, "gui/images/solo_slot.png", true, homeScreen.staticimage[1])
guiSetProperty(homeScreen.staticimage[15], "ImageColours", "tl:B93C3C3C tr:B93C3C3C bl:B93C3C3C br:B93C3C3C")
homeScreen.label["epic"] = guiCreateLabel(0.02, 0.15, 0.94, 0.70, "EPIC CRATES:", true, homeScreen.staticimage[15])
guiLabelSetVerticalAlign(homeScreen.label["epic"], "center")


homeScreen.staticimage[16] = guiCreateStaticImage(0.18, 0.53, 0.31, 0.11, "gui/images/solo_slot.png", true, homeScreen.staticimage[1])
guiSetProperty(homeScreen.staticimage[16], "ImageColours", "tl:B93C3C3C tr:B93C3C3C bl:B93C3C3C br:B93C3C3C")
homeScreen.label["uncommon"] = guiCreateLabel(0.02, 0.15, 0.94, 0.70, "UNCOMMON CRATES:", true, homeScreen.staticimage[16])
guiLabelSetVerticalAlign(homeScreen.label["uncommon"], "center")


homeScreen.staticimage[17] = guiCreateStaticImage(0.18, 0.65, 0.31, 0.11, "gui/images/solo_slot.png", true, homeScreen.staticimage[1])
guiSetProperty(homeScreen.staticimage[17], "ImageColours", "tl:B93C3C3C tr:B93C3C3C bl:B93C3C3C br:B93C3C3C")
homeScreen.label["common"] = guiCreateLabel(0.02, 0.15, 0.94, 0.70, "COMMON CRATES:", true, homeScreen.staticimage[17])
guiLabelSetVerticalAlign(homeScreen.label["common"], "center")
 
homeScreen.staticimage[18] = guiCreateStaticImage(0.21, 0.28, 0.29, 0.04, "gui/images/solo_slot.png", true)
guiSetProperty(homeScreen.staticimage[18], "ImageColours", "tl:E3020202 tr:E3020202 bl:E3020202 br:E3020202")
homeScreen.label[36] = guiCreateLabel(0.00, 0.00, 1.00, 1.00, "NOT AVAILABLE YET", true, homeScreen.staticimage[18]) -- CUSTOMIZABLE SKIN
guiLabelSetHorizontalAlign(homeScreen.label[36], "center", false)
guiLabelSetVerticalAlign(homeScreen.label[36], "center")

homeScreen.staticimage[19] = guiCreateStaticImage(0.50, 0.28, 0.28, 0.05, "gui/images/solo_slot.png", true)
guiSetProperty(homeScreen.staticimage[19], "ImageColours", "tl:DDAFAFAF tr:DDAFAFAF bl:DDAFAFAF br:DDAFAFAF")
homeScreen.label[37] = guiCreateLabel(0.00, 0.00, 1.00, 1.00, "PRESET SKINS", true, homeScreen.staticimage[19])
guiLabelSetHorizontalAlign(homeScreen.label[37], "center", false)
guiLabelSetVerticalAlign(homeScreen.label[37], "center")

homeScreen.staticimage[20] = guiCreateStaticImage(0.18, 0.32, 0.03, 0.59, "gui/images/solo_slot.png", true)
guiSetProperty(homeScreen.staticimage[20], "ImageColours", "tl:DD484848 tr:DD484848 bl:DD484848 br:DD484848")
homeScreen.label[38] = guiCreateLabel(0.00, 0.00, 1.00, 1.00, "<-", true, homeScreen.staticimage[20])
guiLabelSetHorizontalAlign(homeScreen.label[38], "center", false)
guiLabelSetVerticalAlign(homeScreen.label[38], "center")

homeScreen.staticimage[21] = guiCreateStaticImage(0.78, 0.32, 0.03, 0.59, "gui/images/solo_slot.png", true)
guiSetProperty(homeScreen.staticimage[21], "ImageColours", "tl:DD484848 tr:DD484848 bl:DD484848 br:DD484848")
homeScreen.label[39] = guiCreateLabel(0.00, 0.00, 1.00, 1.00, "->", true, homeScreen.staticimage[21])
guiLabelSetHorizontalAlign(homeScreen.label[39], "center", false)
guiLabelSetVerticalAlign(homeScreen.label[39], "center")   
 
	
guiSetVisible(homeScreen.staticimage[1],false)
guiSetVisible(homeScreen.staticimage[5],false)
for i=6,21 do
	guiSetVisible(homeScreen.staticimage[i],false)
end

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function()
		battlegroundsVersion = "MTA:Battlegrounds 0.0.1 PA"
		versionLabel = guiCreateLabel(1,1,0.3,0.3, battlegroundsVersion, true)
		guiSetSize ( versionLabel, guiLabelGetTextExtent ( versionLabel ), guiLabelGetFontHeight ( versionLabel ), false )
		x,y = guiGetSize(versionLabel,true)
		guiSetPosition( versionLabel, 1-x, 1-y*1.8, true )
		guiSetAlpha(versionLabel,0.5)
	end
)

local screenX,screenY = guiGetScreenSize()
function sendToHomeScreen(dimension)
	local number = math.random(1,2)
	soundtrack = playSound("/sounds/Unsung Briefing "..number..".mp3",true)
	setSoundVolume(soundtrack,0.4)
	setCameraMatrix(1720.41125,-1646.7942,21.0576,1721.21911,-1647.3781,20.9919,0,70)
	setElementModel(localPlayer,0)
	setElementPosition(localPlayer,1724.22998,-1647.8363,20.2283)
	setElementRotation(localPlayer,0,0,80.0553)
	setElementDimension(localPlayer,dimension)
	setElementInterior(localPlayer,18)
	setElementFrozen(localPlayer,true)
	guiSetVisible(homeScreen.staticimage[1],true)
	showCursor(true)
	setElementData(localPlayer,"participatingInGame",false)
	triggerServerEvent("mtabg_sendUserDataToHomeScreen",localPlayer)
	setPlayerHudComponentVisible("radar",false)
	setPlayerHudComponentVisible("clock",false)
	setPlayerHudComponentVisible("health",false)
	setPlayerHudComponentVisible("area_name",false)
	setPlayerHudComponentVisible("money",false)
end
addEvent("mtabg_sendToHomeScreen",true)
addEventHandler("mtabg_sendToHomeScreen",root,sendToHomeScreen)

local selectedOption = "HOME"
function changeColorOfOptionOnMouseOver(guiLabel,state)
	if state then
		if selectedOption ~= guiGetText(guiLabel) then
			guiLabelSetColor(guiLabel,255,255,255)
		end
	else
		if selectedOption ~= guiGetText(guiLabel) then
			guiLabelSetColor(guiLabel,197,197,197)
		end
	end
end

function changeColorOfArrowCharacterScreen(guiLabel,state)
	if state then
		if guiLabel == homeScreen.label[38] then
			guiSetProperty(homeScreen.staticimage[20], "ImageColours", "tl:E3020202 tr:E3020202 bl:E3020202 br:E3020202")
		else
			guiSetProperty(homeScreen.staticimage[21], "ImageColours", "tl:E3020202 tr:E3020202 bl:E3020202 br:E3020202")
		end
	else
		if guiLabel == homeScreen.label[38] then
			guiSetProperty(homeScreen.staticimage[20], "ImageColours", "tl:DD484848 tr:DD484848 bl:DD484848 br:DD484848")
		else
			guiSetProperty(homeScreen.staticimage[21], "ImageColours", "tl:DD484848 tr:DD484848 bl:DD484848 br:DD484848")
		end
	end
end

function getCurrentSelectedOption(guiLabel)
	if selectedOption == guiGetText(guiLabel) then
		guiLabelSetColor(guiLabel,255,255,255)
	end
end

function changeColorOfSelectedOptionHome()
	changeColorOfOptionOnMouseOver(source,true)
end
addEventHandler("onClientMouseEnter",homeScreen.label[1],changeColorOfSelectedOptionHome,false)

function changeColorOfDeselectedOptionHome()
	changeColorOfOptionOnMouseOver(source,false)
	getCurrentSelectedOption(source)
end
addEventHandler("onClientMouseLeave",homeScreen.label[1],changeColorOfDeselectedOptionHome,false)

function changeColorOfSelectedOptionCharacter()
	changeColorOfOptionOnMouseOver(source,true)
end
addEventHandler("onClientMouseEnter",homeScreen.label[2],changeColorOfSelectedOptionCharacter,false)

function changeColorOfDeselectedOptionCharacter()
	changeColorOfOptionOnMouseOver(source,false)
	getCurrentSelectedOption(source)
end
addEventHandler("onClientMouseLeave",homeScreen.label[2],changeColorOfDeselectedOptionCharacter,false)

function changeColorOfSelectedOptionRewards()
	changeColorOfOptionOnMouseOver(source,true)
end
addEventHandler("onClientMouseEnter",homeScreen.label[3],changeColorOfSelectedOptionRewards,false)

function changeColorOfDeselectedOptionRewards()
	changeColorOfOptionOnMouseOver(source,false)
	getCurrentSelectedOption(source)
end
addEventHandler("onClientMouseLeave",homeScreen.label[3],changeColorOfDeselectedOptionRewards,false)

function changeColorOfSelectedOptionStatistics()
	changeColorOfOptionOnMouseOver(source,true)
end
addEventHandler("onClientMouseEnter",homeScreen.label[4],changeColorOfSelectedOptionStatistics,false)

function changeColorOfDeselectedOptionStatistics()
	changeColorOfOptionOnMouseOver(source,false)
	getCurrentSelectedOption(source)
end
addEventHandler("onClientMouseLeave",homeScreen.label[4],changeColorOfDeselectedOptionStatistics,false)

function changeColorOfSelectedArrowCharacter()
	changeColorOfArrowCharacterScreen(source,true)
end
addEventHandler("onClientMouseEnter",homeScreen.label[38],changeColorOfSelectedArrowCharacter,false)

function changeColorOfDeselectedArrowCharacter()
	changeColorOfArrowCharacterScreen(source,false)
end
addEventHandler("onClientMouseLeave",homeScreen.label[38],changeColorOfDeselectedArrowCharacter,false)

function changeColorOfSelectedArrowCharacter()
	changeColorOfArrowCharacterScreen(source,true)
end
addEventHandler("onClientMouseEnter",homeScreen.label[39],changeColorOfSelectedArrowCharacter,false)

function changeColorOfDeselectedArrowCharacter()
	changeColorOfArrowCharacterScreen(source,false)
end
addEventHandler("onClientMouseLeave",homeScreen.label[39],changeColorOfDeselectedArrowCharacter,false)

function changeColorOfSelectedOptionPlay()
	guiLabelSetColor(source,255,0,0)
	guiSetProperty(homeScreen.staticimage[3], "ImageColours", "tl:FFFFD700 tr:FFFFD700 bl:FFFFD700 br:FFFFD700")
end
addEventHandler("onClientMouseEnter",homeScreen.label[8],changeColorOfSelectedOptionPlay,false)

function changeColorOfDeselectedOptionPlay()
	guiLabelSetColor(source,255,255,255)
	guiSetProperty(homeScreen.staticimage[3], "ImageColours", "tl:FFFFFFFF tr:FFFFFFFF bl:FFFFFFFF br:FFFFFFFF")
end
addEventHandler("onClientMouseLeave",homeScreen.label[8],changeColorOfDeselectedOptionPlay,false)

function sendPlayerToLobbyOnPlayPress(button)
	if button == "left" then
		triggerServerEvent("mtabg_sendPlayerToLobby",localPlayer)
		guiSetVisible(homeScreen.staticimage[1],false)
		guiSetVisible(homeScreen.staticimage[5],false)
		for i=6,21 do
			guiSetVisible(homeScreen.staticimage[i],false)
		end
		showCursor(false)
		stopSound(soundtrack)
		setCameraTarget(localPlayer)
		setElementFrozen(localPlayer,false)
	end
end
addEventHandler("onClientGUIClick",homeScreen.label[8],sendPlayerToLobbyOnPlayPress,false)

function sendPlayerToOptionOnPress(button)
	if button == "left" then
		guiMoveToBack(homeScreen.staticimage[2])
		for i=1,4 do
			if homeScreen.label[i] == source then
				guiLabelSetColor(source,255,255,255)
				selectedOption = guiGetText(source)
				openUpSelectedOption(selectedOption)
			else
				guiLabelSetColor(homeScreen.label[i],197,197,197)
			end
		end
	end
end
for i=1,4 do
	addEventHandler("onClientGUIClick",homeScreen.label[i],sendPlayerToOptionOnPress,false)
end

local sm = {}
sm.moov = 0
sm.object1,sm.object2 = nil,nil
 
local function removeCamHandler()
	if(sm.moov == 1)then
		sm.moov = 0
	end
end
 
local function camRender()
	if (sm.moov == 1) then
		local x1,y1,z1 = getElementPosition(sm.object1)
		local x2,y2,z2 = getElementPosition(sm.object2)
		setCameraMatrix(x1,y1,z1,x2,y2,z2)
	end
end
addEventHandler("onClientPreRender",root,camRender)
 
function smoothMoveCamera(x1,y1,z1,x1t,y1t,z1t,x2,y2,z2,x2t,y2t,z2t,time)
	if(sm.moov == 1)then return false end
	sm.object1 = createObject(1337,x1,y1,z1)
	sm.object2 = createObject(1337,x1t,y1t,z1t)
	setElementAlpha(sm.object1,0)
	setElementAlpha(sm.object2,0)
	setObjectScale(sm.object1,0.01)
	setObjectScale(sm.object2,0.01)
	moveObject(sm.object1,time,x2,y2,z2,0,0,0,"InOutQuad")
	moveObject(sm.object2,time,x2t,y2t,z2t,0,0,0,"InOutQuad")
	sm.moov = 1
	setTimer(removeCamHandler,time,1)
	setTimer(destroyElement,time,1,sm.object1)
	setTimer(destroyElement,time,1,sm.object2)
	return true
end

local smoothMoveForward = false
local legendaryText = guiGetText(homeScreen.label["legendary"])
local epicText = guiGetText(homeScreen.label["epic"])
local uncommonText = guiGetText(homeScreen.label["uncommon"])
local commonText = guiGetText(homeScreen.label["common"])
function openUpSelectedOption(theOption)
	if theOption == "HOME" then
		-- HOME OPTION CODE
		if guiGetVisible(homeScreen.staticimage[5]) then
			guiSetVisible(homeScreen.staticimage[5],false)
		end
		if guiGetVisible(homeScreen.staticimage[6]) then
			for i=6,17 do
				guiSetVisible(homeScreen.staticimage[i],false)
			end
		end
		if guiGetVisible(homeScreen.staticimage[18]) then
			for i=18,21 do
				guiSetVisible(homeScreen.staticimage[i],false)
			end
		end
		if not smoothMoveForward then		
			local a,b,c,d,e,f = getCameraMatrix(localPlayer)
			smoothMoveCamera(a,b,c,d,e,f,1720.41125,-1646.7942,21.0576,1721.21911,-1647.3781,20.9919,1000)
			smoothMoveForward = true
		end
	elseif theOption == "REWARDS" then
		return
		--[[
		-- Rewards will be disabled until we have a playable alpha and did some serious playtesting of other features!
		if guiGetVisible(homeScreen.staticimage[5]) then
			guiSetVisible(homeScreen.staticimage[5],false)
		end
		if guiGetVisible(homeScreen.staticimage[6]) then
			for i=6,17 do
				guiSetVisible(homeScreen.staticimage[i],false)
			end
		end
		if guiGetVisible(homeScreen.staticimage[18]) then
			for i=18,21 do
				guiSetVisible(homeScreen.staticimage[i],false)
			end
		end
		if not smoothMoveForward then
			local a,b,c,d,e,f = getCameraMatrix(localPlayer)
			smoothMoveCamera(a,b,c,d,e,f,1720.41125,-1646.7942,21.0576,1721.21911+4,-1647.3781+1,20.9919,1000)
			smoothMoveForward = true
			guiSetText(homeScreen.label["Legendary"],legendaryText)
			guiSetText(homeScreen.label["Epic"],epicText)
			guiSetText(homeScreen.label["Uncommon"],uncommonText)
			guiSetText(homeScreen.label["Common"],commonText)
			showRewards()
		end
		]]
	elseif theOption == "CHARACTER" then
		if guiGetVisible(homeScreen.staticimage[5]) then
			guiSetVisible(homeScreen.staticimage[5],false)
		end
		if guiGetVisible(homeScreen.staticimage[6]) then
			for i=6,17 do
				guiSetVisible(homeScreen.staticimage[i],false)
			end
		end
		showCharacters()
		-- CHARACTER OPTION CODE
		if not smoothMoveForward then
			local a,b,c,d,e,f = getCameraMatrix(localPlayer)
			smoothMoveCamera(a,b,c,d,e,f,1720.41125,-1646.7942,21.0576,1721.21911+1,-1647.3781+0.1,20.9919,1000)
			smoothMoveForward = true
		end
	elseif theOption == "STATISTICS" then
		if guiGetVisible(homeScreen.staticimage[6]) then
			for i=6,17 do
				guiSetVisible(homeScreen.staticimage[i],false)
			end
		end
		if guiGetVisible(homeScreen.staticimage[18]) then
			for i=18,21 do
				guiSetVisible(homeScreen.staticimage[i],false)
			end
		end
		local a,b,c,d,e,f = getCameraMatrix(localPlayer)
		smoothMoveCamera(a,b,c,d,e,f,1720.41125,-1646.7942,21.0576,1721.21911,-1647.3781,20.9919,1000)
		showStatistics()
	else
		-- IN CASE ALL FAILS, SEND TO HOME
		if guiGetVisible(homeScreen.staticimage[5]) then
			guiSetVisible(homeScreen.staticimage[5],false)
		end
		if guiGetVisible(homeScreen.staticimage[6]) then
			for i=6,17 do
				guiSetVisible(homeScreen.staticimage[i],false)
			end
		end
		if guiGetVisible(homeScreen.staticimage[18]) then
			for i=18,21 do
				guiSetVisible(homeScreen.staticimage[i],false)
			end
		end
		local a,b,c,d,e,f = getCameraMatrix(localPlayer)
		smoothMoveCamera(a,b,c,d,e,f,1720.41125,-1646.7942,21.0576,1721.21911,-1647.3781,20.9919,1000)
		smoothMoveForward = false
	end
	setTimer(function() smoothMoveForward = false end,500,1)
end

testTable = {
["gamesplayed"] = 3,
["wins"] = 99,
["losses"] = 0,
["winlossratio"] = 0,
["kills"] = 0,
["deaths"] = 9001,
["killdeathratio"] = 0,
["headshots"] = 1,
["battlepoints"] = -5,
["battlepointsspent"] = 69,
["skins"] = {57,90,125,127,128},
["crates"] = {
	["Legendary"] = 20,
	["Epic"] = -1,
	["Uncommon"] = 3,
	["Common"] = 69,
	},
}

function doItNow()
	getStatisticsTableFromDB(testTable)
end

local statisticsTable = {}
local temporarySkinTable = {}
local temporaryCrateTable = {}
-- Is there a better way to accomplish this?
function getStatisticsTableFromDB(theTable)
	statisticsTable[localPlayer] = {}
	temporarySkinTable[localPlayer] = {}
	temporaryCrateTable[localPlayer] = {}
	for i, data in pairs(theTable) do
		if type(data) ~= "table" then	
			table.insert(statisticsTable[localPlayer],{i,data})
			if i == "battlepoints" then
				guiSetText(homeScreen.label[6],tostring(data))
			end
		else
			if i == "skins" then
				table.insert(temporarySkinTable[localPlayer],{data})
			elseif i == "crates" then
				for k, crate in pairs(data) do
					table.insert(temporaryCrateTable[localPlayer],{k,crate})
				end
			end
		end
	end
end
addEvent("mtabg_getStatisticsTableFromDB",true)
addEventHandler("mtabg_getStatisticsTableFromDB",root,getStatisticsTableFromDB)

function showStatistics()
	for i, data in ipairs(statisticsTable[localPlayer]) do
		if type(data[2]) ~= "table" then
			if data[1] == "winlossratio" then
				guiSetText(homeScreen.label[data[1].."_value"],tostring(data[2]).."%")
			elseif data[1] == "killdeathratio" then
				guiSetText(homeScreen.label[data[1].."_value"],tostring(data[2]).."%")
			else
				guiSetText(homeScreen.label[data[1].."_value"],tostring(data[2]))
			end
		end
	end
	guiSetVisible(homeScreen.staticimage[5],true)
end

function moveBackgroundBack()
	guiMoveToBack(homeScreen.staticimage[1])
end
addEventHandler("onClientGUIClick",homeScreen.staticimage[1],moveBackgroundBack,false)


function showRewards()
	for i=6,17 do
		guiSetVisible(homeScreen.staticimage[i],true)
	end
	
	for i, data in ipairs(temporaryCrateTable[localPlayer]) do
		guiSetText(homeScreen.label[data[1]],guiGetText(homeScreen.label[data[1]]).." "..tostring(data[2]))
	end
end

function showCharacters()
	for i=18,21 do
		guiSetVisible(homeScreen.staticimage[i],true)
	end
	for i, data in ipairs(temporarySkinTable[localPlayer]) do
		for k, skin in ipairs(data) do
			if skin[1] then
				setElementModel(localPlayer,skin[1])
			end
		end
	end
	setTimer(setElementRotation,50,1,localPlayer,0,0,80.0553)
end


local arrowLeftRight = 1
function changeCharacterOnArrowClick(guiLabel,state)
	if state then
		if source == homeScreen.label[39] then -- ->
			for i, data in ipairs(temporarySkinTable[localPlayer]) do
				for k, skin in ipairs(data) do
					arrowLeftRight = arrowLeftRight+1
					if arrowLeftRight > #skin then
						arrowLeftRight = 1
					end
					setElementModel(localPlayer,skin[arrowLeftRight])
					setElementRotation(localPlayer,0,0,80.0553)
				end
			end
		else -- <-
			for i, data in ipairs(temporarySkinTable[localPlayer]) do
				for k, skin in ipairs(data) do
					arrowLeftRight = arrowLeftRight-1
					if arrowLeftRight <= 0 then
						arrowLeftRight = #skin
					end
					setElementModel(localPlayer,skin[arrowLeftRight])
					setElementRotation(localPlayer,0,0,80.0553)
				end
			end
		end
	end
end
addEventHandler("onClientGUIClick",homeScreen.label[38],changeCharacterOnArrowClick,false)
addEventHandler("onClientGUIClick",homeScreen.label[39],changeCharacterOnArrowClick,false)

-- World sound group 5
function getMatrixAgain()
	local x,y,z = getElementPosition(localPlayer)
	local r,v,w = getElementRotation(localPlayer)
	local a,b,c,d,e,f,g,h = getCameraMatrix(localPlayer)
	outputChatBox(tostring(x)..", "..tostring(y)..", "..tostring(z))
	outputChatBox(tostring(r)..", "..tostring(v)..", "..tostring(w))
	outputChatBox(tostring(a)..", "..tostring(b)..", "..tostring(c))
	outputChatBox(tostring(d)..", "..tostring(e)..", "..tostring(f))
	outputChatBox(tostring(g)..", "..tostring(h))
end
addCommandHandler("getit",getMatrixAgain)
