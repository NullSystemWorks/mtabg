
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
	setElementHealth(localPlayer,getElementHealth(localPlayer)-finalDamage)
	if getElementHealth(localPlayer) <= 0 then
		--triggerServerEvent("killBattleGroundsPlayer",localPlayer,attacker,headshot)
	end
end
addEventHandler("onClientPlayerDamage",localPlayer,onBattleGroundsPlayerDamage)