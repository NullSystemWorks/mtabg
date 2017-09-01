--[[
	
				MTA:BG
			MTA Battlegrounds
	Developed By: L, CiBeR, neves768, 1BOY

]]--

-- Init game status
gameCache['status'] = false
gameCache['status_duo'] = false -- Currently not in use
gameCache['status_squad'] = false -- Currently not in use
gameCache["initialPlayerAmount"] = 0
gameCache["playerAmount"] = 0
gameCache["countdown"] = 120
gameCache["playingField"] = 0 -- = Dimension (Dimension 500 is reserved for home screen!)

lobbyInteriors = {
{0,3971,3276,16},
}

function sendPlayersOnServerToHomeScreen()
	for i, players in ipairs(getElementsByType("player")) do
		setTimer(function(players)
			spawnPlayer(players,0,0,0)
			fadeCamera(players,true)
			triggerClientEvent(players,"mtabg_sendToHomeScreen",players)
		end,1000,1,players)
	end
end
--addEventHandler("onResourceStart",getResourceRootElement(getThisResource()),sendPlayersOnServerToHomeScreen)

function onJoinSendToHomeScreen()
	setTimer(function(source)
		spawnPlayer(source,0,0,0)
		fadeCamera(source,true)
		triggerClientEvent(source,"mtabg_sendToHomeScreen",source)
	end,1000,1,source)
end
--addEventHandler("onPlayerJoin",root,onJoinSendToHomeScreen)

function onPlayerLeavingGame()
	if not gameCache["status"] then
		gameCache["initialPlayerAmount"] = gameCache["initialPlayerAmount"]-1
		triggerClientEvent("mtabg_setPlayerAmountToClient",root,gameCache["initialPlayerAmount"],gameCache["status"],gameCache["countdown"])
		if gameCache["initialPlayerAmount"] == 0 then
			startCountDown(false)
		end
	end
end
addEventHandler("onPlayerQuit",root,onPlayerLeavingGame)

function sendPlayerToLobby(player)
	if client then player = client end
	local number = math.random(table.size(lobbyInteriors))
	
	spawnID,spawnX,spawnY,spawnZ = lobbyInteriors[number][1],lobbyInteriors[number][2],lobbyInteriors[number][3],lobbyInteriors[number][4]
	spawnPlayer(player,spawnX+math.random(-10,10),spawnY+math.random(-10,10),spawnZ+3,math.random(0,359),0,spawnID)
	fadeCamera (player, false,2000,0,0,0)
	setCameraTarget (player, player)
	setTimer( function(player)
		if isElement(player) then
			setElementFrozen(player, false)
			fadeCamera(player,true)
		end
	end,500,1,player)
	setPlayerHudComponentVisible(player,"radar",false)
	setPlayerHudComponentVisible(player,"clock",false)
	setPlayerHudComponentVisible(player,"health",false)
	setPlayerHudComponentVisible(player,"area_name",false)
	setPlayerHudComponentVisible(player,"money",false)
	playerDataInfo[player] = {}
	for i, data in ipairs(playerDataTable) do
		table.insert(playerDataInfo[player],{i,data[1],data[2]})
	end
	gameCache["initialPlayerAmount"] = gameCache["initialPlayerAmount"]+1
	if gameCache["initialPlayerAmount"] == 1 then
		startCountDown(true)
	end
	setTimer(function()
		triggerClientEvent("mtabg_setPlayerAmountToClient",root,gameCache["initialPlayerAmount"],gameCache["status"],gameCache["countdown"])
	end,2000,1,gameCache["initialPlayerAmount"],gameCache["status"],gameCache["countdown"])
end
addEvent("mtabg_sendPlayerToLobby",true)
addEventHandler("mtabg_sendPlayerToLobby",root,sendPlayerToLobby)

function startCountDown(state)
local countDownTimer
	if state then
		if isTimer(countdownTimer) then killTimer(countdownTimer) end
		countdownTimer = setTimer(function()
			gameCache["countdown"] = gameCache["countdown"]-1
			if gameCache["countdown"] == 0 then
				if gameCache["initialPlayerAmount"] > 0 then -- Must be 1 (= at least 2 players)
					if not gameCache["status"] then 
						startGame()
						if isTimer(countdownTimer) then killTimer(countdownTimer) end
					else
						for i, player in ipairs(getElementsByType("player")) do
							if not getElementData(player,"participatingInGame") then
								outputChatBox("A match is currently running, please wait until it's over!",player,255,0,0,false)
								gameCache["countdown"] = 120
								startCountDown(true)
								return
							end
						end
					end
				end
			end
		end,1000,120,gameCache["countdown"])
	else
		gameCache["countdown"] = 120
		if isTimer(countdownTimer) then killTimer(countdownTimer) end
	end
end

function startGame()
	gameCache['status'] = false
	gameCache["initialPlayerAmount"] = 0
	gameCache["playingField"] = gameCache["playingField"]+1
	if not firstTimeLoot then
		outputDebugString("Creating loot for the first time...")
		createSpotsOnStart()
	else
		outputDebugString("Destroying loot, creating new...")
		refreshLootSpots()
	end
	for i, player in ipairs(getElementsByType("player")) do
		local dataID = -1
		playerInfo[player] = {}
		playerDataInfo[player] = {}
		setPlayerHudComponentVisible(player,"radar",false)
		setPlayerHudComponentVisible(player,"clock",false)
		setPlayerHudComponentVisible(player,"health",false)
		setPlayerHudComponentVisible(player,"area_name",false)
		setPlayerHudComponentVisible(player,"money",false)
		x,y,z = math.random(-2500,2500),math.random(-2500,2500),1000
		spawnPlayer(player,x,y,z, math.random(0,360), 0, 0, gameCache["playingField"])
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
		gameCache["initialPlayerAmount"] = gameCache["initialPlayerAmount"]+1
	end
	createZone()
	gameCache['status'] = true
	triggerClientEvent("mtabg_setPlayerAmountToClient",root,gameCache["initialPlayerAmount"],gameCache["status"],gameCache["countdown"])
	gameCache["playerAmount"] = gameCache["initialPlayerAmount"]
	gameCache["countdown"] = 120
end
addEvent("mtabg_startGame",true)
addEventHandler("mtabg_startGame",root,startGame)

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
