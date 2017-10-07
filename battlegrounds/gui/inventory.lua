--[[

				MTA:BG
			MTA Battlegrounds
	Developed By: Null System Works

]]--

--[[
local screenW, screenH = guiGetScreenSize()
local isInventoryShowing = false


inventoryGUI.label[12] = guiCreateLabel(0.08, 0.15, 0.17, 0.04, "YOUR INVENTORY", true)
guiSetFont(inventoryGUI.label[12], "default-bold-small")
guiLabelSetHorizontalAlign(inventoryGUI.label[12], "center", false)
inventoryGUI.label[29] = guiCreateLabel(0.61, 0.19, 0.04, 0.04, "1", true)
guiSetFont(inventoryGUI.label[29], "default-bold-small")
guiLabelSetHorizontalAlign(inventoryGUI.label[29], "center", false)
guiLabelSetVerticalAlign(inventoryGUI.label[29], "center")
inventoryGUI.label[30] = guiCreateLabel(0.61, 0.39, 0.04, 0.04, "2", true)
guiSetFont(inventoryGUI.label[30], "default-bold-small")
guiLabelSetHorizontalAlign(inventoryGUI.label[30], "center", false)
guiLabelSetVerticalAlign(inventoryGUI.label[30], "center")
inventoryGUI.label[31] = guiCreateLabel(0.61, 0.59, 0.04, 0.04, "3", true)
guiSetFont(inventoryGUI.label[31], "default-bold-small")
guiLabelSetHorizontalAlign(inventoryGUI.label[31], "center", false)
guiLabelSetVerticalAlign(inventoryGUI.label[31], "center")
inventoryGUI.label[32] = guiCreateLabel(0.32, 0.15, 0.17, 0.04, "LOOT", true)
guiSetFont(inventoryGUI.label[32], "default-bold-small")
guiLabelSetHorizontalAlign(inventoryGUI.label[32], "center", false)
inventoryGUI.label[33] = guiCreateLabel(0.34, 0.02, 0.29, 0.08, "[PLAYERNAME]", true)
guiLabelSetHorizontalAlign(inventoryGUI.label[33], "center", false)
guiLabelSetVerticalAlign(inventoryGUI.label[33], "center")
inventoryGUI.label[34] = guiCreateLabel(0.06, 0.17, 0.20, 0.70, "", true)
inventoryGUI.label[35] = guiCreateLabel(0.31, 0.17, 0.20, 0.70, "", true)



function drawInventory()
dxDrawImage(screenW * 0.0000, screenH * 0.0000, screenW * 1.0000, screenH * 1.0000, "/gui/images/background.png", 0, 0, 0, tocolor(0, 0, 0, 222), false)
dxDrawImage(screenW * 0.0788, screenH * 0.1883, screenW * 0.1725, screenH * 0.0583, "/gui/images/inventory_slot.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
dxDrawImage(screenW * 0.0788, screenH * 0.2533, screenW * 0.1725, screenH * 0.0583, "/gui/images/inventory_slot.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
dxDrawImage(screenW * 0.0788, screenH * 0.3183, screenW * 0.1725, screenH * 0.0583, "/gui/images/inventory_slot.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
dxDrawImage(screenW * 0.0788, screenH * 0.3833, screenW * 0.1725, screenH * 0.0583, "/gui/images/inventory_slot.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
dxDrawImage(screenW * 0.0788, screenH * 0.4483, screenW * 0.1725, screenH * 0.0583, "/gui/images/inventory_slot.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
dxDrawImage(screenW * 0.0788, screenH * 0.5150, screenW * 0.1725, screenH * 0.0583, "/gui/images/inventory_slot.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
dxDrawImage(screenW * 0.0788, screenH * 0.5817, screenW * 0.1725, screenH * 0.0583, "/gui/images/inventory_slot.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
dxDrawImage(screenW * 0.0788, screenH * 0.6483, screenW * 0.1725, screenH * 0.0583, "/gui/images/inventory_slot.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
dxDrawImage(screenW * 0.0788, screenH * 0.7150, screenW * 0.1725, screenH * 0.0583, "/gui/images/inventory_slot.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
dxDrawImage(screenW * 0.0788, screenH * 0.7817, screenW * 0.1725, screenH * 0.0583, "/gui/images/inventory_slot.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
dxDrawImage(screenW * 0.2637, screenH * 0.1850, screenW * 0.0112, screenH * 0.6550, "/gui/images/scrollbar.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
dxDrawImage(screenW * 0.2963, screenH * 0.1850, screenW * 0.0112, screenH * 0.6550, "/gui/images/scrollbar.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
dxDrawImage(screenW * 0.3200, screenH * 0.1883, screenW * 0.1725, screenH * 0.0583, "/gui/images/inventory_slot.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
dxDrawImage(screenW * 0.3200, screenH * 0.2533, screenW * 0.1725, screenH * 0.0583, "/gui/images/inventory_slot.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
dxDrawImage(screenW * 0.3200, screenH * 0.3183, screenW * 0.1725, screenH * 0.0583, "/gui/images/inventory_slot.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
dxDrawImage(screenW * 0.3200, screenH * 0.3833, screenW * 0.1725, screenH * 0.0583, "/gui/images/inventory_slot.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
dxDrawImage(screenW * 0.3200, screenH * 0.4483, screenW * 0.1725, screenH * 0.0583, "/gui/images/inventory_slot.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
dxDrawImage(screenW * 0.3200, screenH * 0.5150, screenW * 0.1725, screenH * 0.0583, "/gui/images/inventory_slot.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
dxDrawImage(screenW * 0.3200, screenH * 0.5817, screenW * 0.1725, screenH * 0.0583, "/gui/images/inventory_slot.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
dxDrawImage(screenW * 0.3200, screenH * 0.6483, screenW * 0.1725, screenH * 0.0583, "/gui/images/inventory_slot.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
dxDrawImage(screenW * 0.3200, screenH * 0.7150, screenW * 0.1725, screenH * 0.0583, "/gui/images/inventory_slot.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
dxDrawImage(screenW * 0.3200, screenH * 0.7817, screenW * 0.1725, screenH * 0.0583, "/gui/images/inventory_slot.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
dxDrawImage(screenW * 0.6075, screenH * 0.1883, screenW * 0.3625, screenH * 0.0067, "/gui/images/solo_slot.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
dxDrawImage(screenW * 0.6075, screenH * 0.3833, screenW * 0.3625, screenH * 0.0067, "/gui/images/solo_slot.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
dxDrawImage(screenW * 0.6075, screenH * 0.5833, screenW * 0.3625, screenH * 0.0067, "/gui/images/solo_slot.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
dxDrawImage(screenW * 0.6075, screenH * 0.7833, screenW * 0.3625, screenH * 0.0067, "/gui/images/solo_slot.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
end
]]




inventoryGUI = {
    capacity = {},
    label = {},
    button = {},
    window = {},
	staticimage = {},
    gridlist = {},
	progressbar = {},
	font = {}
}

inventoryGUI.font[1] = guiCreateFont("/fonts/bebas.otf",13)
inventoryGUI.font[2] = guiCreateFont("/fonts/bebas.otf",15)
inventoryGUI.font[3] = guiCreateFont("/fonts/bebas.otf",20)
inventoryGUI.font[4] = guiCreateFont("/fonts/bebas.otf",25)


-- Inventory Init
inventoryGUI.window[1] = guiCreateStaticImage(0.00, 0.00, 1.00, 1.00, "gui/images/solo_slot.png", true)
guiSetAlpha(inventoryGUI.window[1], 0.98)
guiSetProperty(inventoryGUI.window[1], "ImageColours", "tl:FE111111 tr:FE111111 bl:FE111111 br:FE111111")

--Inventory Divider
inventoryGUI.staticimage[2] = guiCreateStaticImage(0.58, 0.35, 0.40, 0.003, "gui/images/solo_slot.png", true, inventoryGUI.window[1])
inventoryGUI.staticimage[3] = guiCreateStaticImage(0.58, 0.53, 0.40, 0.003, "gui/images/solo_slot.png", true, inventoryGUI.window[1])
inventoryGUI.staticimage[4] = guiCreateStaticImage(0.58, 0.71, 0.40, 0.003, "gui/images/solo_slot.png", true, inventoryGUI.window[1])

-- Weapons pictures
inventoryGUI.staticimage["shotsniper"] = guiCreateStaticImage(0.58, 0.21, 0.40, 0.13, "gui/images/solo_slot.png", true, inventoryGUI.window[1])
inventoryGUI.staticimage["rifles"] = guiCreateStaticImage(0.58, 0.40, 0.40, 0.13, "gui/images/solo_slot.png", true, inventoryGUI.window[1])
inventoryGUI.staticimage["handsub"] = guiCreateStaticImage(0.58, 0.59, 0.40, 0.13, "gui/images/solo_slot.png", true, inventoryGUI.window[1])
guiSetVisible(inventoryGUI.staticimage["shotsniper"],false)
guiSetVisible(inventoryGUI.staticimage["rifles"],false)
guiSetVisible(inventoryGUI.staticimage["handsub"],false)
inventoryGUI.label["shotsniper"] = guiCreateLabel(0.58, 0.17, 0.40, 0.04, "", true, inventoryGUI.window[1])
inventoryGUI.label["rifles"] = guiCreateLabel(0.58, 0.36, 0.40, 0.04, "", true, inventoryGUI.window[1])
inventoryGUI.label["handsub"] = guiCreateLabel(0.58, 0.54, 0.40, 0.04, "", true, inventoryGUI.window[1])
guiSetFont(inventoryGUI.label["shotsniper"],inventoryGUI.font[1])
guiSetFont(inventoryGUI.label["rifles"],inventoryGUI.font[1])
guiSetFont(inventoryGUI.label["handsub"],inventoryGUI.font[1])


-- Actual inventory
inventoryGUI.gridlist[1] = guiCreateGridList(0.305, 0.17, 0.20, 0.54, true, inventoryGUI.window[1])
inventoryGUI.gridlist["inventory"] = guiGridListAddColumn(inventoryGUI.gridlist[1],"Inventory",0.6)
inventoryGUI.gridlist["inventoryamount"] = guiGridListAddColumn(inventoryGUI.gridlist[1],"Amount",0.4)
guiGridListSetSortingEnabled(inventoryGUI.gridlist[1],false)

inventoryGUI.gridlist[2] = guiCreateGridList(0.005, 0.17, 0.20, 0.54, true, inventoryGUI.window[1])
inventoryGUI.gridlist["loot"] = guiGridListAddColumn(inventoryGUI.gridlist[2],"Loot",0.6)
inventoryGUI.gridlist["lootamount"] = guiGridListAddColumn(inventoryGUI.gridlist[2],"Amount",0.4)
guiGridListSetSortingEnabled(inventoryGUI.gridlist[2],false)

-- Inventory buttons
inventoryGUI.button[1] = guiCreateStaticImage(0.21, 0.17, 0.04, 0.54, "gui/images/solo_slot.png", true, inventoryGUI.window[1]) -- ->
guiSetProperty(inventoryGUI.button[1], "ImageColours", "tl:FE111111 tr:FE111111 bl:FE111111 br:FE111111")
inventoryGUI.label[6] = guiCreateLabel(0.00, 0.00, 1.00, 1.00, "->", true, inventoryGUI.button[1])
guiLabelSetHorizontalAlign(inventoryGUI.label[6], "center", false)
guiLabelSetVerticalAlign(inventoryGUI.label[6], "center")
inventoryGUI.button[2] = guiCreateStaticImage(0.26, 0.17, 0.04, 0.54, "gui/images/solo_slot.png", true, inventoryGUI.window[1]) -- <-
guiSetProperty(inventoryGUI.button[2], "ImageColours", "tl:FE111111 tr:FE111111 bl:FE111111 br:FE111111")
 inventoryGUI.label[5] = guiCreateLabel(0.00, 0.00, 1.00, 1.00, "<-", true, inventoryGUI.button[2])
guiLabelSetColor(inventoryGUI.label[5], 254, 254, 254)
guiLabelSetHorizontalAlign(inventoryGUI.label[5], "center", false)
guiLabelSetVerticalAlign(inventoryGUI.label[5], "center")

inventoryGUI.label[7] = guiCreateLabel(0.01, 0.13, 0.20, 0.04, "VICINITY", true, inventoryGUI.window[1])
guiLabelSetVerticalAlign(inventoryGUI.label[7], "center")
inventoryGUI.label[8] = guiCreateLabel(0.305, 0.13, 0.20, 0.04, "YOUR LOOT", true, inventoryGUI.window[1])
guiLabelSetVerticalAlign(inventoryGUI.label[8], "center")
inventoryGUI.label[9] = guiCreateLabel(0.01, 0.72, 0.29, 0.06, "", true, inventoryGUI.window[1])
guiLabelSetColor(inventoryGUI.label[9], 217, 0, 0)
guiLabelSetVerticalAlign(inventoryGUI.label[9], "center")
inventoryGUI.progressbar[1] = guiCreateProgressBar(0.305, 0.72, 0.20, 0.04, true, inventoryGUI.window[1])
inventoryGUI.label[10] = guiCreateLabel(0.00, 0.00, 1.00, 1.00, "CAPACITY: 0/0", true, inventoryGUI.progressbar[1])
guiLabelSetColor(inventoryGUI.label[10], 0, 0, 0)
guiLabelSetHorizontalAlign(inventoryGUI.label[10], "center", false)
guiLabelSetVerticalAlign(inventoryGUI.label[10], "center")

inventoryGUI.label[11] = guiCreateLabel(0.58, 0.72, 0.40, 0.04, "STATUS", true, inventoryGUI.window[1])

inventoryGUI.staticimage[10] = guiCreateStaticImage(0.58, 0.76, 0.10, 0.14, "gui/images/solo_slot.png", true, inventoryGUI.window[1]) -- Armor
inventoryGUI.progressbar[2] = guiCreateProgressBar(0.58, 0.91, 0.10, 0.02, true, inventoryGUI.window[1])
guiSetVisible(inventoryGUI.staticimage[10],false)
guiSetVisible(inventoryGUI.progressbar[2],false)

inventoryGUI.staticimage[11] = guiCreateStaticImage(0.69, 0.76, 0.10, 0.14, "gui/images/solo_slot.png", true, inventoryGUI.window[1]) -- Energy Drink Regeneration
inventoryGUI.progressbar[3] = guiCreateProgressBar(0.69, 0.91, 0.10, 0.02, true, inventoryGUI.window[1])
guiSetVisible(inventoryGUI.staticimage[11],false)
guiSetVisible(inventoryGUI.progressbar[3],false)

inventoryGUI.label[4] = guiCreateLabel(0.38, 0.01, 0.23, 0.03, "#Alpha - "..tostring(getPlayerName(localPlayer)), true, inventoryGUI.window[1])
guiLabelSetHorizontalAlign(inventoryGUI.label[4], "center", false)
guiLabelSetVerticalAlign(inventoryGUI.label[4], "center")

for i=1,11 do
	if inventoryGUI.label[i] then
		if i == 4 then
			guiSetFont(inventoryGUI.label[4],inventoryGUI.font[3])
		else
			guiSetFont(inventoryGUI.label[i],inventoryGUI.font[1])
		end
	end
end

guiSetVisible(inventoryGUI.window[1],false)


function isPlayerInLoot()
	if getElementData(localPlayer,"loot") then
		return getElementData(localPlayer,"currentCol")
	end
	return false
end

inventoryIsShowing = false
function displayInventory(key,keyState)
	if getElementData(localPlayer,"participatingInGame") then
		if keyState == "down" then
			guiSetVisible(inventoryGUI.window[1],not guiGetVisible(inventoryGUI.window[1]))
			showCursor(not isCursorShowing())
			triggerServerEvent("mtabg_refreshInventory",localPlayer)
			inventoryIsShowing = not inventoryIsShowing
			if guiGetVisible(inventoryGUI.window[1]) then
				disableMenu()
				guiGridListClear(inventoryGUI.gridlist[1])
				guiGridListClear(inventoryGUI.gridlist[2])
			else
				hideRightClickInventoryMenu()
			end
			if isPlayerInLoot() then
				local col = getElementData(localPlayer,"currentCol")
				local gearName = getElementData(localPlayer,"lootname")
				triggerServerEvent("mtabg_refreshLoot",localPlayer,col,gearName)
			end
		end
	end	
end
bindKey ("tab","down",displayInventory)

function isInventoryShowing()
	return inventoryIsShowing
end

function displayInventoryManually()
	guiSetVisible(inventoryGUI.window[1],not guiGetVisible(inventoryGUI.window[1]))
	showCursor(not isCursorShowing())
	triggerServerEvent("mtabg_refreshInventory",localPlayer)
	if guiGetVisible(inventoryGUI.window[1]) then
		onClientOpenInventoryStopMenu()
	end
end

function hideInventoryManually()
	guiSetVisible(inventoryGUI.window[1],false)
	showCursor(false)
	hideRightClickInventoryMenu()
end
addEvent("hideInventoryManually",true)
addEventHandler("hideInventoryManually",localPlayer,hideInventoryManually)

function refreshInventoryManually()
	triggerServerEvent("mtabg_refreshInventory",localPlayer)
end
addEvent("refreshInventoryManually",true)
addEventHandler("refreshInventoryManually",localPlayer,refreshInventoryManually)

function refreshLootManually(loot)
	triggerServerEvent("mtabg_refreshLoot",localPlayer,loot,"")
end
addEvent("refreshLootManually",true)
addEventHandler("refreshLootManually",localPlayer,refreshLootManually)

local errorTimer 
function sendErrorToInventory(info,r,g,b)
	if info then
		if isTimer(errorTimer) then killTimer(errorTimer) end
		guiSetText(inventoryGUI.label[9],info)
		guiLabelSetColor(inventoryGUI.label[9],r,g,b)
		errorTimer = setTimer(guiSetText,3000,1,inventoryGUI.label[9],"")
	end
end
addEvent("mtabg_sendErrorToInventory",true)
addEventHandler("mtabg_sendErrorToInventory",localPlayer,sendErrorToInventory)

function changeEquippedWeaponGUI(weaponType,weaponName,imagePath,guiLabelName,relX,relY,posX,posY)
	guiSetText(inventoryGUI.label[guiLabelName],weaponName)
	if isElement(inventoryGUI.staticimage[guiLabelName]) then
		destroyElement(inventoryGUI.staticimage[guiLabelName])
	end
	inventoryGUI.staticimage[guiLabelName] = guiCreateStaticImage(posX,posY,relX,relY,"gui/images/"..imagePath,true,inventoryGUI.window[1])
	guiSetVisible(inventoryGUI.staticimage[guiLabelName],true)
end
addEvent("mtabg_changeEquippedWeaponGUI",true)
addEventHandler("mtabg_changeEquippedWeaponGUI",localPlayer,changeEquippedWeaponGUI)

function onPlayerAddArmorImage(armor)
	if isElement(inventoryGUI.staticimage[10]) then
		destroyElement(inventoryGUI.staticimage[10])
	end
	inventoryGUI.staticimage[10] = guiCreateStaticImage(0.58, 0.76, 0.10, 0.14, "gui/images/"..armor..".png", true, inventoryGUI.window[1])
	guiSetVisible(inventoryGUI.staticimage[10],true)
	guiSetVisible(inventoryGUI.progressbar[2],true)
end
addEvent("mtabg_onPlayerAddArmorImage",true)
addEventHandler("mtabg_onPlayerAddArmorImage",root,onPlayerAddArmorImage)

local playerCapacity = {}
function sendCapacityToPlayerClient(maxCapacity,used)
	playerCapacity[localPlayer] = {}
	table.insert(playerCapacity[localPlayer],{maxCapacity,used})
	guiSetText(inventoryGUI.label[10],"CAPACITY: "..tostring(used).."/"..tostring(maxCapacity))
	local progress = (used/maxCapacity)*100
	guiProgressBarSetProgress(inventoryGUI.progressbar[1],progress)
end
addEvent("mtabg_sendCapacityToPlayerClient",true)
addEventHandler("mtabg_sendCapacityToPlayerClient",root,sendCapacityToPlayerClient)

function changeColorOfButtonLeftOnMouseOver()
	guiSetProperty(inventoryGUI.button[1], "ImageColours", "tl:FE8C8C8C tr:FE8C8C8C bl:FE8C8C8C br:FE8C8C8C")
end
addEventHandler("onClientMouseEnter",inventoryGUI.label[6],changeColorOfButtonLeftOnMouseOver,false)

function changeColorOfButtonRightOnMouseOver()
	guiSetProperty(inventoryGUI.button[2], "ImageColours", "tl:FE8C8C8C tr:FE8C8C8C bl:FE8C8C8C br:FE8C8C8C")
end
addEventHandler("onClientMouseEnter",inventoryGUI.label[5],changeColorOfButtonRightOnMouseOver,false)

function revertColorOfButtonLeftOnMouseOver()
	guiSetProperty(inventoryGUI.button[1], "ImageColours", "tl:FE111111 tr:FE111111 bl:FE111111 br:FE111111")
end
addEventHandler("onClientMouseLeave",inventoryGUI.label[6],revertColorOfButtonLeftOnMouseOver,false)

function revertColorOfButtonRightOnMouseOver()
	guiSetProperty(inventoryGUI.button[2], "ImageColours", "tl:FE111111 tr:FE111111 bl:FE111111 br:FE111111")
end
addEventHandler("onClientMouseLeave",inventoryGUI.label[5],revertColorOfButtonRightOnMouseOver,false)

function populateGridListWithItems(gridList,columnName,columnAmount,itemName,itemAmount)
	if itemAmount > 0 then
		if itemName ~= guiGridListGetItemText(inventoryGUI.gridlist[gridList],guiGridListGetSelectedItem(inventoryGUI.gridlist[gridList]),1) then
			row = guiGridListAddRow(inventoryGUI.gridlist[gridList])
			guiGridListSetItemText(inventoryGUI.gridlist[gridList], row, inventoryGUI.gridlist[columnName],itemName, false, false)
		end
		guiGridListSetItemText(inventoryGUI.gridlist[gridList], row, inventoryGUI.gridlist[columnAmount],itemAmount, false, false)
	end
end
addEvent("mtabg_populateGridListWithItems",true)
addEventHandler("mtabg_populateGridListWithItems",localPlayer,populateGridListWithItems)

function clearGridList(gridList)
	guiGridListSetSelectedItem(inventoryGUI.gridlist[gridList],0,0)
	guiGridListClear(inventoryGUI.gridlist[gridList])
end
addEvent("mtabg_clearGridList",true)
addEventHandler("mtabg_clearGridList",localPlayer,clearGridList)

function moveItemFromInventoryToLoot()
	if isPlayerInLoot() then
		col = getElementData(localPlayer,"currentCol")
	else
		col = false
	end
	local itemName = guiGridListGetItemText(inventoryGUI.gridlist[1],guiGridListGetSelectedItem(inventoryGUI.gridlist[1]),1)
	triggerServerEvent("mtabg_onItemFromInventoryToLoot",localPlayer,itemName,col)
end
addEventHandler("onClientGUIClick", inventoryGUI.label[5], moveItemFromInventoryToLoot,false)

function moveItemFromLootToInventory()
	if isPlayerInLoot() then
		col = getElementData(localPlayer,"currentCol")
	end
	local itemName = guiGridListGetItemText(inventoryGUI.gridlist[2],guiGridListGetSelectedItem(inventoryGUI.gridlist[2]),1)
	triggerServerEvent("mtabg_onItemFromLootToInventory",localPlayer,itemName,col)
end
addEventHandler("onClientGUIClick",inventoryGUI.label[6],moveItemFromLootToInventory,false)

rightClick = {}

rightClick["window"] = guiCreateStaticImage(0, 0, 0.05, 0.0215, "gui/images/solo_slot.png", true)
rightClick["label"] = guiCreateLabel(0, 0, 1, 1, "", true, rightClick["window"])
guiLabelSetHorizontalAlign(rightClick["label"], "center")
guiLabelSetVerticalAlign(rightClick["label"], "center")
guiSetFont(rightClick["label"], "default-bold-small")
guiSetVisible(rightClick["window"], false)

function onPlayerRightMouseButton()
	local itemName = guiGridListGetItemText(inventoryGUI.gridlist[1], guiGridListGetSelectedItem(inventoryGUI.gridlist[1]),1)
	local itemName,itemInfo = getInventoryInfosForRightClickMenu(itemName)
	if isCursorShowing() and guiGetVisible(inventoryGUI.window[1]) and itemInfo then
		showRightClickMenu(itemName,itemInfo)
	end
end
bindKey("mouse2","down",onPlayerRightMouseButton)

function getInventoryInfosForRightClickMenu(itemName)
	for i, itemInfo in ipairs(sItemLang["en_US"]) do
		if itemName == itemInfo[1] then
			return itemName,itemInfo[2]
		end
	end
end

function hideRightClickInventoryMenu()
	guiSetVisible(rightClick["window"], false)
end

function showRightClickMenu(itemName, itemInfo)
	if itemInfo and itemInfo ~= "" then
		local screenx, screeny, worldx, worldy, worldz = getCursorPosition()
		guiSetVisible(rightClick["window"], true)
		guiSetText(rightClick["label"], itemInfo.." "..itemName)
		local width = guiLabelGetTextExtent(rightClick["label"])
		guiSetPosition(rightClick["window"], screenx, screeny, true)
		local x, y = guiGetSize(rightClick["window"], false)
		guiSetSize(rightClick["window"], width+10, y, false)
		guiBringToFront(rightClick["window"])
		setElementData(rightClick["window"], "iteminfo", {itemName, itemInfo})
		if isTimer(hideTimer) then 
			killTimer(hideTimer)
			hideTimer = setTimer(hideRightClickInventoryMenu,5000,1)
		else
			hideTimer = setTimer(hideRightClickInventoryMenu,5000,1)
		end
	end
end
addEvent("mtabg_showRightClickMenu",true)
addEventHandler("mtabg_showRightClickMenu",localPlayer,showRightClickMenu)

function onPlayerRightClickMenu(button, state)
	if button == "left" then
		local itemName, itemInfo = getElementData(rightClick["window"], "iteminfo")[1], getElementData(rightClick["window"], "iteminfo")[2]
		hideRightClickInventoryMenu()
		triggerServerEvent("mtabg_onPlayerUseItem",localPlayer,itemName,itemInfo)
	end
end
addEventHandler("onClientGUIClick", rightClick["label"], onPlayerRightClickMenu, false)




  
