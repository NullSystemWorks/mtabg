Atlas = {}

local dxCreateTexture = dxCreateTexture
local dxGetTexturePixels = dxGetTexturePixels
local dxSetTexturePixels = dxSetTexturePixels
local dxGetPixelColor = dxGetPixelColor
local dxSetPixelColor = dxSetPixelColor

function Atlas.unpack(atlas, rootx, rooty, width, height, spriteCount)
	local frameTable = {}
	local atlasPixels = dxGetTexturePixels(atlas)
	local r, g, b, a, pixels
	for i = 1, spriteCount do
		frameTable[i] = dxCreateTexture(width, height)
		pixels = dxGetTexturePixels(frameTable[i])
		for y = 0, height - 1 do
			for x = 0, width - 1 do
				r, g, b, a = dxGetPixelColor(atlasPixels, x + rootx,
				                             y + rooty + height*(i-1))
				dxSetPixelColor(pixels, x, y, r, g, b, a)
			end
		end
		dxSetTexturePixels(frameTable[i], pixels)
	end
	return frameTable
end
