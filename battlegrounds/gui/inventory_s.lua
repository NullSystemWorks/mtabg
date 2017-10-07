--[[

				MTA:BG
			MTA Battlegrounds
	Developed By: Null System Works

]]--

function refreshInventory()
	local usedCapacity = 0
	local maxCapacity = 0
	local itemWeight = 0
	triggerClientEvent(client,"mtabg_clearGridList",client,1)
	for i, items in ipairs(playerInfo[client]) do
		if items[3] ~= nil then
			if items[3] > 0 then
				if items[2] == "11.43x23mm Cartridge" or items[2] == "9x18mm Cartridge" or items[2] == "9x19mm Cartridge" or items[2] == ".303 British Cartridge" or items[2] == "7.62x39mm Cartridge" or items[2] == "5.56x45mm Cartridge" or items[2] == "7.62x54mm Cartridge" or items[2] == "1866 Slug" or items[2] == "12 Gauge Pellet" or items[2] == "Bolt" then
					itemWeight = getItemWeight(items[2])
					itemWeight = math.ceil(items[3]*itemWeight)
				else
					itemWeight = items[3]
				end
				triggerClientEvent(client,"mtabg_populateGridListWithItems",client,1,"inventory","inventoryamount",items[2],itemWeight)
				usedCapacity = usedCapacity+itemWeight
			end
		end
	end
	for i, data in ipairs(playerDataInfo[client]) do
		if data[2] == "UsedCapacity" then
			data[3] = usedCapacity
		end
		if data[2] == "InventoryCapacity" then
			maxCapacity = data[3]
		end
	end
	triggerClientEvent(client,"mtabg_sendCapacityToPlayerClient",client,maxCapacity,usedCapacity)
end
addEvent("mtabg_refreshInventory",true)
addEventHandler("mtabg_refreshInventory",root,refreshInventory)

function refreshLoot(loot,gearName)
	if not loot then
		triggerClientEvent(client,"mtabg_clearGridList",client,2)
		return
	end
	triggerClientEvent(client,"mtabg_clearGridList",client,2)
	for i, item in ipairs(lootpointData[loot]) do
		triggerClientEvent(client,"mtabg_populateGridListWithItems",client,2,"loot","lootamount",item[1],item[2])
		for k, data in ipairs(lootpointData[loot]["objects"]) do
			if item[1] == data[2] then
				if item[2] < 1 then
					if isElement(data[1]) then
						destroyElement(data[1])
						--[[
						-- This part of the code is supposed to destroy empty loot cols, destroys col after looting 3 items to due spawning mechanism, so do not touch!
						data[1] = nil
						if next(lootpointData[loot]["objects"]) then
							destroyElement(loot)
						end
						]]
					end
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
		local itemDeduct = 1
		for i, item in ipairs(playerInfo[client]) do
			if item[2] == itemName then
				if item[2] == "11.43x23mm Cartridge" then
					if item[3] <= 10 then
						itemDeduct = item[3]
						item[3] = 0
					else
						item[3] = item[3]-10
						itemDeduct = 10
					end
				elseif item[2] == "9x18mm Cartridge" then
					if item[3] <= 10 then
						itemDeduct = item[3]
						item[3] = 0
					else
						item[3] = item[3]-10
						itemDeduct = 10
					end
				elseif item[2] == "9x19mm Cartridge" then
					if item[3] <= 10 then
						itemDeduct = item[3]
						item[3] = 0
					else
						item[3] = item[3]-10
						itemDeduct = 10
					end
				elseif item[2] == ".303 British Cartridge" then
					if item[3] <= 10 then
						itemDeduct = item[3]
						item[3] = 0
					else
						item[3] = item[3]-10
						itemDeduct = 10
					end
				elseif item[2] == "7.62x39mm Cartridge" then
					if item[3] <= 10 then
						itemDeduct = item[3]
						item[3] = 0
					else
						item[3] = item[3]-10
						itemDeduct = 10
					end
				elseif item[2] == "5.56x45mm Cartridge" then
					if item[3] <= 10 then
						itemDeduct = item[3]
						item[3] = 0
					else
						item[3] = item[3]-10
						itemDeduct = 10
					end
				elseif item[2] == "7.62x54mm Cartridge" then
					if item[3] <= 10 then
						itemDeduct = item[3]
						item[3] = 0
					else
						item[3] = item[3]-10
						itemDeduct = 10
					end
				elseif item[2] == "1866 Slug" then
					if item[3] <= 10 then
						itemDeduct = item[3]
						item[3] = 0
					else
						item[3] = item[3]-10
						itemDeduct = 10
					end
				elseif item[2] == "12 Gauge Pellet" then
					if item[3] <= 10 then
						itemDeduct = item[3]
						item[3] = 0
					else
						item[3] = item[3]-10
						itemDeduct = 10
					end
				else
					item[3] = item[3]-itemDeduct
				end
			end
		end
		if loot then
			for i, item in ipairs(lootpointData[loot]) do
				if item[1] == itemName then
					item[2] = item[2]+itemDeduct
				end		
			end
			refreshInventory()
			refreshLoot(loot,"")
		else
			local x,y,z = getElementPosition(client)
			local item = getItemFromTablePosition(itemName)
			createItemPickup(item,x+math.random(-1.25,1.25),y+math.random(-1.25,1.25),z,itemName,itemDeduct)
			refreshInventory()
		end
	end
