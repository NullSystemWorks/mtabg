local function forceMatchStart(player, _, quickTick)
	lobby:setForcedTick(true)
	lobby:setQuickTick(quickTick)
	lobby:checkIfMatchShouldStart()
end
addCommandHandler("forceMatchStart", forceMatchStart, true, true)

--ACL: command.forceMatchStart
