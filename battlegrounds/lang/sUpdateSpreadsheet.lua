local workingFile
local path
local number = 0
local buffer
local bufferPosition = 0
local startIndex
local endIndex
local pattern = "str%(\""
local patternLength = 5
local stringsToBeAdded = {}
local luaFilePaths
local loadedFileCount

local function pointToNextFile()
	if number < #luaFilePaths then
		number = number + 1
		path = luaFilePaths[number]
		return true
	else
		number = 0
		return false
	end
end

local function openFile()
	workingFile = File.open(path, true)
	if not workingFile then
		outputDebugString("Failed to open file!")
	end
end

local function readFile()
	buffer = workingFile:read(workingFile.size)
end

local function closeFile()
	if workingFile then
		workingFile:close()
	else
		outputDebugString("No file to close!")
	end
end

local function cleaup() --do more cleaup
	workingFile = nil
end

local function findNextMatch()
	return buffer:find(pattern, bufferPosition)
end

local function markStartIndex()
	startIndex = findNextMatch()
end

local function markEndIndex()
endIndex = buffer:find("\"", startIndex + patternLength)
end

local function getCurrentMatch()
	return buffer:sub(startIndex + patternLength, endIndex - 1)
end

local function updateBufferPosition()
	bufferPosition = endIndex + 1
end

local function resetBufferPosition()
	bufferPosition = 0
end

local function clearStringsToBeAdded()
	stringsToBeAdded = {}
end

local function markStringAsNew()
	-- iprint(path..":"..startIndex..":"..endIndex.. " > " ..getCurrentMatch())
	local currentString = getCurrentMatch()
	stringsToBeAdded[currentString] = true
end

local function checkIfNewString()
	for _, stringName in ipairs(LanguageParser.stringNames) do
		if stringName == getCurrentMatch() then
			-- outputDebugString(string.format("Already present string: %s", getCurrentMatch()))
			return
		end
	end
	markStringAsNew()
end

local function findLanguageStringsInFile()
	while findNextMatch() do
		markStartIndex()
		markEndIndex()
		checkIfNewString()
		updateBufferPosition()
	end
	resetBufferPosition()
end

local function getNewStringCount()
	local newCount = 0
	for _ in pairs(stringsToBeAdded) do
		newCount = newCount + 1
	end
	return newCount
end

local function shouldUpdateLanguageTable()
	return not LanguageParser.isLanguageTableUpToDate
end

local function announceNewStrings()
	if getNewStringCount() > 0 then
		outputDebugString(string.format("Found %d new language entries:", getNewStringCount()))
		outputDebugString(inspect(stringsToBeAdded))
	end
	outputDebugString(string.format("%d available languages: %s", #LanguageParser.availableLanguages, inspect(LanguageParser.availableLanguages)))
	outputDebugString(string.format("Table size: %d (%d x %d)", #LanguageParser.rawLanguageStrings, LanguageParser.columnCount, LanguageParser.rowCount))
end

local function updateLanguageTable()
	LanguageParser.XMLunpackToStringTable()
	LanguageParser.checkIfSpreadSheetChanged()
	if shouldUpdateLanguageTable() then
		LanguageParser.XMLunpackToStringTable()
		LanguageParser.treatRawStringTable()
		announceNewStrings()
		LanguageParser.writeLuaFile()
		resource:restart()
	end
end

local function seekNewStringsForFile()
	openFile()
	readFile()
	findLanguageStringsInFile()
	closeFile()
end

function LanguageParser.updateSpreadsheet()
	luaFilePaths = LanguageParser.getLuaFilePaths()
	clearStringsToBeAdded()
	LanguageParser.treatRawStringTable()
	while pointToNextFile() do
		seekNewStringsForFile()
	end
	LanguageParser.addNewEntriesToSpreadsheet(stringsToBeAdded)
	updateLanguageTable()
end
