--[[

				MTA:BG
			MTA Battlegrounds
	Developed By: L, CiBeR, neves768, 1BOY

]]--

function isGameRunning()
    if gameCache['status'] == true then
        return true
    else
        return false
    end
	return false
end

function setAFKTime(sec)
	if sec and sec > 4 then
		gameplayVariables['afktime'] = sec
		for i, v in ipairs(getElementsByType("player"))do
			outputChatBox("[CONFIG] AFK TIme changed to: "..tostring(sec),v,0,255,0,true)
		end
		exports.battlegrounds:saveLog("[CONFIG] AFK Time changed to: "..tostring(sec).."\n", "game")
		return true
	else
		return false
	end
	return false
end

function setRadiationRate(rate)
	if rate then
		gameplayVariables['radiationrate'] = rate
		for i, v in ipairs(getElementsByType("player"))do
			outputChatBox("[CONFIG] Radiation Rate changed to: "..tostring(rate),v,0,255,0,true)
		end
		exports.battlegrounds:saveLog("[CONFIG] Radiation Rate changed to: "..tostring(rate).."\n", "game")
		return true
	else
		return false
	end
	return false
end

--[[
Exports:
saveLog(string tstring, string logtype) LOGTYPES: "admin", "debug", "updates", "accounts", "game", "chat"
]]
