local currentLanguage = "en"

function Language.getCount()
	return #Language.available
end

function Language.getAvailable()
	return Language.available
end

function Language.getAvailbleNames()
	return Language.availableNames
end

function Language.getLanguageNameFromCode(code)
	return Language[code].languageNameInLanguage
end

function Language.getCurrent()
	return currentLanguage
end

function Language.getCurrentName()
	return Language[currentLanguage].languageNameInLanguage
end

function Language.set(newLang)
	if newLang ~= Language.getCurrent() then
		currentLanguage = newLang
		triggerEvent("onUserLanguageChange", resourceRoot, newLang)
		if not (eventName == "onSetUserLanguage") then
			triggerServerEvent("onPlayerLanguageChange", resourceRoot, newLang)
		end
	end
end
addEvent("onUserLanguageChange", false)
addEvent("onSetUserLanguage", true)
addEventHandler("onSetUserLanguage", localPlayer, Language.set)

function str(stringName, ...)
	if arg.n == 0 then
		return Language[currentLanguage][stringName]
	else
		return string.format(Language[currentLanguage][stringName], unpack(arg))
	end
end