end
addEvent("mtabg_onItemFromInventoryToLoot",true)
addEventHandler("mtabg_onItemFromInventoryToLoot",root,onItemFromInventoryToLoot)


function onItemFromLootToInventory(itemName,loot)
	if itemName then
		if getPlayerCapacity(itemName) then
			local newAmmoAmount = false
			for i, item in ipairs(playerInfo[client]) do
				if item[2] == itemName then
					if item[2] == "11.43x23mm Cartridge" then
						for k, loot in ipairs(lootpointData[loot]) do
							if item[2] == loot[1] then
								item[3] = item[3]+loot[2]
								loot[2] = 0
								newAmmoAmount = item[3]
							end
						end
					elseif item[2] == "9x18mm Cartridge" then
						for k, loot in ipairs(lootpointData[loot]) do
							if item[2] == loot[1] then
								item[3] = item[3]+loot[2]
								loot[2] = 0
								newAmmoAmount = item[3]
							end
						end
					elseif item[2] == "9x19mm Cartridge" then
						for k, loot in ipairs(lootpointData[loot]) do
							if item[2] == loot[1] then
								item[3] = item[3]+loot[2]
								loot[2] = 0
								newAmmoAmount = item[3]
							end
						end
					elseif item[2] == ".303 British Cartridge" then
						for k, loot in ipairs(lootpointData[loot]) do
							if item[2] == loot[1] then
								item[3] = item[3]+loot[2]
								loot[2] = 0
								newAmmoAmount = item[3]
							end
						end
					elseif item[2] == "7.62x39mm Cartridge" then
						for k, loot in ipairs(lootpointData[loot]) do
							if item[2] == loot[1] then
								item[3] = item[3]+loot[2]
								loot[2] = 0
								newAmmoAmount = item[3]
							end
						end
					elseif item[2] == "5.56x45mm Cartridge" then
						for k, loot in ipairs(lootpointData[loot]) do
							if item[2] == loot[1] then
								item[3] = item[3]+loot[2]
								loot[2] = 0
								newAmmoAmount = item[3]
							end
						end
					elseif item[2] == "7.62x54mm Cartridge" then
						for k, loot in ipairs(lootpointData[loot]) do
							if item[2] == loot[1] then
								item[3] = item[3]+loot[2]
								loot[2] = 0
								newAmmoAmount = item[3]
							end
						end
					elseif item[2] == "1866 Slug" then
						for k, loot in ipairs(lootpointData[loot]) do
							if item[2] == loot[1] then
								item[3] = item[3]+loot[2]
								loot[2] = 0
								newAmmoAmount = item[3]
							end
						end
					elseif item[2] == "12 Gauge Pellet" then
						for k, loot in ipairs(lootpointData[loot]) do
							if item[2] == loot[1] then
								item[3] = item[3]+loot[2]
								loot[2] = 0
								newAmmoAmount = item[3]
							end
						end
					else
						item[3] = item[3]+1
					end
				end
			end
			
			local weaponID = 0
			for i, weap in ipairs(weaponDataTable) do
				if itemName == weap[6] then
					weaponID = weap[2]
					break
				end
			end
			if newAmmoAmount then
				setWeaponAmmo(client,weaponID,newAmmoAmount)
			end
			
			if lootpointData[loot] then
				for i, item in ipairs(lootpointData[loot]) do
					if item[1] == itemName then
						if item[1] == "11.43x23mm Cartridge" then
							refreshInventory()
							refreshLoot(loot,"")
							return
						elseif item[1] == "9x18mm Cartridge" then
							refreshInventory()
							refreshLoot(loot,"")
							return
						elseif item[1] == "9x19mm Cartridge" then
							refreshInventory()
							refreshLoot(loot,"")
							return
						elseif item[1] == ".303 British Cartridge" then
							refreshInventory()
							refreshLoot(loot,"")
							return
						elseif item[1] == "7.62x39mm Cartridge" then
							refreshInventory()
							refreshLoot(loot,"")
							return
						elseif item[1] == "5.56x45mm Cartridge" then
							refreshInventory()
							refreshLoot(loot,"")
							return
						elseif item[1] == "7.62x54mm Cartridge" then
							refreshInventory()
							refreshLoot(loot,"")
							return
						elseif item[1] == "1866 Slug" then
							refreshInventory()
							refreshLoot(loot,"")
							return
						elseif item[1] == "12 Gauge Pellet" then
							refreshInventory()
							refreshLoot(loot,"")
							return
						else
							item[2] = item[2]-1
						end
					end
				end
			end
			refreshInventory()
			refreshLoot(loot,"")
		end
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
							data[3] = data[3]+5
							if data[3] > 100 then
								data[3] = 100
							end
							itemUsed = true
							triggerClientEvent(client,"mtabg_onClientBattleGroundsSetPlayerHealthGUI",client,false,data[3])
							triggerClientEvent(client,"mtabg_sendErrorToInventory",client,"Used: "..itemName,255,255,255)
						else
							triggerClientEvent(client,"mtabg_sendErrorToInventory",client,"At full health!",255,0,0)
						end
					end
				elseif itemName == "First Aid Kit" then
					if data[2] == "health" then
						if data[3] < 100 then
							data[3] = 100
							itemUsed = true
							triggerClientEvent(client,"mtabg_onClientBattleGroundsSetPlayerHealthGUI",client,false,data[3])
							triggerClientEvent(client,"mtabg_sendErrorToInventory",client,"Used: "..itemName,255,255,255)
						else
							triggerClientEvent(client,"mtabg_sendErrorToInventory",client,"At full health!",255,0,0)
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
							triggerClientEvent(client,"mtabg_onClientBattleGroundsSetPlayerHealthGUI",client,false,data[3])
							triggerClientEvent(client,"mtabg_sendErrorToInventory",client,"Used: "..itemName,255,255,255)
						else
							triggerClientEvent(client,"mtabg_sendErrorToInventory",client,"At full health!",255,0,0)
						end
					end
				elseif itemName == "Energy Drink" then
					if data[2] == "health" then
						if data[3] < 100 then
							itemUsed = true
							triggerClientEvent(client,"mtabg_sendErrorToInventory",client,"Used: "..itemName,255,255,255)
							if isTimer(energyDrinkTimer) then killTimer(energyDrinkTimer) end
								energyDrinkTimer = setTimer(function(client)
								data[3] = data[3]+1
								if data[3] >= 100 then
									data[3] = 100
								end
								triggerClientEvent(client,"mtabg_onClientBattleGroundsSetPlayerHealthGUI",client,false,data[3])
							end,3000,10,client,data[3])
						else
							triggerClientEvent(client,"mtabg_sendErrorToInventory",client,"At full health!",255,0,0)
						end
					end
				end
			end
			if itemName == "Backpack (Level 1)" then
				addBackpackToPlayerBack(client,170)
				setPlayerCapacity(client,170)
				itemUsed = true
			elseif itemName == "Backpack (Level 2)" then
				addBackpackToPlayerBack(client,220)
				setPlayerCapacity(client,220)
				itemUsed = true
			elseif itemName == "Backpack (Level 3)" then
				addBackpackToPlayerBack(client,270)
				setPlayerCapacity(client,270)
				itemUsed = true
			end
			local armorName = ""
			if itemName == "Police Vest (Level 1)" then
				armorName = "vestlevel1"
				addArmorToPlayer(client,33,armorName)
				itemUsed = true
			elseif itemName == "Police Vest (Level 2)" then
				armorName = "vestlevel2"
				addArmorToPlayer(client,66,armorName)
				itemUsed = true
			elseif itemName == "Military Vest (Level 3)" then
				armorName = "vestlevel3"
				addArmorToPlayer(client,100,armorName)
				itemUsed = true
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

