function checkAccount(serial, column)
	return exports["battlegrounds"]:checkAccount(serial, column)
end

--[[
function pacoca(img, er, player)
	if er == 0 then
		triggerClientEvent(player, "mtabg_logSetAvatarimg", player, img)
	end
end


function downloadAvatar(link)
	fetchRemote(link, pacoca, "", false, client)
end
addEvent("mtabg_logdownloadAvatarimg", true)
addEventHandler("mtabg_logdownloadAvatarimg", getRootElement(), downloadAvatar)
]]

function onJoin()
	--setTimer(function(source)
	local accountCheck, avatar = checkAccount(getPlayerSerial(client), "avatar")
	if accountCheck == 1 then
		if avatar ~= "none" then
			triggerClientEvent(client, "openLoginPanel", client, getPlayerSerial(client))
		else
			triggerClientEvent(client, "openLoginPanel", client, getPlayerSerial(client))
		end
	elseif accountCheck == 0 then
		triggerClientEvent(client, "openLoginPanel", client, getPlayerSerial(client))
	end
	--end,1000,1,source)
end
addEvent("mtabg_onJoin", true)
addEventHandler("mtabg_onJoin", getRootElement(), onJoin)
--addEventHandler("onPlayerJoin", getRootElement(), onJoin)