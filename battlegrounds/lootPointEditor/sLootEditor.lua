--[[

				MTA:BG
			MTA Battlegrounds
	Developed By: Null System Works

]]--

local editorKey = "F2"
local clock = getTickCount --licalize getTickCount()
local lootColPos = lootColPos --localize lootColPos table
local createColSphere = createColSphere --localize createColSphere
local createMarker = createMarker --localize creatMarker
local math = math
local Marker = Marker
local isEditorRunning = false

--Multithreading
local coroutine = coroutine
local markerMaker --creation/destruction thread
local markerMakerTimer --creation/destruction thread timer
local markerMakerSleeppingTime = 500 --in milliseconds >= 50
local markerMakerWorkCount = 50 --work before suspending

local lootColor = { --class colors
	Residential = {r = 176, g = 65, b = 214}, --#b041d6
	Military = {r = 235, g = 48, b = 48}, --#eb3030
	Supermarket = {r = 74, g = 67, b = 222}, --#4a43de
	Farm = {r = 54, g = 172, b = 47}, --#36ac2f
	Industry = {r = 102, g = 102, b = 102}, --#666666
}

--Return the class color in RGB
local function getClassColor(className)
	return lootColor[className].r, lootColor[className].g, lootColor[className].b
end

--Spawn all and markers
local function spawnLootMarkers ()
	isEditorRunning = true --mark as running
	local markerCount = 0 --keep track of marker count
	local startTime = clock() --get starting time
	local partialIterationTime = 0
	local totalIterationTime = 0
	markerMaker = coroutine.create(
	function ()
		cycleStartTime = clock() --get iteration round starting time
		for className, classTable in pairs(lootColPos) do --iterate through col classes
			for colID = 1, #classTable.x, 1 do --iterate from first to last col
				if classTable.x[colID] then --if valid entry
					local marker = Marker(classTable.x[colID], classTable.y[colID], classTable.z[colID], "checkpoint", 1.5, getClassColor(className)) --create marker indicator
					marker:setData("markerClass", className) --store marker class
					marker:setData("markerID", colID) --store marker ID
					marker:setDimension(65535)
					markerCount = markerCount + 1 --increase spawned marker count
				end
				if math.mod(markerCount, markerMakerWorkCount) == 0 then --stop periodically
					partialIterationTime = clock() - cycleStartTime --time for this iteration round
					totalIterationTime = totalIterationTime + partialIterationTime --add time every yield
					partialIterationTime = 0
					coroutine.yield() --suspend execution
					cycleStartTime = clock() --get iteration round starting time
				end
			end
		end
		partialIterationTime = clock() - cycleStartTime --time for last iteration round
		totalIterationTime = totalIterationTime + partialIterationTime --add time for last execution
	end)
	markerMakerTimer = Timer(
	function ()
		if coroutine.status(markerMaker) == "suspended" then
			coroutine.resume(markerMaker)
		else --job done
			markerMakerTimer:destroy() --destroy timer
			markerMakerTimer = nil
			markerMaker = nil --clear dead thread
			outputDebugString("Created " ..markerCount.. " markers in " ..totalIterationTime.. "ms") --output processing time
			local totalDuration = clock() - startTime
			outputDebugString(string.format( "Duration: %dms. Thread: %d%%",
				totalDuration, totalIterationTime/(totalDuration)*100))
		end
	end, markerMakerSleeppingTime, 0)
end

