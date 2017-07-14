--[[
	
				MTA:BG
			MTA Battlegrounds
	Developed By: L, CiBeR, neves768, 1BOY

]]--


------------------- Match HUD
---- Some kind of screen that creates a lobby
local ownedLobby = nil
function createRoom()
	triggerServerEvent("mtabg_createLobby", getLocalPlayer())
end
addCommandHandler("creategame",createRoom)

function startGame()
	if ownedLobby then
		triggerServerEvent("mtabg_startMatch",getLocalPlayer(),ownedLobby)
	else
		outputChatBox("Only room's owner can start the match")
	end
end
addCommandHandler("game",createRoom)

function updateLobbyID(ID)
	ownedLobby = ID
end
addEvent("mtabg_updateLobbyID", true)
addEventHandler("mtabg_updateLobbyID", getRootElement(), updateLobbyID)



---- Screen TO join a Match [maybe a list of rooms]

function joinMatch(ID)
	triggerServerEvent("mtabg_joinMatch", getLocalPlayer(), ID)
end
addCommandHandler("joingame",joinMatch)