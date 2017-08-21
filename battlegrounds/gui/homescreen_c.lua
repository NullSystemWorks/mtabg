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

homeScreen.staticimage[1] = guiCreateStaticImage(0.00, 0.00, 1.00, 1.00, "/gui/images/background_transparent.png", true)
homeScreen.staticimage[2] = guiCreateStaticImage(0.00, 0.02, 1.00, 0.06, "/gui/images/solo_slot.png", true, homeScreen.staticimage[1])
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
homeScreen.label[3] = guiCreateLabel(0.65, 0.29, 0.16, 0.45, "REWARDS", true, homeScreen.staticimage[2])
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
homeScreen.staticimage[4] = guiCreateStaticImage(0.87, 0.11, 0.05, 0.05,"/gui/images/battlepointsicon.png",true,homeScreen.staticimage[1])
homeScreen.label[6] = guiCreateLabel(0.95, 0.11, 0.12, 0.05, "0", true, homeScreen.staticimage[1])
guiLabelSetVerticalAlign(homeScreen.label[6], "center")
guiSetFont(homeScreen.label[6],homeScreen.font[1])	
homeScreen.staticimage[3] = guiCreateStaticImage(0.00, 0.00, 0.30, 0.15, "/gui/images/button.png", true, homeScreen.staticimage[1])	
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
guiSetVisible(homeScreen.staticimage[1],false)

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
function sendToHomeScreen()
	soundtrack = playSound("/sounds/Unsung Briefing.mp3",true)
	setSoundVolume(soundtrack,0.4)
	setCameraMatrix(230.7577,1821.9936,7.97499,229.7822,1822.2131,7.9858,0,70)
	setElementModel(localPlayer,0)
	setElementPosition(localPlayer,227.483932,1822.46862,7.4140625)
	setElementRotation(localPlayer,0,0,257.32000732422)
	setElementDimension(localPlayer,500)
	setElementFrozen(localPlayer,true)
	guiSetVisible(homeScreen.staticimage[1],true)
	myScreenSource = dxCreateScreenSource ( screenX,screenY)
	showCursor(true)
end
addEvent("mtabg_sendToHomeScreen",true)
addEventHandler("mtabg_sendToHomeScreen",root,sendToHomeScreen)

--Debug Function
addCommandHandler("home",sendToHomeScreen)

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
		showCursor(false)
		stopSound(soundtrack)
		myScreenSource = false
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
				-- Function to send player to appropriate option
			else
				guiLabelSetColor(homeScreen.label[i],197,197,197)
			end
		end
	end
end
for i=1,4 do
	addEventHandler("onClientGUIClick",homeScreen.label[i],sendPlayerToOptionOnPress,false)
end

addEventHandler("onClientRender",root,function()
	if myScreenSource then
		dxUpdateScreenSource(myScreenSource)
		dxDrawImage(0,0,screenX,screenY,myScreenSource)
	end
end)
