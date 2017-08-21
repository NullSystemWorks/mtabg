--[[
	
				MTA:BG
			MTA Battlegrounds
	Developed By: L, CiBeR, neves768, 1BOY, expert975

]]--

mysql_link = false
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

function mtabg_mysql_init()
    if gameplayVariables['database'] == 0 then
        outputDebugString("[MTABG] Connecting to DB...")
        mysql_link = dbConnect( "mysql", "dbname="..gameplayVariables['db_name']..";host="..gameplayVariables['db_host']..";port="..gameplayVariables['db_port'], gameplayVariables['db_user'], gameplayVariables['db_pass'], "share=1" )
        if mysql_link then
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
function checkAccount(serial)
    if serial then
        local query = "SELECT id FROM accounts WHERE serial="..serial..";"
        local rQuery = dbQuery(mysql_link, query)
        local rPoll = dbPoll(rQuery, -1)
        if #rPoll > 0 then
            return 1
        else
            return 0
        end
    else
        return 2
    end
end
-- Returns 0 if account was created | 1 if account already existing | 2 if there was an error
function registerAccount(player, email)
    if not player or not email then return end
    local ip = getPlayerIP(player)
    local serial = getPlayerSerial(player)
    local isAccount = checkAccount(serial)
    local data = toJSON(dataStore)
    if isAccount == 0 then
        local query = "INSERT INTO accounts(id,serial,email,data,ip) VALUES(0, "..serial..","..email..","..data..","..ip..";"
        local rQuery = dbQuery(mysql_link, query)
        local rPoll = dbPoll(rQuery, -1)
        if #rPoll > 0 then
            return 0
        else
            return 2
        end
    elseif isAccount == 1 then
        return 1
    else
        return 2
    end
end
