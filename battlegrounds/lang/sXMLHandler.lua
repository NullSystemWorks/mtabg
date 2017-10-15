local tableTableRowNode, textNode, cellString
local workingRow, workingColumn
local tableTableNode, tableTableChildren
local rootNode
local XMLFilePath = "lang/language.fods"

local function loadXML()
	rootNode = XML.load(XMLFilePath)
end

local function saveXML()
	rootNode:saveFile()
end

local function unloadXML()
	rootNode:unload()
	rootNode = nil
end

local function clearRawTable()
	LanguageParser.rawLanguageStrings = {}
end

local function navigateToTargetNode()
	local bodyNode = rootNode:findChild("office:body", 0)
	local spreadsheetNode = bodyNode:findChild("office:spreadsheet", 0)
	tableTableNode = spreadsheetNode:findChild("table:table", 0)
	tableTableChildren = tableTableNode:getChildren()
end

local function countRowsAndColumns()
	LanguageParser.columnCount, LanguageParser.rowCount = 0, 0
	for k, children in ipairs(tableTableChildren) do
		if children:findChild("table:table-cell", 0) then
			LanguageParser.rowCount = LanguageParser.rowCount + 1
		else
			LanguageParser.columnCount = LanguageParser.columnCount + 1
		end
	end
end

local function checkForValue()
	if textNode then
		cellString = textNode:getValue()
	else
		cellString = false
	end
end

local function saveValue()
	table.insert(LanguageParser.rawLanguageStrings, cellString)
end

local function findTableTableRowNode()
	tableTableRowNode = tableTableNode:findChild("table:table-row", workingRow - 1)
end

local function findTextNode()
	local cellNode = tableTableRowNode:findChild("table:table-cell", workingColumn - 1)
	if cellNode then
		textNode = cellNode:findChild("text:p", 0)
	else
		textNode = false
	end
end

local function saveSpreadsheetHash()
	tableTableNode:setAttribute("table:hash", LanguageParser.spreadsheetHash)
	saveXML()
end

local function getPreviousSpreadsheetHash()
	LanguageParser.previousSpreadsheetHash = tableTableNode:getAttribute("table:hash")
end

local function hashSpreadsheet()
	local buffer = ""
	for _, v in pairs(LanguageParser.rawLanguageStrings) do
		buffer = buffer..tostring(v)
	end
	LanguageParser.spreadsheetHash = hash("md5", buffer)
end

local function compareSpreadSheetHash()
	if LanguageParser.previousSpreadsheetHash
	and LanguageParser.previousSpreadsheetHash == LanguageParser.spreadsheetHash then
		LanguageParser.isLanguageTableUpToDate = true
	else
		LanguageParser.isLanguageTableUpToDate = false
		saveSpreadsheetHash()
	end
	-- iprint(LanguageParser.spreadsheetHash.. " : " ..tostring(not LanguageParser.isLanguageTableUpToDate))
end

function LanguageParser.checkIfSpreadSheetChanged()
	loadXML()
	navigateToTargetNode()
	getPreviousSpreadsheetHash()
	hashSpreadsheet()
	compareSpreadSheetHash()
	unloadXML()
end

function LanguageParser.XMLunpackToStringTable()
	loadXML()
	navigateToTargetNode()
	countRowsAndColumns()
	clearRawTable()
	for row = 1, LanguageParser.rowCount do
		workingRow = row
		findTableTableRowNode()
		for column = 1, LanguageParser.columnCount do
			workingColumn = column
			findTextNode()
			checkForValue()
			saveValue()
		end
	end
	unloadXML()
end

local newStringEntry
local workingRowNode
local workingCellNode

local function createCell()
	workingCellNode = workingRowNode:createChild("table:table-cell")
end

local function addNumberIndexCell()
	createCell()
	workingCellNode:setAttribute("office:value-type", "float")
	workingCellNode:setAttribute("office:value", LanguageParser.rowCount)
	workingCellNode:setAttribute("calcext:value-type", "float")
	workingCellNode:createChild("text:p"):setValue(LanguageParser.rowCount)
	LanguageParser.rowCount = LanguageParser.rowCount + 1
end

local function addStringNameCell()
	createCell()
	workingCellNode:setAttribute("office:value-type", "string")
	workingCellNode:setAttribute("calcext:value-type", "string")
	workingCellNode:createChild("text:p"):setValue(newStringEntry)
end

local function addRow()
	workingRowNode = tableTableNode:createChild("table:table-row")
	workingRowNode:setAttribute("table:style-name", "ro1")
end

local function addLanguageEntry()
	addRow()
	addNumberIndexCell()
	addStringNameCell()
end

function LanguageParser.addNewEntriesToSpreadsheet(newEntries)
	loadXML()
	navigateToTargetNode()
	countRowsAndColumns()
	for newEntry in pairs(newEntries) do
		newStringEntry = newEntry
		addLanguageEntry()
	end
	if newStringEntry then
		saveXML()
	end
	unloadXML()
end
