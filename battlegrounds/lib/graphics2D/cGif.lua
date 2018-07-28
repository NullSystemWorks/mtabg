Gif = {}
local gif_mt = { __index = Gif}
local rendering = {}
local renderingCount = 0

local sx, sy = guiGetScreenSize()

local getTickCount = getTickCount
local dxDrawImage = dxDrawImage
local pairs = pairs

function Gif.new(atlas, atlasRootx, atlasRooty,
                 spriteWidth, spriteHeight, spriteCount)
	if getElementType(atlas) == "texture"
	and type(atlasRootx) == "number" and atlasRootx >= 0
	and type(atlasRooty) == "number" and atlasRooty >= 0
	and type(spriteWidth) == "number" and spriteWidth > 0
	and type(spriteHeight) == "number" and spriteHeight > 0
	and type(spriteCount) == "number" and spriteCount > 0 then
		local atlasx, atlasy = atlas:getSize()
		--TODO: Test this condition. It looks fishy
		if (atlasRootx + spriteWidth) > atlasx --sprites outside atlas
		and (atlasRootx + spriteHeight*spriteCount) > atlasy then
			return false
		end

		local newInst = {
			frame = Atlas.unpack(atlas, atlasRootx, atlasRooty,
			                     spriteWidth, spriteHeight, spriteCount),
			frameCount = spriteCount,
			rootx,
			rooty,
			width,
			height,
			gifSpeed,
			currentFrame,
			lastTick
		}

		setmetatable(newInst, gif_mt)
		return newInst
	else
		return false
	end
end

--Render loop frames
local function renderGifFrames()
	for gif, time in pairs(rendering) do
		local frameTime = getTickCount() - gif.lastTick
		if frameTime >= gif.gifSpeed then
			gif.currentFrame = gif.currentFrame < gif.frameCount
				and gif.currentFrame + 1 or 1
			gif.lastTick = getTickCount() --store last frame change
		end
		dxDrawImage(gif.rootx, gif.rooty,
		            gif.width, gif.height, gif.frame[gif.currentFrame])
	end
end

function Gif:setTarget(rootx, rooty, width, height, gifSpeed)
	self.rootx = rootx
	self.rooty = rooty
	self.width = width
	self.height = height
	self.gifSpeed = gifSpeed
	self.currentFrame = 1
end

function Gif:setRendering(shouldRender)
	if shouldRender then
		if not rendering[self] then
			if shouldRender and renderingCount == 0 then
				addEventHandler("onClientRender", root, renderGifFrames)
			end
			self.lastTick = getTickCount()
			rendering[self] = true
			renderingCount = renderingCount + 1
		end
	else
		if rendering[self] then
			if not shouldRender and renderingCount == 1 then
				removeEventHandler("onClientRender", root, renderGifFrames)
			end
			rendering[self] = nil
			renderingCount = renderingCount - 1
		end
	end
end

function Gif:getRendering()
	return rendering[self] or false
end
