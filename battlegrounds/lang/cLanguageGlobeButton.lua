local sx, sy = guiGetScreenSize()
local globeTexture = DxTexture("lang/globeIcon.png")
local color = 0
local lastTick = 0
local rootx = sx*0.013020833 --25
local rooty = sy*0.148148148 --160
local sizex = sx*0.039062500 --75
local sizey = sy*0.069444444 --75
local radius = sizex*.5
local centerx = sizex*.5 + rootx
local centery = sizey*.5 + rooty
local isRendering = false
local functionToCallOnClick
local Globe = {}

local function render()
	dxDrawImage(rootx, rooty, sizex, sizey, globeTexture, 0, 0, 0, tocolor(color,color,color,255), false)
end

local function isClickInsideGlobe(button, state, cursorx, cursory)
	if button == "left" and state == "up" then
		local distance = math.sqrt(
			math.pow(centerx - cursorx, 2)
		+ math.pow(centery - cursory, 2)
		)
		local isInside = distance <= radius
		if isInside and functionToCallOnClick then
			functionToCallOnClick()
		end
	end
end

local function fadeIn()
	if color < 255 then
		local dTime = getTickCount() - lastTick
		local controlVar = (256*dTime)/1000
		color = color + controlVar
		if color > 255 then
			color = 255
		end
		lastTick = getTickCount()
	else
		removeEventHandler("onClientRender", root, fadeIn)
	end
end

function Globe.setFadingIn()
	lastTick = getTickCount()
	addEventHandler("onClientRender", root, fadeIn)
end

function Globe.setRendering(shouldRender)
	if shouldRender then
		addEventHandler("onClientRender", root, render)
		addEventHandler("onClientClick", root, isClickInsideGlobe)
		Globe.setFadingIn()
	else
		removeEventHandler("onClientRender", root, render)
		removeEventHandler("onClientClick", root, isClickInsideGlobe)
		removeEventHandler("onClientRender", root, fadeIn)
	end
	isRendering = shouldRender
end

function Globe.getRendering()
	return isRendering
end

function Globe.toggleRendering()
	Globe.setRendering(not isRendering)
end

function Globe.setCallOnClick(functionToCall)
	functionToCallOnClick = functionToCall
end

LanguageGlobeButton = Globe
