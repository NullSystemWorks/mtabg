ClassStash.save("Player")
local MtaPlayer = ClassStash.get("Player")

Player = {}
setmetatable(Player, {__index = Element}) --Player inherits from Element
local player_mt = {__index = Player}

local instances = {}
local count = 0

Player.MAX_HEALTH = 100
Player.MAX_ARMOR = 100
Player.DEFAULT_SKIN = 0
Player.DEFAULT_INVENTORY_SIZE = 70*100

function Player.new()
	local remote = Remote.new(client)
	local newInst =
	{
		type = "player",
		name = client.name,
		remote = remote,
		account = Account.new(remote),
		inventory = Inventory.new(remote),
		backpack = false,
		match = false,
		lobby = false,
		health = Player.MAX_HEALTH,
		skin = Player.DEFAULT_SKIN,
		currentWeapon,
		weapon = {},
		ammoSlot = {},
		armor = 0,
		kills = 0,
		headshots = 0,
	}
	setmetatable(newInst, player_mt)
	instances[newInst] = true
	count = count + 1
	newInst.remote:setSuper(newInst)
	newInst:askCredentials()
	newInst.inventory:setCapacity(Player.DEFAULT_INVENTORY_SIZE)
	newInst:giveInitialItems()
	return newInst
end
addEvent("onJoin", true)
addEventHandler("onJoin", resourceRoot, Player.new)

function Player:destroy(isResourceStopping)
	if self.account:getInHashQueue() then
		Hash.removePlayerFromQueue(self)
	end
	if not isResourceStopping then
		iprint(self.name.. " left the game")
		if self:getInLobby() then
			self.lobby:removePlayer(self)
		end
		if self:getInMatch() then
			local match = self:getMatch()
			match:removePlayer(self)
			match:endIfWinner()
			match:sendAliveCount()
		end
	end
	self.account:save()
	self.account:destroy()
	self.inventory:destroy()
	self.remote:destroy()
	instances[self] = nil
	count = count - 1
end

function Player.getAll()
	return instances
end

function Player.isPlayer(element)
	return element and element.type == "player"
end

function Player.getNameOrNil(player)
	return (player and player.name) and player.name or false
end

function Player:getInLobby()
	return self:getLobby() and true or false
end

function Player:getLobby()
	return self.lobby
end

function Player:setLobby(_lobby)
	self.lobby = _lobby
	self:showChat(self:getInLobby())
	self.remote:send("onSetInLobby", self:getInLobby())
end

local function handleSendPlayerToLobby()
	local player = Remote.getSuperFromRemote(client)
	lobby:addPlayer(player)
end
addEvent("onSendPlayerToLobby", true)
addEventHandler("onSendPlayerToLobby", root, handleSendPlayerToLobby)

function Player:getInMatch()
	return self:getMatch() and true or false
end

function Player:getMatch()
	return self.match
end

function Player:setMatch(_match)
	self.match = _match
	self.remote:send("onSetInMatch", self:getInMatch())
end

function Player:clearMatchData()
	self:removeBackpack()
	self.inventory:setEmpty()
	self:giveInitialItems()
	self:getMatch():getZone():sendNoZoneToPlayer(self)
	self:setMatch(false)
	self:takeAllWeapons()
	self.health = Player.MAX_HEALTH
	self.skin = Player.DEFAULT_SKIN
	self.currentWeapon = nil
	self.weapon = {}
	self.ammoSlot = {}
	self.armor = 0
	self.kills = 0
	self.headshots = 0
end

function Player:giveInitialItems()
	self.inventory:giveItem("Bandage")
end

function Player:askCredentials()
	self:showChat(false)
	if self.account:getRegistered() then
		self:openLoginPanel(true)
	else
		self:openLoginPanel(false)
	end
end

function Player:spawn(x, y, z)
	self.remote:getRemote():spawn(x, y, z)
end

function Player:showChat(_showChat)
	showChat(self.remote:getRemote(), _showChat)
end

function Player:openLoginPanel(_isRegistered)
	self.remote:send("onOpenLoginPanel", self.account:getSerial(), _isRegistered)
end

function Player:authenticate(password)
	if password == self.account:getPassword() then
		iprint("Player " ..self.name.. " entered the right password")
		self.remote:send("onSendLoginStatus", "success")
	else
		iprint("Player " ..self.name.. " entered the wrong password")
		self.remote:send("onSendLoginStatus", "wrongPass")
	end
end

