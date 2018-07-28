local targetResource = "battlegrounds"
local targetResourcePath = ":" ..targetResource.. "/"
local XMLFilePath = targetResourcePath.. "meta.xml"
local metaFile
local luaWorkingFile
local luaWorkingFileName
local luaWorkingFileNumber = 1
local luaFilePaths = {}

local function loadXML()
	metaFile = XML.load(XMLFilePath)
end

local function unloadXML()
	metaFile:unload()
	metaFile = nil
end

local function insertNameIntoTable()
	table.insert(luaFilePaths, luaWorkingFileName)
end

local function getName()
	luaWorkingFileName = targetResourcePath..luaWorkingFile:getAttributes().src
end

local function register()
	getName()
	insertNameIntoTable()
end

local function extractNames()
	repeat
		luaWorkingFile = metaFile:findChild("script", luaWorkingFileNumber - 1 )
		register()
		luaWorkingFileNumber = luaWorkingFileNumber + 1
	until not metaFile:findChild("script", luaWorkingFileNumber - 1 )
end

function LanguageParser.getLuaFilePaths()
	loadXML()
	extractNames()
	unloadXML()
	return luaFilePaths
end
