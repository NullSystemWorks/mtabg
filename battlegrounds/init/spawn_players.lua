--[[
	
				MTA:BG
			MTA Battlegrounds
	Developed By: L, CiBeR, neves768, 1BOY

]]--

-- Init game status
gameCache['status'] = false
gameCache["initialPlayerAmount"] = 0

lobbyInteriors = {

{2,2558,-1292,1032},
{4,-1435,-662,1052},
{14,-1464,1557,1052},

}

function onLoginIsGameRunning()
	if gameCache['status'] then
		outputChatBox("Please wait until the current game is over!",source,255,0,0,false)
	else
		outputDebugString("Player detected, sending to lobby.")
		sendPlayerToLobby(source)
	end
end
addEventHandler("onPlayerJoin",root,onLoginIsGameRunning)

function sendPlayerToLobby(player)
	local number = math.random(table.size(lobbyInteriors))
	outputDebugString("number: "..tostring(number))
	spawnID,spawnX,spawnY,spawnZ = lobbyInteriors[number][1],lobbyInteriors[number][2],lobbyInteriors[number][3],lobbyInteriors[number][4]
	outputDebugString("ID: "..tostring(spawnID))
	spawnPlayer(player,spawnX+math.random(-10,10),spawnY+math.random(-10,10),spawnZ+1,math.random(0,359),0,spawnID)
	setCameraTarget(player, player)
	setPlayerHudComponentVisible(player,"radar",false)
	setPlayerHudComponentVisible(player,"clock",false)
	setPlayerHudComponentVisible(player,"health",false)
	setPlayerHudComponentVisible(player,"area_name",false)
	setPlayerHudComponentVisible(player,"money",false)
	playerDataInfo[player] = {}
	for i, data in ipairs(playerDataTable) do
		table.insert(playerDataInfo[player],{i,data[1],data[2]})
	end
	table.insert(playerDataInfo[player],{-1,"inLobby",true})
end

function startGame()
	gameCache['status'] = false
	for i, player in ipairs(getElementsByType("player")) do
		gameCache["initialPlayerAmount"] = gameCache["initialPlayerAmount"]+1
		local dataID = -1
		playerInfo[player] = {}
		playerDataInfo[player] = {}
		setPlayerHudComponentVisible(player,"radar",false)
		setPlayerHudComponentVisible(player,"clock",false)
		setPlayerHudComponentVisible(player,"health",false)
		setPlayerHudComponentVisible(player,"area_name",false)
		setPlayerHudComponentVisible(player,"money",false)
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
	end
	--createZone()
	gameCache['status'] = true
	triggerClientEvent("mtabg_setPlayerAmountToClient",root,gameCache["initialPlayerAmount"],gameCache["status"])
end
addCommandHandler("game",startGame)

function returnPlayerInfoToClient(key)
	if not gameCache["status"] then return end
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

function sendClientPlayerInfoToServer(key,action,value,other)
	if not gameCache["status"] then return end
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
	checkPlayerStatus(key,false,other)
end
addEvent("mtabg_sendClientPlayerInfoToServer",true)
addEventHandler("mtabg_sendClientPlayerInfoToServer",root,sendClientPlayerInfoToServer)

function checkPlayerStatus(key,player,other)
	if not gameCache["status"] then return end
	if not player then player = client end
	for i, data in ipairs(playerDataInfo[player]) do
		if data[2] == key then
			if key == "health" then
				if data[3] <= 0 then
					killBattleGroundsPlayer(player,other,false)
				end
			end
		end
	end
end
addEvent("mtabg_checkPlayerStatus",true)
addEventHandler("mtabg_checkPlayerStatus",root,checkPlayerStatus)
