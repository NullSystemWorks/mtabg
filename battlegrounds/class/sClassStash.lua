ClassStash = {}

local stash = {}

function ClassStash.save(className)
	stash[className] = _G[className]
end

function ClassStash.get(className)
	return stash[className]
end
