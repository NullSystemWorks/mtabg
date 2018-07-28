Music = {}
Music.mainMenu = {}
Music.loginPanel = {}

local self

local url =
{
	["mainMenu"] =
	{
		"https://dl.dropboxusercontent.com/s/0mc31vjvkhuedfi/Unsung%20Briefing%201.mp3?dl=0",
		"https://dl.dropboxusercontent.com/s/ql1654iyew9aat8/Unsung%20Briefing%202.mp3?dl=0"
	},

	["loginPanel"] =
	{
		"https://dl.dropboxusercontent.com/s/r472yqhq98mmjye/siege.mp3?dl=0"
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
	local rng = math.random(1, #url.mainMenu)
	playMusic(url.mainMenu[rng], 0.4)
end

function Music.loginPanel.play()
	playMusic(url.loginPanel[1], 0.1)
end

Music.mainMenu.stop = stopMusic
Music.loginPanel.stop = stopMusic
