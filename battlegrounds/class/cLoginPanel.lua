local Music = Music.loginPanel

local imgBackground = GuiStaticImage(0.00, 0.00, 1.00, 1.00,
	"gui/img/pixel.png", true)
imgBackground:setProperty("ImageColours",
	"tl:00000000 tr:00000000 bl:00000000 br:00000000")

local imgLogo = GuiStaticImage(0.11, 0.06, 0.77, 0.28,
	"account/img/battlegrounds_logo.png", true, imgBackground)

local editId = GuiEdit(0.35, 0.41, 0.29, 0.05, "", true, imgBackground)
editId:setReadOnly(true)

local lblID =
	GuiLabel(0.27, 0.42, 0.08, 0.04, str("loginPanelID"), true, imgBackground)
lblID:setFont("default-bold-small")
lblID:setHorizontalAlign("center", false)

local lblPassword = GuiLabel(0.27, 0.51, 0.08, 0.04,
	str("loginPanelPassword"), true, imgBackground)
lblPassword:setFont("default-bold-small")
lblPassword:setHorizontalAlign("center", false)

local editPassword = GuiEdit(0.35, 0.50, 0.29, 0.05, "", true, imgBackground)
editPassword:setMasked(true)

local editAlphaKey = GuiEdit(0.35, 0.32, 0.29, 0.05, "", true, imgBackground)

local lblKey =
	GuiLabel(0.27, 0.33, 0.08, 0.04, str("loginPanelKey"), true, imgBackground)
lblKey:setFont("default-bold-small")
lblKey:setHorizontalAlign("center", false)

local checkRememberPassword = GuiCheckBox(0.35, 0.56, 0.21, 0.02,
	str("loginPanelRememberPassword"), false, true, imgBackground)

local loginButton = GuiStaticImage(0.35, 0.66, 0.29, 0.07,
	"account/img/white.png", true, imgBackground)

loginButton:setProperty("ImageColours",
	"tl:FFF48E0A tr:FFF48E0A bl:FFF48E0A br:FFF48E0A")

local lblLoginButton = GuiLabel(0.00, 0.00, 1.00, 1.00,
	str("loginPanelLoginButton"), true, loginButton)
lblLoginButton:setHorizontalAlign("center", false)
lblLoginButton:setVerticalAlign("center")

local registerButton = GuiStaticImage(0.35, 0.66, 0.29, 0.07,
	"account/img/white.png", true, imgBackground)

registerButton:setProperty("ImageColours",
	"tl:FFF48E0A tr:FFF48E0A bl:FFF48E0A br:FFF48E0A")

local lblRegisterButton = GuiLabel(0.00, 0.00, 1.00, 1.00,
	str("loginPanelRegisterButton"), true, registerButton)
lblRegisterButton:setHorizontalAlign("center", false)
lblRegisterButton:setVerticalAlign("center")

local lblLoginResult =
	GuiLabel(0.25, 0.588, 0.46, 0.05, "", true, imgBackground)

local function resetLoadingBar()
	LoadingBar.setWaiting(false)
	LoadingBar.bar[4]:setA(0) -- hide red bar
	LoadingBar.bar[5]:setA(0) -- hide green bar
	LoadingBar.changeIcon(1)
end

local function loginStart()
	resetLoadingBar()
	LoadingBar.setWaiting(true)
end

local function clickRegisterButton()
	if LoadingBar.isIdle() then
		local password = editPassword:getText()
		local alphaKey = editAlphaKey:getText()
		loginStart()
		triggerServerEvent("onRegister", localPlayer, password, alphaKey)
	end
end

local function clickLoginButton()
	if LoadingBar.isIdle() then
		loginStart()
		triggerServerEvent("onLogin", localPlayer, editPassword:getText())
	end
end

local function disableButton()
	removeEventHandler("onClientGUIClick", lblLoginButton, clickLoginButton)
	removeEventHandler("onClientGUIClick",
	                   lblRegisterButton, clickRegisterButton)
end

--TODO: make login and register the same button
local function enableButton()
	addEventHandler("onClientGUIClick",
	                lblLoginButton, clickLoginButton, false)
	addEventHandler("onClientGUIClick",
	                lblRegisterButton, clickRegisterButton, false)
end

