local function isAnotherPlayerInCol(col)
	for _, player in ipairs(source:getElementsWithin("player")) do
		if player ~= localPlayer then
			return true
		end
	end
	return false
end

local function handlePlayerColHit(theElement)
	if theElement == localPlayer
	and not localPlayer:getOccupiedVehicle()
	and not isAnotherPlayerInCol(source)
	and source:getData("itemloot") then
		localPlayer:setData("currentCol", source)
		SideMenu.showItem("sideMenuGear")
	end
end
addEventHandler("onClientColShapeHit", resourceRoot, handlePlayerColHit)

local function handlePlayerColLeave(theElement)
	if theElement == localPlayer then
		SideMenu.hide()
		localPlayer:setData("currentCol", false)
	end
end
addEventHandler("onClientColShapeLeave", resourceRoot, handlePlayerColLeave)
