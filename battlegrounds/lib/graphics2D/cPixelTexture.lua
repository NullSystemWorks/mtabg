pixelTexture = {} --pixelTexture class
local pixelTexture_mt = {__index = pixelTexture} --the metatable
local renderTable = {} --textures being rendered
local renderingCount = 0 --how many items are being rendered
local fadeTable = {} --elements fading
	fadeTable["in"] = {}
	fadeTable["out"] = {}
local fadingCount  = {["in"] = 0, ["out"] = 0} --how many items are being faded
local crazyModeState = false

local sx, sy = guiGetScreenSize()

--Localized functions


--Generate pixel textures
function pixelTexture:new(r, g, b, a, rootx, rooty, width, height)
	local tex = dxCreateTexture(1,1) --generate texture
	local pixel = dxGetTexturePixels (tex) --get pixel
	dxSetPixelColor (pixel, 0, 0, 255, 255, 255, 255) --set pixel color to white
	dxSetTexturePixels (tex, pixel) --set pixel

	local newInst = { --the new instance
		rootx = rootx or 0,
		rooty = rooty or 0,
		width = width or 128,
		height = height or 32,
		r = r or 0,
		g = g or 0,
		b = b or 0,
		a = a or 255,
		tick = 0,
		texture = tex
	}
	setmetatable(newInst, pixelTexture_mt) --all instances share the same metatable
	if tex then
		return newInst
	else
		return false
	end
end

function pixelTexture:print()
	print(self.r)
	print(self.g)
	print(self.b)
	print(self.a)
	iprint(self.texture)
end

--Pixel showcase
local function crazyRender()
	for k, pix in ipairs(renderTable) do
		dxDrawImage(math.random(0,sx),math.random(0,sy), math.random(32,64), math.random(32,64), pix.texture)
	end
end

--Render all elements int render table
local function renderPixels()
	for k, pix in ipairs(renderTable) do
		dxDrawImage(pix.rootx, pix.rooty, pix.width, pix.height, pix.texture, 0, 0, 0, tocolor(pix.r, pix.g, pix.b, pix.a))
	end
end

--Handle fading textures
local function fadeIn()
	for pix, fadeTime in pairs(fadeTable["in"]) do --for every fading object
		if pix.a < 255 then --if fade is not done
			local dTime = getTickCount() - pix.tick --time since last frame
			local controlVar = (256*dTime)/fadeTime --how much to change for this step
			pix.a = pix.a + controlVar --change alpha
			if pix.a > 255 then --constrain values
				pix.a = 255
			end
			pix.tick = getTickCount() --save time for next run
		else
			if fadingCount["in"] == 1 then --if removing the last element
				removeEventHandler("onClientRender", root, fadeIn) --nothing to fade
			end
			fadeTable["in"][pix] = nil --remove from fading list
			fadingCount["in"] = fadingCount["in"] - 1
		end
	end
end

--Handle fading textures
local function fadeOut()
	for pix, fadeTime in pairs(fadeTable["out"]) do --for every fading object
		if pix.a > 0 then --if fade is not done
			local dTime = getTickCount() - pix.tick --time since last frame
			local controlVar = (256*dTime)/fadeTime --how much to change for this step
			pix.a = pix.a - controlVar --change alpha
			if pix.a < 0 then --constrain values
				pix.a = 0
			end
			pix.tick = getTickCount() --save time for next run
		else
			if fadingCount["out"] == 1 then --if removing the last element
				removeEventHandler("onClientRender", root, fadeOut) --nothing to fade
			end
			fadeTable["out"][pix] = nil --remove from fading list
			fadingCount["out"] = fadingCount["out"] - 1
		end
	end
end

--Color manipulation
function pixelTexture:setR(r) self.r = r end
function pixelTexture:setG(g) self.g = g end
function pixelTexture:setB(b) self.b = b end
function pixelTexture:setA(a) self.a = a end
function pixelTexture:getR()	return self.r end
function pixelTexture:getG() return self.g end
function pixelTexture:getB() return self.b end
function pixelTexture:getA() return self.a end
function pixelTexture:setRGBA(r,g,b,a) self.r, self.g, self.b, self.a = r, g, b, a end
function pixelTexture:getRGBA() return self.r, self.g, self.b, self.a end
function pixelTexture:setSize(width, height) self.width = width self.height = height end
function pixelTexture:getSize() return self.width, self.height end
function pixelTexture:setRoot(rootx, rooty) self.rootx = rootx self.rooty = rooty end
function pixelTexture:getRoot() return self.rootx, self.rooty end

--Enable disable rendering
function pixelTexture:setRendering(shouldRender)
	if shouldRender then --should start rendering
		if not renderTable[self] then --element not in render table
			if shouldRender and renderingCount == 0 then --if adding the first element
				addEventHandler("onClientRender", root, renderPixels) --something to render
			end
			renderTable[self] = true --set element as rendering
			table.insert(renderTable, self)
			renderingCount = renderingCount + 1
		end
	else
		if renderTable[self] then --should stop rendering
			if not shouldRender and renderingCount == 1 then --if removing the last element
				removeEventHandler("onClientRender", root, renderPixels) --nothing to render
			end
			local counter = 1
			for k, v in pairs(renderTable) do
				if v == self then
					-- print(renderTable[counter])
					table.remove(renderTable, counter)
				end
				counter = counter + 1
			end
			renderTable[self] = nil --remove from rendering list
			renderingCount = renderingCount - 1
		end
	end
	-- iprint("----")
	-- local count = 0
	-- for k,v in pairs(renderTable) do
	-- 	count = count + 1
	-- 	print(k, v, count)
	-- end
	-- iprint("----")
end

function pixelTexture:getRendering() return renderTable[self] or false end

function pixelTexture:fadeIn(fadingSpeed)
	if not fadeTable["in"][self] then --element not in fading table
		if fadingCount["in"] == 0 then --if adding the first element
			addEventHandler("onClientRender", root, fadeIn) --something to fade
		end
		self.tick = getTickCount()
		fadeTable["in"][self] = fadingSpeed --set element as fading and set a fading speed
		fadingCount["in"] = fadingCount["in"] + 1
	end
end

function pixelTexture:fadeOut(fadingSpeed)
	if not fadeTable["out"][self] then --element not in fading table
		if fadingCount["out"] == 0 then --if adding the first element
			addEventHandler("onClientRender", root, fadeOut) --something to fade
		end
		self.tick = getTickCount()
		fadeTable["out"][self] = fadingSpeed --set element as fading and set a fading speed
		fadingCount["out"] = fadingCount["out"] + 1
	end
end

function pixelTexture:setParty(goCrazy)
	if not crazyModeState and goCrazy then
		addEventHandler("onClientRender", root, crazyRender) --enables the render
		crazyModeState = true
	elseif crazyModeState and not goCrazy then
		removeEventHandler("onClientRender", root, crazyRender) --disables the render
		crazyModeState = false
	end
end

function pixelTexture:getCrazy() return crazyModeState end

--TODO: implement render order management
--TODO: optimize code(mainly localize)

--Test example
-- local function testpix()
-- 	pix = pixelTexture:new(255, 0, 0, 255, 500, 500, 128, 64)
-- 	pix:setRendering(true)
-- 	setTimer(function() pix:fadeOut(2000) end, 5000, 1)
-- 	setTimer(function() pix:setR(150) end, 4000, 1)
-- 	setTimer(function() pix:setG(150) end, 3000, 1)
-- 	setTimer(function() pix:setB(150) end, 2000, 1)
-- end
-- addEventHandler("onClientResourceStart", root, testpix)
