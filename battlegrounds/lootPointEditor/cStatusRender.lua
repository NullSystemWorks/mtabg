--[[

				MTA:BG
			MTA Battlegrounds
	Developed By: Null System Works

]]--

local sx, sy = guiGetScreenSize()
local sHalfY = sy/2
local sHalfX = sx/2
local isHelpWindowActive = false
local isHelpWindowShowing = false

--Open and fold help window
local function setHelpWindow(state)
	if state then
		addEventHandler("onClientRender", root, renderOpenHelpWindow)
		removeEventHandler("onClientRender", root, renderClosedHelpWindow)
	else
		addEventHandler("onClientRender", root, renderClosedHelpWindow)
		removeEventHandler("onClientRender", root, renderOpenHelpWindow)
	end
	isHelpWindowActive = state
	isHelpWindowShowing = true
end
addEvent("onSetLootEditorWindowSate", true)
addEventHandler("onSetLootEditorWindowSate", localPlayer, setHelpWindow)

--Show and hide help window
local function hideHelpWindow()
	removeEventHandler("onClientRender", root, renderClosedHelpWindow)
	removeEventHandler("onClientRender", root, renderOpenHelpWindow)
	isHelpWindowShowing = false
end
addEvent("onHideLootEditorWindow", true)
addEventHandler("onHideLootEditorWindow", localPlayer, hideHelpWindow)



local tx, ty = sx - 150, sy*.5 --coods for text
local tydist = 15 --y distance for text
local x, y = tx, ty --tmp values
local arrowOffsety
local markerClass

local dxDrawRectangle = dxDrawRectangle
local dxDrawText = dxDrawText
local tostring = tostring
local tocolor = tocolor
local localPlayer = localPlayer
--Render help info
function renderOpenHelpWindow()
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
		dxDrawImage(tx - 40, ty + arrowOffsety, 32, 32, "lootPointEditor/arrow.png")
	end
	y = ty
	dxDrawRectangle ( sx - 160, y - 25, 117, 185, tocolor ( 0, 0, 0, 200 ) ) -- Create black background rectangle.
	dxDrawText ( "Numpad Controls:", tx, y - tydist, tx, ty, tocolor ( 255, 255, 0, 255 ), 1 )
	y = y + tydist
	dxDrawText ( "0: Info", tx, y, tx, ty, tocolor ( 255, 255, 255, 255 ), 1 )
	y = y + tydist
	dxDrawText ( "1: Residential", tx, y, tx, ty, tocolor ( 176, 65, 214, 255 ), 1 )
	y = y + tydist
	dxDrawText ( "2: Military", tx, y, tx, ty, tocolor ( 235, 48, 48, 255 ), 1 )
	y = y + tydist
	dxDrawText ( "3: Supermarket", tx, y, tx, ty, tocolor ( 74, 67, 222, 255 ), 1 )
	y = y + tydist
	dxDrawText ( "4: Farm", tx, y, tx, ty, tocolor ( 54, 172, 47, 255 ), 1 )
	y = y + tydist
	dxDrawText ( "5: Industry", tx, y, tx, ty, tocolor ( 102, 102, 102, 255 ), 1 )
	y = y + tydist
	dxDrawText ( "- : delete", tx, y, tx, ty, tocolor ( 255, 255, 255, 255 ), 1 )
	y = y + tydist
	y = y + tydist
	dxDrawText ( "F2: Leave", tx, y, tx, ty, tocolor ( 108, 214, 230, 255 ), 1 )
end

--Render folden window
function renderClosedHelpWindow()
	y = ty
	dxDrawRectangle ( sx - 160, ty + tydist*9 - 32, 117, 192 - tydist*9, tocolor ( 0, 0, 0, 200 ) ) -- Create black background rectangle.
	y = y + tydist*7
	dxDrawText ( "Loot Place Editor", tx, y + 7, tx, ty, tocolor ( 255, 255, 0, 255 ), 1 )
	y = y + tydist*2
	dxDrawText ( "F2: Join", tx, y, tx, ty, tocolor ( 108, 214, 230, 255 ), 1 )
end
