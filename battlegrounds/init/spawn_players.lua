--[[

				MTA:BG
			MTA Battlegrounds
	Developed By: Null System Works (L, CiBeR, neves768, 1BOY & expert975)

]]--

-- Init game status
gameCache["status"] = false
gameCache['status_duo'] = false -- Currently not in use
gameCache['status_squad'] = false -- Currently not in use
gameCache["initialPlayerAmount"] = 0
gameCache["playerAmount"] = 0
gameCache["countdown"] = 300
gameCache["playingField"] = 0 -- = Dimension (Dimension 500 is reserved for home screen!)
local countdownHasStarted = false

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
		gameCache["initialPlayerAmount"] = math.max(gameCache["initialPlayerAmount"]-1,0)
		for i, players in ipairs(getElementsByType("player")) do
			if getElementData(players,"inLobby") then
				triggerClientEvent(players,"mtabg_onClientBattleGroundsSetStatus",players,false,gameCache["initialPlayerAmount"])
			end
		end
		if gameCache["initialPlayerAmount"] <= 1 then --1
			stopCountDown()
			for i, players in ipairs(getElementsByType("player")) do
				if getElementData(players,"inLobby") then
					triggerClientEvent(players,"mtabg_onClientBattleGroundsAnnounceMatchStart",players,"More players needed")
					triggerClientEvent(players,"mtabg_onClientBattleGroundsSetCountdown",players,"N/A")
				end
			end
		end
	else
		gameCache["playerAmount"] = math.max(gameCache["playerAmount"]-1,0)
		for i, players in ipairs(getElementsByType("player")) do
			if getElementData(players,"participatingInGame") then
				triggerClientEvent(players,"mtabg_onClientBattleGroundsSetAliveCount",players,gameCache["playerAmount"])
			end
		end
	end
end
addEventHandler("onPlayerQuit",root,onPlayerLeavingGame)

function sendPlayerToLobby(player, forcedStart, quickTick)
	if client then player = client end
	showChat(player,true)
	spawnID,spawnX,spawnY,spawnZ = 0,3971,3276,16
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
	setElementData(player,"inLobby",true)
	setTimer(function()
		if not gameCache["status"] then
			for i, players in ipairs(getElementsByType("player")) do
				if getElementData(players,"inLobby") then
					triggerClientEvent(players,"mtabg_onClientBattleGroundsSetStatus",players,false,gameCache["initialPlayerAmount"])
				end
			end
			if gameCache["initialPlayerAmount"] > 1 or forcedStart then
				startCountDown(forcedStart, quickTick)
				for i, players in ipairs(getElementsByType("player")) do
					if getElementData(players,"inLobby") then
						triggerClientEvent(players,"mtabg_onClientBattleGroundsAnnounceMatchStart",players,300)
					end
				end
			else
				for i, players in ipairs(getElementsByType("player")) do
					if getElementData(players,"inLobby") then
						triggerClientEvent(players,"mtabg_onClientBattleGroundsAnnounceMatchStart",players,"More players needed")
					end
				end
			end
		else
			for i, players in ipairs(getElementsByType("player")) do
				if getElementData(players,"inLobby") then
					triggerClientEvent(players,"mtabg_onClientBattleGroundsAnnounceMatchStart",players,"Match running")
					triggerClientEvent(players,"mtabg_onClientBattleGroundsSetStatus",players,false,gameCache["initialPlayerAmount"])
				end
			end
		end
	end,2000,1,gameCache["initialPlayerAmount"],gameCache["status"],gameCache["countdown"])
end
addCommandHandler("forceMatchStart", sendPlayerToLobby, true, true)
addEvent("mtabg_sendPlayerToLobby",true)
addEventHandler("mtabg_sendPlayerToLobby",root,sendPlayerToLobby)

