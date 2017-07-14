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
end