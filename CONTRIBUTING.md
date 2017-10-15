# Writing Translatable Code

We use a preprocessor to extract user-facing strings to a spreadsheet which holds all the string IDs and their correspondent messages on each available language. In order for this system to work, all user-facing strings must be represented in code by a string that identifies where they are displayed and their supposed meaning to the user, then wrapped in the `str()` translation function. **Do not hard code these strings.** The string name should stand by itself in meaning, in a way that looking at it's name should be enough to know what it's supposed to say.

**The preprocessor** will run when the resource starts, identifying all proper uses of the translation function and will add the corresponding new entries to the spreadsheet. After the spreadsheet is populated with the new string IDs, fill the columns for the available languages or add new languages. **Do not add rows to the spreadsheet**. Empty language entries will default to English, empty English entries will default to the string ID.

**The spreadsheet** can be found at `/battlegrounds/lang/lang.fods` and can be edited using LibreOffice.

### Usage examples:
```lua
outputChatBox(str("loginPanelNoSerialError"))
```

It's also possible to pass variables to be formated and used by the translation function:
```lua
guiSetText(guiTextObject, str("statisticsMenuPlayerName", localPlayer.name))
```
In the language spreadsheet, use `%s` to represent a variable that will be in the final string:

String Name|en|pt
---|---|---
statisticsMenuPlayerName| Statistics for %s| Estatísticas de %s

The `%s` token will be replaced with the variable value:

>- Statistics for CoolPlayer7
>- Estatísticas de CoolPlayer7

### Language change event

In every file that calls the translation function less than once per frame there should be declared a local function `changeLanguage` attached to `onUserLanguageChange` event. This function should be responsible for updating all variables/objects using the translation function.

Example:

```lua
local function changeLanguage(newLang)
	LoginScreen.label[4]:setText(str("loginPanelLoginButton"))
	LoginScreen.label[5]:setText(str("loginPanelRegisterButton"))
end
addEventHandler("onUserLanguageChange", resourceRoot, changeLanguage)
```

It's responsibility of contributors and code reviewers to ensure that all user-facing strings are compatible with the translation system.
