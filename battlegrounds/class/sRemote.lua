Remote = {}
local remote_mt = {__index = Remote}

local remoteFromSuper = {}
local superFromRemote = {}

function Remote.new(remote)
	local newInst =
	{
		remote = remote,
		super,
	}
	setmetatable(newInst, remote_mt)
	return newInst
end

function Remote:destroy()
	self:clearCurrentRemoteReference()
end

function Remote.saveRemote(super, remote)
	remoteFromSuper[super] = remote
	superFromRemote[remote] = super
end

function Remote.getSuperFromRemote(remote)
	return superFromRemote[remote]
end

function Remote.getRemoteFromSuper(super)
	return remoteFromSuper[super]
end

function Remote.isLegitPlayer(theClient, theSource)
	if not theClient then
		iprint("Possible rogue login attempt: not called from a client. ")
		iprint("Source: ", theSource)
		return false
	elseif theClient ~= theSource then
		iprint("Possible rogue login attempt: client ~= source")
		iprint("Client: ", theClient)
		iprint("Source: ", theSource)
		return false
	end
	return true
end

function Remote:clearCurrentRemoteReference()
	if remoteFromSuper[self.super] then
		remoteFromSuper[self.super] = nil
	end
	if superFromRemote[self.remote] then
		superFromRemote[self.remote] = nil
	end
end

function Remote:getRemote()
	return self.remote
end

function Remote:getSuper()
	return self.super
end

function Remote:setSuper(_super)
	self:clearCurrentRemoteReference()
	self.super = _super
	Remote.saveRemote(self.super, self.remote)
end

function Remote:send(event, ...)
	-- iprint(self.remote, event)
	self.remote:triggerEvent(event, self.remote, unpack(arg))
	iprint("Sent \"" ..tostring(event).. "\": " ..tostring(unpack(arg)).. " to " ..tostring(self.remote.name))
end
