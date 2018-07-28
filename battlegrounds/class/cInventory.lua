Inventory = {}

local fontInventory = GuiFont("/font/bebas.otf", 13)
local fontPlayerName = GuiFont("/font/bebas.otf", 20)

local imgBackground =
	GuiStaticImage(0.00, 0.00, 1.00, 1.00, "gui/img/pixel.png", true)
imgBackground:setAlpha(0.98)
imgBackground:setProperty("ImageColours",
	"tl:FE111111 tr:FE111111 bl:FE111111 br:FE111111")

local imgDivider1 = GuiStaticImage(0.58, 0.35, 0.40, 0.003,
	"gui/img/pixel.png", true, imgBackground)
local imgDivider2 = GuiStaticImage(0.58, 0.53, 0.40, 0.003,
	"gui/img/pixel.png", true, imgBackground)
local imgDivider3 = GuiStaticImage(0.58, 0.71, 0.40, 0.003,
	"gui/img/pixel.png", true, imgBackground)

local imgWeaponPrimary = GuiStaticImage(0.58, 0.40, 0.40, 0.13,
	"gui/img/pixel.png", true, imgBackground)
imgWeaponPrimary:setVisible(false)
local lblWeaponPrimary =
	GuiLabel(0.58, 0.36, 0.40, 0.04, "", true, imgBackground)
lblWeaponPrimary:setFont(fontInventory)

local imgWeaponSecondary = GuiStaticImage(0.58, 0.59, 0.40, 0.13,
	"gui/img/pixel.png", true, imgBackground)
imgWeaponSecondary:setVisible(false)
local lblWeaponSecondary =
	GuiLabel(0.58, 0.54, 0.40, 0.04, "", true, imgBackground)
lblWeaponSecondary:setFont(fontInventory)

local gridInventory =
	GuiGridList(0.305, 0.17, 0.20, 0.54, true, imgBackground)
local colInventoryItemName =
	gridInventory:addColumn(str("inventoryYourLoot"), 0.6)
local colInventoryItemAmount =
	gridInventory:addColumn(str("inventoryItemAmount"), 0.4)
gridInventory:setSortingEnabled(false)

local gridLoot = GuiGridList(0.005, 0.17, 0.20, 0.54, true, imgBackground)
local colLootItemName =
	gridLoot:addColumn(str("inventoryVicinityLoot"), 0.6)
local colLootItemAmount =
	gridLoot:addColumn(str("inventoryItemAmount"), 0.4)
gridLoot:setSortingEnabled(false)


local btTakeItem = GuiStaticImage(0.21, 0.17, 0.04, 0.54,
	"gui/img/pixel.png", true, imgBackground)
btTakeItem:setProperty("ImageColours",
	"tl:FE111111 tr:FE111111 bl:FE111111 br:FE111111")
local lblTakeItem =
	GuiLabel(0.00, 0.00, 1.00, 1.00, "->", true, btTakeItem)
lblTakeItem:setHorizontalAlign("center", false)
lblTakeItem:setVerticalAlign("center")

local btLeaveItem = GuiStaticImage(0.26, 0.17, 0.04, 0.54,
	"gui/img/pixel.png", true, imgBackground)
btLeaveItem:setProperty("ImageColours",
	"tl:FE111111 tr:FE111111 bl:FE111111 br:FE111111")
local lblLeaveItem =
	GuiLabel(0.00, 0.00, 1.00, 1.00, "<-", true, btLeaveItem)
lblLeaveItem:setColor(254, 254, 254)
lblLeaveItem:setHorizontalAlign("center", false)
lblLeaveItem:setVerticalAlign("center")

local lblVicinityLoot = GuiLabel(0.01, 0.13, 0.20, 0.04,
	str("inventoryVicinityLoot"), true, imgBackground)
lblVicinityLoot:setVerticalAlign("center")
local lblYourLoot = GuiLabel(0.305, 0.13, 0.20, 0.04,
	str("inventoryYourLoot"), true, imgBackground)
