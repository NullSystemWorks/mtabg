--[[

				MTA:BG
			MTA Battlegrounds
	Developed By: Null System Works

]]--

elementBackpack = {}

function addBackpackToPlayerBack(player,backpackslots)
	local client = player
	if elementBackpack[client] then
		detachElementFromBone(elementBackpack[client])
		destroyElement(elementBackpack[client])
		elementBackpack[client] = false
	end
	local x,y,z = getElementPosition(client)
	if backpackslots then
		if backpackslots == 170 then
			elementBackpack[client] = createObject(3026,x,y,z)
			outputDebugString("Object created!")
		elseif backpackslots == 220 then
			elementBackpack[client] = createObject(1239,x,y,z)
		elseif backpackslots == 270 then
			elementBackpack[client] = createObject(1644,x,y,z)
		end
		attachElementToBone(elementBackpack[client],client,3,0,-0.225,0.05,90,0,0)
		setElementDimension(elementBackpack[client],gameCache["playingField"])
	end
end
addEvent("mtabg_onPlayerChangeBackpack",true)
addEventHandler("mtabg_onPlayerChangeBackpack",root,addBackpackToPlayerBack)

function addBackpackToPlayer(dataName,oldValue)
	if getElementType(source) == "player" and dataName == "MAX_Slots" then
		local newValue = getElementData(source,dataName)
		if elementBackpack[source] then
			detachElementFromBone(elementBackpack[source])
			destroyElement(elementBackpack[source])
			elementBackpack[source] = false
		end
		local x,y,z = getElementPosition(source)
		local rx,ry,rz = getElementRotation(source)
		if newValue == 8 then
			elementBackpack[source] = createObject(3026,x,y,z) -- Patrol Pack
		elseif newValue == gameplayVariables["assaultpack_slots"] then
			elementBackpack[source] = createObject(1644,x,y,z) -- Assault Pack (ACU)
		elseif newValue == gameplayVariables["czechvest_slots"] then
			elementBackpack[source] = createObject(1248,x,y,z) -- Czech Vest Pouch
		elseif newValue == gameplayVariables["alice_slots"] then
			elementBackpack[source] = createObject(2382,x,y,z) -- ALICE Pack
		elseif newValue == gameplayVariables["survival_slots"] then
			elementBackpack[source] = createObject(1314,x,y,z) -- Survival ACU
		elseif newValue == gameplayVariables["britishassault_slots"] then
			elementBackpack[source] = createObject(1318,x,y,z) -- British Assault Pack
		elseif newValue == gameplayVariables["coyote_slots"] then
			elementBackpack[source] = createObject(1252,x,y,z) -- Backpack (Coyote)
		elseif newValue == gameplayVariables["czech_slots"] then
			elementBackpack[source] = createObject(1575,x,y,z) -- Czech Backpack
		elseif newValue > gameplayVariables["czech_slots"] then
			return
		end
		if newValue == gameplayVariables["czech_slots"] then
			attachElementToBone(elementBackpack[source],source,3,0,-0.16,0.05,270,0,180)
		else
			attachElementToBone(elementBackpack[source],source,3,0,-0.225,0.05,90,0,0)
		end
	end
end
--addEventHandler ("onElementDataChange", root, addBackpackToPlayer)

function backpackRemoveQuit ()
	if elementBackpack[source] then
		detachElementFromBone(elementBackpack[source])
		destroyElement(elementBackpack[source])
	end
end
addEventHandler ( "onPlayerQuit", getRootElement(), backpackRemoveQuit )

elementWeaponBack = {}
function weaponSwitchBack ( previousWeaponID, currentWeaponID )
	local weapon1 = getElementData(source,"currentweapon_1")
	if not weapon1 then return end
	local ammoData1,weapID1 = getWeaponAmmoFromName(weapon1)
	local x,y,z = getElementPosition(source)
	local rx,ry,rz = getElementRotation(source)
	if previousWeaponID == weapID1 then
		if elementWeaponBack[source] then
			detachElementFromBone(elementWeaponBack[source])
			destroyElement(elementWeaponBack[source])
			elementWeaponBack[source] = false
		end
		elementWeaponBack[source] = createObject(getWeaponObjectID(weapID1),x,y,z)
		setObjectScale(elementWeaponBack[source],0.875)
		if elementBackpack[source] then
			if weapID1 == 8 then
				attachElementToBone(elementWeaponBack[source],source,3,0.19,-0.25,-0.1,0,0,90)
			else
				attachElementToBone(elementWeaponBack[source],source,3,0.19,-0.31,-0.1,0,270,-90)
			end
		else
			if weapID1 == 8 then
				attachElementToBone(elementWeaponBack[source],source,3,-0.19,-0.11,-0.1,0,0,90)
			else
				attachElementToBone(elementWeaponBack[source],source,3,0.19,-0.11,-0.1,0,270,10)
			end
		end
	elseif currentWeaponID == weapID1 then
		detachElementFromBone(elementWeaponBack[source])
			if elementWeaponBack[source] then
				destroyElement(elementWeaponBack[source])
			end
		elementWeaponBack[source] = false
	end
end
--addEventHandler ( "onPlayerWeaponSwitch", getRootElement(), weaponSwitchBack )

function removeBackWeaponOnDrop ()
	if elementWeaponBack[source] then
		detachElementFromBone(elementWeaponBack[source])
		destroyElement(elementWeaponBack[source])
		elementWeaponBack[source] = false
	end
end
--addEvent("removeBackWeaponOnDrop",true)
--addEventHandler("removeBackWeaponOnDrop",getRootElement(),removeBackWeaponOnDrop)

function removeAttachedOnDeath(thePlayer)
	if elementBackpack[thePlayer] then
		detachElementFromBone(elementBackpack[thePlayer])
		destroyElement(elementBackpack[thePlayer])
	end
end
