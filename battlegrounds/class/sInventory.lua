Inventory = {}
local inventory_mt = {__index = Inventory}

function Inventory.new(remote)
	local newInst =
	{
		remote = remote,
		capacity = 0,
		usedSlots = 0,
		items = {},
	}
	setmetatable(newInst, inventory_mt)
	newInst:setEmpty()
	return newInst
end

function Inventory:destroy()
	--nothing needs to be done; keep no references and gc will take care of it
end

function Inventory:setEmpty()
	for itemName in pairs(self:getItemList()) do
		iprint("Taking all "  ..itemName)
		self:takeAll(itemName)
	end
end

function Inventory:getItemList()
	return self.items
end

function Inventory:takeAll(itemName)
	if self:doesHaveItem(itemName) then
		self:takeItem(itemName, self:getItemCount(itemName))
	end
end

function Inventory:doesHaveItem(itemName, amount)
	local amount = amount or 1
	return self:getItemCount(itemName) >= amount
end

function Inventory:getItemCount(itemName)
	return self.items[itemName] or 0
end

function Inventory:setItemCount(itemName, _count)
	self.items[itemName] = _count > 0 and _count or nil
end

function Inventory:giveItem(itemName, amountToGive)
	amountToGive = amountToGive or 1
	self:setItemCount(itemName, self:getItemCount(itemName) + amountToGive)
	self:setUsedSlots(self:getUsedSlots() + getItemWeight(itemName)*amountToGive)
end

function Inventory:takeItem(itemName, amountToTake)
	amountToTake = amountToTake or 1
	self:setItemCount(itemName, self:getItemCount(itemName) - amountToTake)
	self:setUsedSlots(self:getUsedSlots() - getItemWeight(itemName)*amountToTake)
end

function Inventory:transferItemTo(target, itemName, amount)
	if self:doesHaveItem(itemName, amount) then
		local targetFitCount = target:getItemFitCount(itemName)
		if target:doesItemFit(itemName, amount) then
			self:takeItem(itemName, amount)
			target:giveItem(itemName, amount)
		elseif targetFitCount >= 1 then
			self:takeItem(itemName, targetFitCount)
			target:giveItem(itemName, targetFitCount)
		elseif not target:doesItemFit(itemName) then
			target:sendFullInventoryMessage()
		end
	end
end

function Inventory:canTransferItemTo(target, itemName, amount) --NOTE: unused
	return self:doesHaveItem(itemName, amount) and target:doesItemFit(itemName, amount)
end

function Inventory:doesItemFit(itemName, amount)
	local amount = amount or 1
	if self:getItemFitCount(itemName) >= amount then
		return true
	else
		return false
	end
end

function Inventory:getItemFitCount(itemName) --How many of this item fit in the inventory
	return math.floor(self:getFreeSlots()/getItemWeight(itemName))
end

function Inventory:getCapacity()
	return self.capacity
end

function Inventory:setCapacity(_capacity)
	self.capacity = _capacity
	if Player.isPlayer(self.remote:getSuper()) then
		self.remote:send("onSendInventoryCapacity", self:getCapacity())
	end
end

function Inventory:getFreeSlots()
	return self:getCapacity() - self:getUsedSlots()
end

function Inventory:getUsedSlots()
	return self.usedSlots
end

function Inventory:setUsedSlots(_usedSlots)
	self.usedSlots = _usedSlots
	if Player.isPlayer(self.remote:getSuper()) then
		self.remote:send("onSendInventoryUsage", self:getUsedSlots())
	end
end

function Inventory:sendFullInventoryMessage()
	if Player.isPlayer(self.remote:getSuper()) then
		self.remote:send("onShowInventoryMessage", "fullInventory")
	end
end
