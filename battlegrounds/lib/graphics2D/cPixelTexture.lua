PixelTexture = {} --PixelTexture class
local pixelTexture_mt = {__index = PixelTexture} --the metatable
local renderTable = {} --textures being rendered
local renderingCount = 0 --how many items are being rendered
local fadeTable = {} --elements fading
	fadeTable["in"] = {}
	fadeTable["out"] = {}
local fadingCount = {["in"] = 0, ["out"] = 0} --how many items are being faded
local crazyModeState = false

local sx, sy = guiGetScreenSize()

--Localized functions


--Generate pixel textures
function PixelTexture.new(r, g, b, a, rootx, rooty, width, height)
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

function PixelTexture:print()
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

function PixelTexture.setParty(goCrazy)
	if not crazyModeState and goCrazy then
		addEventHandler("onClientRender", root, crazyRender) --enables the render
		crazyModeState = true
	elseif crazyModeState and not goCrazy then
		removeEventHandler("onClientRender", root, crazyRender) --disables the render
		crazyModeState = false
	end
end

function PixelTexture.getParty() return crazyModeState end

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
function PixelTexture:setR(r) self.r = r end
function PixelTexture:setG(g) self.g = g end
function PixelTexture:setB(b) self.b = b end
function PixelTexture:setA(a) self.a = a end
function PixelTexture:getR()	return self.r end
function PixelTexture:getG() return self.g end
function PixelTexture:getB() return self.b end
function PixelTexture:getA() return self.a end
function PixelTexture:setRGBA(r,g,b,a) self.r, self.g, self.b, self.a = r, g, b, a end
function PixelTexture:getRGBA() return self.r, self.g, self.b, self.a end
function PixelTexture:setSize(width, height) self.width = width self.height = height end
function PixelTexture:getSize() return self.width, self.height end
function PixelTexture:setRoot(rootx, rooty) self.rootx = rootx self.rooty = rooty end
function PixelTexture:getRoot() return self.rootx, self.rooty end

--Enable disable rendering
function PixelTexture:setRendering(shouldRender)
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

function PixelTexture:getRendering() return renderTable[self] or false end

function PixelTexture:fadeIn(fadingSpeed)
	if not fadeTable["in"][self] then --element not in fading table
		if fadingCount["in"] == 0 then --if adding the first element
			addEventHandler("onClientRender", root, fadeIn) --something to fade
		end
		self.tick = getTickCount()
		fadeTable["in"][self] = fadingSpeed --set element as fading and set a fading speed
		fadingCount["in"] = fadingCount["in"] + 1
	end
end

function PixelTexture:fadeOut(fadingSpeed)
	if not fadeTable["out"][self] then --element not in fading table
		if fadingCount["out"] == 0 then --if adding the first element
			addEventHandler("onClientRender", root, fadeOut) --something to fade
		end
		self.tick = getTickCount()
		fadeTable["out"][self] = fadingSpeed --set element as fading and set a fading speed
		fadingCount["out"] = fadingCount["out"] + 1
	end
end

--TODO: implement render order management
--TODO: optimize code(mainly localize)