--Destroy all markers
local function destroyLootMarkers()
	isEditorRunning = false --mark as not running
	local markerCount = 0 --keep track of marker count
	local startTime = clock()
	local partialIterationTime = 0
	local totalIterationTime = 0
	markerMaker = coroutine.create(
	function()
		local cycleStartTime = clock() --get starting time
		for k, marker in ipairs(getElementsByType("marker")) do --for all markers
			if marker:getData("markerClass") then
				marker:destroy()
				markerCount = markerCount + 1 --increase spawned marker count
			end
			if math.mod(markerCount, markerMakerWorkCount) == 0 then --stop periodically
				partialIterationTime = clock() - cycleStartTime --time for this iteration round
				totalIterationTime = totalIterationTime + partialIterationTime --add time every yield
				partialIterationTime = 0
				coroutine.yield()
				cycleStartTime = clock() --get starting time
			end
		end
		partialIterationTime = clock() - cycleStartTime --time for last iteration round
		totalIterationTime = totalIterationTime + partialIterationTime --add time for last execution
	end)
	markerMakerTimer = Timer(
	function()
		if coroutine.status(markerMaker) == "suspended" then
			coroutine.resume(markerMaker)
		else --job done
			markerMakerTimer:destroy() --destroy timer
			markerMakerTimer = nil
			markerMaker = nil --clear dead thread
			outputDebugString("Destroyed " ..markerCount.. " markers in " ..totalIterationTime.. "ms") --output processing time
			local totalDuration = clock() - startTime
			outputDebugString(string.format( "Duration: %dms. Thread: %d%%",
			totalDuration, totalIterationTime/(totalDuration)*100))
		end
	end, markerMakerSleeppingTime, 0)
end

--Keep track of which marker the player is in
local function onPlayerMarkerHandler(marker, matchingDimension)
	if matchingDimension and marker.dimension == 65535 then --both on the right dimension?
		if eventName == "onPlayerMarkerHit" then --when the player enters a marker
			source:setData("markerID", marker:getData("markerID")) --save markerID to player data
			source:setData("markerClass", marker:getData("markerClass")) --save markerClass to palyer data
		elseif eventName == "onPlayerMarkerLeave" then --when the player leaves a marker
			source:setData("markerID", false) --clear markerID from player data
			source:setData("markerClass", false) --clear markerID from player data
		end
	end
end

--Find our marker from it's ID
local function getMarkerFromID(markerID, markerClass)
	for k, v in ipairs(getElementsByType("marker")) do --iterate through marker pool
		if v:getData("markerID") == markerID and v:getData("markerClass") == markerClass then --select the right one
			return v
		end
	end
end

--Detele a marker from it's ID
local function deleteMarkerFromID(markerID, markerClass)
	--Delete old class entry
	lootColPos[markerClass].x[markerID] = false --erase old classe's entry
	lootColPos[markerClass].y[markerID] = false
	lootColPos[markerClass].z[markerID] = false
end

--Find the next available position in a table
local function getNextTablePosition(class)
	for i = 0, #lootColPos[class].x do --from all positions
		if lootColPos[class].x[i] == false then
			return i --return the first empty index
		end
	end
	return #lootColPos[class].x + 1 --no empty index found, return last class slot ID +1
end

--Copy coords from old  class to new class entry
local function transferDataToNewMarker(markerID, markerClass, newClass)
	local nextPos = getNextTablePosition(newClass) --get the last entry of the class table
	lootColPos[newClass].x[nextPos] = lootColPos[markerClass].x[markerID] --set new entry on old's position
	lootColPos[newClass].y[nextPos] = lootColPos[markerClass].y[markerID]
	lootColPos[newClass].z[nextPos] = lootColPos[markerClass].z[markerID]
	return nextPos --return new marker ID
end

--Create a new marker entry
local function createNewMarker(player, markerClass)
	local markerID = getNextTablePosition(markerClass) --get the last entry of the class table
	local x, y, z = player.position.x, player.position.y, player.position.z
	local r, g, b = lootColor[markerClass].r, lootColor[markerClass].g, lootColor[markerClass].b
	local marker = Marker(x, y, z, "checkpoint", 2, r, g, b) --create new marker
	lootColPos[markerClass].x[markerID] = x --add new entry based on caller position
	lootColPos[markerClass].y[markerID] = y
	lootColPos[markerClass].z[markerID] = z
	marker:setData("markerID", markerID) --store marker ID
	marker:setData("markerClass", markerClass) --store marker class
	player:setData("markerID", markerID) --save markerID to player data
	player:setData("markerClass", markerClass) --save markerClass to palyer data
	marker:setDimension(65535)
	outputDebugString(string.format("%s has created %s%i at { %.4f, %.4f, %.4f }", player.name, markerClass, markerID, marker.position.x, marker.position.y, marker.position.z)) --document action
