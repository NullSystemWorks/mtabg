--[[
	
				MTA:BG
			MTA Battlegrounds
	Developed By: L, CiBeR, neves768, 1BOY

]]--

-- Init game status
gameCache['status'] = false

function onLoginIsGameRunning()
	if gameCache['status'] then
		outputChatBox("Please wait until the current game is over!",source,255,0,0,false)
	end
end
addEventHandler("onPlayerJoin",root,onLoginIsGameRunning)


function startGame()
	gameCache['status'] = false
	for i, player in ipairs(getElementsByType("player")) do
		local dataID = -1
		playerInfo[player] = {}
		playerDataInfo[player] = {}
		setPlayerHudComponentVisible(player,"radar",false)
		x,y,z = math.random(-2500,2500),math.random(-2500,2500),500
		spawnPlayer(player,x,y,z, math.random(0,360), 0, 0, 0)
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
			table.insert(playerDataInfo[player],{i,data[1],data[2]})
		end
		for i, data in ipairs(playerInventoryTable) do
			table.insert(playerInfo[player],{i,data[1],data[2]})
		end
		attachElements(playerCol,player,0,0,0)
		setElementData(player,"participatingInGame",true)
		--triggerClientEvent(player,"mtabg_sendDataToClient",player,playerInfo[player])
		
	end
	--createZone()
	gameCache['status'] = true
end
addCommandHandler("game",startGame)

function returnPlayerInfoToClient(key)
	local info
	for i, data in ipairs(playerDataInfo[client]) do
		if data[2] == key then
			info = data[3]
		end
	end
	triggerClientEvent("mtabg_returnPlayerInfoFromServer",client,info)
end
addEvent("mtabg_returnPlayerInfoToClient",true)
addEventHandler("mtabg_returnPlayerInfoToClient",root,returnPlayerInfoToClient)

function sendClientPlayerInfoToServer(key,action,value)
	for i, data in ipairs(playerDataInfo[client]) do
		if data[2] == key then
			if action == "damage" then
				data[3] = data[3]-value
			elseif action == "heal" then
				data[3] = data[3]+value
			elseif action == nil then
				data[3] = value
			else
				data[3] = value
			end
		end
	end
	checkPlayerStatus(key)
end
addEvent("mtabg_sendClientPlayerInfoToServer",true)
addEventHandler("mtabg_sendClientPlayerInfoToServer",root,sendClientPlayerInfoToServer)

function checkPlayerStatus(key)
	for i, data in ipairs(playerDataInfo[client]) do
		if data[2] == key then
			if key == "health" then
				if data[3] <= 0 then
					killBattleGroundsPlayer(client)
				end
			end
		end
	end
end
addEvent("mtabg_checkPlayerStatus",true)
addEventHandler("mtabg_checkPlayerStatus",root,checkPlayerStatus)


-- Debug
function checkTable(source,cmd)
	for i, data in ipairs(playerDataInfo[source]) do
		outputDebugString(tostring(data[1])..", "..tostring(data[2])..", "..tostring(data[3]))
	end
end
addCommandHandler("data",checkTable)