function Player:login(plainPassword)
	if self.account:getRegistered() then
		local salt = Hash.getSalt(self.account:getPassword())
		Hash.getHash(plainPassword, salt, Player.authenticate, self)
	else
		iprint("Warning: Player " ..self.name.. " tried to login without an account!")
	end
end

local function handlePlayerLogin(plainPassword)
	if Remote.isLegitPlayer(client, source) then
		local player = Remote.getSuperFromRemote(client)
		player:login(plainPassword)
	end
end
addEvent("onLogin", true)
addEventHandler("onLogin", root, handlePlayerLogin)

function Player:createAccount(password)
	self.account:register(password)
	self.remote:send("onSendLoginStatus", "success")
end

function Player:register(plainPassword)
	if not self.account:getRegistered() then
		if string.len(plainPassword) > 0 then
			local salt = Hash.generateSalt()
			Hash.getHash(plainPassword, salt, Player.createAccount, self)
		else
			self.remote:send("onSendLoginStatus", "noPassword")
		end
	else
		iprint("Warning: Player " ..self.name.. " tried to register twice!")
	end
end

local function handlePlayerRegister(plainPassword)
	if Remote.isLegitPlayer(client, source) then
		local player = Remote.getSuperFromRemote(client)
		player:register(plainPassword)
	end
end
addEvent("onRegister", true)
addEventHandler("onRegister", root, handlePlayerRegister)

function Player:getSkin()
	return self.skin
end

function Player:getWearingArmor()
	return self.armor > 0
end

function Player:getArmor()
	return self.armor
end

function Player:setArmor(_armor)
	if self.armor ~= _armor then
		self.armor = math.constrain(_armor, 0, Player.MAX_ARMOR)
		--TODO: sync armor
	end
end

function Player:giveArmor(_armor)
	self:setArmor(self:getArmor() + _armor)
end

function Player:takeArmor(_armor)
	self:setArmor(self:getArmor() - _armor)
end

function Player:getAlive() --NOTE: unused
	return self:getHealth() > 0 and self:getInMatch()
end

function Player:getHealth()
	return self.health
end

function Player:setHealth(_health, responsible, isHeashot)
	_health = math.constrain(_health, 0, Player.MAX_HEALTH)
	self.health = _health
	self.remote:send("onSendPlayerHealth", _health)
	if _health == 0 then
		self:kill(responsible, isHeashot)
	end
end

function Player:heal(_heal, responsible)
	if _heal > 0 then
		iprint("Heal " ..self.name.. " for " .._heal)
		self:setHealth(self:getHealth() + _heal, responsible)
	end
end

function Player:harm(_harm, responsible, isHeashot)
	if _harm > 0 then
		iprint("Harm " ..self.name.. " for " .._harm)
		self:setHealth(self:getHealth() - _harm, responsible, isHeashot)
	end
end

function Player:isFullHealth()
	return self:getHealth() == Player.MAX_HEALTH
end

function Player:showFullHealthMessage()
	self.remote:send("onShowInventoryMessage", "fullHealth")
end

function Player:showUseMessage(itemName)
	self.remote:send("onShowInventoryMessage", "use", itemName)
end

function Player:giveParachute()
	giveWeapon(self.remote:getRemote(), 46, 1, true)
end

function Player:takeParachute()
	takeWeapon(self.remote:getRemote(), 46)
end

function Player:getBackpack()
	return self.backpack
end

function Player:setBackpack(itemName)
	self:removeBackpack()
	if isItemBackpack(itemName) then
		self.backpack = Backpack.new(itemName, self)
		self.inventory:setCapacity(getBackpackSlotCount(itemName))
	end
end

function Player:removeBackpack()
	local backpack = self:getBackpack()
	if backpack then
		backpack:destroy()
		self.inventory:setCapacity(Player.DEFAULT_INVENTORY_SIZE)
		self.backpack = false
	end
end

function Player:transferBackpackTo(ped)
	if self:getBackpack() then
		self:getBackpack():transferTo(ped)
	end
end

function Player:setWeaponAmmo(itemName, ammoCount, ammoInClip)
	iprint("Setting ammo for weapon " ..itemName.. " as " ..ammoCount)
	setWeaponAmmo(self.remote:getRemote(), getWeaponID(itemName), ammoCount, ammoInClip)
end

function Player:updateAmmo(itemName)
	iprint("Ammo " ..itemName.. " in use: " ..tostring(self:isAmmoInUse(itemName)))
	if self:isAmmoInUse(itemName) then
		local ammoSlot = self:getAmmoSlot(itemName)
		local ammoCount = self.inventory:getItemCount(itemName)
		self:setWeaponAmmo(self:getWeapon(ammoSlot), ammoCount)
		if not self.inventory:doesHaveItem(itemName) then
			self:takeWeapon(self:getWeapon(ammoSlot))
		end
	end
