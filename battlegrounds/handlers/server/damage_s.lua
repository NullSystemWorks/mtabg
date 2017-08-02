
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
			ped = createPed(skin,x,y,z,rotZ)
			pedCol = createColSphere(x,y,z,1.5)
			deadPlayerTable[pedCol] = {}
			killPed(ped)
			setTimer(destroyDeadPlayer,600000,1,ped,pedCol)
			attachElements(pedCol,ped,0,0,0)
			setElementData(pedCol,"parent",ped)
			setElementData(pedCol,"playername",getPlayerName(player))
			setElementData(pedCol,"deadman",true)
		end	
	end
	if killer and killer ~= player then
		for i, data in ipairs(playerInfo[killer]) do
			if data[2] == "Kills" then
				data[3] = data[3]+1
			end
		end
	end
	if pedCol then
		for k,	data in ipairs(playerInfo[player]) do
			table.insert(deadPlayerTable[pedCol],{data[2],data[3]})
		end
	end
	setTimer(setElementPosition,500,1,player,6000,6000,0)
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
	gameCache["initialPlayerAmount"] = gameCache["initialPlayerAmount"]-1
	checkPlayerAmount()
	--outputSideChat("Player "..getPlayerName(player).." was killed",root,255,255,255)
end
addEvent("killBattleGroundsPlayer",true)
addEventHandler("killBattleGroundsPlayer",root,killBattleGroundsPlayer)

function checkPlayerAmount()
end