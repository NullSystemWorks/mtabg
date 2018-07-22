PixelTexture = {}
local pixelTexture_mt = {__index = PixelTexture}

--This hex incantation represents a white pixel
local BASE_PIXEL = "\255\255\255\255\001\000\001\000"
local IN, OUT = 0, 1 --magic names for magic numbers
local rendering = {}
local renderingCount = 0
local fading = {[IN] = {}, [OUT] = {}}
local fadingCount = {[IN] = 0, [OUT] = 0}
local fadingHandler = {}
local crazyMode = false

local sx, sy = guiGetScreenSize()

local DxTexture = DxTexture
local dxGetTexturePixels = dxGetTexturePixels
local dxSetPixelColor = dxSetPixelColor
local dxSetTexturePixels = dxSetTexturePixels
local setmetatable = setmetatable
local addEventHandler = addEventHandler
local removeEventHandler = removeEventHandler
local table = table
local ipairs = ipairs
local pairs = pairs
local dxDrawImage = dxDrawImage
local math = math
local tocolor = tocolor
local getTickCount = getTickCount

function PixelTexture.new(r, g, b, a, rootx, rooty, width, height)
	local tex = DxTexture(BASE_PIXEL)

	local newInst = {
		rootx = rootx or 0,
		rooty = rooty or 0,
		width = width or 128,
		height = height or 32,
		r = r or 0,
		g = g or 0,
		b = b or 0,
		a = a or 255,
		isRendering = false,
		lastTick = 0,
		texture = tex
	}
	setmetatable(newInst, pixelTexture_mt)
	return tex and newInst or false
end

--Pixel showcase
local function crazyRender()
	for _, pix in ipairs(rendering) do
		dxDrawImage(math.random(0,sx),math.random(0,sy),
			math.random(32,64), math.random(32,64), pix.texture,
			0, 0, 0, tocolor(pix.r, pix.g, pix.b, pix.a))
	end
end

function PixelTexture.setParty(goCrazy)
	if not crazyMode and goCrazy then
		addEventHandler("onClientRender", root, crazyRender)
		crazyMode = true
	elseif crazyMode and not goCrazy then
		removeEventHandler("onClientRender", root, crazyRender)
		crazyMode = false
	end
end

function PixelTexture.getParty()
	return crazyMode
end

local function renderFrame()
	for _, pix in ipairs(rendering) do
		dxDrawImage(pix.rootx, pix.rooty, pix.width, pix.height,
			pix.texture, 0, 0, 0, tocolor(pix.r, pix.g, pix.b, pix.a))
	end
end

fadingHandler[IN] = function()
	for pix, fadeTime in pairs(fading[IN]) do
		if pix.a < 255 then --if fade is not done
			local frameTime = getTickCount() - pix.lastTick
			local changeStep = (256*frameTime)/fadeTime
			pix.a = pix.a + changeStep
			if pix.a > 255 then
				pix.a = 255
			end
			pix.lastTick = getTickCount()
		else
			if fadingCount[IN] == 1 then --if removing the last element
				removeEventHandler("onClientRender", root, fadingHandler[IN])
			end
			fading[IN][pix] = nil
			fadingCount[IN] = fadingCount[IN] - 1
		end
	end
end

fadingHandler[OUT] = function()
	for pix, fadeTime in pairs(fading[OUT]) do
		if pix.a > 0 then --if fade is not done
			local frameTime = getTickCount() - pix.lastTick
			local changeStep = (256*frameTime)/fadeTime
			pix.a = pix.a - changeStep
			if pix.a < 0 then
				pix.a = 0
			end
			pix.lastTick = getTickCount()
		else
			if fadingCount[OUT] == 1 then --if removing the last element
				removeEventHandler("onClientRender", root, fadingHandler[OUT])
			end
			fading[OUT][pix] = nil
			fadingCount[OUT] = fadingCount[OUT] - 1
		end
	end
end

--Color manipulation
function PixelTexture:setR(r) self.r = r end
function PixelTexture:setG(g) self.g = g end
function PixelTexture:setB(b) self.b = b end
function PixelTexture:setA(a) self.a = a end
function PixelTexture:getR() return self.r end
function PixelTexture:getG() return self.g end
function PixelTexture:getB() return self.b end
function PixelTexture:getA() return self.a end
function PixelTexture:setRGBA(r,g,b,a)
	self.r, self.g, self.b, self.a = r, g, b, a
end
function PixelTexture:getRGBA()
	return self.r, self.g, self.b, self.a
end
function PixelTexture:setSize(width, height)
	self.width = width
	self.height = height
end
function PixelTexture:getSize()
	return self.width, self.height
end
function PixelTexture:setRoot(rootx, rooty)
	self.rootx = rootx
	self.rooty = rooty
end
function PixelTexture:getRoot()
	return self.rootx, self.rooty
end

local function stopRenderingIfLastElement()
	if #rendering == 0 then
		removeEventHandler("onClientRender", root, renderFrame)
	end
end

local function startRenderingIfFirstElement()
	if #rendering == 0 then
		addEventHandler("onClientRender", root, renderFrame)
	end
end

local function removeFromRenderingQueue(self)
	for removeIndex, pix in ipairs(rendering) do
		if pix == self then
			--could we use a weak table to remove this loop?
			table.remove(rendering, removeIndex)
			break
		end
	end
end

local function insertIntoRenderingQueue(self)
	table.insert(rendering, self)
end

function PixelTexture:setRendering(shouldRender)
	if not self.isRendering and shouldRender then
		startRenderingIfFirstElement()
		self.isRendering = true
		insertIntoRenderingQueue(self)
	elseif self.isRendering and not shouldRender then
		self.isRendering = false
		removeFromRenderingQueue(self)
		stopRenderingIfLastElement()
	end
end

function PixelTexture:getRendering()
	return self.isRendering
end

local function startFade(self, fadeDuration, fadeType)
	if not fading[fadeType][self] then
		if fadingCount[fadeType] == 0 then
			addEventHandler("onClientRender", root, fadingHandler[fadeType])
		end
		self.lastTick = getTickCount()
		fading[fadeType][self] = fadeDuration
		fadingCount[fadeType] = fadingCount[fadeType] + 1
	end
end

function PixelTexture:fadeIn(fadeDuration)
	startFade(self, fadeDuration, IN)
end

function PixelTexture:fadeOut(fadeDuration)
	startFade(self, fadeDuration, OUT)
end

--TODO: implement rendering order management
