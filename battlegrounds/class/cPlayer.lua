local inMatch = false
local inLobby = false

function Player:disableHudComponents(...)
	for _, component in ipairs(arg) do
		setPlayerHudComponentVisible(component, false)
	end
end

function Player:enableHudComponents(...)
	for _, component in ipairs(arg) do
		setPlayerHudComponentVisible(component, true)
	end
end

function Player:getInMatch()
	return inMatch
end

function Player.setInMatch(_inMatch)
	inMatch = _inMatch
end
addEvent("onSetInMatch", true)
addEventHandler("onSetInMatch", localPlayer, Player.setInMatch)

function Player:getInLobby()
	return inLobby
end

function Player.setInLobby(_inLobby)
	inLobby = _inLobby
end
addEvent("onSetInLobby", true)
addEventHandler("onSetInLobby", localPlayer, Player.setInLobby)

local function delegatePlayerDamage(attacker, weapon, bodypart, loss)
	cancelEvent()
	triggerServerEvent("onDamagePlayer", resourceRoot,
	                   attacker, weapon, bodypart, loss)
end
addEventHandler("onClientPlayerDamage", localPlayer, delegatePlayerDamage)

function treatProjectileCreation(creator)
	if creator == localPlayer
	and source:getType() == 16 then --Only for grenades
		triggerServerEvent("onPlayerWeaponThrow", resourceRoot)
	end
end
addEventHandler("onClientProjectileCreation", root, treatProjectileCreation)
