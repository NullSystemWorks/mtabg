AlphaKey = {}

function AlphaKey.getUsed(alphaKey)
	if alphaKey == "" then
		return "blankAlphaKey"
	end
	local keyUser = Database.getAlphaKeyUser(alphaKey)
	if not keyUser then
		return "invalidAlphaKey"
	elseif keyUser["serial"] == "unclaimed" then
		return "unclaimed"
	else
		return "keyAlreadyUsed"
	end
end

function AlphaKey.useKey(alphaKey, serial)
	Database.setAlphaKeyAsUsed(alphaKey, serial)
end

local function generateAlphaKeys(_, _, count)
	count = count or 1
	for i = 1, count do
		local alphaKey = Hash.generateSalt():match("%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x")
		Database.insertNewAlphaKey(alphaKey)
		iprint(alphaKey)
	end
	outputDebugString("Generated " ..count.. " new alpha keys")
end
addCommandHandler("mtabgComputeAlphaKeys", generateAlphaKeys, true, true)

--ACL: command.mtabgComputeAlphaKeys
