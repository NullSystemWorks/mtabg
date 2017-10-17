--[[

				MTA:BG
			MTA Battlegrounds
	Developed By: Null System Works

]]--


function onBattleGroundsPlayerDamage(attacker,weapon,bodypart,loss)
	cancelEvent()
	triggerServerEvent("mtabg_onBattleGroundsPlayerDamage",localPlayer,attacker,weapon,bodypart,loss)
end
addEventHandler("onClientPlayerDamage",root,onBattleGroundsPlayerDamage)
