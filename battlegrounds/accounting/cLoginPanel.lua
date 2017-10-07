--[[

				MTA:BG
			MTA Battlegrounds
	Developed By: Null System Works

]]--



local anticheat_avatar = false
local soundtrack = false

LoginScreen = {
	checkbox = {},
    staticimage = {},
    label = {},
    edit = {}
}

LoginScreen.staticimage[1] = guiCreateStaticImage(0.00, 0.00, 1.00, 1.00, "accounting/img/background.png", true)
LoginScreen.staticimage[2] = guiCreateStaticImage(0.11, 0.06, 0.77, 0.28, "accounting/img/battlegrounds_logo.png", true, LoginScreen.staticimage[1])
LoginScreen.edit[1] = guiCreateEdit(0.35, 0.41, 0.29, 0.05, "", true, LoginScreen.staticimage[1]) -- ID
guiEditSetReadOnly(LoginScreen.edit[1], true)
LoginScreen.label[1] = guiCreateLabel(0.27, 0.42, 0.08, 0.04, "ID", true, LoginScreen.staticimage[1])
guiSetFont(LoginScreen.label[1], "default-bold-small")
guiLabelSetHorizontalAlign(LoginScreen.label[1], "center", false)
LoginScreen.edit[2] = guiCreateEdit(0.35, 0.50, 0.29, 0.05, "", true, LoginScreen.staticimage[1]) -- PWD
guiEditSetMasked(LoginScreen.edit[2],true)
LoginScreen.edit[3] = guiCreateEdit(0.35, 0.32, 0.29, 0.05, "", true, LoginScreen.staticimage[1]) -- Alpha key
LoginScreen.label[7] = guiCreateLabel(0.27, 0.33, 0.08, 0.04, "KEY", true, LoginScreen.staticimage[1])
guiSetFont(LoginScreen.label[7], "default-bold-small")
guiLabelSetHorizontalAlign(LoginScreen.label[7], "center", false)
LoginScreen.label[2] = guiCreateLabel(0.27, 0.51, 0.08, 0.04, "PWD", true, LoginScreen.staticimage[1])
guiSetFont(LoginScreen.label[2], "default-bold-small")
guiLabelSetHorizontalAlign(LoginScreen.label[2], "center", false)
LoginScreen.checkbox[1] = guiCreateCheckBox(0.35, 0.56, 0.21, 0.02, "Remember Password (PWD)", false, true, LoginScreen.staticimage[1])
LoginScreen.staticimage[3] = guiCreateStaticImage(0.35, 0.66, 0.29, 0.07, "accounting/img/white.png", true, LoginScreen.staticimage[1])
guiSetProperty(LoginScreen.staticimage[3], "ImageColours", "tl:FFF48E0A tr:FFF48E0A bl:FFF48E0A br:FFF48E0A")
LoginScreen.label[4] = guiCreateLabel(0.00, 0.00, 1.00, 1.00, "LOGIN", true, LoginScreen.staticimage[3])
guiLabelSetHorizontalAlign(LoginScreen.label[4], "center", false)
guiLabelSetVerticalAlign(LoginScreen.label[4], "center")
LoginScreen.staticimage[4] = guiCreateStaticImage(0.35, 0.66, 0.29, 0.07, "accounting/img/white.png", true, LoginScreen.staticimage[1])
guiSetProperty(LoginScreen.staticimage[4], "ImageColours", "tl:FFF48E0A tr:FFF48E0A bl:FFF48E0A br:FFF48E0A")
LoginScreen.label[5] = guiCreateLabel(0.00, 0.00, 1.00, 1.00, "REGISTER", true, LoginScreen.staticimage[4])
guiLabelSetHorizontalAlign(LoginScreen.label[5], "center", false)
guiLabelSetVerticalAlign(LoginScreen.label[5], "center")
LoginScreen.label[6] = guiCreateLabel(0.25, 0.588, 0.46, 0.05, "", true, LoginScreen.staticimage[1])

local function clickRegisterButton()
	local password = guiGetText(LoginScreen.edit[2])
	local alphaKey = guiGetText(LoginScreen.edit[3])
	triggerServerEvent("mtabg_register", localPlayer, password, "None", false, alphaKey)
end

local function clickLoginButton()
	triggerServerEvent("mtabg_login", localPlayer, guiGetText(LoginScreen.edit[2]))
end

local function closeLoginPanel()
	loginPanel(false)
	-- showCursor(false) --WTF: should this really be here?
	loadingBar.hide()
	guiSetVisible(homeScreen.staticimage[1],true)
	fadeCamera(true)
end

