--[[

				MTA:BG
			MTA Battlegrounds
	Developed By: Null System Works

]]--

local logTypes = { "admin", "debug", "updates", "accounts", "game", "chat" }

function isCorrectLogType(logtype)
	local _isCorrectLogType = false
	for _, v in ipairs( logTypes ) do
		if v == logtype then
			_isCorrectLogType = true
			break
		end
	end

	if _isCorrectLogType ~= true then
		outputDebugString( "[MTA:BG Logs] Error in 'saveLog' function. Wrong log type '".. logtype .."'!"  )
		return false
	end
end

function fileLog(logtype,tstring)
	local file = fileOpen("log/".. logtype .. ".log")
	local size = fileGetSize( file )
	if tstring then
		local set = fileSetPos( file, size )
		local writ = fileWrite( file, tstring )
		fileClose( file )
		return true
	else
		return fileRead( file, size ),fileClose( file )
	end
end


function saveLog( tstring, logtype )
	if isCorrectLogType(logtype) ~= false then
		return fileLog(logtype,tstring)
	else
		return false
	end
end


addEventHandler("onResourceStart", resourceRoot,
	function()
		for _, typeLog in ipairs( logTypes )do
			local logFile = "log/" .. typeLog .. ".log"
			if not fileExists( logFile ) then
				outputDebugString( "[MTA:BG Logs] File: " .. logFile .. " not found. " )
				local newFile = fileCreate( logFile )
				if not newFile then
					outputDebugString( "[MTA:BG Logs] File: cannot create file " .. logFile .. "." )
				else
					outputDebugString( "[MTA:BG Logs] File: " .. logFile .. " has been created." )
				end
				fileClose( newFile )
			end
		end
	end
)
