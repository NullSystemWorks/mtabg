--[[
	
				MTA:BG
			MTA Battlegrounds
	Developed By: L, CiBeR, neves768, 1BOY

]]--

function refreshInventory()
	triggerClientEvent(client,"mtabg_clearGridList",client,1)
	for i, items in ipairs(playerInfo[client]) do
		if items[3] ~= nil then
			if items[3] > 0 then
				triggerClientEvent(client,"mtabg_populateGridListWithItems",client,1,"inventory","inventoryamount",items[2],items[3])
			end
		end
	end
end
addEvent("mtabg_refreshInventory",true)
addEventHandler("mtabg_refreshInventory",root,refreshInventory)

function refreshLoot(loot,gearName)
	if not loot then
		triggerClientEvent(client,"mtabg_clearGridList",client,2)
		return
	end
	for i, item in ipairs(lootpointData[loot]) do
		if tonumber(item[2]) then
			if item[1] ~= nil then
				if item[2] > 0 then
					triggerClientEvent(client,"mtabg_populateGridListWithItems",client,2,"loot","lootamount",item[1],item[2])
				end
			end
		end
	end
end
addEvent("mtabg_refreshLoot",true)
addEventHandler("mtabg_refreshLoot",root,refreshLoot)

function getItemFromTablePosition(theItem)
	for id, item in ipairs(lootItems["FullList"]) do
		if theItem == item[1] then
			return id
		end
	end
	return item
end

function onItemFromInventoryToLoot(itemName,loot)
	if itemName then
		for i, item in ipairs(playerInfo[client]) do
			if item[2] == itemName then
				item[3] = item[3]-1
			end
		end
		refreshInventory()
		if loot then
			for i, item in ipairs(lootpointData[loot]) do
				if item[1] == itemName then
					item[2] = item[2]+1
				end
			end
			triggerClientEvent(client,"mtabg_clearGridList",client,2)
			refreshLoot(loot,"")
		else
			local x,y,z = getElementPosition(client)
			local item = getItemFromTablePosition(itemName)
			local itemPickup = createItemPickup(item,x+math.random(-1.25,1.25),y+math.random(-1.25,1.25),z,itemName)
		end
	end
end
addEvent("mtabg_onItemFromInventoryToLoot",true)
addEventHandler("mtabg_onItemFromInventoryToLoot",root,onItemFromInventoryToLoot)


function onItemFromLootToInventory(itemName,loot)
	if itemName then
		for i, item in ipairs(playerInfo[client]) do
			if item[2] == itemName then
				item[3] = item[3]+1
			end
		end
		refreshInventory()
		for i, item in ipairs(lootpointData[loot]) do
			if item[1] == itemName then
				item[2] = item[2]-1
			end
		end
		triggerClientEvent(client,"mtabg_clearGridList",client,2)
		refreshLoot(loot,"")
	end
end
addEvent("mtabg_onItemFromLootToInventory",true)
addEventHandler("mtabg_onItemFromLootToInventory",root,onItemFromLootToInventory)

function onPlayerUseItem(itemName,itemInfo)
	if itemInfo then
		local itemUsed = false
		if itemInfo == "Equip Primary Weapon" then
			outputDebugString("Equip Primary Weapon: "..tostring(itemName))
		elseif itemInfo == "Use" then
			for i, data in ipairs(playerDataInfo[client]) do
				if itemName == "Bandage" then
					if data[2] == "health" then
						if data[3] < 100 then
							data[3] = data[3]+10
							if data[3] > 100 then
								data[3] = 100
							end
							itemUsed = true
							triggerClientEvent(client,"mtabg_setHealthToClient",client,data[3])
						end
					end
				elseif itemName == "First Aid Kit" then
					if data[2] == "health" then
						if data[3] < 100 then
							data[3] = 100
							itemUsed = true
							triggerClientEvent(client,"mtabg_setHealthToClient",client,data[3])
						end
					end
				elseif itemName == "Painkiller" then
					if data[2] == "health" then
						if data[3] < 100 then
							data[3] = data[3]+25
							if data[3] > 100 then
								data[3] = 100
							end
							itemUsed = true
							triggerClientEvent(client,"mtabg_setHealthToClient",client,data[3])
						end
					end
				end	
			end
		end
		if itemUsed then
			for i, data in ipairs(playerInfo[client]) do
				if itemName == data[2] then
					data[3] = data[3]-1
				end
			end
			refreshInventory()
			itemUsed = false
		end
	end
end
addEvent("mtabg_onPlayerUseItem",true)
addEventHandler("mtabg_onPlayerUseItem",root,onPlayerUseItem)

function debugSetHealth(player,value)
	for i, data in ipairs(playerDataInfo[player]) do
		if data[2] == "health" then
			data[3] = tonumber(value)
			triggerClientEvent(player,"mtabg_setHealthToClient",player,tonumber(data[3]))
		end
	end
	
end
addCommandHandler("health",debugSetHealth)