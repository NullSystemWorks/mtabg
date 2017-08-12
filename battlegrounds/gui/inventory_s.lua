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
				--[[
				else
				
					for k, data in ipairs(lootpointData[loot]["objects"]) do
						if data[1] then
							destroyElement(data[1])
							if data[2] then
								destroyElement(data[2])
								if data[3] then
									destroyElement(data[3])
								end
							end
						end
						return loot
					end
				end
				]]
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
			createItemPickup(item,x+math.random(-1.25,1.25),y+math.random(-1.25,1.25),z,itemName)
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
			equipWeapon(itemName,itemInfo,client)
		elseif itemInfo == "Equip Secondary Weapon" then
			equipWeapon(itemName,itemInfo,client)
		elseif itemInfo == "Equip Special Weapon" then
			equipWeapon(itemName,itemInfo,client)
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
							triggerClientEvent(client,"mtabg_sendErrorToInventory",client,"Used: "..itemName)
						else
							triggerClientEvent(client,"mtabg_sendErrorToInventory",client,"At full health!")
						end
					end
				elseif itemName == "First Aid Kit" then
					if data[2] == "health" then
						if data[3] < 100 then
							data[3] = 100
							itemUsed = true
							triggerClientEvent(client,"mtabg_setHealthToClient",client,data[3])
							triggerClientEvent(client,"mtabg_sendErrorToInventory",client,"Used: "..itemName)
						else
							triggerClientEvent(client,"mtabg_sendErrorToInventory",client,"At full health!")
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
							triggerClientEvent(client,"mtabg_sendErrorToInventory",client,"Used: "..itemName)
						else
							triggerClientEvent(client,"mtabg_sendErrorToInventory",client,"At full health!")
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

local currentWeapon_1 = ""
local currentWeapon_2 = ""
local currentWeapon_3 = ""
local weaponType = ""
function equipWeapon(weapon,info,player)
	local weaponID = 0
	local ammoType = ""
	for i, weap in ipairs(weaponDataTable) do
		if weapon == weap[1] then
			weaponID = weap[2]
			ammoType = weap[6]
			weaponType = weap[7]
			break
		end
	end
	for i, data in ipairs(playerInfo[player]) do
		if ammoType == data[2] then
			if data[3] > 0 then	
				giveWeapon(client,weaponID,data[3],true)
				triggerClientEvent(client,"mtabg_changeEquippedWeaponGUI",client,info,weapon)
				for k, playData in ipairs(playerDataInfo[player]) do
					if weaponType == "Primary" then
						currentWeapon_1 = weapon
					elseif weaponType == "Secondary" then
						currentWeapon_2 = weapon
					elseif weaponType == "Special" then
						currentWeapon_3 = weapon
					end
					break
				end
			else
				triggerClientEvent(client,"mtabg_sendErrorToInventory",client,"Not enough ammo!")
				break
			end
		end
	end
end

function removeWeapon(weaponID,player)
	takeWeapon(player,weaponID)
end

function depleteAmmoCountWhenFiring(weapon,x,y,z,hitElement,startX,startY,startZ)
	local weaponName = ""
	local weaponID = 0
	local ammoType = ""
	for i, weap in ipairs(weaponDataTable) do
		if weapon == 22 or weapon == 23 or weapon == 24 or weapon == 28 or weapon == 29 or weapon == 32 then
			if currentWeapon_2 == weap[1] then
				weaponName = weap[1]
				weaponID = weap[2]
				ammoType = weap[6]
			end
		elseif weapon == 25 or weapon == 26 or weapon == 27 or weapon == 30 or weapon == 31 or weapon == 33 or weapon == 34 then
			if currentWeapon_1 == weap[1] then
				weaponName = weap[1]
				weaponID = weap[2]
				ammoType = weap[6]
			end
		else
			if currentWeapon_3 == weap[1] then
				weaponName = weap[1]
				weaponID = weap[2]
				ammoType = weap[6]
			end
		end
	end
	for i, data in ipairs(playerInfo[source]) do
		if ammoType == data[2] then
			data[3] = data[3]-1
			if data[3] <= 0 then
				data[3] = 0
				removeWeapon(weaponID,source)
			end
		end
	end
end
addEventHandler("onPlayerWeaponFire",root,depleteAmmoCountWhenFiring)

function getItemWeight(theItem)
	for i, weight in ipairs(lootItems["FullList"]) do
		if theItem == weight[1] then
			return weight[5]
		end
	end
end

function getPlayerCapacity(item)
	local usedCapacity = 0
	local maxCapacity = 0
	local itemWeight = getItemWeight(item)
	for i, data in ipairs(playerDataInfo[client]) do
		if data[2] == "InventoryCapacity" then
			maxCapacity = data[3]
		end
		if data[2] == "usedCapacity" then
			usedCapacity = data[3]
		end
	end
	if usedCapacity+itemWeight >= maxCapacity then
		triggerClientEvent(client,"mtabg_sendErrorToInventory",client,"Not enough inventory capacity!")
	else
		for i, data in ipairs(playerInfo[client]) do
			if data[2] == item then
				data[3] = data[3]+1
				break
			end
		end
	end
end
addEvent("mtabg_getPlayerCapacity",true)
addEventHandler("mtabg_getPlayerCapacity",root,getPlayerCapacity)


function debugGiveItem(player,cmd,item,amount)
	for i, data in ipairs(playerInfo[player]) do
		if data[2] == item then
			data[3] = data[3]+amount
		end
	end
end
addCommandHandler("give",debugGiveItem)