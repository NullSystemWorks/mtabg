Backpack = {}
local backpack_mt = {__index = Backpack}

function Backpack.new(backpackName)
	local model = getItemModel(backpackName)
	local worldObject = createObject(model, 0, 0, 0)

	local newInst =
	{
		worldObject = worldObject
	}
	setmetatable(newInst, backpack_mt)
	return newInst
end

function Backpack:attachToPlayer(player)
	self.worldObject:setDimension(player:getDimension())
	attachElementToBone(self.worldObject, player, Bone.SPINE1, 0, -0.225, 0.05, 90, 0, 0)
end

function Backpack:destroy()
	detachElementFromBone(self.worldObject)
	self.worldObject:destroy()
end
