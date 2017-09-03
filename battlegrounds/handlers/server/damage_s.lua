--[[

				MTA:BG
			MTA Battlegrounds
	Developed By: Null System Works (L, CiBeR, neves768, 1BOY & expert975)
	
]]--


function destroyDeadPlayer(ped,pedCol)
	destroyElement(ped)
	destroyElement(pedCol)
end

function killBattleGroundsPlayer(player,killer,headshot)
	if not player then player = source end
	local x,y,z = getElementPosition(player)
	local deadPlayerTable = {}
	pedCol = false
	killPed(player)
	if not isElementInWater(player) then
		if getDistanceBetweenPoints3D (x,y,z,6000,6000,0) > 200 then
			local x,y,z = getElementPosition(player)
			local rotX,rotY,rotZ = getElementRotation(player)
			local skin = getElementModel(player)
			local dimension = getElementDimension(player)
			ped = createPed(skin,6000,6000,0,rotZ)
			pedCol = createColSphere(6000,6000,0,1.5)
			deadPlayerTable[pedCol] = {}
			killPed(ped)
			setElementDimension(ped,dimension)
			setTimer(destroyDeadPlayer,600000,1,ped,pedCol)
			attachElements(pedCol,ped,0,0,0)
			setElementData(pedCol,"parent",ped)
			setElementData(pedCol,"playername",getPlayerName(player))
			setElementData(pedCol,"deadman",true)
			setElementPosition(ped,x,y,z)
		end	
	end
	if killer and killer ~= player then
		for i, data in ipairs(playerDataInfo[killer]) do
			if data[2] == "kills" then
				data[3] = data[3]+1
			end
		end
	end
	if pedCol then
		for k,	data in ipairs(playerDataInfo[player]) do
			table.insert(deadPlayerTable[pedCol],{data[2],data[3]})
		end
	end
	setTimer(setElementPosition,500,1,player,6000,6000,0)
	setCameraMatrix(player,x,y,z+10,x,y,z)
	setTimer(function()
		fadeCamera(player,false,5000,0,0,0)
		setCameraMatrix(player,x,y,3000)
		setTimer(function(player)
			if isElement(player) then
				setElementFrozen(player, false)
				fadeCamera(player,true)
			end
		end,500,1,player)
	end,4000,1,player)
	if gameplayVariables['multipleMatch'] then
		local ID = playerInfo[player]["matchID"]
		playingPlayers[player] = false
		if games[ID]["config"]["gameType"] == "Solo" then
			playerInfo[player]["matchID"] = false
			-- removePlayerFromMatch()
		end
		games[ID]["deathplayers"][player] = true
		-- OR: table.insert(games[ID]["deathplayers"],player)
		checkMatch(ID)
	else
		--
	end
	homeScreenDimension = homeScreenDimension+1
	gameCache["playerAmount"] = gameCache["playerAmount"]-1
	if isElement(killer) then
		checkForWinner(killer)
		outputSideChat("Player "..getPlayerName(player).." was killed by "..getPlayerName(killer).." - "..gameCache["playerAmount"].." left",root,255,255,255)
	else
		if gameCache["playerAmount"] <= 1 then
			resetGameCache()
			refreshLootSpots()
		end
		triggerClientEvent(player,"mtabg_showEndscreen",player,gameCache["playerAmount"],homeScreenDimension)
		outputSideChat("Player "..getPlayerName(player).." has died - "..gameCache["playerAmount"].." left",root,255,255,255)
	end
	removeAttachedOnDeath(player)
	local losses = getUserData(player,"losses")
	local deaths = getUserData(player,"deaths")
	setUserData(player,"losses",losses+1)
	setUserData(player,"deaths",deaths+1)
	awardPlayerWithStatistics(player)
	playerInfo[player] = {}
	playerDataInfo[player] = {}
	spawnPlayer(player,1724.22998,-1647.8363,20.2283,0,0,18,600)
	
end
addEvent("killBattleGroundsPlayer",true)
addEventHandler("killBattleGroundsPlayer",root,killBattleGroundsPlayer)

function awardPlayerWithStatistics(player)
	if player then
		local coins = 0
		local stat_kills = 0
		local stat_headshots = 0
		for i, data in ipairs(playerDataInfo[player]) do
			if data[2] == "kills" then
				coins = (10*data[3])+10 -- even with 0 kills, player still receives 10 coins
				stat_kills = data[3]
			end
			if data[2] == "headshots" then
				coins = (coins*data[3])+coins
				stat_headshots = data[3]
			end
		end
		local gamesplayed = getUserData(player,"gamesplayed")
		local losses = getUserData(player,"losses")
		local wins = getUserData(player,"wins")
		local winlossratio = (wins/losses)*100
		local deaths = getUserData(player,"deaths")
		local kills = getUserData(player,"kills")
		local killdeathratio = (kills/deaths)*100
		local headshots = getUserData(player,"headshots")
		local battlepoints = getUserData(player,"battlepoints")

		setUserData(player,"gamesplayed",gamesplayed+1)
		setUserData(player,"winlossratio",winlossratio)
		setUserData(player,"kills",kills+stat_kills)
		setUserData(player,"killdeathratio",killdeathratio)
		setUserData(player,"headshots",headshots+stat_headshots)
		setUserData(player,"battlepoints",battlepoints+coins)
		
	end
end

function checkForWinner(killer)
	if gameCache["playerAmount"] <= 1 then
		local wins = getUserData(killer,"wins")
		setUserData(killer,"wins",wins+1)
		setElementFrozen(killer,true)
		triggerClientEvent(killer,"mtabg_showEndscreen",killer,gameCache["playerAmount"],homeScreenDimension)
		resetGameCache()
		awardPlayerWithStatistics(killer)
		refreshLootSpots()
	end
end

-- To check if there is a player remaining (= winner)
--[[
function checkPlayerAmount()
	if gameCache["playerAmount"] <= 1 then 
		for i, players in ipairs(getElementsByType("player")) do
			if not isPedDead(players) then
				setElementFrozen(players,true)
				triggerClientEvent(players,"mtabg_showEndscreen",players,gameCache["playerAmount"])
			end
		end
		gameCache["status"] = false
		gameCache["countdown"] = 120
		gameCache["initialPlayerAmount"] = 0
		triggerClientEvent("mtabg_setPlayerAmountToClient",root,0,gameCache["status"],gameCache["countdown"])
	end
end
]]