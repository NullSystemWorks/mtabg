--[[
	
				MTA:BG
			MTA Battlegrounds
	Developed By: L, CiBeR, neves768, 1BOY

]]--

local lootPointID = 0
lootpointData = {}

function createItemPickup(item,x,y,z,itemName,itemAmount)
	if item and x and y and z then
		lootPointID = lootPointID+1
		local lootCol = createColSphere(x,y,z,1.25)
		lootpointData[lootCol] = {
			["itemloot"] = true,
			["parent"] = "FullList",
			["Space"] = 20,
			["lootID"] = lootPointID,
			["objects"] = {}
		}
		table.insert(lootpointData[lootCol],{itemName,itemAmount})
		setElementData(lootCol,"itemloot",true)
		setElementData(lootCol,"parent","FullList")	
		local objectTable = {}
		for i, item in ipairs(lootItems["FullList"]) do
			for k, spot in ipairs(lootpointData[lootCol]) do
				if item[1] == spot[1] then
					local x,y,z = getElementPosition(lootCol)
					objectTable[1] = createObject(item[2],x+math.random(-1,1),y+math.random(-1,1),z-0.875,item[4])
					setObjectScale(objectTable[1],item[3])
					setElementCollisionsEnabled(objectTable[1], false)
					setElementFrozen(objectTable[1],true)
				end
			end
		end	
		table.insert(lootpointData[lootCol]["objects"],{objectTable[1],itemName})
		return lootpointData[lootCol]
	end
end

local async = Async()
async:setPriority("normal")

function createLootPoint(lootSpot,x,y,z,ID)
	lootPointID = lootPointID+1
	local lootCol = createColSphere(x,y,z,1.25)
	lootpointData[lootCol] = {
		["itemloot"] = true,
		["parent"] = lootSpot,
		["Space"] = 20,
		["lootID"] = lootPointID,
		["objects"] = {}
	}
	for i, item in ipairs(lootItems[lootSpot]) do
		local itemChance = math.percentChance(item[5],5)
		if itemChance > 0 then
			if item[1] == "11.43x23mm Cartridge" then
				itemChance = 20
			elseif item[1] == "9x18mm Cartridge" then
				itemChance = 20
			elseif item[1] == "9x19mm Cartridge" then
				itemChance = 20
			elseif item[1] == ".303 British Cartridge" then
				itemChance = 20
			elseif item[1] == "7.62x39mm Cartridge" then
				itemChance = 20
			elseif item[1] == "5.56x45mm Cartridge" then
				itemChance = 20
			elseif item[1] == "7.62x54mm Cartridge" then
				itemChance = 20
			elseif item[1] == "1866 Slug" then
				itemChance = 20
			elseif item[1] == "12 Gauge Pellet" then
				itemChance = 20		
			end
		end
		table.insert(lootpointData[lootCol],{item[1],itemChance})
	end
	setElementData(lootCol,"itemloot",true)
	setElementData(lootCol,"parent",lootSpot)
	createLootPointObject(lootCol,lootSpot)
	return lootpointData[lootCol]
end

function createLootPointObject(lootCol,lootSpot)
	local objectCounter = 0
	local objectTable = {}
	--Tables
	for i, item in ipairs(lootItems[lootSpot]) do
		for k, spot in ipairs(lootpointData[lootCol]) do
			if item[1] == spot[1] then
				if spot[2] > 0 then
					itemName = spot[1]
					objectCounter = objectCounter + 1
					local x,y,z = getElementPosition(lootCol)
					objectTable[objectCounter] = createObject(item[2],x+math.random(-1,1),y+math.random(-1,1),z-0.875,item[4])
					setObjectScale(objectTable[objectCounter],item[3])
					setElementCollisionsEnabled(objectTable[objectCounter], false)
					setElementFrozen(objectTable[objectCounter],true)
					table.insert(lootpointData[lootCol]["objects"],{objectTable[objectCounter],itemName})
				end
			end
		end
	end
end
addEvent("mtabg_createLootPointObject",true)
addEventHandler("mtabg_createLootPointObject",root,createLootPointObject)



function createSpotsOnStart()
	local SpotsID = 0
	outputDebugString("[MTA:BG] Spawning Industry Loot Points(20%)")
	async:foreach(lootPoints["Industry"], function(position)
		SpotsID = SpotsID+1
		createLootPoint("Industry",position[1],position[2],position[3],SpotsID)
	end)
	outputDebugString("[MTA:BG] Spawning Residential Loot Points(40%)")
	async:foreach(lootPoints["Residential"], function(position)
		SpotsID = SpotsID+1
		createLootPoint("Residential",position[1],position[2],position[3],SpotsID)
	end)
	outputDebugString("[MTA:BG] Spawning Supermarket Loot Points(60%)")
	async:foreach(lootPoints["Supermarket"], function(position)
		SpotsID = SpotsID+1
		createLootPoint("Supermarket",position[1],position[2],position[3],SpotsID)
	end)
	outputDebugString("[MTA:BG] Spawning Farm Loot Points(80%)")
	async:foreach(lootPoints["Farm"], function(position)
		SpotsID = SpotsID+1
		createLootPoint("Farm",position[1],position[2],position[3],SpotsID)
	end)
	outputDebugString("[MTA:BG] Spawning Military Loot Points(100%)")
	async:foreach(lootPoints["Military"], function(position)
		SpotsID = SpotsID+1
		createLootPoint("Military",position[1],position[2],position[3],SpotsID)
	end)
	outputDebugString("[MTA:BG] All loot points spawned!")
end
-- Dev command, remove on release
addCommandHandler("spot",createSpotsOnStart)

function refreshLootSpots()
	outputDebugString("[MTA:BG] Item Refresh Started!")
	for i, col in ipairs(getElementsByType("colshape")) do
		if lootpointData[col]["objects"] then
			for k, items in ipairs(lootpointData[col]["objects"]) do
				if items[1] ~= nil then
					destroyElement(items[1])
				end
				if items[2] ~= nil then
					destroyElement(items[2])
				end
				if items[3] ~= nil then
					destroyElement(items[3])
				end
			end
		end
		destroyElement(col)
		lootPointID = 0
	end
	createSpotsOnStart()
end

--addEvent("mtabg_refreshLoot", true)
--addEventHandler("mtabg_refreshLoot", root, refreshLootSpots)

-- Dev command, remove on release
addCommandHandler("loot",refreshLootSpots)