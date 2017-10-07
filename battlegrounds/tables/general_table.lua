--[[

				MTA:BG
			MTA Battlegrounds
	Developed By: Null System Works

]]--

weaponDataTable = {
-- {"WeaponName",weaponID,modelID,size,Rotation,"ammoType","weaponType","imageName","guiLabelName",relativeSizeX,relativeSizeY,relativePosX,relativePosY}
{"M1911",22,346,1,90,"11.43x23mm Cartridge","Secondary","m1911.png","handsub",0.13,0.17,0.58,0.59},
{"Revolver",24,348,1,90,"11.43x23mm Cartridge","Secondary","revolver.png","handsub",0.13, 0.17,0.58,0.59},
{"M9",22,346,1,90,"9x19mm Cartridge","Secondary","m9sd.png","handsub",0.13, 0.17,0.58,0.59},
{"Makarov SD",23,347,1,90,"9x18mm Cartridge","Secondary","m9sd.png","handsub",0.13, 0.17,0.58,0.59},
{"Bizon PP-19 SD",29,353,1,90,"9x19mm Cartridge","Secondary","bizon.png","handsub",0.25, 0.17,0.58,0.59},
{"PDW",28,352,1,90,"9x19mm Cartridge","Secondary","pdw.png","handsub",0.13, 0.17,0.58,0.59},
{"MP5A5",29,353,1,90,"9x19mm Cartridge","Secondary","mp5a5.png","handsub",0.25, 0.17,0.58,0.59},
{"M24",34,358,1,90,"7.62x54mm Cartridge","Primary","M24.png","shotsniper",0.25, 0.17,0.58, 0.21},
{"SVD Dragunov",34,358,1,90,"7.62x54mm Cartridge","Primary","svd.png","shotsniper",0.25, 0.17,0.58, 0.21},
{"Mosin-Nagant",33,357,1,90,".303 British Cartridge","Primary","enfield.png","shotsniper",0.25, 0.17,0.58, 0.21},
{"AK-74",30,355,1,90,"7.62x39mm Cartridge","Primary","ak47.png","rifles",0.25, 0.17,0.58, 0.40},
{"AKM",30,355,1,90,"7.62x39mm Cartridge","Primary","ak47.png","rifles",0.25, 0.17,0.58, 0.40},
{"Sa58V CCO",30,355,1,90,"7.62x39mm Cartridge","Primary","sa58v.png","rifles",0.25, 0.17,0.58, 0.40},
{"FN FAL",30,355,1,90,"7.62x39mm Cartridge","Primary","fnfal.png","rifles",0.25, 0.17,0.58, 0.40},
{"G36C",31,356,1,90,"5.56x45mm Cartridge","Primary","g36c.png","rifles",0.25, 0.17,0.58, 0.40},
{"M16A2",31,356,1,90,"5.56x45mm Cartridge","Primary","m4.png","rifles",0.25, 0.17,0.58, 0.40},
{"M4A1",31,356,1,90,"5.56x45mm Cartridge","Primary","m4.png","rifles",0.25, 0.17,0.58, 0.40},
{"Winchester 1866",25,349,1,90,"1866 Slug","Primary","winchester.png","shotsniper",0.25, 0.17,0.58, 0.21},
{"Double-barreled Shotgun",25,351,1,90,"1866 Slug","Primary","sawn.png","shotsniper",0.25, 0.17,0.58, 0.21},
{"M1014",27,351,1,90,"12 Gauge Pellet","Primary","spaz.png","shotsniper",0.25, 0.17,0.58, 0.21},
{"Baseball Bat",5,336,1,90,"Melee","Special"},
{"Axe",8,339,1,90,"Melee","Special"},
{"Hunting Knife",4,335,1,90,"Melee","Special"},
{"Shovel",6,337,1,90,"Melee","Special"},
{"Grenade",16,342,1,90,"Melee","Special"},
{"Binoculars",43,369,1,90,"Melee","Special"},
{"Range Finder",43,369,1,90,"Melee","Special"},
}

weaponAmmoTable = {
["11.43x23mm Cartridge"] = {
{"M1911",22},
{"Revolver",24},
},

["9x18mm Cartridge"] = {
{"Bizon PP-19 SD",29},
},

["9x19mm Cartridge"] = {
{"M9",22},
{"Makarov SD",23},
{"PDW",28},
{"MP5A5",29},
},

[".303 British Cartridge"] = {
{"Mosin-Nagant",33},
},

["7.62x39mm Cartridge"] = {
{"AKM",30},
{"AK-74",30},
{"Sa58V CCO",30},
{"FN FAL",30},
},

["5.56x45mm Cartridge"] = {
{"G36C",31},
{"M16A2",31},
{"M4A1",31},
},

["7.62x54mm Cartridge"] = {
{"SVD Dragunov",34},
{"M24",34},
},

["1866 Slug"] = {
{"Winchester 1866",25},
{"Double-barreled Shotgun",25},
},

["12 Gauge Pellet"] = {
{"M1014",27},
},

["others"] = {
{"Baseball Bat",5},
{"Axe",8},
{"Parachute",46},
{"Grenade",16},
{"Hunting Knife",4},
{"Binoculars",43},
{"Range Finder",43},
{"Shovel",6},
},
}

weaponModelIDTable = {
{"M1911",22},
{"Revolver",24},
{"Bizon PP-19 SD",29},
{"M9",22},
{"Makarov SD",23},
{"PDW",28},
{"MP5A5",29},
{"Mosin-Nagant",33},
{"AKM",30},
{"AK-74",30},
{"Sa58V CCO",30},
{"FN FAL",30},
{"G36C",31},
{"M16A2",31},
{"M4A1",31},
{"SVD Dragunov",34},
{"M24",34},
{"CZ 550",34},
{"Winchester 1866",25},
{"Double-barreled Shotgun",25},
{"M1014",27},
{"Compound Crossbow",25},
{"Baseball Bat",5},
{"Axe",8},
{"Parachute",46},
{"Grenade",16},
{"Hunting Knife",4},
{"Binoculars",43},
{"Range Finder",43},
{"Shovel",6},
}

weaponDamageTable = {
-- {"WeaponName",damage,distance}
{"M1911",42,100},
{"Revolver",42,100},
{"M9",27,100},
{"Makarov SD",32,100},
{"Bizon PP-19 SD",27,100},
{"PDW",27,100},
{"MP5A5",27,100},
{"M24",100,100},
{"SVD Dragunov",77,100},
{"Mosin-Nagant",50,100},
{"AK-74",42,100},
{"AKM",42,100},
{"Sa58V CCO",37,100},
{"FN FAL",37,100},
{"G36C",37,100},
{"M16A2",37,100},
{"M4A1",42,100},
{"Winchester 1866",100,100},
{"Double-barreled Shotgun",100,100},
{"M1014",92,100},
{"Compound Crossbow",100,100},
{"Baseball Bat",30,100},
{"Axe",30,100},
{"Hunting Knife",30,100},
{"Shovel",30,100},
{"Grenade",100,100},
}

playerInfo = {}
playerDataInfo = {}
