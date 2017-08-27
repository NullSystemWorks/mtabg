--[[
	
				MTA:BG
			MTA Battlegrounds
	Developed By: Null System Works

]]--



itemTXD = engineLoadTXD("models/items/txd/cola_can.txd")
engineImportTXD(itemTXD, 2647)
itemDFF = engineLoadDFF("models/items/dff/cola_can.dff", 2647)
engineReplaceModel(itemDFF, 2647)
itemTXD = engineLoadTXD("models/items/txd/bandage.txd")
engineImportTXD(itemTXD, 1578)
itemDFF = engineLoadDFF("models/items/dff/bandage.dff", 1578)
engineReplaceModel(itemDFF, 1578)
itemTXD = engineLoadTXD("models/items/txd/painkillers.txd")
engineImportTXD(itemTXD, 2709)
itemDFF = engineLoadDFF("models/items/dff/painkillers.dff", 2709)
engineReplaceModel(itemDFF, 2709)
itemTXD = engineLoadTXD("models/items/txd/first_aid_kit.txd")
engineImportTXD(itemTXD, 2891)
itemDFF = engineLoadDFF("models/items/dff/first_aid_kit.dff", 2891)
engineReplaceModel(itemDFF, 2891)
itemTXD = engineLoadTXD("models/items/txd/jerrycan.txd")
engineImportTXD(itemTXD, 1650)
itemDFF = engineLoadDFF("models/items/dff/jerrycan.dff", 1650)
engineReplaceModel(itemDFF, 1650)


itemTXD = engineLoadTXD("models/items/txd/9x18cartridge.txd")
engineImportTXD(itemTXD, 2057)
itemDFF = engineLoadDFF("models/items/dff/9x18cartridge.dff", 2057)
engineReplaceModel(itemDFF, 2057)
itemTXD = engineLoadTXD("models/items/txd/9x19cartridge.txd")
engineImportTXD(itemTXD, 2041)
itemDFF = engineLoadDFF("models/items/dff/9x19cartridge.dff", 2041)
engineReplaceModel(itemDFF, 2041)
itemTXD = engineLoadTXD("models/items/txd/12gauge.txd")
engineImportTXD(itemTXD, 2358)
itemDFF = engineLoadDFF("models/items/dff/12gauge.dff", 2358)
engineReplaceModel(itemDFF, 2358)
itemTXD = engineLoadTXD("models/items/txd/308winchester.txd")
engineImportTXD(itemTXD, 2036)
itemDFF = engineLoadDFF("models/items/dff/308winchester.dff", 2036)
engineReplaceModel(itemDFF, 2036)
itemTXD = engineLoadTXD("models/items/txd/545x39cartridge.txd")
engineImportTXD(itemTXD, 1271)
itemDFF = engineLoadDFF("models/items/dff/545x39cartridge.dff", 1271)
engineReplaceModel(itemDFF, 1271)
itemTXD = engineLoadTXD("models/items/txd/556x45cartridge.txd")
engineImportTXD(itemTXD, 2035)
itemDFF = engineLoadDFF("models/items/dff/556x45cartridge.dff", 2035)
engineReplaceModel(itemDFF, 2035)
itemTXD = engineLoadTXD("models/items/txd/762x51cartridge.txd")
engineImportTXD(itemTXD, 2034)
itemDFF = engineLoadDFF("models/items/dff/762x51cartridge.dff", 2034)
engineReplaceModel(itemDFF, 2034)
itemTXD = engineLoadTXD("models/items/txd/762x54cartridge.txd")
engineImportTXD(itemTXD, 2358)
itemDFF = engineLoadDFF("models/items/dff/762x54cartridge.dff", 2358)
engineReplaceModel(itemDFF, 2358)
itemTXD = engineLoadTXD("models/items/txd/1143x23cartridge.txd")
engineImportTXD(itemTXD, 3013)
itemDFF = engineLoadDFF("models/items/dff/1143x23cartridge.dff", 3013)
engineReplaceModel(itemDFF, 3013)
itemTXD = engineLoadTXD("models/items/txd/1866slug.txd")
engineImportTXD(itemTXD, 2033)
itemDFF = engineLoadDFF("models/items/dff/1866slug.dff", 2033)
engineReplaceModel(itemDFF, 2033)


itemTXD = engineLoadTXD("models/items/txd/backpack_pouch.txd")
engineImportTXD(itemTXD, 3026)
itemDFF = engineLoadDFF("models/items/dff/backpack_pouch.dff", 3026)
engineReplaceModel(itemDFF, 3026)
itemTXD = engineLoadTXD("models/items/txd/backpack_alice.txd")
engineImportTXD(itemTXD, 1644)
itemDFF = engineLoadDFF("models/items/dff/backpack_alice.dff", 1644)
engineReplaceModel(itemDFF, 1644)
itemTXD = engineLoadTXD("models/items/txd/backpack_survival.txd")
engineImportTXD(itemTXD, 1239)
itemDFF = engineLoadDFF("models/items/dff/backpack_survival.dff", 1239)
engineReplaceModel(itemDFF, 1239)


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
--addEventHandler("onClientResourceStart",getResourceRootElement(getThisResource()),loadTheSkins)



