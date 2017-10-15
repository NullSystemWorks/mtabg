local sx, sy = guiGetScreenSize()
local currentLangIndex = 1
local changeTime = 1000
local tick = 0

local function renderString()
	dxDrawText ( Language.getCurrent(), sx*.01, sy*.1)
	local count = 1
	for k, v in pairs(Language[Language.getCurrent()]) do
		dxDrawText ( v, sx*.01, sy*.1 + 15*count)
		count = count + 1
	end
end

local function drawAvailableLangages()
	dxDrawText(Language.getCurrentName(), 500, 515)
	if ((getTickCount() - tick) >= changeTime) then
		currentLangIndex = currentLangIndex < Language.getCount() and currentLangIndex + 1 or 1
		Language.set(Language.available[currentLangIndex])
		tick = getTickCount()
	end
end

local function checkStringTableOnInit()
	if Language.getCount() > 0 then
		addEventHandler("onClientRender", root, renderString)
		addEventHandler("onClientRender", root, drawAvailableLangages)
	else
		outputDebugString("Test failed: error parsing language table!", 1)
	end
end
-- addEventHandler("onClientResourceStart", root, checkStringTableOnInit)
