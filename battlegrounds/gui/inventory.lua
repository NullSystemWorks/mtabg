--[[

				MTA:BG
			MTA Battlegrounds
	Developed By: Null System Works (L, CiBeR, neves768, 1BOY & expert975)
	
]]--

--[[
local screenW, screenH = guiGetScreenSize()
local isInventoryShowing = false


GUIEditor.label[12] = guiCreateLabel(0.08, 0.15, 0.17, 0.04, "YOUR INVENTORY", true)
guiSetFont(GUIEditor.label[12], "default-bold-small")
guiLabelSetHorizontalAlign(GUIEditor.label[12], "center", false)
GUIEditor.label[29] = guiCreateLabel(0.61, 0.19, 0.04, 0.04, "1", true)
guiSetFont(GUIEditor.label[29], "default-bold-small")
guiLabelSetHorizontalAlign(GUIEditor.label[29], "center", false)
guiLabelSetVerticalAlign(GUIEditor.label[29], "center")
GUIEditor.label[30] = guiCreateLabel(0.61, 0.39, 0.04, 0.04, "2", true)
guiSetFont(GUIEditor.label[30], "default-bold-small")
guiLabelSetHorizontalAlign(GUIEditor.label[30], "center", false)
guiLabelSetVerticalAlign(GUIEditor.label[30], "center")
GUIEditor.label[31] = guiCreateLabel(0.61, 0.59, 0.04, 0.04, "3", true)
guiSetFont(GUIEditor.label[31], "default-bold-small")
guiLabelSetHorizontalAlign(GUIEditor.label[31], "center", false)
guiLabelSetVerticalAlign(GUIEditor.label[31], "center")
GUIEditor.label[32] = guiCreateLabel(0.32, 0.15, 0.17, 0.04, "LOOT", true)
guiSetFont(GUIEditor.label[32], "default-bold-small")
guiLabelSetHorizontalAlign(GUIEditor.label[32], "center", false)
GUIEditor.label[33] = guiCreateLabel(0.34, 0.02, 0.29, 0.08, "[PLAYERNAME]", true)
guiLabelSetHorizontalAlign(GUIEditor.label[33], "center", false)
guiLabelSetVerticalAlign(GUIEditor.label[33], "center")
GUIEditor.label[34] = guiCreateLabel(0.06, 0.17, 0.20, 0.70, "", true)
GUIEditor.label[35] = guiCreateLabel(0.31, 0.17, 0.20, 0.70, "", true)



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
    gridlist = {},
	progressbar = {},
	font = {}
}

inventoryGUI.font[1] = guiCreateFont("/fonts/etelka.ttf",11)
inventoryGUI.font[2] = guiCreateFont("/fonts/etelka.ttf",15)
inventoryGUI.font[3] = guiCreateFont("/fonts/etelka.ttf",20)
inventoryGUI.font[4] = guiCreateFont("/fonts/etelka.ttf",25)


inventoryGUI.window[1] = guiCreateWindow(0.00, 0.00, 1.00, 1.00, "#alpha - "..getPlayerName(localPlayer), true)
guiWindowSetMovable(inventoryGUI.window[1], false)
guiWindowSetSizable(inventoryGUI.window[1], false)

inventoryGUI.gridlist[1] = guiCreateGridList(0.01, 0.13, 0.24, 0.61, true, inventoryGUI.window[1])
inventoryGUI.gridlist["inventory"] = guiGridListAddColumn(inventoryGUI.gridlist[1],"Inventory",0.6)
inventoryGUI.gridlist["inventoryamount"] = guiGridListAddColumn(inventoryGUI.gridlist[1],"Amount",0.4)

inventoryGUI.gridlist[2] = guiCreateGridList(0.34, 0.13, 0.24, 0.61, true, inventoryGUI.window[1])
inventoryGUI.gridlist["loot"] = guiGridListAddColumn(inventoryGUI.gridlist[2],"Loot",0.6)
inventoryGUI.gridlist["lootamount"] = guiGridListAddColumn(inventoryGUI.gridlist[2],"Amount",0.4)

inventoryGUI.button[1] = guiCreateButton(0.25, 0.23, 0.03, 0.40, "->", true, inventoryGUI.window[1])
inventoryGUI.button[2] = guiCreateButton(0.31, 0.23, 0.03, 0.40, "<-", true, inventoryGUI.window[1])
inventoryGUI.label[1] = guiCreateLabel(0.01, 0.09, 0.24, 0.04, "YOUR INVENTORY", true, inventoryGUI.window[1])
guiLabelSetHorizontalAlign(inventoryGUI.label[1], "center", false)
inventoryGUI.label[2] = guiCreateLabel(0.34, 0.09, 0.24, 0.04, "LOOT", true, inventoryGUI.window[1])
guiLabelSetHorizontalAlign(inventoryGUI.label[2], "center", false)

inventoryGUI.progressbar[1] = guiCreateProgressBar(0.01, 0.74, 0.24, 0.04, true, inventoryGUI.window[1])
inventoryGUI.label[3] = guiCreateLabel(0.01, 0.74, 0.24, 0.04, "CAPACITY: 0/70", true, inventoryGUI.window[1])
guiLabelSetColor(inventoryGUI.label[3], 0, 0, 0)
guiLabelSetHorizontalAlign(inventoryGUI.label[3], "center", false)

inventoryGUI.label[4] = guiCreateLabel(0.66, 0.13, 0.04, 0.05, "1", true, inventoryGUI.window[1])
guiLabelSetHorizontalAlign(inventoryGUI.label[4], "center", false)
guiLabelSetVerticalAlign(inventoryGUI.label[4], "center")
inventoryGUI.label[5] = guiCreateLabel(0.66, 0.37, 0.04, 0.05, "2", true, inventoryGUI.window[1])
guiLabelSetHorizontalAlign(inventoryGUI.label[5], "center", false)
guiLabelSetVerticalAlign(inventoryGUI.label[5], "center")
inventoryGUI.label[6] = guiCreateLabel(0.66, 0.61, 0.04, 0.05, "3", true, inventoryGUI.window[1])
guiLabelSetHorizontalAlign(inventoryGUI.label[6], "center", false)
guiLabelSetVerticalAlign(inventoryGUI.label[6], "center")
inventoryGUI.label[7] = guiCreateLabel(0.69, 0.13, 0.27, 0.05, "PRIMARY WEAPON:", true, inventoryGUI.window[1])
guiLabelSetVerticalAlign(inventoryGUI.label[7], "center")
inventoryGUI.label["Equip Primary Weapon"] = guiCreateLabel(0.69, 0.18, 0.27, 0.05, "", true, inventoryGUI.window[1])
guiLabelSetVerticalAlign(inventoryGUI.label["Equip Primary Weapon"], "center")
inventoryGUI.label["Equip Secondary Weapon"] = guiCreateLabel(0.69, 0.41, 0.27, 0.05, "", true, inventoryGUI.window[1])
guiLabelSetVerticalAlign(inventoryGUI.label["Equip Secondary Weapon"], "center")
inventoryGUI.label["Equip Special Weapon"] = guiCreateLabel(0.69, 0.65, 0.27, 0.05, "", true, inventoryGUI.window[1])
guiLabelSetVerticalAlign(inventoryGUI.label["Equip Special Weapon"], "center")
inventoryGUI.label[8] = guiCreateLabel(0.69, 0.61, 0.27, 0.05, "SPECIAL WEAPON:", true, inventoryGUI.window[1])
guiLabelSetVerticalAlign(inventoryGUI.label[8], "center")
inventoryGUI.label[9] = guiCreateLabel(0.69, 0.37, 0.27, 0.05, "SECONDARY WEAPON:", true, inventoryGUI.window[1])
guiLabelSetVerticalAlign(inventoryGUI.label[9], "center") 

inventoryGUI.label[10] = guiCreateLabel(0.01, 0.84, 0.24, 0.04, "", true, inventoryGUI.window[1])

for i=1,10 do
	guiSetFont(inventoryGUI.label[i],inventoryGUI.font[1])
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

function sendErrorToInventory(info)
	guiSetText(inventoryGUI.label[10],info)
	setTimer(guiSetText,3000,1,inventoryGUI.label[10],"")
end
addEvent("mtabg_sendErrorToInventory",true)
addEventHandler("mtabg_sendErrorToInventory",localPlayer,sendErrorToInventory)

local playerDataInfoClient = {}



function changeEquippedWeaponGUI(weaponType,weaponName,dataTable)
	-- 8 = Primary, 9 = Secondary, 10 = Special
	guiSetText(inventoryGUI.label[weaponType],weaponName)
	playerDataInfoClient[localPlayer] = {}
	for i, data in ipairs(dataTable) do
		if data[2] == "currentweapon_1" then
			if data[3] then
				table.insert(playerDataInfoClient[localPlayer],{data[2],data[3]})
			end
		elseif data[2] == "currentweapon_2" then
			if data[3] then
				table.insert(playerDataInfoClient[localPlayer],{data[2],data[3]})
			end
		end
	end
end
addEvent("mtabg_changeEquippedWeaponGUI",true)
addEventHandler("mtabg_changeEquippedWeaponGUI",localPlayer,changeEquippedWeaponGUI)

local playerCapacity = {}
function sendCapacityToPlayerClient(maxCapacity,used)
	playerCapacity[localPlayer] = {}
	table.insert(playerCapacity[localPlayer],{maxCapacity,used})
	guiSetText(inventoryGUI.label[3],"CAPACITY: "..tostring(used).."/"..tostring(maxCapacity))
	local progress = (used/maxCapacity)*100
	guiProgressBarSetProgress(inventoryGUI.progressbar[1],progress)
end
addEvent("mtabg_sendCapacityToPlayerClient",true)
addEventHandler("mtabg_sendCapacityToPlayerClient",root,sendCapacityToPlayerClient)
	

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
addEventHandler("onClientGUIClick", inventoryGUI.button[1], moveItemFromInventoryToLoot,false)

function moveItemFromLootToInventory()
	if isPlayerInLoot() then
		col = getElementData(localPlayer,"currentCol")
	end
	local itemName = guiGridListGetItemText(inventoryGUI.gridlist[2],guiGridListGetSelectedItem(inventoryGUI.gridlist[2]),1)
	triggerServerEvent("mtabg_onItemFromLootToInventory",localPlayer,itemName,col)
end
addEventHandler("onClientGUIClick",inventoryGUI.button[2],moveItemFromLootToInventory,false)

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




  
