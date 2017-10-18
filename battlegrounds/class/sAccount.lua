ClassStash.save("Account")

Account = {}
local account_mt = {__index = Account}

function Account.new(remote)
	local serial = remote:getRemote():getSerial()
	local newInst =
	{
		ip = remote:getRemote():getIP(),
		serial = serial,
		data = Database.getAccount(serial),
		isInHashQueue = false,
	}
	setmetatable(newInst, account_mt)
	return newInst
end

function Account:destroy()
	--nothing needs to be done; keep no references and gc will take care of it
end

function Account:getRegistered()
	return self.data and true or false
end

function Account:register(password)
	Database.createAccount(self.ip, self:getSerial(), password)
	self.data = Database.getAccount(serial)
end

function Account:setInHashQueue(_inHashQueue)
	self.isInHashQueue = _inHashQueue
end

function Account:getInHashQueue()
	return self.isInHashQueue
end

function Account:save()
	if self:getRegistered() then
		Database.saveAccount(self.ip, self:getSerial(), self.data)
	end
end

function Account:getSerial()
	return self.serial
end

function Account:getPassword()
	return self.data.password
end

function Account:getLanguage()
	return self.data.language
end

function Account:setLanguage(_language)
	self.data.language = _language
end

function Account:increaseLosses()
	self.data.losses = self.data.losses + 1
end

function Account:increaseWins()
	self.data.wins = self.data.wins + 1
end

function Account:increaseDeaths()
	self.data.deaths = self.data.deaths + 1
end

function Account:increaseGamesplayed()
	self.data.gamesPlayed = self.data.gamesPlayed + 1
end

function Account:addHeadshots(_headshots)
	self.data.headshots = self.data.headshots + _headshots
end

function Account:addKills(_kills)
	self.data.kills = self.data.kills + _kills
end

function Account:addCoins(_coins)
	self.data.coins = self.data.coins + _coins
end