lblYourLoot:setVerticalAlign("center")
local lblMessage = GuiLabel(0.01, 0.72, 0.29, 0.06, "", true, imgBackground)
lblMessage:setColor(217, 0, 0)
lblMessage:setVerticalAlign("center")
local barCapacity = GuiProgressBar(0.305, 0.72, 0.20, 0.04, true, imgBackground)
local lblCapacity = GuiLabel(0.00, 0.00, 1.00, 1.00,
	str("inventoryCapacity", 0, 0), true, barCapacity)
lblCapacity:setColor(0, 0, 0)
lblCapacity:setHorizontalAlign("center", false)
lblCapacity:setVerticalAlign("center")

local lblStatus = GuiLabel(0.58, 0.72, 0.40, 0.04,
	str("inventoryStatus"), true, imgBackground)

local imgArmor = GuiStaticImage(0.58, 0.76, 0.10, 0.14, "gui/img/pixel.png",
	true, imgBackground)
local barArmor = GuiProgressBar(0.58, 0.91, 0.10, 0.02, true, imgBackground)
imgArmor:setVisible(false)
barArmor:setVisible(false)

local lblPlayerName = GuiLabel(0.38, 0.01, 0.23, 0.03,
	str("inventoryPlayerName", localPlayer.name), true, imgBackground)
lblPlayerName:setHorizontalAlign("center", false)
lblPlayerName:setVerticalAlign("center")

lblPlayerName:setFont(fontPlayerName)
lblLeaveItem:setFont(fontInventory)
lblTakeItem:setFont(fontInventory)
lblVicinityLoot:setFont(fontInventory)
lblYourLoot:setFont(fontInventory)
lblMessage:setFont(fontInventory)
lblCapacity:setFont(fontInventory)
lblStatus:setFont(fontInventory)

function Inventory.getVisible()
	return imgBackground:getVisible()
end

function Inventory.setVisible(visible)
	imgBackground:setVisible(visible)
end

Inventory.setVisible(false)

local function isPlayerInLoot()
	if localPlayer:getData("currentCol") then
		return localPlayer:getData("currentCol")
	end
	return false
end

local imgActionPopup =
	GuiStaticImage(0, 0, 0.05, 0.0215, "gui/img/pixel.png", true)
local lblActionPopup = GuiLabel(0, 0, 1, 1, "", true, imgActionPopup)
lblActionPopup:setHorizontalAlign("center")
lblActionPopup:setVerticalAlign("center")
lblActionPopup:setFont("default-bold-small")
local timerActionPopup

function Inventory.getPopupVisible()
	return imgActionPopup:getVisible()
end

function Inventory.setPopupVisible(isVisible)
	imgActionPopup:setVisible(isVisible)
end
Inventory.setPopupVisible(false)

local function displayInventory(key, keyState)
	if localPlayer:getInMatch() then
		showCursor(not isCursorShowing())
		triggerServerEvent("onRefreshInventory", localPlayer)
		Inventory.setVisible(not Inventory.getVisible())
		if Inventory.getVisible() then
			SideMenu.hide()
			gridInventory:clear()
			gridLoot:clear()
		else
			Inventory.setPopupVisible(false)
		end
		if isPlayerInLoot() then
			local col = localPlayer:getData("currentCol")
			triggerServerEvent("onRefreshLoot", localPlayer, col)
		end
	end
end
bindKey ("tab", "down", displayInventory)

local msgTimer
local inventoryMessage
local inventoryMessageArgs
local function updateInventoryMessage()
	if isTimer(msgTimer) then
		local info
		local r, g, b = 255, 0, 0
		if inventoryMessage == "use" then
			info = str("inventoryMessageUseItem", inventoryMessageArgs[1])
			g, b = 255, 255
		elseif inventoryMessage == "noAmmo" then
			info = str("inventoryMessageNoAmmo")
		elseif inventoryMessage == "fullHealth" then
			info = str("inventoryMessageFullHealth")
		elseif inventoryMessage == "fullInventory" then
			info = str("inventoryMessageFullInventory")
		end
		lblMessage:setText(info)
		lblMessage:setColor(r, g, b)
	end
