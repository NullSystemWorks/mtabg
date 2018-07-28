local font = GuiFont("/font/etelka.ttf", 10)
local sx, sy = guiGetScreenSize()
local background = PixelTexture.new(150, 150, 150, 255,
                                    0, sy*.4, sx*.35, sy*.03)
local text = GuiLabel(.0175, .4015, 0.995,0.95, "", true)
text:setVisible(false)
text:setColor(255,255,255)
text:setFont(font)

SideMenu = {}

local sideMenuMessage
function SideMenu.showItem(message)
	sideMenuMessage = message
	background:setRendering(true)
	text:setVisible(true)
	text:setText(str(message))
end

function SideMenu.hide()
	background:setRendering(false)
	text:setVisible(false)
end

local function changeLanguage(newLang)
	if text:getVisible() and sideMenuMessage then
		text:setText(str(sideMenuMessage))
	end
end
addEventHandler("onUserLanguageChange", resourceRoot, changeLanguage)
