LanguageParser = {}

LanguageParser.rawLanguageStrings = {}
LanguageParser.availableLanguages = {}
LanguageParser.availableLanguageNames = {}
LanguageParser.stringNames = {}
LanguageParser.stringsOfALanguage = {}
LanguageParser.rowCount = 0
LanguageParser.columnCount = 0
LanguageParser.spreadsheetHash = nil
LanguageParser.previousSpreadsheetHash = nil
LanguageParser.isLanguageTableUpToDate = nil

local function parseLanguage()
	LanguageParser.XMLunpackToStringTable()
	LanguageParser.treatRawStringTable()
	LanguageParser.updateSpreadsheet()
end
addEventHandler("onResourceStart", resourceRoot, parseLanguage)