local function showLoadingBar()
	for bar in ipairs(LoadingBar.bar) do
		LoadingBar.bar[bar]:setRendering(true) --start rendering all textures
	end
	LoadingBar.changeIcon(1) --start with faded V icon
end
addEventHandler("onClientResourceStart", resourceRoot, showLoadingBar)

local function loadingBarSetProgress(progress)
	LoadingBar.setProgress(progress)
	resetLoadingBar()
end
addEvent("onLoginLoadingBarSetProgress", true)
addEventHandler("onLoginLoadingBarSetProgress",
                localPlayer, loadingBarSetProgress)

local msgTimer
local currentMessage
local function scheduleHide()
	if isTimer(msgTimer) then
		msgTimer:destroy()
	end
	msgTimer = Timer(
		function()
			lblLoginResult:setText("")
			msgTimer = nil
			currentMessage = nil
			resetLoadingBar()
			LoadingBar.setProgress(0)
		end, 3000, 1)
end

local loginMessage =
{
	success = str("loginPanelWelcomeMessage"),
	keyAlreadyUsed = str("loginPanelKeyAlreadyUsedError"),
	invalidAlphaKey = str("loginPanelInvlidAlphaKeyError"),
	blankAlphaKey = str("loginPanelBlankAlphaKeyError"),
	noPassword = str("loginPanelEmptyPasswordError"),
	noSerial = str("loginPanelNoSerialError"),
	wrongPass = str("loginPanelInvalidAccountOrPasswordError"),
	unknownError = str("loginPanelUnknownError"),
}

local function chooseMessage(loginResult)
	return loginMessage[loginResult]
end

local function showMessage(loginResult)
	if loginResult or currentMessage then
		loginResult = loginResult or currentMessage
		currentMessage = loginResult
		lblLoginResult:setText(chooseMessage(loginResult))
	end
end

local errorFont
local screenSize = guiGetScreenSize()
if screenSize >= 1920 then
	errorFont = GuiFont("font/tahomab.ttf", 13)
elseif screenSize >= 1336 then
	errorFont = GuiFont("font/tahomab.ttf", 8)
elseif screenSize >= 800 then
	errorFont = GuiFont("font/tahomab.ttf", 6)
else
	errorFont = GuiFont("font/tahomab.ttf", 5)
end
lblLoginResult:setFont(errorFont)

lblLoginResult:setHorizontalAlign("center", false)
lblLoginResult:setVerticalAlign("center")

imgBackground:setVisible(false)

local function setVisible(state)
	if state then
		imgBackground:setVisible(true)
		enableButton()
		imgBackground:bringToFront()
		local copyright =
			GuiLabel(0.00, 0.97, 0.46, 0.03,
			         "MTA:Battlegrounds ©2017, 2018 Null System Works. "
				         .."Licensed under AGPL3.", true,
			         imgBackground)
		copyright:setAlpha(0.35)
		copyright:setHorizontalAlign("left", true)
		local sourceDownload =
			GuiLabel(0.00, 0.94, 0.49, 0.03,
			         "Gamemode source code can be found at: "
				         .."https://github.com/NullSystemWorks/mtabg", true,
			         imgBackground)
		sourceDownload:setAlpha(0.35)
		sourceDownload:setHorizontalAlign("left", true)
		Music.play()
		local oldFile = XML.load("loginCredentials.xml")
		local confFile = XML.load("@loginCredentials.xml")
		local checkbox = false
		local pass = ""
		if not confFile and oldFile then
			confFile = XML("@loginCredentials.xml", "user")
			pass = oldFile:getAttribute("password")
			checkbox = oldFile:getAttribute("checkbox")
			confFile:setAttribute("password", pass)
			confFile:setAttribute("checkbox", checkbox)
			confFile:saveFile()
		end
		if oldFile then
			oldFile:unload()
		end
		confFile = XML.load("@loginCredentials.xml")
		if(confFile) then
			pass = confFile:getAttribute("password")
			checkbox = confFile:getAttribute("checkbox")
			editPassword:setText(pass)
			if checkbox == "true" then
				checkbox = true
			else
				checkbox = false
			end
			checkRememberPassword:setSelected(checkbox)
		else
			confFile = XML("@loginCredentials.xml","user")
			confFile:setAttribute("password", "")
			confFile:setAttribute("checkbox", "true")
			pass = ""
			checkbox = true
			editPassword:setText(pass)
			checkRememberPassword:setSelected(checkbox)
		end
		confFile:saveFile()
		confFile:unload()
	else
		if checkRememberPassword:getSelected() then
			local confFile = XML.load("@loginCredentials.xml")
			confFile:setAttribute("password", editPassword:getText())
			confFile:setAttribute("checkbox",
				tostring(checkRememberPassword:getSelected()))
			confFile:saveFile()
			confFile:unload()
		else
			local confFile = XML.load("@loginCredentials.xml")
			confFile:setAttribute("password", "")
			confFile:setAttribute("checkbox",
				tostring(checkRememberPassword:getSelected()))
			confFile:saveFile()
			confFile:unload()
		end
		imgBackground:setVisible(false)
		disableButton()
	end
