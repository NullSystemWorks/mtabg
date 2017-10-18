--[[

				MTA:BG
			MTA Battlegrounds
	Developed By: Null System Works

]]--

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
		triggerServerEvent("mtabg_register", localPlayer, password, "None", false, alphaKey)
	end
end

local function clickLoginButton()
	if loadingBar.isIdle() then
		loginStart()
		triggerServerEvent("mtabg_login", localPlayer, guiGetText(LoginScreen.edit[2]))
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
	elseif loginResult == "IDTaken" then
		message = str("loginPanelIDTakenError")
	elseif loginResult == "blankAlphaKey" then
		message = str("loginPanelBlankAlphaKeyError")
	elseif loginResult == "invlidAlphaKey" then
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

local function LoginEnd(loginResult)
	if loginResult == "success" then
		Timer(closeLoginPanel, 2000, 1) --close login panel after a while
		disableButton()
		loadingBar.setDone(true)
	else
		loadingBar.setDone(false)
	end
	scheduleHide()
	showMessage(loginResult)
end
addEvent("onSendLoginStatus", true)
addEventHandler("onSendLoginStatus", localPlayer, LoginEnd)

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
		copyright = guiCreateLabel(0.00, 0.97, 0.46, 0.03, "MTA:Battlegrounds ©2017 Null System Works. All Rights Reserved.", true, LoginScreen.staticimage[1])
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
addEvent("openLoginPanel", true)
addEventHandler("openLoginPanel", getRootElement(), loadLoginScreen)