end

--Edit loot points
local function editLootPoint(player, key, _, newClass)
	local markerID = player:getData("markerID") --get current loot point ID
	local markerClass = player:getData("markerClass") --get current loot point class
	local marker = getMarkerFromID(markerID, markerClass) --get current loot point marker
	if markerID then --if player in a marker
		if newClass == "delete" then --delete operation
			outputDebugString(string.format("%s has deleted %s%i at { %.4f, %.4f, %.4f }", player.name, markerClass, markerID, marker.position.x, marker.position.y, marker.position.z)) --document action
			player:setData("markerID", false) --clear markerID from player data
			player:setData("markerClass", false) --clear markerID from player data
			deleteMarkerFromID(markerID, markerClass) --delete marker class reference
			marker:destroy()
			writeTableToDisk() --commit changes to disk
		elseif newClass == "info" then --info operations
			outputDebugString(string.format("%s%i at { %.4f, %.4f, %.4f }", markerClass, markerID, marker.position.x, marker.position.y, marker.position.z)) --document action
		elseif newClass ~= markerClass then --only if really changing
			local newID = transferDataToNewMarker(markerID, markerClass, newClass) --copy data from old class reference to new one
			deleteMarkerFromID(markerID, markerClass) --delete old marker class reference
			player:setData("markerClass", newClass) --update player marker class
			marker:setData("markerClass", newClass) --set marker's new class
			player:setData("markerID", newID) --update player marker ID
			marker:setData("markerID", newID) --set marker's new ID
			marker:setColor(lootColor[newClass].r, lootColor[newClass].g, lootColor[newClass].b, 255) --set marker's new color
			outputDebugString(string.format("%s %s%i > %s%i at { %.4f, %.4f, %.4f }", player.name, markerClass, markerID, newClass, newID, marker.position.x, marker.position.y, marker.position.z)) --document action
			writeTableToDisk() --commit changes to disk
		else --in case a new class type was called but it's the same as the old one
			--No need to change to the same class
		end
	elseif newClass == "info" then --if not in a marker and called info
		--Output some global statistics
	elseif newClass ~= "delete" then --if attempted to create new marker
		createNewMarker(player, newClass) --create a new marker entry
		writeTableToDisk() --commit changes to disk
	end
end

--Output class colors an bindings to chat
local function printHelpMenu(player)
    outputChatBox(" ", player) --must fill the chat
    outputChatBox(" ", player)
    outputChatBox(" ", player)
		outputChatBox("backspace: Delete", player, 255, 255, 255)
    outputChatBox("0: Info ", player, 255, 255, 255)
    outputChatBox("1: Residential", player, getClassColor("Residential"))
    outputChatBox("2: Military", player, getClassColor("Military"))
    outputChatBox("3: Supermarket", player, getClassColor("Supermarket"))
    outputChatBox("4: Farm", player, getClassColor("Farm"))
    outputChatBox("5: Industrial", player, getClassColor("Industry"))
end

--Checks if player has permission to join the editor
local function canPlayerUseEditor(player)
	return hasObjectPermissionTo(player, "resource.battlegrounds.lootEditor", false)
end

--Clear control binding definitions
local function unbindControlKeys (player)
	if canPlayerUseEditor(player) then --read-only mode?
		unbindKey(player, "backspace", "down", editLootPoint, "delete") --unbind delete button
		unbindKey(player, "num_0", "down", editLootPoint, "info") --unbind info button
		unbindKey(player, "num_1", "down", editLootPoint, "Residential") --unbind Residential button
		unbindKey(player, "num_2", "down", editLootPoint, "Military") --unbind Military button
		unbindKey(player, "num_3", "down", editLootPoint, "Supermarket") --unbind Supermarket button
		unbindKey(player, "num_4", "down", editLootPoint, "Farm") --unbind Farm button
		unbindKey(player, "num_5", "down", editLootPoint, "Industry") --unbind Industry button
	end
end

