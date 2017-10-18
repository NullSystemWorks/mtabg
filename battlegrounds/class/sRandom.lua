-- Random = {}

-- Get unpredictable values
local function entrophySource()
	return getRealTime().timestamp - getTickCount()
end

-- Warm up math.random
local function initRandom()
	math.randomseed(entrophySource())
	math.random() math.random() math.random()
end
initRandom()
