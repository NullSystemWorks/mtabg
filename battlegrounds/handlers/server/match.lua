--[[

				MTA:BG
			MTA Battlegrounds
	Developed By: Null System Works

]]--


games = {}
playingPlayers = {}

function createLobby(gameType,roomName,slots)
	local ID = #games+1
	games[ID] = {
		["config"] = {
			["gameType"] = "solo",
			["RoomName"] = roomName,
			["slots"] = slots,
			["minPlayers"] = 1,
			["started"] = false
			},
			["players"] = {
				[client] = true
				},
			["deadPlayers"] = {},
			["spectating"] = {}
		}
end
addEvent("mtabg_createLobby",true)
addEventHandler("mtabg_createLobby",root,createLobby)

function joinMatch(ID)
	if not games[ID]["config"]["started"] then
		games[ID]["players"][client] = true
	end
end
addEvent("mtabg_joinMatch", true)
addEventHandler("mtabg_joinMatch", getRootElement(), joinMatch)

function startMatch(ID)
	if not games[ID]["config"]["started"] then
		games[ID]["config"]["started"] = true
		-- Spawn players
		for i, player in ipairs(games[ID]["players"]) do
			local dataID = -1
			playerInfo[player] = {}
			setPlayerHudComponentVisible(player,"radar",false)
			x,y,z = math.random(-2500,2500),math.random(-2500,2500),500
			spawnPlayer(player,x,y,z, math.random(0,360), 0, 0, 0)
			setElementDimension(player,ID)
			giveWeapon(player,46,1)
			fadeCamera (player, false,2000,0,0,0)
			setCameraTarget (player, player)
			setTimer( function(player)
				if isElement(player) then
					setElementFrozen(player, false)
					fadeCamera(player,true)
				end
			end,500,1,player)
			playerCol = createColSphere(x,y,z,1.5)
			table.insert(playerInfo[player],{dataID+1,playerCol})
			for i, data in ipairs(playerDataTable) do
				table.insert(playerInfo[player],{i,data[1],data[2]})
			end
			attachElements(playerCol,player,0,0,0)
			playerInfo[player]["matchID"] = ID
			playingPlayers[player] = true
		end
	else
		outputChatBox("Match already started", client)
	end
end
addEvent("mtabg_startMatch", true)
addEventHandler("mtabg_startMatch", getRootElement(), startMatch)

function endMatch(ID)

end

function checkMatch(ID)
	if games[ID]["gameType"] == "solo" then
		if #games[ID]["players"]-1 == #games[ID]["deathplayers"] then
			endMatch(ID)
		end
	end
end
addEvent("mtabg_checkMatch", true)
addEventHandler("mtabg_checkMatch", getRootElement(), checkMatch)