end

local function closeLoginPanel()
	setVisible(false)
	LoadingBar.hide()
	HomeScreen.setVisible(true)
	Camera.fade(true)
	LanguageSelection.setShowing(true)
end

local function endLogin(loginResult)
	if loginResult == "success" then
		disableButton()
		Timer(closeLoginPanel, 2000, 1) --close login panel after a while
		LoadingBar.setDone(true)
		HomeScreen.show()
	else
		LoadingBar.setDone(false)
	end
	scheduleHide()
	showMessage(loginResult)
end
addEvent("onSendLoginStatus", true)
addEventHandler("onSendLoginStatus", localPlayer, endLogin)

local function changeColorOfLoginButtonOnMouseEnter()
	loginButton:setProperty("ImageColours",
		"tl:FF3A8CF7 tr:FF3A8CF7 bl:FF3A8CF7 br:FF3A8CF7")
end
addEventHandler("onClientMouseEnter", lblLoginButton,
                changeColorOfLoginButtonOnMouseEnter, false)

local function changeColorOfLoginButtonOnMouseLeave()
	loginButton:setProperty("ImageColours",
		"tl:FFF48E0A tr:FFF48E0A bl:FFF48E0A br:FFF48E0A")
end
addEventHandler("onClientMouseLeave", lblLoginButton,
                changeColorOfLoginButtonOnMouseLeave, false)

local function changeColorOfRegisterButtonOnMouseEnter()
	registerButton:setProperty("ImageColours",
		"tl:FF3A8CF7 tr:FF3A8CF7 bl:FF3A8CF7 br:FF3A8CF7")
end
addEventHandler("onClientMouseEnter", lblRegisterButton,
                changeColorOfRegisterButtonOnMouseEnter,false)

local function changeColorOfRegisterButtonOnMouseLeave()
	registerButton:setProperty("ImageColours",
		"tl:FFF48E0A tr:FFF48E0A bl:FFF48E0A br:FFF48E0A")
end
addEventHandler("onClientMouseLeave", lblRegisterButton,
                changeColorOfRegisterButtonOnMouseLeave, false)

local hasAccount = false
local function loadLoginScreen(serial, account)
	if imgBackground:getVisible() then
		return
	end
	setVisible(true)
	imgBackground:setVisible(true)
	editId:setText(serial)
	showCursor(true)
	hasAccount = account
	if not account then
		editAlphaKey:setVisible(true)
		lblKey:setVisible(true)
		loginButton:setVisible(false)
		registerButton:setVisible(true)
	else
		editAlphaKey:setVisible(false)
		lblKey:setVisible(false)
		loginButton:setVisible(true)
		registerButton:setVisible(false)
	end
end
addEvent("onOpenLoginPanel", true)
addEventHandler("onOpenLoginPanel", localPlayer, loadLoginScreen)

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		Camera.fade(false, .1) --fade camera on resource restart
		triggerServerEvent("onJoin", resourceRoot)
	end
)

local function changeLanguage(newLang)
	lblID:setText(str("loginPanelID"))
	lblKey:setText(str("loginPanelKey"))
	lblPassword:setText(str("loginPanelPassword"))
	checkRememberPassword:setText(str("loginPanelRememberPassword"))
	lblLoginButton:setText(str("loginPanelLoginButton"))
	lblRegisterButton:setText(str("loginPanelRegisterButton"))
	showMessage()
end
addEventHandler("onUserLanguageChange", resourceRoot, changeLanguage)