end

local function hideInventoryMessage()
	lblMessage:setVisible(false)
	if isTimer(msgTimer) then
		msgTimer:destroy()
	end
	msgTimer = nil
end

local function showInventoryMessage(message, ...)
	inventoryMessage = message
	inventoryMessageArgs = arg
	lblMessage:setVisible(true)
	if isTimer(msgTimer) then
		msgTimer:destroy()
	end
	msgTimer = Timer(hideInventoryMessage, 3000, 1)

	local info, r, g, b = updateInventoryMessage(message, unpack(arg))
end
addEvent("onShowInventoryMessage", true)
addEventHandler("onShowInventoryMessage", localPlayer, showInventoryMessage)

local function removeEquippedWeaponGui(itemName)
	if getWeaponGuiName(itemName) == "handsub" then
		if(isElement(imgWeaponSecondary)) then
			imgWeaponSecondary:destroy()
		end
		lblWeaponSecondary:setText("")
	elseif getWeaponGuiName(itemName) == "rifles" then
		if(isElement(imgWeaponPrimary)) then --TODO:why? fishy
			imgWeaponPrimary:destroy()
		end
		lblWeaponPrimary:setText("")
	end
end
addEvent("onUnequipWeapon", true)
addEventHandler("onUnequipWeapon", localPlayer, removeEquippedWeaponGui)

local function changeEquippedWeaponGui(itemName)
	local imagePath = getWeaponImagePath(itemName)
	--TODO: size and position depend only on weapon class
	local relX = getWeaponImageSizeX(itemName)
	local relY = getWeaponImageSizeY(itemName)
	local posX = getWeaponImagePositionX(itemName)
	local posY = getWeaponImagePositionY(itemName)

	removeEquippedWeaponGui(itemName)
	--TODO: generalize/decouple to weapon classes (primary, secondary, etc)
	if getWeaponGuiName(itemName) == "handsub" then
		lblWeaponSecondary:setText(itemName)
		imgWeaponSecondary =
			GuiStaticImage(posX, posY, relX, relY, "gui/img/" ..imagePath,
			               true, imgBackground)
		imgWeaponSecondary:setVisible(true)
	elseif getWeaponGuiName(itemName) == "rifles" then
		lblWeaponPrimary:setText(itemName)
		imgWeaponPrimary =
			GuiStaticImage(posX, posY, relX, relY, "gui/img/" ..imagePath,
			               true, imgBackground)
		imgWeaponPrimary:setVisible(true)
	end
end
addEvent("onEquipWeapon", true)
addEventHandler("onEquipWeapon", localPlayer, changeEquippedWeaponGui)

local function onPlayerAddArmorImage(armor)
	local armorFile
	if armor == "Police Vest (Level 1)" then
		armorFile = "vestlevel1"
	elseif armor == "Police Vest (Level 2)" then
		armorFile = "vestlevel2"
	elseif armor == "Military Vest (Level 3)" then
		armorFile = "vestlevel3"
	end

	if isElement(imgArmor) then
		imgArmor:destroy()
	end
	imgArmor = GuiStaticImage(0.58, 0.76, 0.10, 0.14,
		"gui/img/"..armorFile..".png", true, imgBackground)
	imgArmor:setVisible(true)
	barArmor:setVisible(true)
end
addEvent("onSetArmorImage", true)
addEventHandler("onSetArmorImage", root, onPlayerAddArmorImage)

local inventoryUsage = 0
local inventoryCapacity = 0
local function updateInventoryUsageAndCapcity()
	lblCapacity:setText(str("inventoryCapacity",
		tostring(inventoryUsage), tostring(inventoryCapacity)))
	local progress = (inventoryUsage/inventoryCapacity)*100
	barCapacity:setProgress(progress)
