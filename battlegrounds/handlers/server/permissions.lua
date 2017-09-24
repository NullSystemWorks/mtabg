--[[

				MTA:BG
			MTA Battlegrounds
	Developed By: Null System Works (L, CiBeR, neves768, 1BOY & expert975)

]]--

local function restrictCommands(cmd)
	if (cmd == "say" and not getElementData(source,"inLobby"))
		or cmd == "teamsay"
		or cmd == "showchat"
		or cmd == "register"
		or cmd == "me" then
			cancelEvent()
	end
end
addEventHandler("onPlayerCommand",root,restrictCommands)

local function stopExternalParachuteResource()
	local parachuteResource = getResourceFromName("parachute")
	if parachuteResource and getResourceState(parachuteResource) == "running" then
		stopResource(parachuteResource)
	end
end
addEventHandler("onResourceStart",resourceRoot,stopExternalParachuteResource)
