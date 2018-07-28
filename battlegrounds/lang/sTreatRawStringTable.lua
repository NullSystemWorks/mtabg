local LANG_START_COLUMN = 3
local STRING_START_ROW = 2
local STRING_NAME_COLUMN = 2
local HEADER_ROW = 1

local workingRow
local workingColumn


local function getCellNumber()
	return (workingRow - 1)*LanguageParser.columnCount + workingColumn
end

local function getCellString()
	return LanguageParser.rawLanguageStrings[getCellNumber()]
end

local function createNewLanguageEntry()
	table.insert(LanguageParser.availableLanguages, getCellString())
end

local function registerStringsForLanguage()
	local oldWorkingRow = workingRow
	local currentLanguage = getCellString()
	LanguageParser.stringsOfALanguage[currentLanguage] = {}
	for row = STRING_START_ROW, LanguageParser.rowCount do
		workingRow = row
		table.insert(LanguageParser.stringsOfALanguage[currentLanguage],
		             getCellString())
	end
	workingRow = oldWorkingRow
end

local function registerStringNames()
	if workingColumn == STRING_NAME_COLUMN
	and workingRow >= STRING_START_ROW then
		table.insert(LanguageParser.stringNames, getCellString())
	end
end

local function registerLanguage()
	if workingRow == HEADER_ROW and workingColumn >= LANG_START_COLUMN then
		createNewLanguageEntry()
		registerStringsForLanguage()
	end
end

local function registerLanguageNames()
	for k, language in ipairs(LanguageParser.availableLanguages) do
		table.insert(LanguageParser.availableLanguageNames,
		             LanguageParser.stringsOfALanguage[language][1])
	end
end

local function clearStringTables()
	LanguageParser.stringNames = {}
	LanguageParser.availableLanguages = {}
	LanguageParser.availableLanguageNames = {}
	LanguageParser.stringsOfALanguage = {}
end

function LanguageParser.treatRawStringTable()
	clearStringTables()
	for row = 1, LanguageParser.rowCount do --y
		for column = 1, LanguageParser.columnCount do --x
			workingRow = row; workingColumn = column
			registerStringNames()
			registerLanguage()
			-- iprint(column, row, getCellNumber())
		end
	end
	registerLanguageNames()
	-- iprint(LanguageParser.stringNames)
	-- iprint(LanguageParser.stringsOfALanguage)
	-- iprint(LanguageParser.availableLanguageNames)
end
