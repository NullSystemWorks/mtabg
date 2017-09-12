--[[

				MTA:BG
			MTA Battlegrounds
	Developed By: Null System Works (L, CiBeR, neves768, 1BOY & expert975)
	
]]--

local finalDamage = 0
function onBattleGroundsPlayerDamage(attacker,weapon,bodypart,loss)
	if not gameCache["status"] then return end
	local damage,weaponDistance = 0,0
	local headshot = false
	if isElement(attacker) then
		if getElementType(attacker) == "player" then
			if weapon then
				damage,weaponDistance = getWeaponDamage(weapon,attacker)
				local x1,y1,z1 = getElementPosition(client)
				local x2,y2,z2 = getElementPosition(attacker)
				local calculcatedDistance = getDistanceBetweenPoints3D(x1,y1,z1,x2,y2,z2)
				--finalDistance = math.min(calculatedDistance-weaponDistance,100)
				--finalDamage = math.min(math.abs(damage*(finalDistance/100)),damage-(damage*(finalDistance/100)))
				local hasArmor = getPedArmor(client)
				if hasArmor > 0 then
					if damage >= hasArmor then
						setPedArmor(client,0)
					else
						setPedArmor(client,getPedArmor(client)-damage)
					end
					damage = damage-hasArmor
				end
				finalDamage = damage
				if bodypart == 9 then
					headshot = true
					finalDamage = finalDamage*2
				end
			end
		end
	else
		if weapon == 54 then
			finalDamage = loss
		end
	end
	if finalDamage > 100 then
		finalDamage = 100
	end
	triggerClientEvent(client,"mtabg_onClientBattleGroundsSetPlayerHealthGUI",client,"damage",finalDamage)
	onBattleGroundsSetPlayerHealth("health","damage",finalDamage,attacker)
end
addEvent("mtabg_onBattleGroundsPlayerDamage",true)
addEventHandler("mtabg_onBattleGroundsPlayerDamage",root,onBattleGroundsPlayerDamage)

function getWeaponDamage(weapon,attacker)
local weapon_1 = ""
local weapon_2 = ""
	for i, data in ipairs(playerDataInfo[attacker]) do
		if data[2] == "currentweapon_1" then
			weapon_1 = data[3]
		end
		if data[2] == "currentweapon_2" then
			weapon_2 = data[3]
		end
	end
	for i,weap in ipairs(weaponDamageTable) do
		if weap[1] == weapon_1 or weap[1] == weapon_2 then
			return weap[2],weap[3]
		end
	end
end

function destroyDeadPlayer(ped,pedCol)
	destroyElement(ped)
	destroyElement(pedCol)
end

local finalRank = 0
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
	finalRank = gameCache["playerAmount"]
	gameCache["playerAmount"] = gameCache["playerAmount"]-1
	setElementData(player,"participatingInGame",false)
	if isElement(killer) then
		checkForWinner(killer)
		outputSideChat("Player "..getPlayerName(player).." was killed by "..getPlayerName(killer).." - "..gameCache["playerAmount"].." left",root,255,255,255)
		triggerClientEvent(player,"mtabg_showEndscreen",player,finalRank,homeScreenDimension)
	else
		if gameCache["playerAmount"] <= 1 then
			for i, players in ipairs(getElementsByType("player")) do
				if getElementData(players,"participatingInGame") then
					checkForWinner(players)
				end
			end
		end
		triggerClientEvent(player,"mtabg_showEndscreen",player,finalRank,homeScreenDimension)
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
	takeAllWeapons(player)
	
end
addEvent("mtabg_killBattleGroundsPlayer",true)
addEventHandler("mtabg_killBattleGroundsPlayer",root,killBattleGroundsPlayer)

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
		--[[ 
		If a player is rank #1 -> 101-1 = 100
		If coins value was, for example, 20 -> 20*100 -> 2000 Battlepoints earned
		
		If a player is rank #50 -> 101-50 = 51
		If coins value was, for example, 20 -> 20*51 = 1020 Battlepoints earned
		
		If a player is rank #100 -> 101-100 = 1
		If coins value was, for example, 10 -> 10*1 = 10 Battlepoints earned
		
		-> Division by 5 due to sheer amount of battlepoints earned
		]]
		coins = math.floor((coins*(101-finalRank))/5)
		local gamesplayed = getUserData(player,"gamesplayed")
		local losses = getUserData(player,"losses")
		local wins = getUserData(player,"wins")
		local winlossratio = (wins/gamesplayed)*100
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
		homeScreenDimension = homeScreenDimension+1
		triggerClientEvent(killer,"mtabg_showEndscreen",killer,gameCache["playerAmount"],homeScreenDimension)
		resetGameCache()
		awardPlayerWithStatistics(killer)
		refreshLootSpots()
		removeAttachedOnDeath(killer)
		setElementData(killer,"participatingInGame",false)
		takeAllWeapons(killer)
		resetZoneAfterMatch()
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