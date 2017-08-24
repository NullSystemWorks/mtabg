local mysql_link = false
local dbname = "bgs"
local host = "127.0.0.1"
local port = 3306
local dbuser = "root" 
local dbpass = "vertrigo"

dataStore = {
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


function dbInit()
	mysql_link = dbConnect( "mysql", "dbname="..dbname..";host="..host..";port="..port, dbuser, dbpass, "share=1" )
	if mysql_link then
		dbExec(mysql_link,"CREATE TABLE IF NOT EXISTS `accounts` (`ID` int(11) NOT NULL AUTO_INCREMENT, `email` text NOT NULL, `password` text NOT NULL, `serial` text NOT NULL, `IP` text NOT NULL, `data` text NOT NULL, `avatar` longtext NOT NULL, PRIMARY KEY (`ID`)) ENGINE=InnoDB DEFAULT CHARSET=latin1;")
		outputDebugString("[MTABG] Connected to DB: "..dbname)
	else
		outputDebugString("[MTABG] Error connecting to MySQL Database. Stoping Resource...")
		cancelEvent()
	end
end
addEventHandler("onResourceStart", resourceRoot, dbInit)

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

-- Returns 0 serial invalid/non existing | 1 serial valid/existing | 2 for error
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
function register(email, password, avatar)
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
addEventHandler("mtabg_register", getRootElement(), register)

function onJoin(source)
	local accountCheck, avatar = checkAccount(getPlayerSerial(source), "avatar")
	if accountCheck == 1 then
		if avatar ~= "none" then
			triggerClientEvent(source, "openLoginPanel", source, accountCheck, getPlayerSerial(source), base64Decode(avatar))
		else
			triggerClientEvent(source, "openLoginPanel", source, accountCheck, getPlayerSerial(source), false)
		end
	elseif accountCheck == 0 then
		triggerClientEvent(source, "openLoginPanel", source, accountCheck, getPlayerSerial(source), false)
	end
end
addEventHandler("onPlayerJoin", getRootElement(), onJoin)
addCommandHandler("p",onJoin) -- testing only