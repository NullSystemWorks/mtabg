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
		remote = Remote.new(MtaPed),
	}
	setmetatable(newInst, ped_mt)
	newInst.remote:setSuper(newInst)
	if dim then
		newInst:setDimension(dim)
	end
	return newInst
end

function Ped:destroy()
	self.remote:destroy()
	self.remote:getRemote():destroy()
end

function Ped:kill()
	self.remote:getRemote():kill()
end
