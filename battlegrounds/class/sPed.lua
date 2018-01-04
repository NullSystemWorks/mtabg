ClassStash.save("Ped")
local MtaPed = ClassStash.get("Ped")

Ped = {}
setmetatable(Ped, {__index = Element}) --Ped inherits from Element
local ped_mt = {__index = Ped}

function Ped.new(modelID, pos, rot, dim, synced)
	modelID = modelID or 1
	pos = pos or Vector3(0, 0, 0)
	local MtaPed = createPed(modelID, pos, rot, synced)
	local newInst =
	{
		type = "Ped",
		name,
		remote = Remote.new(MtaPed),
		backpack,
	}
	setmetatable(newInst, ped_mt)
	newInst.remote:setSuper(newInst)
	if dim then
		newInst:setDimension(dim)
	end
	return newInst
end

function Ped:destroy()
	self:removeBackpack()
	self.remote:destroy()
	self.remote:getRemote():destroy()
end

function Ped:getName()
	return self.name or "ped"
end

function Ped:setName(_name)
	self.name = _name
end

function Ped:kill()
	self.remote:getRemote():kill()
end

function Ped:getBackpack()
	return self.backpack
end

function Ped:removeBackpack()
	local backpack = self:getBackpack()
	if backpack then
		backpack:destroy()
		self.backpack = false
	end
end