--Control binding definitions
local function bindControlKeys (player)
	bindKey(player, "backspace", "down", editLootPoint, "delete") --bind delete button
	bindKey(player, "num_0", "down", editLootPoint, "info") --bind info button
	bindKey(player, "num_1", "down", editLootPoint, "Residential") --bind Residential button
	bindKey(player, "num_2", "down", editLootPoint, "Military") --bind Military button
	bindKey(player, "num_3", "down", editLootPoint, "Supermarket") --bind Supermarket button
	bindKey(player, "num_4", "down", editLootPoint, "Farm") --bind Farm button
	bindKey(player, "num_5", "down", editLootPoint, "Industry") --bind Industry button
end

--Allow player to leave editor mode
local function leaveEditor(player)
	player:setData("markerID", nil) --clear markerID in player data
	player:setData("markerClass", nil) --clear markerClass in player data
	unbindControlKeys(player) --unbind all control keys
	player:setDimension(player:getData("previousDimension"))
	player:setData("previousDimension", nil)
	if not canPlayerUseEditor(player) then --spectating player
		player:triggerEvent("onHideLootEditorWindow", player)
		triggerEvent("onPlayerLeaveLootEditor", resourceRoot, player, false)
	elseif isEditorRunning then --not spectator, editor running
		player:triggerEvent("onSetLootEditorWindowSate", player, false)
		triggerEvent("onPlayerLeaveLootEditor", resourceRoot, player, true)
	end
end

--Allow player to enter editor mode
local function enterEditor(player)
	if not player.dead then
		player:setData("markerID", false) --declare markerID in player data
		player:setData("markerClass", false) --declare markerClass in player data
		player:setData("previousDimension", player.dimension)
		player:setDimension(65535)
		player:triggerEvent("onSetLootEditorWindowSate", player, true)
		if canPlayerUseEditor(player) then --not read-only mode?
			bindControlKeys(player) --bind all control keys
			triggerEvent("onPlayerEnterLootEditor", resourceRoot, player, true)
		else
			outputChatBox("Welcome to loot editor preview! You are on read-only mode.", player, 103, 193, 163)
			triggerEvent("onPlayerEnterLootEditor", resourceRoot, player, false)
		end
		-- printHelpMenu(player) --print help text
	end
end

--Toggle in and out of editor
local function toggleJoinEditor(player)
	if not player:getData("previousDimension") then
		enterEditor(player)
	else
		leaveEditor(player)
	end
end

--Clear player data on resource stop
local function handleResourceStop()
	for k, player in ipairs(getElementsByType("player")) do
		if player:getData("previousDimension") then
			player:setData("markerID", nil) --clear markerID in player data
			player:setData("markerClass", nil) --clear markerClass in player data
			player:setDimension(player:getData("previousDimension")) --get player back home
			player:setData("previousDimension", nil)
		end
	end
	triggerEvent("onLootEditorStop", resourceRoot)
end

--Clear player data on player death
local function handlePlayerDeath()
	player = source
	if player:getData("previousDimension") then
		player:setData("markerID", nil) --clear markerID in player data
		player:setData("markerClass", nil) --clear markerClass in player data
		player:setData("previousDimension", nil)
		unbindControlKeys(player) --unbind all control keys
		if not canPlayerUseEditor(player) then --spectating player
			player:triggerEvent("onHideLootEditorWindow", player)
		elseif isEditorRunning then --not spectator, editor running
			player:triggerEvent("onSetLootEditorWindowSate", player, false)
		end
	end
end

--Bind editor access and show window
local function bindAndGreet(player)
	if canPlayerUseEditor(player) then
		bindKey(player, editorKey, "down", toggleJoinEditor) --bind to toggle enditor
		player:triggerEvent("onSetLootEditorWindowSate", player, false) --show folden window
	end
end

--Invite joiners
local function handleJoin()
	bindAndGreet(source)
end

