Notification = {}

local maxLines = 8
local sx,sy = guiGetScreenSize()
local rootx = 0.015625*sx
local rooty = 0.185185*sy + (maxLines+1)*15
local font = DxFont("/font/bitstream.ttf", 9)
local sideMessages = {}

local timerRemove
local function scheduleRemoval()
	if isTimer(timerRemove) then
		killTimer(timerRemove)
		timerRemove = nil
	end
	timerRemove = Timer(function() sideMessages = {} end, 5000, 1)
end

function Notification.send(message)
	if #sideMessages >= maxLines then
		table.remove(sideMessages, maxLines)
	end
	table.insert(sideMessages, 1, message)
	outputConsole(message)
	scheduleRemoval()
end

local function draw()
	for messageNumber, message in pairs(sideMessages) do
		local ty = rooty - messageNumber*15
		dxDrawText(message, rootx + 1, ty + 1, 0, 0, 0xFF000000, 1, font)
		dxDrawText(message, rootx, ty, 0, 0, 0xFFCCCCCC, 1, font)
	end
end
addEventHandler("onClientRender", root, draw)
