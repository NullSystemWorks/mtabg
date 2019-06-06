Database = {}

local database =
{
	["host"] = "127.0.0.1", -- MySQL Host | DEFAULT: 127.0.0.1
	["user"] = "root", -- MySQL User
	["pass"] = "P&7+dGmnPX&FW5)v", -- MySQL Password
	["port"] = 3306, -- MySQL Port | DEFAULT: 3306
	["name"] = "mtabg" -- MySQL Database name | DEFAULT: mtabg
}

local connection

function Database.init()
	connection = Connection("mysql", string.format("dbname=%s;host=%s;port=%d", database.name, database.host, database.port), database.user, database.pass)
	if connection then
		connection:exec([[
		CREATE TABLE IF NOT EXISTS `accounts`
		(
			`ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
			`IP` VARCHAR(15) NOT NULL,
			`serial` CHAR(32) NOT NULL UNIQUE,
			`password` CHAR(105) NOT NULL,
			`language` CHAR(2) NOT NULL DEFAULT "en",
			`gamesPlayed` SMALLINT UNSIGNED DEFAULT 0 NOT NULL,
			`wins` SMALLINT UNSIGNED DEFAULT 0 NOT NULL,
			`losses` SMALLINT UNSIGNED DEFAULT 0 NOT NULL,
			`deaths` SMALLINT UNSIGNED DEFAULT 0 NOT NULL,
			`kills` SMALLINT UNSIGNED DEFAULT 0 NOT NULL,
			`headshots` SMALLINT UNSIGNED DEFAULT 0 NOT NULL,
			`coins` MEDIUMINT UNSIGNED DEFAULT 0 NOT NULL,
			`coinsSpent` MEDIUMINT UNSIGNED DEFAULT 0 NOT NULL,
			PRIMARY KEY (`ID`)
		)
		ENGINE=InnoDB DEFAULT CHARSET=latin1;]])
	else
		outputDebugString("Error connecting to MySQL Database. Stoping Resource...", 1)
		cancelEvent()
	end
end
addEventHandler("onResourceStart", resourceRoot, Database.init)

function Database.getAccount(serial)
	local query = connection:query([[
	SELECT
	`password`,
	`language`,
	`gamesPlayed`,
	`wins`,
	`losses`,
	`deaths`,
	`kills`,
	`headshots`,
	`coins`,
	`coinsSpent`
	FROM accounts WHERE `serial`=?;]], serial)
	return query:poll(-1)[1] or false
end

function Database.saveAccount(ip, serial, data)
	connection:exec([[
	UPDATE accounts SET
		`IP`=?,
		`language`=?,
		`gamesPlayed`=?,
		`wins`=?,
		`losses`=?,
		`deaths`=?,
		`kills`=?,
		`headshots`=?,
		`coins`=?,
		`coinsSpent`=?
	WHERE `serial`=?;]],
		ip,
		data.language,
		data.gamesPlayed,
		data.wins,
		data.losses,
		data.deaths,
		data.kills,
		data.headshots,
		data.coins,
		data.coinsSpent,
		serial
	)
end

function Database.createAccount(ip, serial, password)
	connection:exec([[
	INSERT INTO accounts SET
		`IP`=?,
		`serial`=?,
		`password`=?;]],
		ip,
		serial,
		password
	)
end
