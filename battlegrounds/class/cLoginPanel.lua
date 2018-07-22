local Music = Music.loginPanel

local anticheat_avatar = false

LoginScreen = {
	checkbox = {},
	staticimage = {},
	label = {},
	edit = {}
}

LoginScreen.staticimage[1] = guiCreateStaticImage(0.00, 0.00, 1.00, 1.00, "account/img/background.png", true)
LoginScreen.staticimage[2] = guiCreateStaticImage(0.11, 0.06, 0.77, 0.28, "account/img/battlegrounds_logo.png", true, LoginScreen.staticimage[1])
LoginScreen.edit[1] = guiCreateEdit(0.35, 0.41, 0.29, 0.05, "", true, LoginScreen.staticimage[1]) -- ID
guiEditSetReadOnly(LoginScreen.edit[1], true)
LoginScreen.label[1] = guiCreateLabel(0.27, 0.42, 0.08, 0.04, str("loginPanelID"), true, LoginScreen.staticimage[1])
guiSetFont(LoginScreen.label[1], "default-bold-small")
guiLabelSetHorizontalAlign(LoginScreen.label[1], "center", false)
LoginScreen.edit[2] = guiCreateEdit(0.35, 0.50, 0.29, 0.05, "", true, LoginScreen.staticimage[1]) -- PWD
guiEditSetMasked(LoginScreen.edit[2],true)
LoginScreen.edit[3] = guiCreateEdit(0.35, 0.32, 0.29, 0.05, "", true, LoginScreen.staticimage[1]) -- Alpha key
LoginScreen.label[7] = guiCreateLabel(0.27, 0.33, 0.08, 0.04, str("loginPanelKey"), true, LoginScreen.staticimage[1])
guiSetFont(LoginScreen.label[7], "default-bold-small")
guiLabelSetHorizontalAlign(LoginScreen.label[7], "center", false)
LoginScreen.label[2] = guiCreateLabel(0.27, 0.51, 0.08, 0.04, str("loginPanelPassword"), true, LoginScreen.staticimage[1])
guiSetFont(LoginScreen.label[2], "default-bold-small")
guiLabelSetHorizontalAlign(LoginScreen.label[2], "center", false)
LoginScreen.checkbox[1] = guiCreateCheckBox(0.35, 0.56, 0.21, 0.02, str("loginPanelRememberPassword"), false, true, LoginScreen.staticimage[1])
LoginScreen.staticimage[3] = guiCreateStaticImage(0.35, 0.66, 0.29, 0.07, "account/img/white.png", true, LoginScreen.staticimage[1])
guiSetProperty(LoginScreen.staticimage[3], "ImageColours", "tl:FFF48E0A tr:FFF48E0A bl:FFF48E0A br:FFF48E0A")
LoginScreen.label[4] = guiCreateLabel(0.00, 0.00, 1.00, 1.00, str("loginPanelLoginButton"), true, LoginScreen.staticimage[3])
guiLabelSetHorizontalAlign(LoginScreen.label[4], "center", false)
guiLabelSetVerticalAlign(LoginScreen.label[4], "center")
LoginScreen.staticimage[4] = guiCreateStaticImage(0.35, 0.66, 0.29, 0.07, "account/img/white.png", true, LoginScreen.staticimage[1])
guiSetProperty(LoginScreen.staticimage[4], "ImageColours", "tl:FFF48E0A tr:FFF48E0A bl:FFF48E0A br:FFF48E0A")
LoginScreen.label[5] = guiCreateLabel(0.00, 0.00, 1.00, 1.00, str("loginPanelRegisterButton"), true, LoginScreen.staticimage[4])
guiLabelSetHorizontalAlign(LoginScreen.label[5], "center", false)
guiLabelSetVerticalAlign(LoginScreen.label[5], "center")
LoginScreen.label[6] = guiCreateLabel(0.25, 0.588, 0.46, 0.05, "", true, LoginScreen.staticimage[1])

local function resetLoadingBar()
	loadingBar.setWaiting(false)
	loadingBar.bar[4]:setA(0) -- hide red bar
	loadingBar.bar[5]:setA(0) -- hide green bar
	loadingBar.changeIcon(1)
end

local function loginStart()
	resetLoadingBar()
	loadingBar.setWaiting(true)
end

local function clickRegisterButton()
	if loadingBar.isIdle() then
		local password = guiGetText(LoginScreen.edit[2])
		local alphaKey = guiGetText(LoginScreen.edit[3])
		loginStart()
		triggerServerEvent("onRegister", localPlayer, password, alphaKey)
	end
end

local function clickLoginButton()
	if loadingBar.isIdle() then
		loginStart()
		triggerServerEvent("onLogin", localPlayer, guiGetText(LoginScreen.edit[2]))
	end
end

local function disableButton()
	removeEventHandler("onClientGUIClick", LoginScreen.label[4], clickLoginButton)
	removeEventHandler("onClientGUIClick", LoginScreen.label[5], clickRegisterButton)
end