function addArmorToPlayer(player,amount,armorName)
	setPedArmor(player,amount)
	triggerClientEvent(player,"mtabg_onPlayerAddArmorImage",player,armorName)
end

local currentWeapon_1 = ""
local currentWeapon_2 = ""
local currentWeapon_3 = ""
local weaponType = ""
local imagePath = ""
local guiLabelName = ""
local relativeSizeX = 0
local relativeSizeY = 0
local relativePosX = 0
local relativePosY = 0
local oldWeapon = ""
function equipWeapon(weapon,info,player)
	local weaponID = 0
	local ammoType = ""
	for i, weap in ipairs(weaponDataTable) do
		if weapon == weap[1] then
			weaponID = weap[2]
			ammoType = weap[6]
			weaponType = weap[7]
			imagePath = weap[8]
			guiLabelName = weap[9]
			relativeSizeX = weap[10]
			relativeSizeY = weap[11]
			relativePosX = weap[12]
			relativePosY = weap[13]
			break
		end
	end
	for i, data in ipairs(playerInfo[player]) do
		if ammoType == data[2] then
			if data[3] > 0 then
				takeWeapon(player,weaponID)
				giveWeapon(player,weaponID,data[3],true)
				triggerClientEvent(player,"mtabg_changeEquippedWeaponGUI",player,info,weapon,imagePath,guiLabelName,relativeSizeX,relativeSizeY,relativePosX,relativePosY)
				break
			else
				triggerClientEvent(player,"mtabg_sendErrorToInventory",player,"Not enough ammo!",255,0,0)
				return
			end
		end
	end
	for k, playData in ipairs(playerDataInfo[player]) do
		if weaponType == "Primary" then
			if playData[2] == "currentweapon_1" then
				playData[3] = weapon
				currentWeapon_1 = weapon
			end
		elseif weaponType == "Secondary" then
			if playData[2] == "currentweapon_2" then
				playData[3] = weapon
				currentWeapon_2 = weapon
			end
		elseif weaponType == "Special" then
			if playData[2] == "currentweapon_2" then
				playData[3] = weapon
				currentWeapon_3 = weapon
			end
			
		end
	end
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
				takeWeapon(source,weaponID)
			end
		end
	end
