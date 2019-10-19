Grenade = {}

Grenade.TIME = 3000

local screenW, screenH = guiGetScreenSize()
local texture = DxTexture("gui/img/grenadeHud.png")

local TEX_RES = 128
local HUD_RADIUS = (screenW < screenH and screenW/2 or screenH/2) - TEX_RES/2
local SCREEN_CENTER_X = screenW/2
local SCREEN_CENTER_Y = screenH/2

local function getGrenadeSize(distance)
	if distance > 15 then
		return 0
	elseif distance > 9 then
		return mapValues(distance, 15, 9, .1, .25)
	elseif distance > 4.5 then
		return mapValues(distance, 9, 4.5, .25, 1)
	else
		return 1
	end
end

local function getGrenadeColor(time)
	local red = mapValues(time, Grenade.TIME, 0, 0, 255)
	return tocolor(red, 255 - red, 0)
end

local math = math
local function drawGrenades()
	for _, projectile in
	ipairs(Element.getAllByType("projectile", root, false)) do
		if projectile:getType() == 16
		and projectile:getDimension() == localPlayer:getDimension() then
			local projPos = projectile:getPosition()
			local playerPos = localPlayer:getPosition() - Vector3(0, 0.5, 0)
			local dist = projPos - playerPos
			local time = projectile:getCounter()
			local angle = math.atan2(dist.y, dist.x)
			local screenAngleRad = math.rad(Camera.getRotation().z) - angle
			local size = TEX_RES*getGrenadeSize(Vector3.getLength(dist))
			local offsetX = (SCREEN_CENTER_X - TEX_RES/2)
			local offsetY = (SCREEN_CENTER_Y - TEX_RES/2)
			dxDrawImage(math.cos(screenAngleRad)*HUD_RADIUS + offsetX,
			            math.sin(screenAngleRad)*HUD_RADIUS + offsetY,
			            size, size, texture, 0, 0, 0, getGrenadeColor(time))
		end
	end
end
addEventHandler("onClientRender", root, drawGrenades)