end

function Player:isAmmoInUse(itemName)
	if self:getAmmoSlot(itemName) then
		return true
	else
		return false
	end
end

function Player:getAmmoSlot(itemName)
	return self.ammoSlot[itemName]
end

function Player:setAmmoSlot(itemName, slot)
	iprint(itemName .." is now on slot " ..tostring(slot))
	self.ammoSlot[itemName] = slot
end

function Player:getWeapons()
	return self.weapon
end

function Player:getWeapon(slot)
	return self.weapon[slot]
end

function Player:setWeapon(itemName, slot)
	self.weapon[slot] = itemName
end

function Player:isWeaponEquipped(itemName)
	local weaponSlot = getWeaponSlot(itemName)
	if self:getWeapon(weaponSlot) == itemName then
		return true
	else
		return false
	end
end

function Player:giveWeapon(itemName)
	iprint("Equipping " ..itemName.. " weapon")
	local weaponSlot = getWeaponSlot(itemName)
	local ammoType = getWeaponAmmoType(itemName)
	local ammoCount = self.inventory:getItemCount(ammoType)
	self:setWeapon(itemName, weaponSlot)
	self:setAmmoSlot(ammoType, weaponSlot)
	self.remote:send("onEquipWeapon", itemName)
	self.remote:getRemote():giveWeapon(getWeaponID(itemName), ammoCount, true)
end

function Player:takeWeapon(itemName)
	iprint("Unequipping " ..itemName.. " weapon")
	local weaponSlot = getWeaponSlot(itemName)
	local ammoType = getWeaponAmmoType(itemName)
	self:setAmmoSlot(ammoType, nil)
	self:setWeapon(nil, weaponSlot)
	self.remote:send("onUnequipWeapon", itemName)
	self:setWeaponAmmo(itemName, 0)
end

function Player:takeAllWeapons()
	for _, itemName in pairs(self:getWeapons()) do
		self:takeWeapon(itemName)
	end
	self:takeParachute()
end

function Player:equipWeapon(itemName)
	if self.inventory:doesHaveItem(getWeaponAmmoType(itemName)) then
		if not self:isWeaponEquipped(itemName) then
			local weaponSlot = getWeaponSlot(itemName)
			if self:getWeapon(weaponSlot) then
				self:takeWeapon(self:getWeapon(weaponSlot))
			end
			self:giveWeapon(itemName)
		end
	else
		self.remote:send("onShowInventoryMessage", "noAmmo")
	end
end

function Player:getWeaponDamage(slot)
	local weapon = self:getWeapon(slot)
	if weapon then
		return getWeaponDamage(weapon)
	end
end

function Player:getHeadshots()
	return self.headshots
end

function Player:getCurrentWeapon()
	return self.currentWeapon
end

function Player:setCurrentWeapon(itemName)
	iprint(self.name.. "'s current weapon is " ..tostring(itemName))
	self.currentWeapon = itemName
end

function Player:handleWeaponFire()
	local currentWeapon = self:getCurrentWeapon()
	local ammoType = getWeaponAmmoType(currentWeapon)
	if currentWeapon then
		self.inventory:takeItem(ammoType)
		if not self.inventory:doesHaveItem(ammoType) then
			self:takeWeapon(currentWeapon)
		end
	end
end

local function handlePlayerWeaponFire()
	local player = Remote.getSuperFromRemote(source)
	player:handleWeaponFire()
end
addEventHandler("onPlayerWeaponFire", root, handlePlayerWeaponFire)

function Player:setHeadshots(_headshots)
	self.headshots = _headshots
end

function Player:getKills()
	return self.kills
end

function Player:setKills(_kills)
	self.kills = _kills
end

function Player:increaseKills()
	self:setKills(self:getKills() + 1)
end

function Player:setWeather(weather)
	self.remote:send("onSetClientWeather", weather)
end

function Player:getFinalDamageAndDeduceArmor(damage)
	if self:getWearingArmor() then
		local armor = self:getArmor()
		if damage >= armor then
			self:setArmor(0)
			damage = damage - armor
		else
			self:takeArmor(damage)
			damage = 0
		end
	end
	return damage
end