--TODO: make login and register the same button
local function enableButton()
	addEventHandler("onClientGUIClick", LoginScreen.label[4], clickLoginButton, false)
	addEventHandler("onClientGUIClick", LoginScreen.label[5], clickRegisterButton, false)
end

local function closeLoginPanel()
	loginPanel(false)
	loadingBar.hide()
	guiSetVisible(homeScreen.staticimage[1],true)
	fadeCamera(true)
	LanguageSelection.setShowing(true)
end

local function showLoadingBar()
	for k, v in ipairs(loadingBar.bar) do
		loadingBar.bar[k]:setRendering(true) --start rendering all textures
	end
	loadingBar.changeIcon(1) --start with faded V icon
end
addEventHandler("onClientResourceStart", resourceRoot, showLoadingBar)

local function loadingBarSetProgress(progress)
	loadingBar.setProgress(progress)
	resetLoadingBar()
end
addEvent("onLoginLoadingBarSetProgress", true)
addEventHandler("onLoginLoadingBarSetProgress", localPlayer, loadingBarSetProgress)

local msgTimer
local currentMessage
local function scheduleHide()
	if isTimer(msgTimer) then
		msgTimer:destroy()
	end
	msgTimer = Timer(
	function()
		guiSetText(LoginScreen.label[6], "")
		msgTimer = nil
		currentMessage = nil
		resetLoadingBar()
		loadingBar.setProgress(0)
	end, 3000, 1)
end

local function chooseMessage(loginResult)
	local message
	if loginResult == "unknownError" then
		message = str("loginPanelUnknownError")
	elseif loginResult == "wrongPass" then
		message = str("loginPanelInvalidAccountOrPasswordError")
	elseif loginResult == "noSerial" then
		message = str("loginPanelNoSerialError")
	elseif loginResult == "noPassword" then
		message = str("loginPanelEmptyPasswordError")
	elseif loginResult == "blankAlphaKey" then
		message = str("loginPanelBlankAlphaKeyError")
	elseif loginResult == "invalidAlphaKey" then
		message = str("loginPanelInvlidAlphaKeyError")
	elseif loginResult == "keyAlreadyUsed" then
		message = str("loginPanelKeyAlreadyUsedError")
	elseif loginResult == "success" then
		message = str("loginPanelWelcomeMessage")
	end
	return message
end

local function showMessage(loginResult)
	if loginResult or currentMessage then
		loginResult = loginResult or currentMessage
		currentMessage = loginResult
		guiSetText(LoginScreen.label[6], chooseMessage(loginResult))
	end
end

local function endLogin(loginResult)
	if loginResult == "success" then
		Timer(closeLoginPanel, 2000, 1) --close login panel after a while
		disableButton()
		loadingBar.setDone(true)
		sendToHomeScreen()
	else
		loadingBar.setDone(false)
	end
	scheduleHide()
	showMessage(loginResult)
end
addEvent("onSendLoginStatus", true)
addEventHandler("onSendLoginStatus", localPlayer, endLogin)

local errorFont
local screenSize = guiGetScreenSize()
if screenSize >= 1920 then
	errorFont = guiCreateFont("font/tahomab.ttf",13)
elseif screenSize >= 1336 then
	errorFont = guiCreateFont("font/tahomab.ttf",8)
elseif screenSize >= 800 then
	errorFont = guiCreateFont("font/tahomab.ttf",6)
else
	errorFont = guiCreateFont("font/tahomab.ttf",5)
end
guiSetFont ( LoginScreen.label[6], errorFont )

guiLabelSetHorizontalAlign(LoginScreen.label[6], "center", false)
guiLabelSetVerticalAlign(LoginScreen.label[6], "center")

guiSetVisible(LoginScreen.staticimage[1],false)

