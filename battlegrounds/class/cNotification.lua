Notification = {}

local maxLines = 8
local sx,sy = guiGetScreenSize()
local rootx = 0.015625*sx
local rooty = 0.185185*sy + (maxLines+1)*15
local bitstream = dxCreateFont("/font/bitstream.ttf", 9)
local sideMessages = {}

local messageRemoverTimer
local function scheduleRemoval()
	if messageRemoverTimer and isTimer(messageRemoverTimer) then
		killTimer(messageRemoverTimer)
		messageRemoverTimer = nil
	end
	messageRemoverTimer = setTimer(function() sideMessages = {} end, 5000, 1)
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
		dxDrawText(message, rootx + 1, ty + 1, 0, 0, 0xFF000000, 1, bitstream)
		dxDrawText(message, rootx, ty, 0, 0, 0xFFCCCCCC, 1, bitstream)
	end
end
addEventHandler("onClientRender", root, draw)