function Player:handleDamage(attacker, weapon, bodypart, loss)
	iprint(tostring(Player.getNameOrNil(attacker)).. " attacked " ..self.name)
	if self:getInMatch() then
		local damage = 0
		local headshot = false
		if weapon == Damage.FALL then
			damage = loss
		elseif Player.isPlayer(attacker) and attacker:getCurrentWeapon()
		and getWeaponID(attacker:getCurrentWeapon()) == weapon then
			damage = getWeaponDamage(attacker:getCurrentWeapon())
			if bodypart == Body.HEAD then
				headshot = true
				damage = damage*2
			end
			damage = self:getFinalDamageAndDeduceArmor(damage)
			iprint(tostring(attacker.name).. " shot " ..tostring(self.name).. " using " ..tostring(attacker:getCurrentWeapon()).. ". Damage: " ..tostring(damage).. ". Headshot: " ..tostring(headshot))
		end
		self:harm(damage, attacker, headshot)
	end
end

local function handlePlayerDamage(attacker, weapon, bodypart, loss)
	local player = Remote.getSuperFromRemote(client)
	local attacker = Remote.getSuperFromRemote(attacker)
	Player.handleDamage(player, attacker, weapon, bodypart, loss)
end
addEvent("onDamagePlayer", true) --onPlayerDamage is taken by MTA
addEventHandler("onDamagePlayer", resourceRoot, handlePlayerDamage)

function Player:getMatchReward()
	return self:getKills()*10 + self:getHeadshots()*5 + 10
end

function Player:kill(killer, headshot)
	iprint(self.name.. " died. Killed by: " ..tostring(killer and killer.name or killer).. ". Headshot: " ..tostring(headshot))
	if Player.isPlayer(killer) and self ~= killer then
		killer:increaseKills()
	end
	self:accountLoss()
	self:showEndScreen()
	self:createDeadBody()
	self:moveToNowhere()

	local match = self.match
	match:removePlayer(self)
	match:sendAliveCount()
	match:endIfWinner()
	match:pushDeathNotification(self.name, Player.getNameOrNil(killer))
end

function Player:moveToNowhere()
	self:setPosition(6000, 6000, 0) --inheritance works! :D
end

function Player:moveCameraAround() --NOTE: unused --FIXME: camera moves should be done clientside
	local x, y, z = getElementPosition(self)
	setCameraMatrix(self, x, y, z + 10, x, y, z)
	fadeCamera(self, false, 5)
	Timer(
	function(self)
		if isElement(self) then
			fadeCamera(self, true)
		end
	end, 6000, 1, self)
end

function Player:accountLoss()
	self.account:increaseLosses()
	self.account:increaseDeaths()
	self:accountMatch()
end

function Player:accountWin()
	self.account:increaseWins()
	self:accountMatch()
end

function Player:accountMatch()
	self.account:increaseGamesplayed()
	self.account:addHeadshots(self:getHeadshots())
	self.account:addKills(self:getKills())
	self.account:addCoins(self:getMatchReward())
end

function Player:showEndScreen()
	iprint("Showing endscreen for " ..self.name.. ". Rank: " ..self.match:getPlayerCount())
	self.remote:send("onShowEndScreen", self.match:getPlayerCount())
end

local function handlerWeaponChange(_, currentWeaponID)
	local player = Remote.getSuperFromRemote(source)
	if player then --player happens to be nil when resource stops
		for _, itemName in pairs(player:getWeapons()) do
			if getWeaponID(itemName) == currentWeaponID then
				return player:setCurrentWeapon(itemName)
			end
		end
		player:setCurrentWeapon(nil)
	end
end
addEventHandler("onPlayerWeaponSwitch", root, handlerWeaponChange)

function Player:useItem(itemName)
	iprint(self.name.." used " ..tostring(itemName))
	if self.inventory:doesHaveItem(itemName) and canItemBeUsed(itemName) then
		if isItemWeapon(itemName) then
			self:equipWeapon(itemName)
		elseif isItemMedicine(itemName) then
			if self:isFullHealth() then
				self:showFullHealthMessage()
			else
				self:heal(getMedicineHealValue(itemName))
				self:showUseMessage(itemName)
				self.inventory:takeItem(itemName)
				self:sendInventoryItems()
			end
		elseif isItemBackpack(itemName) then
			self:setBackpack(itemName)
			self:showUseMessage(itemName)
			self.inventory:takeItem(itemName)
			self:sendInventoryItems()
		elseif isItemArmor(itemName) then
			self:giveArmor(getArmorAbsorption(itemName))
			self:showUseMessage(itemName)
			self.inventory:takeItem(itemName)
			self:sendInventoryItems()
			--TODO: send armor picture to client
		end
	else
		iprint("Warning: " ..self.name.. " failed to use" ..tostring(itemName)
		..": HasItem: " ..tostring(self.inventory:doesHaveItem(itemName)
		.." CanBeUsed: " ..tostring(canItemBeUsed(itemName))))
	end
