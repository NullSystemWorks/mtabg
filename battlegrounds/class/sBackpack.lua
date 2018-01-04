Backpack = {}
local backpack_mt = {__index = Backpack}

function Backpack.new(itemName, owner)
	local model = getItemModel(itemName)
	local worldObject = createObject(model, 0, 0, 0)

	local newInst =
	{
		worldObject = worldObject,
		owner = owner,
	}
	setmetatable(newInst, backpack_mt)
	newInst:attachToOwner()
	return newInst
end

function Backpack:destroy()
	detachElementFromBone(self.worldObject)
	self.worldObject:destroy()
	self.owner = nil
end

function Backpack:attachToOwner()
	self.worldObject:setDimension(self.owner:getDimension())
	attachElementToBone(self.worldObject, self.owner.remote:getRemote(),
	Bone.SPINE1, 0, -0.225, 0.05, 90, 0, 0)
end

function Backpack:transferTo(ped)
	if not ped:getBackpack() then
		detachElementFromBone(self.worldObject)
		self.owner.backpack = false
		ped.backpack = self
		self.owner = ped
		self:attachToOwner()
	else
		iprint("ERROR: tried to attatch two backpacks to ped: " ..ped.name)
	end
end
