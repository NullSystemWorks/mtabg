--[[

				MTA:BG
			MTA Battlegrounds
	Developed By: Null System Works (L, CiBeR, neves768, 1BOY & expert975)
	
]]--



local anticheat_avatar = false

LoginScreen = {
    staticimage = {},
    label = {},
    edit = {}
}

function setLSVisibility(state)
	if not Loginbg and state then
		Loginbg = guiCreateStaticImage(0.00, 0.00, 1.00, 1.00, ":login/img/bg01.png", true)
		copyright = guiCreateLabel(0.00, 0.97, 0.46, 0.03, "MTA:Battlegrounds ©2017 Null System Works. All Rights Reserved.", true, Loginbg)
		guiSetAlpha(copyright, 0.35)
		guiLabelSetHorizontalAlign(copyright, "left", true)
	else
		guiSetVisible(Loginbg, state)
	end
end

function loginPanel(state)
	if not LoginScreen.staticimage[2] and Loginbg and state then
		LoginScreen.staticimage[2] = guiCreateStaticImage(0.46, 0.16, 0.08, 0.14, ":login/img/defaultavatar.png", true, Loginbg)
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
		LoginScreen.staticimage[3] = guiCreateStaticImage(0.47, 0.50, 0.06, 0.04, ":login/img/white.png", true, Loginbg)
		guiSetAlpha(LoginScreen.staticimage[3], 0.95)
		guiSetProperty(LoginScreen.staticimage[3], "ImageColours", "tl:FFCF8F00 tr:FFCF8F00 bl:FFCF8F00 br:FFCF8F00")

		LoginScreen.label[3] = guiCreateLabel(0.00, 0.00, 1.00, 1.00, "LOGIN", true, LoginScreen.staticimage[3])
		guiSetFont(LoginScreen.label[3], "default-bold-small")
		guiLabelSetColor(LoginScreen.label[3], 0, 0, 0)
		guiLabelSetHorizontalAlign(LoginScreen.label[3], "center", false)
		guiLabelSetVerticalAlign(LoginScreen.label[3], "center")
		
		addEventHandler("onClientGUIClick", LoginScreen.label[3], function()
			triggerServerEvent("mtabg_login", getLocalPlayer(), guiGetText(LoginScreen.edit[1]))
		end,false)

		LoginScreen.label[5] = guiCreateLabel(0.44, 0.46, 0.11, 0.04, "Lost your pass? Click here", true, Loginbg)
		guiSetFont(LoginScreen.label[5], "default-bold-small")
		guiLabelSetColor(LoginScreen.label[5], 231, 232, 255)
		guiLabelSetHorizontalAlign(LoginScreen.label[5], "left", true)
		guiBringToFront(Loginbg)
	elseif LoginScreen.staticimage[2] then
		--setLSVisibility(state)
		for index, guiOpt in pairs(LoginScreen) do
			for _i, gui in pairs(guiOpt) do
				guiSetVisible(gui, state)
			end
		end

	end
end


RegisterScreen = {
    staticimage = {},
    label = {},
    edit = {}
}

function registerPanel(state)
	if not RegisterScreen.staticimage[2] and Loginbg and state then
		RegisterScreen.staticimage[2] = guiCreateStaticImage(0.46, 0.16, 0.08, 0.14, ":login/img/defaultavatar.png", true, Loginbg)
		
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
		RegisterScreen.staticimage[3] = guiCreateStaticImage(0.47, 0.56, 0.06, 0.04, ":login/img/white.png", true, Loginbg)
		guiSetAlpha(RegisterScreen.staticimage[3], 0.95)
		guiSetProperty(RegisterScreen.staticimage[3], "ImageColours", "tl:FFCF8F00 tr:FFCF8F00 bl:FFCF8F00 br:FFCF8F00")

		
		
		
		
		RegisterScreen.label[3] = guiCreateLabel(0.00, 0.00, 1.00, 1.00, "REGISTER", true, RegisterScreen.staticimage[3])
		guiSetFont(RegisterScreen.label[3], "default-bold-small")
		guiLabelSetColor(RegisterScreen.label[3], 0, 0, 0)
		guiLabelSetHorizontalAlign(RegisterScreen.label[3], "center", false)
		guiLabelSetVerticalAlign(RegisterScreen.label[3], "center")

		addEventHandler("onClientGUIClick", RegisterScreen.label[3], function()
			local email = guiGetText(RegisterScreen.edit[3])
			local password = guiGetText(RegisterScreen.edit[1])
			local avatarAaang = false
			if anticheat_avatar then
				avatarAaang = base64Encode(anticheat_avatar)
				outputChatBox("ooh eyah")
			end
			triggerServerEvent("mtabg_register", getLocalPlayer(), email, password, avatarAaang)
		end, false)
		
		
		
		
		RegisterScreen.label[5] = guiCreateLabel(0.44, 0.41, 0.11, 0.02, "E-mail", true, Loginbg)
		RegisterScreen.edit[3] = guiCreateEdit(0.44, 0.43, 0.11, 0.03, "", true, Loginbg)
		guiSetFont(RegisterScreen.label[5], "default-bold-small")
		guiLabelSetColor(RegisterScreen.label[5], 254, 254, 254)
		guiLabelSetHorizontalAlign(RegisterScreen.label[5], "center", false)
		guiLabelSetVerticalAlign(RegisterScreen.label[5], "center")
		RegisterScreen.staticimage[4] = guiCreateStaticImage(0.55, 0.16, 0.13, 0.14, ":login/img/white.png", true, Loginbg)
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
		

        RegisterScreen.staticimage[5] = guiCreateStaticImage(0.44, 0.16, 0.02, 0.03, ":login/img/white.png", true, Loginbg)
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



function onRegister(serial, avatar)
	loginPanel(false)
	registerPanel(false)
	setLSVisibility(false)
end
addEvent("mtabg_registerDone", true)
addEventHandler("mtabg_registerDone", getRootElement(), onRegister)


function showError(errorMsg)
	
end
addEvent("MTABG_LoginError", true)
addEventHandler("MTABG_LoginError", getRootElement(), showError)


function loadLoginScreen(accountCheck, serial, avatar)
	if accountCheck == 1 then
		registerPanel(false)
		loginPanel(true)
		if avatar then setAvatarImg(avatar) end
		guiSetText(LoginScreen.edit[2], serial)
	elseif accountCheck == 0 then
		loginPanel(false)
		registerPanel(true)
		if avatar then setAvatarImg(avatar) end
		guiSetText(RegisterScreen.edit[2], serial)
	else
		 ---
	end
end
addEvent("openLoginPanel", true)
addEventHandler("openLoginPanel", getRootElement(), loadLoginScreen)



addEventHandler("onClientResourceStart", getResourceRootElement(), function()
	setLSVisibility(true)
	--registerPanel(true)
	showCursor(true)	
end)