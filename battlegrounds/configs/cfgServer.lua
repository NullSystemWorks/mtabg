--[[
	
				MTA:BG
			MTA Battlegrounds
	Developed By: L, CiBeR, neves768, 1BOY

]]--

--[ Dev Settings ]--
gameplayVariables['allowstats'] = true -- Allow or disallow stats being sent to the dev team. | DEFAULT: true


--[ Match Settings ]--
gameplayVariables['matchtime'] = 1800 -- Time in seconds the match will last | DEFAULT: 1800(30 min)
gameplayVariables['enablerespawn'] = true -- Enable respawn when time is over respawn timer | DEFAULT: true
gameplayVariables['respawntime'] = 600 -- Minimum time left to allow respawn | DEFAULT: 600(10 min)
gameplayVariables['afktime'] = 300 -- Max AFK time before auto-kill | DEFAULT: 300(5 min)

--[ Enviorment Settings ]--
gameplayVariables['radiationrate'] = 1 -- Multiplier for damage taken by radiation | DEFAULT: 1


--[ Database Settings ]--
gameplayVariables['database'] = 0 -- Define DB type to use | 0 = MySQL | 1 = Default MTA(Not Recommended| Deprecated)
gameplayVariables['db_host'] = "127.0.0.1" -- Define our MySQL Host | DEFAULT: 127.0.0.1
gameplayVariables['db_user'] = '' -- Define our MySQL User
gameplayVariables['db_port'] = 3306 -- Define our MySQL Port | DEFAULT: 3306
gameplayVariables['db_name'] = 'mtabg' -- Define our MySQL Database name | DEFAULT: mtabg