end

local function setInventoryCapacity(maxCapacity)
	--NOTE: beware the float arithmetic!
	inventoryCapacity = maxCapacity/100
	updateInventoryUsageAndCapcity()
end
addEvent("onSendInventoryCapacity", true)
addEventHandler("onSendInventoryCapacity", root, setInventoryCapacity)

local function setInventoryUsage(usedSlots)
	inventoryUsage = usedSlots/100
	updateInventoryUsageAndCapcity()
end
addEvent("onSendInventoryUsage", true)
addEventHandler("onSendInventoryUsage", root, setInventoryUsage)

local function changeColorOfButtonLeftOnMouseOver()
	btTakeItem:setProperty("ImageColours",
		"tl:FE8C8C8C tr:FE8C8C8C bl:FE8C8C8C br:FE8C8C8C")
end
addEventHandler("onClientMouseEnter", lblTakeItem,
                changeColorOfButtonLeftOnMouseOver, false)

local function changeColorOfButtonRightOnMouseOver()
	btLeaveItem:setProperty("ImageColours",
		"tl:FE8C8C8C tr:FE8C8C8C bl:FE8C8C8C br:FE8C8C8C")
end
addEventHandler("onClientMouseEnter", lblLeaveItem,
                changeColorOfButtonRightOnMouseOver, false)

local function revertColorOfButtonLeftOnMouseOver()
	btTakeItem:setProperty("ImageColours",
		"tl:FE111111 tr:FE111111 bl:FE111111 br:FE111111")
end
addEventHandler("onClientMouseLeave", lblTakeItem,
                revertColorOfButtonLeftOnMouseOver, false)

local function revertColorOfButtonRightOnMouseOver()
	btLeaveItem:setProperty("ImageColours",
		"tl:FE111111 tr:FE111111 bl:FE111111 br:FE111111")
end
addEventHandler("onClientMouseLeave", lblLeaveItem,
                revertColorOfButtonRightOnMouseOver, false)

local function populateInventory(itemName, itemAmount)
	local row
	if itemName ~= gridInventory:getItemText(gridInventory:getSelectedItem(),
	                                         1) then
		row = gridInventory:addRow()
		gridInventory:setItemText(row, colInventoryItemName,
		                          itemName, false, false)
	end
	gridInventory:setItemText(row, colInventoryItemAmount,
	                          itemAmount, false, false)
end
addEvent("onPopulateInventory", true)
addEventHandler("onPopulateInventory", localPlayer, populateInventory)

local function populateLoot(itemName, itemAmount)
	local row
	if itemName ~= gridLoot:getItemText(guiGridListGetSelectedItem(gridLoot),
	                                    1) then
		row = gridLoot:addRow()
		gridLoot:setItemText(row, colLootItemName,itemName, false, false)
	end
	gridLoot:setItemText(row, colLootItemAmount,itemAmount, false, false)
end
addEvent("onPopulateLoot", true)
addEventHandler("onPopulateLoot", localPlayer, populateLoot)

local function clearInventory()
	gridInventory:setSelectedItem(0, 0)
	gridInventory:clear()
end
addEvent("onClearInventory", true)
addEventHandler("onClearInventory", localPlayer, clearInventory)

local function clearLoot()
	gridLoot:setSelectedItem(0, 0)
	gridLoot:clear()
end
addEvent("onClearInventoryLoot", true)
addEventHandler("onClearInventoryLoot", localPlayer, clearLoot)

local function moveItemFromInventoryToLoot()
	if isPlayerInLoot() then
		col = localPlayer:getData("currentCol")
	else
		col = false
	end
	local itemName =
		gridInventory:getItemText(gridInventory:getSelectedItem(), 1)
	if itemName > "" then
		triggerServerEvent("onItemFromInventoryToLoot",
		                   localPlayer, itemName, col)
	end
end
addEventHandler("onClientGUIClick", lblLeaveItem,
                moveItemFromInventoryToLoot, false)

