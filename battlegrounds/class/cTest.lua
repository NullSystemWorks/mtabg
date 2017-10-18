local function sendToSideChat()
	for i=1,10 do
		Notification.send("This is a test message. This is a test message")
	end
end

local function testPixelTexture()
	pix = PixelTexture.new(255, 0, 0, 255, 500, 500, 128, 64)
	pix:setRendering(true)
	setTimer(function() pix:fadeOut(2000) end, 5000, 1)
	setTimer(function() pix:setR(150) end, 4000, 1)
	setTimer(function() pix:setG(150) end, 3000, 1)
	setTimer(function() pix:setB(150) end, 2000, 1)
end
