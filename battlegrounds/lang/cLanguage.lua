local lang = "en"

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
	return lang
end

function Language.getCurrentName()
	return Language[lang].languageNameInLanguage
end

function Language.set(newLang)
	if newLang ~= Language.getCurrent() then
		lang = newLang
		triggerEvent("onUserLanguageChange", resourceRoot, newLang)
	end
end
addEvent("onUserLanguageChange", true)
addEventHandler("onUserLanguageChange", resourceRoot, Language.set)

function str(stringName, ...)
	if arg.n == 0 then
		return Language[lang][stringName]
	else
		return string.format(Language[lang][stringName], unpack(arg))
	end
end