end
addEventHandler("onPlayerWeaponFire",root,depleteAmmoCountWhenFiring)

function removeWeapon(weaponID,player)
	takeWeapon(player,weaponID)
end

function getItemWeight(theItem)
	for i, weight in ipairs(lootItems["FullList"]) do
		if theItem == weight[1] then
			return weight[5]
		end
	end
end

function setPlayerCapacity(player,amount)
local usedCapacity = 0
	for i, data in ipairs(playerDataInfo[player]) do
		if data[2] == "InventoryCapacity" then
			data[3] = amount
		end
		if data[2] == "UsedCapacity" then
			usedCapacity = data[3]
		end
	end
	triggerClientEvent(client,"mtabg_sendCapacityToPlayerClient",client,amount,usedCapacity)
	refreshInventory()
end

function getPlayerCapacity(item)
	local usedCapacity = 0
	local maxCapacity = 0
	local itemWeight = getItemWeight(item)
	for i, data in ipairs(playerDataInfo[client]) do
		if data[2] == "InventoryCapacity" then
			maxCapacity = data[3]
		end
		if data[2] == "UsedCapacity" then
			usedCapacity = data[3]
		end
	end
	if itemWeight and itemWeight < 1 then
		itemWeight = 0
	end
	if itemWeight and usedCapacity+itemWeight > maxCapacity then
		triggerClientEvent(client,"mtabg_sendErrorToInventory",client,"Not enough inventory capacity!")
		return false
	else
		return true
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