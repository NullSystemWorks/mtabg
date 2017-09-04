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
	showChat(client,false)
	local accountCheck, avatar = checkAccount(getPlayerSerial(client), "avatar")
	if accountCheck == 1 then
		if avatar ~= "None" then
			triggerClientEvent(client, "openLoginPanel", client, getPlayerSerial(client),true)
		else
			triggerClientEvent(client, "openLoginPanel", client, getPlayerSerial(client),true)
		end
	elseif accountCheck == 0 then
		triggerClientEvent(client, "openLoginPanel", client, getPlayerSerial(client),false)
	end
	--end,1000,1,source)
end
addEvent("mtabg_onJoin", true)
addEventHandler("mtabg_onJoin", getRootElement(), onJoin)
--addEventHandler("onPlayerJoin", getRootElement(), onJoin)

function preventChatSay(cmd)
	if cmd == "say" or cmd == "teamsay" or cmd == "showchat" or cmd == "me" then
		cancelEvent()
	end
end
addEventHandler("onPlayerCommand",root,preventChatSay)
