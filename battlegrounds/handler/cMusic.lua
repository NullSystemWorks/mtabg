Music = {}
Music.mainMenu = {}
Music.loginPanel = {}

local self

local url =
{
	["mainMenu"] =
	{
		"http://download1642.mediafireuserdownload.com/148sd69916ug/qmh5x3jp0cd3zuk/Unsung+Briefing+1.mp3",
		"http://download1081.mediafireuserdownload.com/rv3zjspijgag/c57alfaqwt6t8q2/Unsung+Briefing+2.mp3"
	},

	["loginPanel"] =
	{
		"http://download2128.mediafireuserdownload.com/qvjtavc0r4kg/d34cab53otlzqay/siege.mp3"
	}
}

local function stopMusic()
	if self then
		self:stop()
	end
	self = nil
end

local function playMusic(path, volume)
	stopMusic()
	self = Sound(path, true, true)
	self.volume = volume
end

function Music.mainMenu.play()
	local rng = math.random(1,2)
	playMusic(url.mainMenu[rng], 0.4)
end

function Music.loginPanel.play()
	playMusic(url.loginPanel[1], 0.1)
end

Music.mainMenu.stop = stopMusic
Music.loginPanel.stop = stopMusic
