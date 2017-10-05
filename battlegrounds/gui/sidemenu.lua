--[[

				MTA:BG
			MTA Battlegrounds
	Developed By: Null System Works

]]--

local row = {}
local rowImage = {}
local rowText = {}
local font = {}
local number = 0
local moveDown = 0
local playerPickedUpItem = false
font[1] = guiCreateFont("/fonts/etelka.ttf", 10)

function initSideMenu()
	row[1] = ""
	rowImage[1] = guiCreateStaticImage(0,0.400,0.35,0.03,"gui/images/solo_slot.png",true)
	rowText[1] = guiCreateLabel(0.05,0.05,0.995,0.95,row[1],true,rowImage[1])
	guiLabelSetColor(rowText[1],255,255,255)
	guiSetFont(rowText[1],font[1])
	guiSetVisible(rowImage[1],false)
end
addEventHandler("onClientResourceStart",getResourceRootElement(getThisResource()),initSideMenu)


function showClientMenuItem(arg1,arg2,arg3,arg4)
local number = 0
	if arg1 == "Take" then
		number = number+1
		guiSetVisible(rowImage[number],true)
		guiSetText(rowText[number], str("sideMenuTake", arg2))
		if number == 1 then
			guiLabelSetColor (rowText[number],255,255,255)
			setElementData(rowText[number],"markedMenuItem",true)
		end
		setElementData(rowText[number],"usedItem",arg2)
	end
	if arg1 == "stop" then
		disableMenu()
		--triggerServerEvent("mtabg_refreshLoot",localPlayer,false,gearName)
	end
	if arg1 == "Dead" then
		number = number+1
		guiSetVisible(rowImage[number],true)
		guiSetText(rowText[number], str("sideMenuCorpseGear"))
		if number == 1 then
			guiLabelSetColor (rowText[number],255,255,255)
			setElementData(rowText[number],"markedMenuItem",true)
		end
		setElementData(rowText[number],"usedItem","dead")
		number = number+1
		setElementData(rowText[number],"usedItem","deadreason")
		guiSetVisible(rowImage[number],true)
		guiSetText(rowText[number], str("sideMenuCheckBody"))

		setElementData(rowText[3],"usedItem","hidebody")
  		guiSetVisible(rowImage[3],true)
  		guiSetText(rowText[3], str("sideMenuHideBody"))
	end
	if arg1 == "Gear" then
		number = number+1
		guiSetVisible(rowImage[number],true)
		guiSetText(rowText[number], str("sideMenuGear"))
		if number == 1 then
			guiLabelSetColor (rowText[number],255,255,255)
			setElementData(rowText[number],"markedMenuItem",true)
		end
		setElementData(rowText[number],"usedItem","itemloot")
	end
end
addEvent("showClientMenuItem",true)
addEventHandler("showClientMenuItem",localPlayer,showClientMenuItem)

function disableMenu()
	guiSetVisible(rowImage[1],false)
	guiLabelSetColor(rowText[1],255,255,255)
end
addEvent("disableMenu",true)
addEventHandler("disableMenu",getLocalPlayer(),disableMenu)


function getPlayerInCol(tab)
	for theKey,thePlayer in ipairs(tab) do
		if thePlayer ~= localPlayer then
			return true
		end
	end
	return false
end

function onPlayerTargetPickup (theElement)
	if theElement == localPlayer then
		if getElementData(source,"parent") == localPlayer then
			return
		end
		local player = getPlayerInCol(getElementsWithinColShape(source, "player"))
		if getPedOccupiedVehicle(localPlayer) then
			return
		end
		setElementData(rowText[1],"markedMenuItem",true)
		guiLabelSetColor (rowText[1],255,255,255)
		if getElementData(source,"player") then
			showClientMenuItem("Player",getElementData(source,"parent"))
			setElementData(localPlayer,"currentCol",source)
			setElementData(localPlayer,"loot",false)
			return
		end
		if player then
			return
		end
		if getElementData(source,"deadman") then
			showClientMenuItem("Dead",getPlayerName(source))
			setElementData(localPlayer,"currentCol",source)
			setElementData(localPlayer,"loot",true)
			setElementData(localPlayer,"lootname","Gear ("..tostring(getPlayerName(source))..")")
			return
		end
		if getElementData(source,"droppedItem") then
			showClientMenuItem("Take",getElementData(source,"droppedItem"))
			setElementData(getLocalPlayer(),"currentCol",source)
			setElementData(getLocalPlayer(),"loot",false)
			return
		end
		if getElementData(source,"itemloot") then
			showClientMenuItem("Gear")
			setElementData(localPlayer,"loot",true)
			setElementData(localPlayer,"lootname","Gear")
			setElementData(localPlayer,"currentCol",source)
			return
		end
	showClientMenuItem("stop")
	end
end
addEventHandler("onClientColShapeHit",getRootElement(),onPlayerTargetPickup)

function onPlayerTargetPickup(theElement)
	if theElement == localPlayer then
		showClientMenuItem("stop")
		setElementData(localPlayer,"loot",false)
		setElementData(localPlayer,"currentCol",false)
	end
end
addEventHandler("onClientColShapeLeave",getRootElement(),onPlayerTargetPickup)

unbindKey("mouse3","both")
function onPlayerPressMiddleMouse (key,keyState)
if ( keyState == "down" ) then
	if not guiGetVisible(rowText[1]) then return end
		local itemName = getMenuMarkedItem()
		if itemName == "itemloot" then
			local col = getElementData(getLocalPlayer(),"currentCol")
			local gearName = "Gear"
			triggerServerEvent("mtabg_refreshLoot",localPlayer,col,gearName)
			showInventoryManually()
			disableMenu()
			return
		end
		if itemName == "dead" then
			local col = getElementData(getLocalPlayer(),"currentCol")
			local gearName = "Gear ("..getElementData(col,"playername")..")"
			triggerServerEvent("mtabg_refreshLoot",localPlayer,col,gearName)
			showInventoryManually()
			disableMenu()
			return
		end
		if not playerPickedUpItem then
			triggerServerEvent("mtabg_getPlayerCapacity",localPlayer,itemName)
			disableMenu()
			playerPickedUpItem = true
			setTimer(function()
				playerPickedUpItem = false
			end,3000,1)
		end
	end
end
bindKey ( "mouse3", "down", onPlayerPressMiddleMouse )
bindKey ( "-", "down", onPlayerPressMiddleMouse )

function getMenuMarkedItem()
	for i,guiItem in ipairs(rowText) do
		if getElementData(guiItem,"markedMenuItem") then
			return getElementData(guiItem,"usedItem")
		end
	end
end
