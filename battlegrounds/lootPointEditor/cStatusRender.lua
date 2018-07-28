local sx, sy = guiGetScreenSize()
local sHalfY = sy/2
local sHalfX = sx/2

local tx, ty = sx - 150, sy*.5 --coords for text
local tydist = 15 --y distance for text
local x, y = tx, ty --tmp values
local arrowTexture = DxTexture("lootPointEditor/arrow.png")
local arrowOffsety
local markerClass

local dxDrawRectangle = dxDrawRectangle
local dxDrawText = dxDrawText
local tostring = tostring
local tocolor = tocolor
local localPlayer = localPlayer

local function renderOpenHelpWindow()
	markerClass = localPlayer:getData("markerClass")
	if markerClass then
		if markerClass == "Residential" then
			arrowOffsety = 5 + tydist
		elseif markerClass == "Military" then
			arrowOffsety = 5 + tydist*2
		elseif markerClass == "Supermarket" then
			arrowOffsety = 5 + tydist*3
		elseif markerClass == "Farm" then
			arrowOffsety = 5 + tydist*4
		elseif markerClass == "Industry" then
			arrowOffsety = 5 + tydist*5
		else
			arrowOffsety = 5
		end
		dxDrawImage(tx - 40, ty + arrowOffsety, 32, 32, arrowTexture)
	end
	y = ty
	--Background rectangle
	dxDrawRectangle(sx - 160, y - 25, 117, 185, 0xC8000000)
	dxDrawText("Numpad Controls:", tx, y - tydist, tx, ty, 0xFFFFFF00, 1)
	y = y + tydist
	dxDrawText("0: Info", tx, y, tx, ty, 0xFFFFFFFF, 1)
	y = y + tydist
	dxDrawText("1: Residential", tx, y, tx, ty, 0xFFB041D6, 1)
	y = y + tydist
	dxDrawText("2: Military", tx, y, tx, ty, 0xFFEB3030, 1)
	y = y + tydist
	dxDrawText("3: Supermarket", tx, y, tx, ty, 0xFF4A43DE, 1)
	y = y + tydist
	dxDrawText("4: Farm", tx, y, tx, ty, 0xFF36AC2F, 1)
	y = y + tydist
	dxDrawText("5: Industry", tx, y, tx, ty, 0xFF666666, 1)
	y = y + tydist
	dxDrawText("- : delete", tx, y, tx, ty, 0xFFFFFFFF, 1)
	y = y + tydist
	y = y + tydist
	dxDrawText("F2: Leave", tx, y, tx, ty, 0xFF6CD6E6, 1)
end

--Render folden window
local function renderClosedHelpWindow()
	y = ty
	--Background rectangle
	dxDrawRectangle(sx - 160, ty + tydist*9 - 32,
	                117, 192 - tydist*9, 0xC8000000)
	y = y + tydist*7
	dxDrawText("Loot Place Editor", tx, y + 7, tx, ty, 0xFFFFFF00, 1)
	y = y + tydist*2
	dxDrawText("F2: Join", tx, y, tx, ty, 0xFF6CD6E6, 1)
end

--Open and fold help window
local function setHelpWindow(shouldOpen)
	if shouldOpen then
		addEventHandler("onClientRender", root, renderOpenHelpWindow)
		removeEventHandler("onClientRender", root, renderClosedHelpWindow)
	else
		addEventHandler("onClientRender", root, renderClosedHelpWindow)
		removeEventHandler("onClientRender", root, renderOpenHelpWindow)
	end
end
addEvent("onSetLootEditorWindowSate", true)
addEventHandler("onSetLootEditorWindowSate", localPlayer, setHelpWindow)

--Show and hide help window
local function hideHelpWindow()
	removeEventHandler("onClientRender", root, renderClosedHelpWindow)
	removeEventHandler("onClientRender", root, renderOpenHelpWindow)
end
addEvent("onHideLootEditorWindow", true)
addEventHandler("onHideLootEditorWindow", localPlayer, hideHelpWindow)