local function moveItemFromLootToInventory()
	if isPlayerInLoot() then
		col = localPlayer:getData("currentCol")
	end
	local itemName =
		gridLoot:getItemText(gridLoot:getSelectedItem(), 1)
	if itemName > "" then
		triggerServerEvent("onItemFromLootToInventory",
		                   localPlayer, itemName, col)
	end
end
addEventHandler("onClientGUIClick", lblTakeItem,
                moveItemFromLootToInventory, false)

local rightClickMenuItemName
local rightClickMenuItemAction
local function updateRightClickMenuText()
	if Inventory.getPopupVisible() then
		local itemActionMessage
		--not pretty, should probably rethink all of it this
		if rightClickMenuItemAction == "equipPrimary" then
			itemActionMessage =
				str("inventoryEquipPrimaryWeapon", rightClickMenuItemName)
		elseif rightClickMenuItemAction == "equipSecondary" then
			itemActionMessage =
				str("inventoryEquipSecondaryWeapon", rightClickMenuItemName)
		elseif rightClickMenuItemAction == "useItem" then
			itemActionMessage = str("inventoryUseItem", rightClickMenuItemName)
		else
			itemActionMessage =
				"Please read \"Writing translatable code\" on CONTRIBUTING.md"
		end
		lblActionPopup:setText(itemActionMessage)
		local width = lblActionPopup:getTextExtent()
		local x, y = imgActionPopup:getSize(false)
		imgActionPopup:setSize(width+10, y, false)
	end
end

local function showRightClickMenu(itemName, itemAction)
	if itemAction and itemAction ~= "" then
		rightClickMenuItemName = itemName
		rightClickMenuItemAction = itemAction
		local screenx, screeny, worldx, worldy, worldz = getCursorPosition()
		local itemActionMessage
		Inventory.setPopupVisible(true)
		updateRightClickMenuText()
		imgActionPopup:setPosition(screenx, screeny, true)
		imgActionPopup:bringToFront()
		imgActionPopup:setData("itemName", itemName)
		if isTimer(timerActionPopup) then
			timerActionPopup:destroy()
		end
		timerActionPopup = Timer(Inventory.setPopupVisible, 5000, 1, false)
	end
end

local function onPlayerRightMouseButton()
	local itemName =
		gridInventory:getItemText(gridInventory:getSelectedItem(), 1)
	if Inventory.getVisible() and isCursorShowing() then
		showRightClickMenu(itemName, getInventoryAction(itemName))
	end
end
bindKey("mouse2", "down", onPlayerRightMouseButton)

local function onPlayerRightClickMenu(button, state)
	if button == "left" then
		local itemName = imgActionPopup:getData("itemName")
		Inventory.setPopupVisible(false)
		triggerServerEvent("onPlayerUseItem", localPlayer, itemName)
	end
end
addEventHandler("onClientGUIClick", lblActionPopup,
                onPlayerRightClickMenu, false)

local function changeLanguage(newLang)
	gridInventory:setColumnTitle(colInventoryItemName, str("inventoryYourLoot"))
	gridInventory:setColumnTitle(colInventoryItemAmount,
	                             str("inventoryItemAmount"))
	gridLoot:setColumnTitle(colLootItemName, str("inventoryVicinityLoot"))
	gridLoot:setColumnTitle(colLootItemAmount, str("inventoryItemAmount"))
	lblVicinityLoot:setText(str("inventoryVicinityLoot"))
	lblYourLoot:setText(str("inventoryYourLoot"))
	lblStatus:setText(str("inventoryStatus"))
	lblPlayerName:setText(str("inventoryPlayerName", localPlayer.name))
	lblCapacity:setText(str("inventoryCapacity",
		tostring(inventoryUsage),
		tostring(inventoryCapacity)))
	updateInventoryMessage()
	updateRightClickMenuText()
end
addEventHandler("onUserLanguageChange", resourceRoot, changeLanguage)
