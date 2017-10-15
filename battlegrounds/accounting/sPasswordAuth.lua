--[[

				MTA:BG
			MTA Battlegrounds
	Developed By: Null System Works

]]--

--Hashing multithreading definitions
local mHash =
{
	sleepTime = 50,
	workCount = 5000,
	currentClient,
	thread,
	timer
}

--Client authentication queue
local authQueue = {
	pass = {},
	hash = {},
	data = {},
	timr = {},
	code = {}
}

local function removePlayerFromQueue(player)
	if isTimer(authQueue.timr[player]) then
		authQueue.timr[player]:destroy()
	end
	authQueue.pass[player] = nil
	authQueue.hash[player] = nil
	authQueue.data[player] = nil
	authQueue.timr[player] = nil
	authQueue.code[player] = nil
end

local function clearHashThread()
	if isTimer(mHash.timer) then
		mHash.timer:destroy()
	end
	mHash.timer = nil
	mHash.thread = nil
	mHash.currentClient = nil --set working for no one
end

-- Get unpredictable values
local function entrophySource()
	return getRealTime().timestamp - getTickCount()
end

-- Warm up math.random
local function initRandom()
	math.randomseed(entrophySource())
	math.random() math.random() math.random()
end

initRandom()

-- NaCl Factory
local function generateSalt()
	return hash("sha1", math.random(entrophySource()))
end

--Make sure the player is who he claims to be
local function isLegitPlayer(theClient, theSource)
	if not theClient then --not triggered by a client
		outputDebugString("Possible rogue login attempt: not called from a client. ")
		outputDebugString("Source:"); iprint(theSource) --target login element
		return false --stop right there
	elseif theClient ~= theSource then --client triggered for something else
		outputDebugString("Possible rogue login attempt: client ~= source")
		outputDebugString("Client:"); iprint(theClient) --client triggering login
		outputDebugString("Source:"); iprint(theSource) --target login element
		return false --stop right there
	end
	return true
end

--End hashing proccess and send results
local function loginCallback(player)
	if authQueue.code[player] == 0 then --authention success
		if LoginMagic(player, authQueue.data[player]) then
			triggerClientEvent(player, "mtabg_registerDone", player)
		else
			triggerClientEvent(player, "MTABG_LoginError", player, "Unknown error. Please contact a server admin (EC: 1)!")
		end
	elseif authQueue.code[player] == 1 then --wrong account or pass
		triggerClientEvent(player, "MTABG_LoginError", player, "Wrong password or account does not exist!")
	elseif authQueue.code[player] == 2 then --no serial
		triggerClientEvent(player, "MTABG_LoginError", player, "Unknown error. Please contact a server admin (EC: No Serial)!")
	end
	removePlayerFromQueue(player)
end

--End hashing proccess and send results
local function registerCallback(player)
	if authQueue.code[player] == -1 then --login in
		local email = authQueue.data[player].email
		local avatar = authQueue.data[player].avatar
		local ip = getPlayerIP(player)
		local serial = getPlayerSerial(player)
		local data = toJSON(dataStore)
		local tempAvatar = false
		if avatar ~= "none" then
			tempAvatar = base64Decode(avatar)
		end
		local query = "INSERT INTO accounts(ID, serial, email, pass, IP, data, avatar) VALUES (null, '"..serial.."', '"..email.."', '"..authQueue.hash[player].."', '"..ip.."', '"..data.."', '"..avatar.."');"
		dbExec(mysql_link, query)
		local registered = checkAccount(serial)
		if registered == 1 then
			authQueue.code[player] = 0 --here we tell login what it wants to hear
			authQueue.data[player] = data --give it delfault values
			loginCallback(player) --call login directly
		else
			triggerClientEvent(player, "MTABG_LoginError", player, "Unknown error. Please contact a server admin (EC: 2)!")
		end
	elseif authQueue.code[player] == -2 then --ID taken
		triggerClientEvent(player, "MTABG_LoginError", player, "ID is taken. Please contact a server admin (EC: 3)!")
	elseif authQueue.code[player] == 2 then --no serial
		triggerClientEvent(player, "MTABG_LoginError", player, "Unknown error. Please contact a server admin (EC: No Serial)!")
	end
	removePlayerFromQueue(player)
end