function loginPanel(state)
	if state then
		guiSetVisible(LoginScreen.staticimage[1],true)
		enableButton()
		guiBringToFront(LoginScreen.staticimage[1])
		copyright = guiCreateLabel(0.00, 0.97, 0.46, 0.03, "MTA:Battlegrounds ©2017, 2018 Null System Works. Licensed under AGPL3.", true, LoginScreen.staticimage[1])
		guiSetAlpha(copyright, 0.35)
		guiLabelSetHorizontalAlign(copyright, "left", true)
		Music.play()
		oldFile = xmlLoadFile("loginCredentials.xml")
		confFile = xmlLoadFile("@loginCredentials.xml")
		local checkbox = false
		local pass = ""
		if not confFile and oldFile then
			confFile = xmlCreateFile("@loginCredentials.xml","user")
			pass = xmlNodeGetAttribute(oldFile,"password")
			checkbox = xmlNodeGetAttribute(oldFile,"checkbox")
			xmlNodeSetAttribute(confFile, "password", pass)
			xmlNodeSetAttribute(confFile, "checkbox", checkbox)
			xmlSaveFile(confFile)
		end
		if oldFile then
			xmlUnloadFile(oldFile)
		end
		confFile = xmlLoadFile("@loginCredentials.xml")
		if (confFile) then
			pass = xmlNodeGetAttribute(confFile,"password")
			checkbox = xmlNodeGetAttribute(confFile,"checkbox")
			guiSetText(LoginScreen.edit[2],pass)
			if checkbox == "true" then
				checkbox = true
			else
				checkbox = false
			end
			guiCheckBoxSetSelected(LoginScreen.checkbox[1],checkbox)
		else
			confFile = xmlCreateFile("@loginCredentials.xml","user")
			xmlNodeSetAttribute(confFile,"password","")
			xmlNodeSetAttribute(confFile,"checkbox","true")
			pass = ""
			checkbox = true
			guiSetText(LoginScreen.edit[2],pass)
			guiCheckBoxSetSelected(LoginScreen.checkbox[1],checkbox)
		end
		xmlSaveFile(confFile)
		xmlUnloadFile(confFile)
	else
		if guiCheckBoxGetSelected(LoginScreen.checkbox[1]) then
			confFile = xmlLoadFile("@loginCredentials.xml")
			xmlNodeSetAttribute(confFile, "password", guiGetText(LoginScreen.edit[2]))
			xmlNodeSetAttribute(confFile, "checkbox", tostring(guiCheckBoxGetSelected(LoginScreen.checkbox[1])))
			xmlSaveFile(confFile)
			xmlUnloadFile(confFile)
		else
			confFile = xmlLoadFile("@loginCredentials.xml")
			xmlNodeSetAttribute(confFile, "password", "")
			xmlNodeSetAttribute(confFile, "checkbox", tostring(guiCheckBoxGetSelected(LoginScreen.checkbox[1])))
			xmlSaveFile(confFile)
			xmlUnloadFile(confFile)
		end
		guiSetVisible(LoginScreen.staticimage[1],false)
		disableButton()
	end
end

function changeColorOfLoginButtonOnMouseEnter()
	guiSetProperty(LoginScreen.staticimage[3], "ImageColours", "tl:FF3A8CF7 tr:FF3A8CF7 bl:FF3A8CF7 br:FF3A8CF7")
end
addEventHandler("onClientMouseEnter",LoginScreen.label[4],changeColorOfLoginButtonOnMouseEnter,false)

function changeColorOfLoginButtonOnMouseLeave()
	guiSetProperty(LoginScreen.staticimage[3], "ImageColours", "tl:FFF48E0A tr:FFF48E0A bl:FFF48E0A br:FFF48E0A")
end
addEventHandler("onClientMouseLeave",LoginScreen.label[4],changeColorOfLoginButtonOnMouseLeave,false)

function changeColorOfRegisterButtonOnMouseEnter()
	guiSetProperty(LoginScreen.staticimage[4], "ImageColours", "tl:FF3A8CF7 tr:FF3A8CF7 bl:FF3A8CF7 br:FF3A8CF7")
end
addEventHandler("onClientMouseEnter",LoginScreen.label[5],changeColorOfRegisterButtonOnMouseEnter,false)

function changeColorOfRegisterButtonOnMouseLeave()
	guiSetProperty(LoginScreen.staticimage[4], "ImageColours", "tl:FFF48E0A tr:FFF48E0A bl:FFF48E0A br:FFF48E0A")
end
addEventHandler("onClientMouseLeave",LoginScreen.label[5],changeColorOfRegisterButtonOnMouseLeave,false)

local hasAccount = false
function loadLoginScreen(serial, account)
	if guiGetVisible(LoginScreen.staticimage[1]) then return end
	loginPanel(true)
	guiSetVisible(LoginScreen.staticimage[1],true)
	guiSetText(LoginScreen.edit[1], serial)
	showCursor(true)
	hasAccount = account
	if not account then
		guiSetVisible(LoginScreen.edit[3], true)
		guiSetVisible(LoginScreen.label[7], true)
		guiSetVisible(LoginScreen.staticimage[3],false)
		guiSetVisible(LoginScreen.staticimage[4],true)
	else
		guiSetVisible(LoginScreen.edit[3], false)
		guiSetVisible(LoginScreen.label[7], false)
		guiSetVisible(LoginScreen.staticimage[3],true)
		guiSetVisible(LoginScreen.staticimage[4],false)
	end
end
addEvent("onOpenLoginPanel", true)
addEventHandler("onOpenLoginPanel", getRootElement(), loadLoginScreen)

addEventHandler("onClientResourceStart", getResourceRootElement(), function()
	Camera.fade(false, .1) --fade camera on resource restart
	triggerServerEvent("onJoin", resourceRoot)
end)


local function changeLanguage(newLang)
	LoginScreen.label[1]:setText(str("loginPanelID"))
	LoginScreen.label[7]:setText(str("loginPanelKey"))
	LoginScreen.label[2]:setText(str("loginPanelPassword"))
	LoginScreen.checkbox[1]:setText(str("loginPanelRememberPassword"))
	LoginScreen.label[4]:setText(str("loginPanelLoginButton"))
	LoginScreen.label[5]:setText(str("loginPanelRegisterButton"))
	showMessage()
end
addEventHandler("onUserLanguageChange", resourceRoot, changeLanguage)
