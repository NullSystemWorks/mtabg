--[[

				MTA:BG
			MTA Battlegrounds
	Developed By: L, CiBeR, neves768, 1BOY

]]--

function getGroundMaterial(x, y, z)
	local hit, hitX, hitY, hitZ, hitElement, normalX, normalY, normalZ, material = processLineOfSight(x, y, z, x, y, z-10, true, false, false, true, false, false, false, false, nil)
	return material
end

function isInBuilding(x, y, z)
	local hit, hitX, hitY, hitZ, hitElement, normalX, normalY, normalZ, material = processLineOfSight(x, y, z, x, y, z+10, true, false, false, true, false, false, false, false, nil)
	if hit then return true end
	return false
end

function findRotation(x1,y1,x2,y2)
  local t = -math.deg(math.atan2(x2-x1,y2-y1))
  if t < 0 then t = t + 360 end;
  return t;
end

function getPointFromDistanceRotation(x, y, dist, angle)
	local a = math.rad(90 - angle)
	local dx = math.cos(a) * dist
	local dy = math.sin(a) * dist
	return x+dx, y+dy
end

function isObjectAroundPlayer ( thePlayer, distance, height )
	local x, y, z = getElementPosition( thePlayer )
	for i = math.random(0,360), 360, 1 do
		local nx, ny = getPointFromDistanceRotation( x, y, distance, i )
		local hit, hitX, hitY, hitZ, hitElement, normalX, normalY, normalZ, material = processLineOfSight ( x, y, z + height, nx, ny, z + height)
		if material == 0 then
			return material,hitX, hitY, hitZ
		end
	end
	return false
end

function isObjectAroundPlayer2 ( thePlayer, distance, height )
	material_value = 0
	local x, y, z = getElementPosition( thePlayer )
	for i = math.random(0,360), 360, 1 do
		local nx, ny = getPointFromDistanceRotation( x, y, distance, i )
		local hit, hitX, hitY, hitZ, hitElement, normalX, normalY, normalZ, material = processLineOfSight ( x, y, z + height, nx, ny, z + height,true,false,false,false,false,false,false,false )
		if material == 0 or material == 1 or material == 2 or material == 3 then
			material_value = material_value+1
		end
		if material_value > 40 then
			return material,hitX, hitY, hitZ
		end
	end
	return false
end

function getRotationOfCamera()
    local px, py, pz, lx, ly, lz = getCameraMatrix()
    local rotz = 6.2831853071796 - math.atan2 ( ( lx - px ), ( ly - py ) ) % 6.2831853071796
    local rotx = math.atan2 ( lz - pz, getDistanceBetweenPoints2D ( lx, ly, px, py ) )
    --Convert to degrees
    rotx = math.deg(rotx)
    rotz = -math.deg(rotz)
    return rotx, 180, rotz
end

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then
		return math[method](number * factor) / factor
    else
		return tonumber(("%."..decimals.."f"):format(number))
	end
end

function math.percent(percent,maxvalue)
    if tonumber(percent) and tonumber(maxvalue) then
        local x = (maxvalue*percent)/100
        return x
    end
    return false
end

function math.percentChance (percent,repeatTime)
	local hits = 0
	for i = 1, repeatTime do
	local number = math.random(0,200)/2
		if number <= percent then
			hits = hits+1
		end
	end
	return hits
end

function table.size(tab)
    local length = 0
    for _ in pairs(tab) do length = length + 1 end
    return length
end

function table.merge(table1,...)
	for _,table2 in ipairs({...}) do
		for key,value in pairs(table2) do
			if (type(key) == "number") then
				table.insert(table1,value)
			else
				table1[key] = value
			end
		end
	end
	return table1
end

function mapValues(x, in_min, in_max, out_min, out_max) --rescales values
	return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
end

function getElementSpeed(theElement, unit)
	-- Check arguments for errors
	if not isElement(theElement) then
		error("Bad argument 1 @ getElementSpeed (element expected, got " .. type(theElement) .. ")", 2)
	end
	local elementType = getElementType(theElement)
	if not (elementType == "player"
	or elementType == "ped"
	or elementType == "object"
	or elementType == "vehicle"
	or elementType == "projectile") then
		error("Invalid element type @ getElementSpeed (player/ped/object/vehicle/projectile expected, got " .. elementType .. ")", 2)
	end
	if not ((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph")) then
		error("Bad argument 2 @ getElementSpeed (invalid speed unit)", 2)
	end

	-- Default to m/s if no unit specified and 'ignore' argument type if the string contains a number
	unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
	-- Setup our multiplier to convert the velocity to the specified unit
	local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
	-- Return the speed by calculating the length of the velocity vector, after converting the velocity to the specified unit
	return (Vector3(getElementVelocity(theElement)) * mult).length
end