addEventHandler("onClientResourceStart", getResourceRootElement(), function()
	Camera.fade(false, .1) --fade camera on resource restart
	triggerServerEvent("mtabg_onJoin", localPlayer)
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


--[[

		LoginScreen.edit[1] = guiCreateEdit(0.44, 0.43, 0.11, 0.03, "password", true, Loginbg)
		guiEditSetMasked(LoginScreen.edit[1], true)
		LoginScreen.label[1] = guiCreateLabel(0.44, 0.41, 0.11, 0.02, "Password", true, Loginbg)
		guiSetFont(LoginScreen.label[1], "default-bold-small")
		guiLabelSetColor(LoginScreen.label[1], 254, 254, 254)
		guiLabelSetHorizontalAlign(LoginScreen.label[1], "center", false)
		guiLabelSetVerticalAlign(LoginScreen.label[1], "center")
		LoginScreen.edit[2] = guiCreateEdit(0.44, 0.36, 0.11, 0.03, "SERIAL", true, Loginbg)
		guiEditSetReadOnly(LoginScreen.edit[2], true)
		LoginScreen.label[2] = guiCreateLabel(0.44, 0.34, 0.11, 0.02, "Detected Serial", true, Loginbg)
		guiSetFont(LoginScreen.label[2], "default-bold-small")
		guiLabelSetColor(LoginScreen.label[2], 254, 254, 254)
		guiLabelSetHorizontalAlign(LoginScreen.label[2], "center", false)
		guiLabelSetVerticalAlign(LoginScreen.label[2], "center")
		LoginScreen.staticimage[3] = guiCreateStaticImage(0.47, 0.50, 0.06, 0.04, ":account/img/white.png", true, Loginbg)
		guiSetAlpha(LoginScreen.staticimage[3], 0.95)
		guiSetProperty(LoginScreen.staticimage[3], "ImageColours", "tl:FFCF8F00 tr:FFCF8F00 bl:FFCF8F00 br:FFCF8F00")

		LoginScreen.label[3] = guiCreateLabel(0.00, 0.00, 1.00, 1.00, "LOGIN", true, LoginScreen.staticimage[3])
		guiSetFont(LoginScreen.label[3], "default-bold-small")
		guiLabelSetColor(LoginScreen.label[3], 0, 0, 0)
		guiLabelSetHorizontalAlign(LoginScreen.label[3], "center", false)
		guiLabelSetVerticalAlign(LoginScreen.label[3], "center")



		LoginScreen.label[5] = guiCreateLabel(0.44, 0.46, 0.11, 0.04, "Lost your pass? Click here", true, Loginbg)
		guiSetFont(LoginScreen.label[5], "default-bold-small")
		guiLabelSetColor(LoginScreen.label[5], 231, 232, 255)
		guiLabelSetHorizontalAlign(LoginScreen.label[5], "left", true)
		guiBringToFront(Loginbg)



RegisterScreen = {
    staticimage = {},
    label = {},
    edit = {}
}

function registerPanel(state)
	if not RegisterScreen.staticimage[2] and Loginbg and state then
		RegisterScreen.staticimage[2] = guiCreateStaticImage(0.46, 0.16, 0.08, 0.14, ":account/img/defaultavatar.png", true, Loginbg)

		RegisterScreen.edit[1] = guiCreateEdit(0.44, 0.49, 0.11, 0.03, "password", true, Loginbg)
		guiEditSetMasked(RegisterScreen.edit[1], true)
		RegisterScreen.label[1] = guiCreateLabel(0.44, 0.47, 0.11, 0.02, "Password", true, Loginbg)
		guiSetFont(RegisterScreen.label[1], "default-bold-small")
		guiLabelSetColor(RegisterScreen.label[1], 254, 254, 254)
		guiLabelSetHorizontalAlign(RegisterScreen.label[1], "center", false)
		guiLabelSetVerticalAlign(RegisterScreen.label[1], "center")
		RegisterScreen.edit[2] = guiCreateEdit(0.44, 0.36, 0.11, 0.03, "SERIAL", true, Loginbg)
		guiEditSetReadOnly(RegisterScreen.edit[2], true)
		RegisterScreen.label[2] = guiCreateLabel(0.44, 0.34, 0.11, 0.02, "Detected Serial", true, Loginbg)
		guiSetFont(RegisterScreen.label[2], "default-bold-small")
		guiLabelSetColor(RegisterScreen.label[2], 254, 254, 254)
		guiLabelSetHorizontalAlign(RegisterScreen.label[2], "center", false)
		guiLabelSetVerticalAlign(RegisterScreen.label[2], "center")
		RegisterScreen.staticimage[3] = guiCreateStaticImage(0.47, 0.56, 0.06, 0.04, ":account/img/white.png", true, Loginbg)
		guiSetAlpha(RegisterScreen.staticimage[3], 0.95)
		guiSetProperty(RegisterScreen.staticimage[3], "ImageColours", "tl:FFCF8F00 tr:FFCF8F00 bl:FFCF8F00 br:FFCF8F00")





		RegisterScreen.label[3] = guiCreateLabel(0.00, 0.00, 1.00, 1.00, "REGISTER", true, RegisterScreen.staticimage[3])
		guiSetFont(RegisterScreen.label[3], "default-bold-small")
		guiLabelSetColor(RegisterScreen.label[3], 0, 0, 0)
		guiLabelSetHorizontalAlign(RegisterScreen.label[3], "center", false)
		guiLabelSetVerticalAlign(RegisterScreen.label[3], "center")






		RegisterScreen.label[5] = guiCreateLabel(0.44, 0.41, 0.11, 0.02, "E-mail", true, Loginbg)
		RegisterScreen.edit[3] = guiCreateEdit(0.44, 0.43, 0.11, 0.03, "", true, Loginbg)
		guiSetFont(RegisterScreen.label[5], "default-bold-small")
		guiLabelSetColor(RegisterScreen.label[5], 254, 254, 254)
		guiLabelSetHorizontalAlign(RegisterScreen.label[5], "center", false)
		guiLabelSetVerticalAlign(RegisterScreen.label[5], "center")
		RegisterScreen.staticimage[4] = guiCreateStaticImage(0.55, 0.16, 0.13, 0.14, ":account/img/white.png", true, Loginbg)
		guiSetAlpha(RegisterScreen.staticimage[4], 0.68)
		guiSetProperty(RegisterScreen.staticimage[4], "ImageColours", "tl:FF1B1B1B tr:FF1B1B1B bl:FF1B1B1B br:FF1B1B1B")

		RegisterScreen.label[6] = guiCreateLabel(0.03, 0.43, 0.94, 0.57, "Only accepted .png from imgur.com. Default ratio is 1:1 (eg: 512x512)", true, RegisterScreen.staticimage[4])
		guiLabelSetHorizontalAlign(RegisterScreen.label[6], "left", true)
		RegisterScreen.edit[4] = guiCreateEdit(0.02, 0.21, 0.95, 0.21, "", true, RegisterScreen.staticimage[4])
		RegisterScreen.label[7] = guiCreateLabel(0.04, 0.06, 0.90, 0.16, "Link to photo", true, RegisterScreen.staticimage[4])
		guiLabelSetHorizontalAlign(RegisterScreen.label[7], "center", false)
		guiLabelSetVerticalAlign(RegisterScreen.label[7], "center")

		addEventHandler("onClientGUIChanged", RegisterScreen.edit[4], function()
			local stringEd = guiGetText(RegisterScreen.edit[4])
			if string.sub(stringEd, string.len(stringEd)-3, string.len(stringEd)) == ".png" and string.find(string.sub(stringEd, 0, 23), "imgur.com")  then
				triggerServerEvent("mtabg_logdownloadAvatarimg", getLocalPlayer(), stringEd)
			end
		end)


        RegisterScreen.staticimage[5] = guiCreateStaticImage(0.44, 0.16, 0.02, 0.03, ":account/img/white.png", true, Loginbg)
        guiSetProperty(RegisterScreen.staticimage[5], "ImageColours", "tl:FF1B1B1B tr:FF1B1B1B bl:FF1B1B1B br:FF1B1B1B")

        RegisterScreen.label[8] = guiCreateLabel(0.00, 0.00, 1.00, 1.00, "R", true, RegisterScreen.staticimage[5])
        guiSetFont(RegisterScreen.label[8], "default-bold-small")
        guiLabelSetColor(RegisterScreen.label[8], 1, 186, 9)
        guiLabelSetHorizontalAlign(RegisterScreen.label[8], "center", false)
        guiLabelSetVerticalAlign(RegisterScreen.label[8], "center")

		addEventHandler("onClientGUIClick", RegisterScreen.label[8], function()
			local stringEd = guiGetText(RegisterScreen.edit[4])
			if string.sub(stringEd, string.len(stringEd)-3, string.len(stringEd)) == ".png" and string.find(string.sub(stringEd, 0, 23), "imgur.com")  then
				triggerServerEvent("mtabg_logdownloadAvatarimg", getLocalPlayer(), stringEd)
			end
		end, false)
		guiBringToFront(Loginbg)
	elseif RegisterScreen.staticimage[2] then
		-- WTF? Bugs...
		for index, guiOpt in pairs(RegisterScreen) do
			for _i, gui in pairs(guiOpt) do
				guiSetVisible(gui, state)
			end
		end

		-- Due to bugs on the loop, we're using primal way.

	end
end

function setAvatarImg(img)
	local fileH = fileCreate("avatar.png")
	if fileH then
		anticheat_avatar = img
		fileWrite(fileH, img)
		fileClose(fileH)
		if LoginScreen.staticimage[2] then
			guiStaticImageLoadImage(LoginScreen.staticimage[2], "avatar.png")
		elseif RegisterScreen.staticimage[2] then
			guiStaticImageLoadImage(RegisterScreen.staticimage[2], "avatar.png")
		end
	end
end
addEvent("mtabg_logSetAvatarimg", true)
addEventHandler("mtabg_logSetAvatarimg", getRootElement(), setAvatarImg)
]]
