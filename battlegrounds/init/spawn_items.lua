--[[

				MTA:BG
			MTA Battlegrounds
	Developed By: Null System Works (L, CiBeR, neves768, 1BOY & expert975)
	
]]--

lootPointID = 0
SpotsID = 0
firstTimeLoot = false
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
					setElementDimension(objectTable[1],gameCache["playingField"])
				end
			end
		end	
		table.insert(lootpointData[lootCol]["objects"],{objectTable[1],itemName})
		return lootpointData[lootCol]
	end
end


async = Async()
async:setPriority("normal")

function createColOnPosition(lootSpot)
	for data, lootTable in pairs(lootColPos) do
		for colID = 1, #lootTable.x do
			if data == lootSpot then
				if lootTable.x[colID] then
					--lootpointID = lootpointID+1
					local lootCol = createColSphere(lootTable.x[colID],lootTable.y[colID],lootTable.z[colID],1.25)
					lootpointData[lootCol] = {
						["itemloot"] = true,
						["parent"] = lootSpot,
						["Space"] = 20,
						["lootID"] = colID,
						["objects"] = {}
					}
					async:foreach(lootItems[lootSpot],function(item)
						local itemChance = math.percentChance(item[5],5)
						if itemChance > 0 then
							if item[1] == "11.43x23mm Cartridge" then
								itemChance = math.ceil(itemChance*7)
							elseif item[1] == "9x18mm Cartridge" then
								itemChance = math.ceil(itemChance*8)
							elseif item[1] == "9x19mm Cartridge" then
								itemChance = math.ceil(itemChance*17)
							elseif item[1] == ".303 British Cartridge" then
								itemChance = math.ceil(itemChance*10)
							elseif item[1] == "7.62x39mm Cartridge" then
								itemChance = math.ceil(itemChance*30)
							elseif item[1] == "5.56x45mm Cartridge" then
								itemChance = math.ceil(itemChance*20)
							elseif item[1] == "7.62x54mm Cartridge" then
								itemChance = math.ceil(itemChance*10)
							elseif item[1] == "1866 Slug" then
								itemChance = math.ceil(itemChance*15)
							elseif item[1] == "12 Gauge Pellet" then
								itemChance = math.ceil(itemChance*7)	
							end
						end
						table.insert(lootpointData[lootCol],{item[1],itemChance})
					end)
					
					setElementData(lootCol,"itemloot",true)
					setElementData(lootCol,"parent",lootSpot)
					local objectCounter = 0
					local objectTable = {}
					async:foreach(lootItems[lootSpot],function(item)
						for k, spot in ipairs(lootpointData[lootCol]) do
							if item[1] == spot[1] then
								if spot[2] > 0 then
									itemName = spot[1]
									if objectCounter == 3 then
										break
									end
									objectCounter = objectCounter+1
									local x,y,z = getElementPosition(lootCol)
									objectTable[objectCounter] = createObject(item[2],x+math.random(-1,1),y+math.random(-1,1),z-0.875,item[4])
									setObjectScale(objectTable[objectCounter],item[3])
									setElementCollisionsEnabled(objectTable[objectCounter], false)
									setElementFrozen(objectTable[objectCounter],true)
									setElementDimension(objectTable[objectCounter],gameCache["playingField"])
									table.insert(lootpointData[lootCol]["objects"],{objectTable[objectCounter],itemName})
								end
							end
						end
					end)
				end
			end
		end
	end
end





--[[
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
				itemChance = math.ceil(itemChance*7)
			elseif item[1] == "9x18mm Cartridge" then
				itemChance = math.ceil(itemChance*8)
			elseif item[1] == "9x19mm Cartridge" then
				itemChance = math.ceil(itemChance*17)
			elseif item[1] == ".303 British Cartridge" then
				itemChance = math.ceil(itemChance*10)
			elseif item[1] == "7.62x39mm Cartridge" then
				itemChance = math.ceil(itemChance*30)
			elseif item[1] == "5.56x45mm Cartridge" then
				itemChance = math.ceil(itemChance*20)
			elseif item[1] == "7.62x54mm Cartridge" then
				itemChance = math.ceil(itemChance*10)
			elseif item[1] == "1866 Slug" then
				itemChance = math.ceil(itemChance*15)
			elseif item[1] == "12 Gauge Pellet" then
				itemChance = math.ceil(itemChance*7)	
			end
		end
		table.insert(lootpointData[lootCol],{item[1],itemChance})
	end
	setElementData(lootCol,"itemloot",true)
	setElementData(lootCol,"parent",lootSpot)
	createLootPointObject(lootCol,lootSpot)
	return lootpointData[lootCol]
end



function createLootPointObject(lootSpot,x,y,z)
	local objectCounter = 0
	local objectTable = {}
	for i, item in ipairs(lootItems[lootSpot]) do
		for k, spot in ipairs(lootpointData[lootCol]) do
			if item[1] == spot[1] then
				if spot[2] > 0 then
					itemName = spot[1]
					if objectCounter == 3 then
						break
					end
					objectCounter = objectCounter+1
					local x,y,z = getElementPosition(lootCol)
					objectTable[objectCounter] = createObject(item[2],x+math.random(-1,1),y+math.random(-1,1),z-0.875,item[4])
					setObjectScale(objectTable[objectCounter],item[3])
					setElementCollisionsEnabled(objectTable[objectCounter], false)
					setElementFrozen(objectTable[objectCounter],true)
					setElementDimension(objectTable[objectCounter],gameCache["playingField"])
					table.insert(lootpointData[lootCol]["objects"],{objectTable[objectCounter],itemName})
				end
			end
		end
	end
end
addEvent("mtabg_createLootPointObject",true)
addEventHandler("mtabg_createLootPointObject",root,createLootPointObject)
]]


function createSpotsOnStart()
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
	firstTimeLoot = true
end

function refreshLootSpots()
	outputDebugString("[MTA:BG] Item Refresh Started!")
	local objectTable = {}
	objectTable = getElementsByType("objects")
	async:foreach(objectTable, function(object)
		destroyElement(object)
	end)
	local colshapeTable = {}
	colshapeTable = getElementsByType("colshape")
	async:foreach(objectTable, function(col)
		destroyElement(col)
	end)
	lootPointID = 0
	SpotsID = 0
	lootpointData = {}
end
