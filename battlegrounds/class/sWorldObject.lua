WorldObject = {}
setmetatable(WorldObject, {__index = Element})
local worldObject_mt = {__index = WorldObject}

function WorldObject.new(modelID, x, y, z, rx, ry, rz, isLowLod)
	local	object = Object(modelID, x, y, z, rx, ry, rz, isLowLod)
	local newInst =
	{
		remote = Remote.new(object)
	}
	setmetatable(newInst, worldObject_mt)
	newInst.remote:setSuper(newInst)
	return newInst
end

function WorldObject:destroy()
	self.remote:getRemote():destroy()
	self.remote:destroy()
end

function WorldObject:setScale(scale, scaleY, scaleZ)
	self.remote:getRemote():setScale(scale, scaleY, scaleZ)
end
