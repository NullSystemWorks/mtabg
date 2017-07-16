--[[
	
				MTA:BG
			MTA Battlegrounds
	Developed By: L, CiBeR, neves768, 1BOY

]]--

guiPlayerHealth = 100
function onBattleGroundsPlayerDamage(attacker,weapon,bodypart,loss)
	cancelEvent()
	local damage,weaponDistance = 0,0
	local headshot = false
	if isElement(attacker) then
		if getElementType(attacker) == "player" then
			if weapon then
				damage,weaponDistance = getWeaponDamage(weapon,attacker)
				local x1,y1,z1 = getElementPosition(localPlayer)
				local x2,y2,z2 = getElementPosition(attacker)
				local calculcatedDistance = getDistanceBetweenPoints3D(x1,y1,z1,x2,y2,z2)
				finalDistance = math.min(calculatedDistance-weaponDistance,100)
				finalDamage = math.min(math.abs(damage*(finalDistance/100)),damage-(damage*(finalDistance/100)))
				if bodypart == 9 then
					headshot = true
					finalDamage = finalDamage*2
				end
			end
		end
	end
	if weapon == 54 then
		finalDamage = loss
	end
	if finalDamage > 100 then
		finalDamage = 100
	end
	triggerServerEvent("mtabg_sendClientPlayerInfoToServer",localPlayer,"health","damage",finalDamage,attacker)
	setHealthToClient(guiPlayerHealth-finalDamage)
end
addEventHandler("onClientPlayerDamage",localPlayer,onBattleGroundsPlayerDamage)