local hash = hash
local math = math
-- Hash a password + salt multiple times
local function multipleHash(password, salt)
	mHash.thread = coroutine.create( --start hashing thread
	function()
		local saltyPass = salt .. password
		local hashedString = hash("sha256", saltyPass) --hash for the fisrt time
		local iterationCount = 1 --how many iterations
		local totalIterationTime = 0 --total computational time
		local partialIterationTime = 0 --time for single iteration round
		local startTime = getTickCount() --start of the proccess
		local cycleStartTime = getTickCount() --start of the cycle
		for i=1, 250000 do
			hashedString = hash("sha256", hashedString .. saltyPass ) --hash
			iterationCount = iterationCount + 1 --count how many hashes
			if math.mod(iterationCount, mHash.workCount) == 0 then --stop periodically
				partialIterationTime = getTickCount() - cycleStartTime --store time for this iteration round
				totalIterationTime = totalIterationTime + partialIterationTime --add to total
				partialIterationTime = 0 --reset this iteration time
				triggerClientEvent("onLoginLoadingBarSetProgress", mHash.currentClient, (i + 1)*0.0004)
				coroutine.yield() --suspend proccess
				cycleStartTime = getTickCount() --get start time for new cycle
			end
		end
		partialIterationTime = getTickCount() - cycleStartTime --time for last iteration round
		totalIterationTime = totalIterationTime + partialIterationTime --add time for last execution
		local totalDuration = getTickCount() - startTime --computational time + sleep time
		outputDebugString("Hashed " ..iterationCount.. " times in " ..totalIterationTime.. "ms") --output processing time
		outputDebugString(string.format( "Hashing password took: %dms. Thread: %d%%",
		totalDuration, totalIterationTime/(totalDuration)*100))

		if authQueue.code[mHash.currentClient] == -1 then
			authQueue.hash[mHash.currentClient] = salt.. "$" ..hashedString
		elseif authQueue.code[mHash.currentClient] == 0 then--login going well
			if not (salt.. "$" ..hashedString == authQueue.hash[mHash.currentClient]) then --wrong pass
				authQueue.code[mHash.currentClient] = 1 --set code to: wrong password
			end
		-- elseif authQueue.code[mHash.currentClient] == 1 then--it should fail, but give no hint
		end
		if authQueue.code[mHash.currentClient] then --if the proccess wasn't cancelled
			if authQueue.code[mHash.currentClient] < 0 then
				registerCallback(mHash.currentClient)
			else
				loginCallback(mHash.currentClient) --return results
			end
		end
	end)
	mHash.timer = Timer( --start timer that wakes the thread
	function()
		if coroutine.status(mHash.thread) == "suspended" then --work left to do
			coroutine.resume(mHash.thread)
		else --job done
			clearHashThread()
		end
	end, mHash.sleepTime, 0)
end

--Check user credentials
local function authenticateUser(player)
	if mHash.thread then --is hashing in progress
		if not (authQueue.timr[player] or mHash.currentClient == player) then --player is not in queue
			authQueue.timr[player] = Timer(authenticateUser, 1000, 0, player) --queue player
			outputDebugString("Another hash is in progress, login posponed for " ..tostring(player))
		end
	else --if the hash is not running
		if isTimer(authQueue.timr[player]) then --if timer was used
			authQueue.timr[player]:destroy() --stop timer
		end
		authQueue.timr[player] = nil --clear timer reference
		local serial = getPlayerSerial(player)
		authQueue.code[player] = 0 --authentication result, set as 0: no errors
		if serial then
			local passQuery = dbQuery(mysql_link, "SELECT pass FROM accounts WHERE serial='"..serial.."';")
			local dataQuery = dbQuery(mysql_link, "SELECT data FROM accounts WHERE serial='"..serial.."';")
			authQueue.hash[player] = dbPoll(passQuery, -1)[1]["pass"] --passwordHash from database
			authQueue.data[player] = dbPoll(dataQuery, -1)[1]["data"] --store player data
			local salt = split(authQueue.hash[player], "$")[1] --extract salt
			mHash.currentClient = player --store who the server is working for
			multipleHash(authQueue.pass[player], salt) --pass match?
		else
			authQueue.code[player] = 2 --set error to: no serial
			loginCallback(player) --can't hash, callback
		end
	end
end

--Start login proccess
local function loginPlayer(password)
	if isLegitPlayer(client, source) then
		authQueue.pass[client] = password --store client password
		authenticateUser(client) --try to auth client
	end
end
addEvent("mtabg_login", true)
addEventHandler("mtabg_login", root, loginPlayer)

--Remove player from queue on disconnect
local function handlePlayerQuit()
	removePlayerFromQueue(source)
end
addEventHandler("onPlayerQuit", root, handlePlayerQuit)

--Clear thread on resource stop
local function handleResourceStop()
	clearHashThread()
end
addEventHandler("onResourceStop", resourceRoot, handleResourceStop)

