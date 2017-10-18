LootSpot = {}
local lootSpot_mt = {__index = LootSpot}

local lootSpotCount = 0

LootSpot.DEFAULT_INVENTORY_SIZE = 300*100

function LootSpot.new(x, y, z, match)
	local colShape = ColShape.Sphere(x, y, z, 1.25)
	local remote = Remote.new(colShape)
	local newInst =
	{
		x = x,
		y = y,
		z = z,
		remote = remote,
		match = match,
		inventory = Inventory.new(remote),
		worldModels = {},
	}
	setmetatable(newInst, lootSpot_mt)
	newInst.remote:setSuper(newInst)
	newInst.inventory:setCapacity(LootSpot.DEFAULT_INVENTORY_SIZE)
	lootSpotCount = lootSpotCount + 1
	setElementData(colShape,"itemloot",true) --YUCK: please, don't...
	return newInst
end

function LootSpot:destroy()
	self:destroyWorldModels()
	self.inventory:destroy()
	self.remote:getRemote():destroy()
	self.remote:destroy()
	self.match = nil
	lootSpotCount = lootSpotCount - 1
end

function LootSpot:destroyWorldModels()
	for _, object in ipairs(self.worldModels) do
		object:destroy()
	end
end

function LootSpot.getCount()
	return lootSpotCount
end

function LootSpot.createAll(match)
	local allLoot = {}
	for className, classTable in pairs(lootColPos) do
		for colID = 1, #classTable.x do
			local lootSpot = LootSpot.new(classTable.x[colID],classTable.y[colID],classTable.z[colID], match)
			lootSpot:insertItems(className)
			lootSpot:insertWorldObjects()
			table.insert(allLoot, lootSpot)
		end
	end
	return allLoot
end

function LootSpot:insertItems(className)
	for itemName in pairs(getItemNames()) do
		local itemCount = math.percentChance(getItemSpawnChance(className, itemName),5)
		if itemCount > 0 then
			if isItemAmmo(itemName) then
				itemCount = itemCount*getAmmoClipSize(itemName)
			end
			self.inventory:giveItem(itemName, itemCount)
		end
	end
end

function LootSpot:insertWorldObjects()
	local objectCounter = 0
	for itemName in pairs(self.inventory:getItemList()) do
		if objectCounter >= 3 then
			break
		end

		local worldObject = WorldObject.new(
			getItemModel(itemName),
			self.x + math.random(-1, 1),
			self.y + math.random(-1, 1),
			self.z - 0.875,
			getItemModelRotation(itemName)
		)
		worldObject:setScale(getItemModelScale(itemName))
		worldObject:setCollisionsEnabled(false)
		worldObject:setFrozen(true)
		worldObject:setDimension(self.match:getDimension())
		table.insert(self.worldModels, worldObject)
		objectCounter = objectCounter + 1
	end
end
