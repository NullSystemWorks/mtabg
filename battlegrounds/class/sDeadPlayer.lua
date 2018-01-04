DeadPlayer = {}
local deadplayer_mt = {__index = DeadPlayer}

function DeadPlayer.new(player)
	local pos = player:getPosition()
	local rotZ = player:getZRotation()
	local skin = player:getSkin()
	local dim = player:getDimension()

	local newInst =
	{
		name = player.name,
		ped = Ped.new(skin, pos, rotZ, dim),
		lootSpot = LootSpot.new(pos.x, pos.y, pos.z, player:getMatch()),
	}
	setmetatable(newInst, deadplayer_mt)
	if player:getBackpack() then
		player:transferBackpackTo(newInst.ped)
	end
	newInst.ped:kill()
	player.match:addLootSpot(newInst)

	local tmp = newInst.lootSpot.inventory
	newInst.lootSpot.inventory = player.inventory
	player.inventory = tmp

	return newInst
end

function DeadPlayer:destroy()
	self.ped:destroy()
	self.lootSpot:destroy()
end