--Start editor
local function startEditor()
	if markerMaker then return end --something is already running, quit
	if not isEditorRunning then
		addEventHandler("onPlayerLogin", root, handleJoin)
		spawnLootMarkers()
		for k, player in ipairs(getElementsByType("player")) do --bind for all players
			bindAndGreet(player)
		end
		addEventHandler("onPlayerMarkerHit", root, onPlayerMarkerHandler)
		addEventHandler("onPlayerMarkerLeave", root, onPlayerMarkerHandler)
		addEventHandler("onResourceStop", resourceRoot, handleResourceStop)
		addEventHandler("onPlayerWasted", root, handlePlayerDeath)
		triggerEvent("onLootEditorStart", resourceRoot)
	end
end

--Terminate editor
local function stopEditor()
	if markerMaker then return end --something is already running, quit
	if isEditorRunning then
		removeEventHandler("onPlayerLogin", root, handleJoin)
		destroyLootMarkers()
		for k, player in ipairs(getElementsByType("player")) do
			if canPlayerUseEditor(player) then
				unbindKey(player, editorKey, "down", toggleJoinEditor) --unbind toggle editor
				player:triggerEvent("onHideLootEditorWindow", player) --hide window
			end
			if player:getData("previousDimension") then --remove players from editor
				leaveEditor(player)
			end
		end
		removeEventHandler("onPlayerMarkerHit", root, onPlayerMarkerHandler)
		removeEventHandler("onPlayerMarkerLeave", root, onPlayerMarkerHandler)
		removeEventHandler("onResourceStop", resourceRoot, handleResourceStop)
		removeEventHandler("onPlayerWasted", root, handlePlayerDeath)
		triggerEvent("onLootEditorStop", resourceRoot)
		collectgarbage() --clean up the mess
	end
end

--Toggle editor
function toggleEditor()
	if isEditorRunning then
		stopEditor()
	else
		startEditor()
	end
end
addCommandHandler("lootEditor", toggleEditor, true)

addEvent("onLootEditorStart")
addEvent("onLootEditorStop")
addEvent("onPlayerEnterLootEditor")
addEvent("onPlayerLeaveLootEditor")


lootEditor = {} --expose editor functionality

--Get editor state
function lootEditor:getRunning()
	return isEditorRunning
end

--Start and stop editor
function lootEditor:setRunning(state)
	if type(state) == "boolean" then
		if state == isEditorRunning then --not changing
			return
		elseif state then
			startEditor()
		else
			stopEditor()
		end
	else --not boolean
		error("Bad argument #1 to 'lootEditor:setRunning' (boolean expected, got " ..type(state).. ")", 2)
	end
end

--Check if palyer is in the editor
function lootEditor:getPlayerInEditor(player)
	if (type(player) == "userdata" and getElementType(player) == "player") then
		return player:getData("previousDimension") and true or false
	else
		error("Bad argument #1 to 'lootEditor:getPlayerInEditor' (player expected, got " ..type(player).. ")", 2)
	end
end

--Insert and remove player into editor
function lootEditor:setPlayerInEditor(player, state)
	if (type(player) == "userdata" and getElementType(player) == "player") then
		if type(state) == "boolean" then
			if isEditorRunning then
				if lootEditor:getPlayerInEditor(player) then
					if state then --if change
						leaveEditor(player)
					end
				else
					if not state then --if change
						enterEditor(player)
					end
				end
			end
		else
			error("Bad argument #2 to 'lootEditor:setPlayerInEditor' (boolean expected, got " ..type(state).. ")", 2)
		end
	else
		error("Bad argument #1 to 'lootEditor:setPlayerInEditor' (player expected, got " ..type(player).. ")", 2)
	end
end

--[[
Methods:
	lootEditor:getRunning()
	lootEditor:setRunning(state)
	lootEditor:getPlayerInEditor(player)
	lootEditor:setPlayerInEditor(player, state)
Event:
	triggerEvent("onLootEditorStart", resourceRoot) -- triggered when the editor starts
	triggerEvent("onLootEditorStop", resourceRoot) -- triggered when the editor stops
	triggerEvent("onPlayerEnterLootEditor", resourceRoot, player, isReadOnly) --triggered when a player enters the editor
	triggerEvent("onPlayerLeaveLootEditor", resourceRoot, player, canRejoin) --triggered when a player leaves the editor
ACL:
	command.lootEditor
	resource.battlegrounds.lootEditor
]]
