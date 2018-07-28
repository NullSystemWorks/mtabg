local sx, sy = guiGetScreenSize()
local rootx = sx*0.008854167 --17
local rooty = sy*0.225925926 --244
local languageComboBox
local languageCodes = {}

local function setNewLanguage()
	local selectedItem = languageComboBox:getSelected()
	local languageName = languageComboBox:getItemText(selectedItem)
	Language.set(languageCodes[languageName])
end

local function createComboBox()
	languageComboBox = guiCreateComboBox(rootx, rooty, 100, 20,
	                                     Language.getCurrentName(), false)
	guiComboBoxAdjustHeight(languageComboBox, Language.getCount())
end

local function getAvailableLanguages()
	for languageIndex, languageCode in ipairs(Language.getAvailable()) do
		local languageName = Language.getLanguageNameFromCode(languageCode)
		languageCodes[languageName] = languageCode
	end
end

local function populateCombobox()
	getAvailableLanguages()
	for languageName, languageCode in pairs(languageCodes) do
		guiComboBoxAddItem(languageComboBox, languageName)
	end
end

local function showComboBox()
	languageComboBox:setVisible(true)
end

local function hideComboBox()
	languageComboBox:setVisible(false)
end

local function toggleDialog()
	if languageComboBox:getVisible() then
		hideComboBox()
		setNewLanguage()
	else
		showComboBox()
	end
end

local function attachToButton()
	LanguageGlobeButton.setCallOnClick(toggleDialog)
end

local function createDialog()
	createComboBox()
	populateCombobox()
	hideComboBox()
	attachToButton()
end
addEventHandler("onClientResourceStart", resourceRoot, createDialog)

LanguageSelection = {}
function LanguageSelection.setShowing(shouldShow)
	LanguageGlobeButton.setRendering(shouldShow)
	if not shouldShow then
		languageComboBox:setVisible(false)
	end
end
