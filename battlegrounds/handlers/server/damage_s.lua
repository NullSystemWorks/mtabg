
function destroyDeadPlayer(ped,pedCol)
	destroyElement(ped)
	destroyElement(pedCol)
end

function killBattleGroundsPlayer(killer,headshot)
	local x,y,z = getElementPosition(source)
	local deadPlayerTable = {}
	pedCol = false
	killPed(source)
	if not isElementInWater(source) then
		if getDistanceBetweenPoints3D (x,y,z,6000,6000,0) > 200 then
			local x,y,z = getElementPosition(source)
			local rotX,rotY,rotZ = getElementRotation(source)
			local skin = getElementModel(source)
			ped = createPed(skin,x,y,z,rotZ)
			pedCol = createColSphere(x,y,z,1.5)
			deadPlayerTable[pedCol] = {}
			killPed(ped)
			setTimer(destroyDeadPlayer,600000,1,ped,pedCol)
			attachElements(pedCol,ped,0,0,0)
			setElementData(pedCol,"parent",ped)
			setElementData(pedCol,"playername",getPlayerName(source))
			setElementData(pedCol,"deadman",true)
		end	
	end
	if killer then
		for i, data in ipairs(playerInfo[killer]) do
			if data[2] == "Kills" then
				data[3] = data[3]+1
			end
		end
	end
	if pedCol then
		for k,	data in ipairs(playerInfo[source]) do
			table.insert(deadPlayerTable[pedCol],{data[2],data[3]})
		end
	end
	setTimer(setElementPosition,500,1,source,6000,6000,0)
	if gameplayVariables['multipleMatch'] then
		local ID = playerInfo[player]["matchID"]
		playingPlayers[source] = false
		if games[ID]["config"]["gameType"] == "Solo" then
			playerInfo[player]["matchID"] = false
			-- removePlayerFromMatch()
		end
		games[ID]["deathplayers"][source] = true
		-- OR: table.insert(games[ID]["deathplayers"],source)
		checkMatch(ID)
	else
		--
	end
	--outputSideChat("Player "..getPlayerName(source).." was killed",root,255,255,255)
end
addEvent("killBattleGroundsPlayer",true)
addEventHandler("killBattleGroundsPlayer",root,killBattleGroundsPlayer)