--Alpha access:
local function createNewAlphaKeys()
	dbExec(mysql_link, "DROP TABLE IF EXISTS alpha")
	dbExec(mysql_link,"CREATE TABLE IF NOT EXISTS `alpha` (`ID` int(11) NOT NULL AUTO_INCREMENT, `joinKey` text NOT NULL, `serial` text NOT NULL, PRIMARY KEY (`ID`)) ENGINE=InnoDB DEFAULT CHARSET=latin1;")
	for i = 1, 105, 1 do
		local key1, key2, key3, key4, key5, key6, key7, key8, key9, key10, key11, key12, key13, key14, key15, key16 = generateSalt():match("(%w)(%w)(%w)(%w)(%w)(%w)(%w)(%w)(%w)(%w)(%w)(%w)(%w)(%w)(%w)(%w)")
		local halfKey = key1..key2..key3..key4..key5..key6..key7..key8..key9..key10..key11..key12..key13..key14..key15..key16
		dbExec(mysql_link, "INSERT INTO alpha(ID, joinKey, serial) VALUES (null, '"..halfKey.."', 'unclaimed');")
	end
	outputDebugString("Generated new alpha keys")
end
--addCommandHandler("mtabgComputeAlphaKeys", createNewAlphaKeys, true)

local function validateAlphaKey(player, key)
	local playerSerial = getPlayerSerial(player)
	local serialPoll = dbPoll(dbQuery(mysql_link, "SELECT serial FROM alpha WHERE joinKey='"..key.."'"), -1)[1]
	local isValidAlphaKey = false
	if key == "" then --key field blank
		triggerClientEvent(player, "MTABG_LoginError", player, "Please insert an alpha key to register.")
	elseif not serialPoll then --unvalid key
		iprint("Key not in database. Please insert a valid key.") --show error
		triggerClientEvent(player, "MTABG_LoginError", player, "Key not in database. Please insert a valid key.")
	else
		local serialForKey = serialPoll["serial"]
		if serialForKey == "unclaimed" then --unclaimed key
			iprint("Key not registered. Player can register") --allowed to register
			dbExec(mysql_link, "UPDATE alpha SET serial='"..playerSerial.."' WHERE joinKey='"..key.."'") --mark as used
			isValidAlphaKey = true --allow registering
		elseif serialForKey == playerSerial then --this account registered with this key
			iprint("Key already registered, please login.") --do nothing
			triggerClientEvent(player, "MTABG_LoginError", player, "Key already registered, please login.")
		else
			iprint("This key has been used.") --do nothing
			triggerClientEvent(player, "MTABG_LoginError", player, "This key has been used.")
		end
	end
	iprint(serialPoll)
	return isValidAlphaKey
end

-- Prepare a new password to be stored
local function hashNewPassword(player)
	if mHash.thread then --is hashing in progress
		if not (authQueue.timr[player] or mHash.currentClient == player) then --player is not in queue
			authQueue.timr[player] = Timer(hashNewPassword, 1000, 0, player) --queue player
			outputDebugString("Another hash is in progress, register posponed for " ..tostring(player))
		end
	else --if the hash is not running
		if isTimer(authQueue.timr[player]) then --if timer was used
			authQueue.timr[player]:destroy() --stop timer
		end
		authQueue.timr[player] = nil --clear timer reference
		authQueue.code[player] = -1 --authentication result, set as -1: registering

		local alphaKey = authQueue.data[player].alphaKey
		local email = authQueue.data[player].email
		local isValidAlphaKey = validateAlphaKey(player, alphaKey)
		if not isValidAlphaKey or not email then return end --prevent login
		local isAccount = checkAccount(getPlayerSerial(player))
		if isAccount == 0 then
			local newSalt = generateSalt() --new password, new salt. ALWAYS!
			mHash.currentClient = player --store who the server is working for
			multipleHash(authQueue.pass[player], newSalt) --hash new password
		elseif isAccount == 1 then
			authQueue.code[player] = -2
			registerCallback(player) --can't hash, callback
		else
			authQueue.code[player] = 2 --set error to: no serial
			registerCallback(player) --can't hash, callback
		end
	end
end

local function registerPlayer(password, email, avatar,	alphaKey)
	if isLegitPlayer(client, source) then
		avatar = avatar or "none" --set default value for avatar
		local data = {
			alphaKey = alphaKey,
			email = email,
			avatar = avatar
		}
		authQueue.data[client] = data --store client data
		authQueue.pass[client] = password --store client password
		hashNewPassword(client)
	end
end
addEvent("mtabg_register", true)
addEventHandler("mtabg_register", getRootElement(), registerPlayer)


--ACL: command.mtabgComputeAlphaKeys

--[[

--TODO: should have a table that keeps track of access history, with the intent of
preventing login abuse
--TODO: only allow one timer per IP and SERIAL
--TODO: control how often users can try to wrong password

]]
