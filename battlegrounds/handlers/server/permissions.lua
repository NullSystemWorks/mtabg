--[[

				MTA:BG
			MTA Battlegrounds
	Developed By: Null System Works (L, CiBeR, neves768, 1BOY & expert975)
	
]]--


function preventCertainCommands(cmd)
	if cmd == "say" then
		for i, players in ipairs(getElementsByType("player")) do
			if not getElementData(players,"inLobby") then
				cancelEvent()
				return
			end
		end
	end
	if cmd == "teamsay" then
		cancelEvent()
		return
	end
	if cmd == "register" then -- login will be enabled for now, until we have a proper admin panel that does not MTA's login system
		cancelEvent()
		return
	end
end
addEventHandler("onPlayerCommand",root,preventCertainCommands)