--[[

					MTA:BG
				MTA Battlegrounds
	Developed By: L, CiBeR, neves768, 1BOY, expert975
			 © 2017 Null System Works
]]--

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

-- Extract NaCl
local function generateSalt()
	return hash("sha1", math.random(entrophySource()))
end

local hash = hash
-- Hash a password + salt multiple times
local function multipleHash(password, salt)
	local saltyPass = salt .. password
	local hashedString = hash("sha256", saltyPass) --hash for the fisrt time
	t = getTickCount()
	for i=1, 25000 do
		hashedString = hash("sha256", hashedString .. saltyPass )
	end
	outputDebugString("Hashing pasword took: " ..getTickCount() - t.. "ms")
	return salt.. "$" ..hashedString
end

-- Compare a password and a password hash
function checkPasswordHash(passwordHash, password)
	local salt = split(passwordHash, "$")[1] --extract salt
	return multipleHash(password, salt) == passwordHash --pass match?
end

-- Prepare a new passowrd to be stored
function hashNewPassword(password)
	local newSalt = generateSalt() --new passowrd, new salt. ALWAYS!
	return multipleHash(password, newSalt)
end

--Alpha access:
function createNewAlphaKeys()
	dbExec(mysql_link, "DROP TABLE IF EXISTS alpha")
	dbExec(mysql_link,"CREATE TABLE IF NOT EXISTS `alpha` (`ID` int(11) NOT NULL AUTO_INCREMENT, `joinKey` text NOT NULL, `serial` text NOT NULL, PRIMARY KEY (`ID`)) ENGINE=InnoDB DEFAULT CHARSET=latin1;")
	for i = 1, 105, 1 do
		local key1, key2, key3, key4, key5, key6, key7, key8, key9, key10, key11, key12, key13, key14, key15, key16 = generateSalt():match("(%w)(%w)(%w)(%w)(%w)(%w)(%w)(%w)(%w)(%w)(%w)(%w)(%w)(%w)(%w)(%w)")
		local halfKey = key1..key2..key3..key4..key5..key6..key7..key8..key9..key10..key11..key12..key13..key14..key15..key16
		dbExec(mysql_link, "INSERT INTO alpha(ID, joinKey, serial) VALUES (null, '"..halfKey.."', 'unclaimed');")
	end
	outputDebugString("Generated new alpha keys")
end
addCommandHandler("mtabgComputeAlphaKeys", createNewAlphaKeys, true)

function validateAlphaKey(player, key)
	local playerSerial = getPlayerSerial(player)
	local serialPoll = dbPoll(dbQuery(mysql_link, "SELECT serial FROM alpha WHERE joinKey='"..key.."'"), -1)[1]
	local isValidAlphaKey = false
	if not serialPoll then --unvalid key
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

--ACL: command.mtabgComputeAlphaKeys
