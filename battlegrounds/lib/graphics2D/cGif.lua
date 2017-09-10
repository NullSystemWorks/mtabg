Gif = {} --gif class
local gif_mt = { __index = Gif} --gif metatable
local renderTable = {} --gifs being rendered
local renderingCount = 0 --how many gifs are being rendered

local sx, sy = guiGetScreenSize()

function Gif:new(atlas, atlasRootx, atlasRooty, spriteWidth, spriteHeight, spriteCount)
	if getElementType(atlas) == "texture"
	and type(atlasRootx) == "number" and atlasRootx >= 0
	and type(atlasRooty) == "number" and atlasRooty >= 0
	and type(spriteWidth) == "number" and spriteWidth > 0
	and type(spriteHeight) == "number" and spriteHeight > 0
	and type(spriteCount) == "number" and spriteCount > 0 then
		local atlasx, atlasy = atlas:getSize()
		if (atlasRootx + spriteWidth) > atlasx --sprites outside atlas
		and (atlasRootx + spriteHeight*spriteCount) > atlasy then --sprites outside atlas
			return false
		end

		local newInst = {
			frame = unpackAtlas(atlas, atlasRootx, atlasRooty, spriteWidth, spriteHeight, spriteCount),
			frameCount = spriteCount,
			rootx,
			rooty,
			width,
			height,
			gifSpeed,
			currentFrame,
			tick
		}

		setmetatable(newInst, gif_mt)
		return newInst
	else
		return false
	end
end

--Render loop frames
local function renderGifFrames()
	for gif, time in pairs(renderTable) do
		local dTime = getTickCount() - gif.tick --time since last frame
		if dTime >= gif.gifSpeed then
			gif.currentFrame = gif.currentFrame < gif.frameCount and gif.currentFrame + 1 or 1
			gif.tick = getTickCount() --store last frame change
		end
		dxDrawImage(gif.rootx, gif.rooty, gif.width, gif.height, gif.frame[gif.currentFrame])
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
	if shouldRender then --should start rendering
		if not renderTable[self] then --element not in render table
			if shouldRender and renderingCount == 0 then --if adding the first element
				addEventHandler("onClientRender", root, renderGifFrames) --something to render
			end
			self.tick = getTickCount()
			renderTable[self] = true --set element as rendering
			renderingCount = renderingCount + 1
		end
	else
		if renderTable[self] then --should stop rendering
			if not shouldRender and renderingCount == 1 then --if removing the last element
				removeEventHandler("onClientRender", root, renderGifFrames) --nothing to render
			end
			renderTable[self] = nil --remove from rendering list
			renderingCount = renderingCount - 1
		end
	end
end