end

local function handleItemUse(itemName)
	local player = Remote.getSuperFromRemote(client)
	player:useItem(itemName)
end
addEvent("onPlayerUseItem", true)
addEventHandler("onPlayerUseItem", root, handleItemUse)

function Player:sendInventoryItems()
	local self = Remote.getSuperFromRemote(client)
	self.remote:send("onClearInventory")
	for itemName in pairs(self.inventory:getItemList()) do
		self.remote:send("onPopulateInventory", itemName, self.inventory:getItemCount(itemName))
		if self.inventory:getItemCount(itemName) < 0 then
			outputDebugString("Item with negative amount in " ..tostring(self.remote:getRemote()).. "'s inventory: " ..itemName, 2)
		end
	end
end
addEvent("onRefreshInventory", true)
addEventHandler("onRefreshInventory", root, Player.sendInventoryItems)

local function sendLootItems(loot)
	local player = Remote.getSuperFromRemote(client)
	local loot = Remote.getSuperFromRemote(loot)
	if loot then
		player.remote:send("onClearInventoryLoot")
		for itemName in pairs(loot.inventory:getItemList()) do
			player.remote:send("onPopulateLoot", itemName, loot.inventory:getItemCount(itemName))
			 --FIXME: destroy worldModels for taken items
		end
	end
end
addEvent("onRefreshLoot", true)
addEventHandler("onRefreshLoot",root,sendLootItems)

local function giveItemToLoot(itemName, loot)
	local self = Remote.getSuperFromRemote(client)
	local lootSpot = Remote.getSuperFromRemote(loot)
	local amountToTransfer = 1

	if isItemAmmo(itemName) then
		local itemCount = self.inventory:getItemCount(itemName)
		amountToTransfer = itemCount <= 10 and itemCount or 10
	end

	if lootSpot then
		self.inventory:transferItemTo(lootSpot.inventory, itemName, amountToTransfer)
		self:sendInventoryItems()
		sendLootItems(loot)
	end
	--FIXME: implement dropping items to the ground
	if isItemAmmo(itemName) then
		self:updateAmmo(itemName)
	elseif isItemWeapon(itemName)
	and self:isWeaponEquipped(itemName)
	and not self.inventory:doesHaveItem(itemName) then
		self:takeWeapon(itemName)
	end
end
addEvent("onItemFromInventoryToLoot", true)
addEventHandler("onItemFromInventoryToLoot", root, giveItemToLoot)

local function takeItemFromLoot(itemName, loot)
	local self = Remote.getSuperFromRemote(client)
	local lootSpot = Remote.getSuperFromRemote(loot)

	if isItemAmmo(itemName) then
		local itemCount = lootSpot.inventory:getItemCount(itemName)
		lootSpot.inventory:transferItemTo(self.inventory, itemName, itemCount)
		self:updateAmmo(itemName)
	else
		lootSpot.inventory:transferItemTo(self.inventory, itemName, 1)
	end

	self:sendInventoryItems()
	sendLootItems(loot)
end
addEvent("onItemFromLootToInventory", true)
addEventHandler("onItemFromLootToInventory", root, takeItemFromLoot)

function Player:createDeadBody()
	if not self:isInWater() then
		local deadPlayer = DeadPlayer.new(self)
		iprint("Created body for " ..self.name)
	end
end

function handleResourceStop()
	for player in pairs(Player.getAll()) do
		player:destroy(true)
	end
end
addEventHandler("onResourceStop", resourceRoot, handleResourceStop)

local function handlePlayerLeave()
	local player = Remote.getSuperFromRemote(source)
	player:destroy()
end
addEventHandler("onPlayerQuit", root, handlePlayerLeave)

function Player:sendStatistics()
	local data = self.account.data
	local statistics =
	{
		gamesPlayed = data.gamesPlayed,
		wins = data.wins,
		losses = data.losses,
		kills = data.kills,
		deaths = data.deaths,
		headshots = data.headshots,
		coins = data.coins,
		coinsSpent = data.coinsSpent,
	}
	self.remote:send("onGetAccountStatsFromServer", statistics)
end

local function handleSendStatistics()
	local player = Remote.getSuperFromRemote(client)
	player:sendStatistics()
end
addEvent("onAskServerForAccountStats", true)
addEventHandler("onAskServerForAccountStats", root, handleSendStatistics)