local spawnItemsTimer
function startCountDown(forcedStart, quickTick)
	if gameCache["status"] then return end
	if isTimer(spawnItemsTimer) then killTimer(spawnItemsTimer) end
	gameCache["playingField"] = 0
	if gameCache["initialPlayerAmount"] < 1 and not forcedStart then
		for i, players in ipairs(getElementsByType("player")) do
			if getElementData(players,"inLobby") then
				triggerClientEvent(players,"mtabg_onClientBattleGroundsAnnounceMatchStart",players,"More players needed")
			end
		end
		return
	end
	spawnItemsTimer = setTimer(function()
		if firstTimeLoot then
			refreshLootSpots()
			firstTimeLoot = false
		end
		gameCache["countdown"] = gameCache["countdown"]-1
		for i, players in ipairs(getElementsByType("player")) do
			if getElementData(players,"inLobby") then
				triggerClientEvent(players,"mtabg_onClientBattleGroundsSetCountdown",players,gameCache["countdown"])
			end
		end
		if gameCache["countdown"] == 240 then
			for i, players in ipairs(getElementsByType("player")) do
				if getElementData(players,"inLobby") then
					triggerClientEvent(players,"mtabg_onClientBattleGroundsAnnounceMatchStart",players,240)
				end
			end
		end
		if gameCache["countdown"] == 100 then
			outputDebugString("[MTA:BG] Spawning Industry Loot Points(20%)")
			async:foreach(lootPoints["Industry"], function(position)
				SpotsID = SpotsID+1
				createLootPoint("Industry",position[1],position[2],position[3],SpotsID)
			end)
		elseif gameCache["countdown"] == 80 then
			outputDebugString("[MTA:BG] Spawning Residential Loot Points(40%)")
			async:foreach(lootPoints["Residential"], function(position)
				SpotsID = SpotsID+1
				createLootPoint("Residential",position[1],position[2],position[3],SpotsID)
			end)
		elseif gameCache["countdown"] == 60 then
			outputDebugString("[MTA:BG] Spawning Supermarket Loot Points(60%)")
			async:foreach(lootPoints["Supermarket"], function(position)
				SpotsID = SpotsID+1
				createLootPoint("Supermarket",position[1],position[2],position[3],SpotsID)
			end)
			for i, players in ipairs(getElementsByType("player")) do
				if getElementData(players,"inLobby") then
					triggerClientEvent(players,"mtabg_onClientBattleGroundsAnnounceMatchStart",players,60)
				end
			end
		elseif gameCache["countdown"] == 40 then
			outputDebugString("[MTA:BG] Spawning Farm Loot Points(80%)")
			async:foreach(lootPoints["Farm"], function(position)
				SpotsID = SpotsID+1
				createLootPoint("Farm",position[1],position[2],position[3],SpotsID)
			end)
		elseif gameCache["countdown"] == 20 then
			outputDebugString("[MTA:BG] Spawning Military Loot Points(100%)")
			async:foreach(lootPoints["Military"], function(position)
				SpotsID = SpotsID+1
				createLootPoint("Military",position[1],position[2],position[3],SpotsID)
			end)
			for i, players in ipairs(getElementsByType("player")) do
				if getElementData(players,"inLobby") then
					triggerClientEvent(players,"mtabg_onClientBattleGroundsAnnounceMatchStart",players,20)
				end
			end
		elseif gameCache["countdown"] == 0 then
			if gameCache["initialPlayerAmount"] > 1 then
				startGame()
				firstTimeLoot = true
				killTimer(spawnItemsTimer)
			end
		end
	end,quickTick and 50 or 1000,300,gameCache["countdown"],gameCache["initialPlayerAmount"],firstTimeLoot,gameCache["status"])
end

function stopCountDown()
	if isTimer(spawnItemsTimer) then killTimer(spawnItemsTimer) refreshLootSpots() end
end

function startGame()
	gameCache["status"] = false
	for i, player in ipairs(getElementsByType("player")) do
		if getElementData(player, "inLobby") then
			showChat(player,false)
			local dataID = -1
			playerInfo[player] = {}
			playerDataInfo[player] = {}
			--setPlayerHudComponentVisible(player,"radar",false)
			setPlayerHudComponentVisible(player,"clock",false)
			setPlayerHudComponentVisible(player,"health",false)
			setPlayerHudComponentVisible(player,"area_name",false)
			setPlayerHudComponentVisible(player,"money",false)
			x,y,z = math.random(-2500,2500),math.random(-2500,2500),1000
			spawnPlayer(player,x,y,z, math.random(0,360), 0, 0, gameCache["playingField"])
			giveWeapon(player,46,1,true)
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
			gameCache["playerAmount"] = gameCache["initialPlayerAmount"]
			triggerClientEvent(player,"mtabg_onClientBattleGroundsSetStatus",player,gameCache["playerAmount"],true,gameCache["countdown"])
			setElementData(player,"inLobby",false)
			giveWeapon(player,46,1,true)
			setPedWeaponSlot(player,11)
		end
	end
	createZone()
	spawnVehiclesOnMatchStart()
	gameCache["status"] = true
	gameCache["countdown"] = 300
	countdownHasStarted = false
end
addEvent("mtabg_startGame",true)
addEventHandler("mtabg_startGame",root,startGame)

function startGameCommand()
	startCountDown()
	startGame()
	async:foreach(lootPoints["Industry"], function(position)
	SpotsID = SpotsID+1
	createLootPoint("Industry",position[1],position[2],position[3],SpotsID)
	end)
end

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

function onBattleGroundsSetPlayerHealth(key,action,value,other)
	if not gameCache["status"] then return end
	if not client then client = source end
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
addEvent("mtabg_onBattleGroundsSetPlayerHealth",true)
addEventHandler("mtabg_onBattleGroundsSetPlayerHealth",root,onBattleGroundsSetPlayerHealth)

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

function resetGameCache()
	gameCache["status"] = false
	gameCache['status_duo'] = false -- Currently not in use
	gameCache['status_squad'] = false -- Currently not in use
	gameCache["initialPlayerAmount"] = 0
	gameCache["playerAmount"] = 0
	gameCache["countdown"] = 300
	gameCache["playingField"] = 0 -- = Dimension (Dimension 500 is reserved for home screen!)
end
addEvent("mtabg_resetGameCache",true)
addEventHandler("mtabg_resetGameCache",root,resetGameCache)