local function showLoadingBar()
	for k, v in ipairs(loadingBar.bar) do
		loadingBar.bar[k]:setRendering(true) --start rendering all textures
	end
	loadingBar.changeIcon(1) --start with faded V icon
end
addEventHandler("onClientResourceStart", resourceRoot, showLoadingBar)

local function resetLoadingBar()
	loadingBar.setWaiting(false)
	loadingBar.bar[4]:setA(0) -- hide red bar
	loadingBar.bar[5]:setA(0) -- hide green bar
	loadingBar.changeIcon(1)
end

local function loadingBarSetProgress(progress)
	loadingBar.setProgress(progress)
	resetLoadingBar()
end
addEvent("onLoginLoadingBarSetProgress", true)
addEventHandler("onLoginLoadingBarSetProgress", localPlayer, loadingBarSetProgress)

--TODO: expand to handle hashingResults, not only success
local function hashingEnd()
	showError("Welcome!") --TODO: error? right...
	loadingBar.setDone(true)
	Timer( closeLoginPanel, 2000, 1) --close login panel after a while
	--TODO: get this into a proper function
	removeEventHandler("onClientGUIClick",LoginScreen.label[4], clickLoginButton)
	removeEventHandler("onClientGUIClick",LoginScreen.label[5], clickRegisterButton)
end
addEvent("mtabg_registerDone", true)
addEventHandler("mtabg_registerDone", localPlayer, hashingEnd)

local function hashingStart()
	resetLoadingBar()
	loadingBar.setWaiting(true)
end
addEvent("onHashingStart", true)
addEventHandler("onHashingStart", localPlayer, hashingStart)

local errorFont
local screenSize = guiGetScreenSize()
if screenSize >= 1920 then
	errorFont = guiCreateFont("fonts/tahomab.ttf",13)
elseif screenSize >= 1336 then
	errorFont = guiCreateFont("fonts/tahomab.ttf",8)
elseif screenSize >= 800 then
	errorFont = guiCreateFont("fonts/tahomab.ttf",6)
else
	errorFont = guiCreateFont("fonts/tahomab.ttf",5)
end
guiSetFont ( LoginScreen.label[6], errorFont )

guiLabelSetHorizontalAlign(LoginScreen.label[6], "center", false)
guiLabelSetVerticalAlign(LoginScreen.label[6], "center")

guiSetVisible(LoginScreen.staticimage[1],false)

function loginPanel(state)
	if state then
		guiSetVisible(LoginScreen.staticimage[1],true)
		addEventHandler("onClientGUIClick", LoginScreen.label[4], clickLoginButton, false)
		addEventHandler("onClientGUIClick", LoginScreen.label[5], clickRegisterButton, false)
		guiBringToFront(LoginScreen.staticimage[1])
		copyright = guiCreateLabel(0.00, 0.97, 0.46, 0.03, "MTA:Battlegrounds ©2017 Null System Works. All Rights Reserved.", true, LoginScreen.staticimage[1])
		guiSetAlpha(copyright, 0.35)
		guiLabelSetHorizontalAlign(copyright, "left", true)
		if not soundtrack then
			soundtrack = playSound("sounds/siege.mp3",true)
			setSoundVolume(soundtrack,0.1)
		end
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
		removeEventHandler("onClientGUIClick",LoginScreen.label[4], clickLoginButton)
		removeEventHandler("onClientGUIClick",LoginScreen.label[5], clickRegisterButton)
		stopSound(soundtrack)
		soundtrack = false
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
		LoginScreen.staticimage[3] = guiCreateStaticImage(0.47, 0.50, 0.06, 0.04, ":accounting/img/white.png", true, Loginbg)
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
		RegisterScreen.staticimage[2] = guiCreateStaticImage(0.46, 0.16, 0.08, 0.14, ":accounting/img/defaultavatar.png", true, Loginbg)

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
		RegisterScreen.staticimage[3] = guiCreateStaticImage(0.47, 0.56, 0.06, 0.04, ":accounting/img/white.png", true, Loginbg)
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
		RegisterScreen.staticimage[4] = guiCreateStaticImage(0.55, 0.16, 0.13, 0.14, ":accounting/img/white.png", true, Loginbg)
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


        RegisterScreen.staticimage[5] = guiCreateStaticImage(0.44, 0.16, 0.02, 0.03, ":accounting/img/white.png", true, Loginbg)
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


function showError(errorMsg)
	guiSetText(LoginScreen.label[6],tostring(errorMsg))
	setTimer(function()
		guiSetText(LoginScreen.label[6],"")
	end,3000,1)
	loadingBar.setDone(false)
end
addEvent("MTABG_LoginError", true)
addEventHandler("MTABG_LoginError", getRootElement(), showError)

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
