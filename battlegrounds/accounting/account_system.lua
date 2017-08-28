--[[
	
					MTA:BG
				MTA Battlegrounds
	Developed By: L, CiBeR, neves768, 1BOY, expert975
			 © 2017 Null System Works 
]]--

mysql_link = false
dataStore = { -- Default values
    ['kills'] = 0,
    ['deaths'] = 0,
    ['ratio'] = 0,
    ['headshots'] = 0,
    ['wins'] = 0,
    ['defeats'] = 0,
    ['rank'] = 0,
    ['battlepoints'] = 0,
    ['items'] = {},
    ['achievement'] = {},
    ['crates'] = 0
}

function mtabg_mysql_init()
    if gameplayVariables['database'] == 0 then
        outputDebugString("[MTABG] Connecting to DB...")
        mysql_link = dbConnect( "mysql", "dbname="..gameplayVariables['db_name']..";host="..gameplayVariables['db_host']..";port="..gameplayVariables['db_port'], gameplayVariables['db_user'], gameplayVariables['db_pass'], "share=1" )
        if mysql_link then
			dbExec(mysql_link,"CREATE TABLE IF NOT EXISTS `accounts` (`ID` int(11) NOT NULL AUTO_INCREMENT, `email` text NOT NULL, `password` text NOT NULL, `serial` text NOT NULL, `IP` text NOT NULL, `data` text NOT NULL, `avatar` longtext NOT NULL, PRIMARY KEY (`ID`)) ENGINE=InnoDB DEFAULT CHARSET=latin1;")
            outputDebugString("[MTABG] Connected to DB: "..gameplayVariables['db_name'])
        else
            outputDebugString("[MTABG] Error connecting to MySQL Database. Stoping Resource...")
            cancelEvent()
            return
        end
    end

end
addEventHandler("onResourceStart", resourceRoot, mtabg_mysql_init)

-- Returns 0 serial invalid/non existing | 1 serial valid/existing | 2 for error
function checkAccount(serial, column)
	if serial then
		local query = "SELECT * FROM accounts WHERE `serial`='"..serial.."';"
		local rQuery = dbQuery(mysql_link, query)
		local rPoll = dbPoll(rQuery, -1)
		if #rPoll > 0 then
			if column then
				return 1, rPoll[1][column]
			else
				return 1
			end
		else
			return 0
		end
	else
		return 2
	end
end

function login(password)
local serial = getPlayerSerial(source)
if serial then
	local query = "SELECT id, data FROM accounts WHERE serial='"..serial.."' AND password='"..md5(md5(password)).."';"
	local rQuery = dbQuery(mysql_link, query)
	local rPoll = dbPoll(rQuery, -1)
	if #rPoll > 0 then
		-- exists
		if exports["battlegrounds"]:LoginMagic(source, rPoll[1]["data"]) then
			triggerClientEvent(client, "mtabg_registerDone", client)
		else
			triggerClientEvent(client, "MTABG_LoginError", client, "Unknown error")
		end
		outputDebugString("sucesso")
	else
		-- nothing found (maybe wrong password)
		triggerClientEvent(client, "MTABG_LoginError", client, "Unknown error")
	end
else
	-- The player isn't human (Maybe an ET?)
end
end
addEvent("mtabg_login", true)
addEventHandler("mtabg_login", getRootElement(), login)

-- Returns 0 if account was created | 1 if account already existing | 2 if there was an error
function registerAccount(email, password, avatar)
    if not source or not email then return end
	if not avatar then avatar = "none" end
    local ip = getPlayerIP(source)
    local serial = getPlayerSerial(source)
    local isAccount = checkAccount(serial)
    local data = toJSON(dataStore)
	local tempAvatar = false
	if avatar ~= "none" then
		tempAvatar = base64Decode(avatar)
	end
    if isAccount == 0 then
        local query = "INSERT INTO accounts(ID, serial, email, password, IP, data, avatar) VALUES (null, '"..serial.."', '"..email.."', '"..md5(md5(password)).."', '"..ip.."', '"..data.."', '"..avatar.."');"
        dbExec(mysql_link, query)
        local registered = checkAccount(serial)
        if registered == 1 then
            --triggerClientEvent(client, "mtabg_registerDone", client, serial, avatar)
			triggerClientEvent(client, "openLoginPanel", client, 1, serial, tempAvatar)
        else
            -- error
        end
    elseif isAccount == 1 then
        triggerClientEvent(client, "openLoginPanel", client, 1, serial, tempAvatar)
    else
        -- error
    end
end
addEvent("mtabg_register", true)
addEventHandler("mtabg_register", getRootElement(), registerAccount)







--- DATA Management

usersData = {}

function setUserData(user, data, value)
	if user and data and value then
		usersData[user][data] = value
	end
end

function getUserData(user, data)
	if user and data and usersData[user] then
		return usersData[user][data]
	else
		return false
	end
end

-- Example usage: getEUserData("kills", "setScoreKillsEvent")
function getEUserData(data, event) -- "E" functions return value by event
	if not client then client = source end
	triggerClientEvent(client, event, client, usersData[user][data])
end
addEvent("getEUserData", true)
addEventHandler("getEUserData", getRootElement(), getEUserData)


function LoginMagic(player, data)
	-- do something
	usersData[player] = fromJSON(data)
	triggerClientEvent(player, "mtabg_sendToHomeScreen", player)
	return true
end
--addEvent("MTABG_onLogin", true)
--addEventHandler("MTABG_onLogin", getRootElement(), MTABG_onLogin)


function save()
	local account = getPlayerSerial(source)
	if account then
		local toSaveData = {}
		for index, dataName in pairs(dataStore) do
			toSaveData[index] = getUserData(source, index)
		end
		dbExec(mysql_link, "UPDATE accounts SET data='"..toJSON(toSaveData).."' WHERE serial='"..account.."'")
	end
end
addEventHandler("onPlayerQuit", getRootElement(), save)