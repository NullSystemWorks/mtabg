--[[

				MTA:BG
			MTA Battlegrounds
	Developed By: Null System Works (L, CiBeR, neves768, 1BOY & expert975)
	
]]--


function onBattleGroundsPlayerDamage(attacker,weapon,bodypart,loss)
	cancelEvent()
	triggerServerEvent("mtabg_onBattleGroundsPlayerDamage",localPlayer,attacker,weapon,bodypart,loss)
end
addEventHandler("onClientPlayerDamage",root,onBattleGroundsPlayerDamage)