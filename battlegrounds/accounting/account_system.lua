--[[
	
				MTA:BG
			MTA Battlegrounds
	Developed By: L, CiBeR, neves768, 1BOY, expert975

]]--

mysql_link = false

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