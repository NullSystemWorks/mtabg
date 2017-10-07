--[[

				MTA:BG
			MTA Battlegrounds
	Developed By: Null System Works

]]--

local gifRoot = {["x"] = 0, ["y"] = 0}
local gifSize = {["x"] = 208, ["y"] = 13}
local gifFrameCount = 10
local gifSpeed = 100
local loadGif --gif object

local iconRoot = {["x"] = gifSize.x, ["y"] = 0}
local iconSize = {["x"] = 32, ["y"] = 32}
local iconFrameCount = 3
local iconFrames = {} --icon textures
local iconToRender --rendering icon

local pixelTextures = {}

loadingBar = {}

local sx, sy =  guiGetScreenSize()
local rootx, rooty = sx*0.353, sy*0.59 --677, 637

local atlasTexture = dxCreateTexture("accounting/img/atlas.png")
local color = {
	{255, 255, 255, 255}, --backgound
	{222, 242, 250, 255}, --inBackgound
	{149, 192, 255, 255}, --loadingBar
	{252, 057, 057, 000}, --failLoadingBar
	{106, 212, 166, 000}, --doneLoadingBar
}
local pos = {
	["background"] = {rootx, rooty, sx*0.28125, sy*0.046296296}, --540, 50
	["icon"] = {rootx + sx*0.256770833, rooty + sy*0.009259259, sx*0.016666667, sy*0.02962963}, --493, 10, 32, 32
	["bar"] = {rootx + sx*0.007291667, rooty + sy*0.014814815, sx*0.239583333, sy*0.018518519 } --14, 16, 460, 20
}

local function renderIcon()
	dxDrawImage(pos.icon[1], pos.icon[2], pos.icon[3], pos.icon[4], iconFrames[iconToRender])
end

local function changeIcon(iconSelection)
	if type(iconSelection) == "number" and iconSelection <= #iconFrames then
		if not iconToRender then --setting for the first time
			addEventHandler("onClientRender", root, renderIcon)
		end
		iconToRender = iconSelection
	end
end

local function setProgress(percentage)
	local position = mapValues(percentage, 0, 100, 0, pos.bar[3])
	pixelTextures[3]:setSize(position, pos.bar[4])
end

local function setDone(status)
	if status then
		changeIcon(2) --grenn V
		pixelTextures[5]:fadeIn(600) --green bar
	else
		changeIcon(3) --red X
		pixelTextures[4]:fadeIn(600) --red bar
	end
end

local function setWaiting(status)
	loadGif:setRendering(status)
end

--TODO: create destructor methods for all this
local function hide()
	loadGif:setRendering(false)
	for k, pixTex in pairs(pixelTextures) do
		pixTex:setRendering(false)
	end
	removeEventHandler("onClientRender", root, renderIcon)
end

local function initializeLoadingBar()
	for k, v in ipairs(color) do --generate pixel textures
		if k == 3 then --if progress bar
			pixelTextures[k] = pixelTexture:new(v[1], v[2], v[3], v[4],
			pos.bar[1], pos.bar[2], 0, pos.bar[4])
		elseif k ~= 1 then --if not background
			pixelTextures[k] = pixelTexture:new(v[1], v[2], v[3], v[4],
				pos.bar[1], pos.bar[2], pos.bar[3], pos.bar[4])
		else --if other bars
			pixelTextures[k] = pixelTexture:new(v[1], v[2], v[3], v[4],
				pos.background[1], pos.background[2], pos.background[3], pos.background[4])
		end
	end
	iconFrames = unpackAtlas(atlasTexture, iconRoot.x, iconRoot.y, iconSize.x, iconSize.y, iconFrameCount)
	loadGif = Gif:new(atlasTexture, gifRoot.x, gifRoot.y, gifSize.x, gifSize.y, gifFrameCount )
	loadGif:setTarget(pos.bar[1], pos.bar[2], pos.bar[3], pos.bar[4], gifSpeed)

	loadingBar.gif = loadGif
	loadingBar.bar = pixelTextures
	loadingBar.changeIcon = changeIcon
	loadingBar.hide = hide
	loadingBar.setProgress = setProgress
	loadingBar.setDone = setDone
	loadingBar.setWaiting = setWaiting
end
addEventHandler ("onClientResourceStart", resourceRoot, initializeLoadingBar)
