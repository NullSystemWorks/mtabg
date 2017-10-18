ClassStash.save("Element")
Element = {} --Abstract class

function Element:getPosition()
	return self.remote:getRemote():getPosition()
end

function Element:setPosition(x, y, z, warp)
	self.remote:getRemote():setPosition(x, y, z, warp)
end

function Element:setCollisionsEnabled(_enabled)
	self.remote:getRemote():setCollisionsEnabled(_enabled)
end

function Element:setFrozen(_frozen)
	self.remote:getRemote():setFrozen(_frozen)
end

function Element:getDimension()
	return self.remote:getRemote():getDimension()
end

function Element:setDimension(_dimension)
	self.remote:getRemote():setDimension(_dimension)
end

function Element:setInterior(interior, x, y, z)
	self.remote:getRemote():setInterior(interior, x, y, z)
end

function Element:getSpeed()
	return (Vector3(self.remote:getRemote():getVelocity())*50).length --Speed in m/s
end

function Element:isInWater()
	return self.remote:getRemote():isInWater()
end

function Element:getRotation()
	return self.remote:getRemote():getRotation()
end

function Element:getZRotation()
	return self.remote:getRemote():getRotation().z
end

function Element:getModel()
	return self.remote:getRemote():getModel()
end
