--[[
	
				MTA:BG
			MTA Battlegrounds
	Developed By: Null System Works

]]--

-- Define models
local models = {
	[2647] = "cola_can",
	[1578] = "bandage",
	[2709] = "painkillers",
	[2891] = "first_aid_kit",
	[1650] = "jerrycan",
	[2057] = "9x18cartridge",
	[2041] = "9x19cartridge",
	[2358] = "12gauge",
	[2036] = "308winchester",
	[1271] = "545x39cartridge",
	[2035] = "556x45cartridge",
	[2034] = "762x51cartridge",
	[2358] = "762x54cartridge",
	[3013] = "1143x23cartridge",
	[2033] = "1866slug",
	[3026] = "backpack_pouch",
	[1644] = "backpack_alice",
	[1239] = "backpack_survival"
}

-- Define model tables
modelTXD = {}
modelDFF = {}

function loadModels()
	for i, v in pairs(models) do
		-- Load TXD
		modelTXD[i] = engineLoadTXD("models/items/txd/"..v..".txd")
		engineImportTXD(modelTXD[i], i)
		-- Load DFF
		modelDFF[i] = engineLoadDFF("models/items/dff/"..v..".dff", i)
		engineReplaceModel(modelDFF[i], i)
	end
end

--[[
weaponSkinTable = {
{"m1911",2,"M1911"},
{"revolver",2,"Revolver"},
{"makarovpm",2,"Makarov PM"},
{"bizon",2,"Bizon PP-19 SD"},
{"g17",2,"G17"},
{"m9",2,"M9"},
{"makarovsd",2,"Makarov SD"},
{"pdw",2,"PDW"},
{"mp5a5",2,"MP5A5"},
{"enfield",1,"Lee Enfield"},
{"ak74",1,"AK-74"},
{"aks74u",1,"AKS-74U"},
{"rpk",1,"RPK"},
{"akm",1,"AKM"},
{"sa58vcco",1,"Sa58V CCO"},
{"sa58vrco",1,"Sa58V RCO"},
{"fnfal",1,"FN FAL"},
{"m24",1,"M24"},
{"dmr",1,"DMR"},
{"m40a3",1,"M40A3"},
{"g36acamo",1,"G36A CAMO"},
{"g36c",1,"G36C"},
{"g36ccamo",1,"G36C CAMO"},
{"g36kcamo",1,"G36K CAMO"},
{"l85a2holo",1,"L85A2 RIS Holo"},
{"m16a2",1,"M16A2"},
{"m4a1",1,"M4A1"},
{"m16a4",1,"M16A4"},
{"cz550",1,"CZ 550"},
{"dragunov",1,"SVD Dragunov"},
{"enfield",1,"Mosin-Nagant"},
{"winchester",1,"Winchester 1866"},
{"double",1,"Double-barreled Shotgun"},
{"m1014",1,"M1014"},
{"remington",1,"Remington 870"},
{"crossbow",1,"Compound Crossbow"},
}

weaponTXD = {}
weaponDFF = {}

function loadTheSkins()
	for i, skin in ipairs(weaponSkinTable) do
		weaponTXD[i] = engineLoadTXD("models/weapons/txd/"..skin[1]..".txd")
		weaponDFF[i] = engineLoadDFF("models/weapons/dff/"..skin[1]..".dff", 0)
	end
end
addEventHandler("onClientResourceStart",getResourceRootElement(getThisResource()),loadTheSkins)
]]--


