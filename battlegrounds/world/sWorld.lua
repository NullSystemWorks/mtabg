function preventChatSay(cmd)
	if cmd == "say" or cmd == "teamsay" or cmd == "showchat" or cmd == "me" then
		cancelEvent()
	end
end
addEventHandler("onPlayerCommand",root,preventChatSay)
