--[[
	
				MTA:BG
			MTA Battlegrounds
	Developed By: L, CiBeR, neves768, 1BOY

]]--

-- Not in use for now until we ironed out game features & bugs
LobbyScreen = {
    gridlist = {},
    window = {},
    button = {},
    label = {}
}

LobbyScreen.window[1] = guiCreateWindow(-0.00, 0.00, 0.98, 1.00, "Lobby", true)
guiWindowSetMovable(LobbyScreen.window[1], false)
guiWindowSetSizable(LobbyScreen.window[1], false)
guiSetAlpha(LobbyScreen.window[1], 1.00)
LobbyScreen.gridlist[1] = guiCreateGridList(0.01, 0.13, 0.98, 0.41, true, LobbyScreen.window[1])
guiGridListAddColumn(LobbyScreen.gridlist[1], "Game ID", 0.2)
guiGridListAddColumn(LobbyScreen.gridlist[1], "Players", 0.2)
guiGridListAddColumn(LobbyScreen.gridlist[1], "Mode", 0.2)
guiGridListAddColumn(LobbyScreen.gridlist[1], "Current Status", 0.2)
LobbyScreen.label[1] = guiCreateLabel(0.01, 0.92, 0.37, 0.03, "MTA:Battlegrounds Version: 0.0.1a", true, LobbyScreen.window[1])
LobbyScreen.button[1] = guiCreateButton(0.02, 0.57, 0.11, 0.07, "Enter Game", true, LobbyScreen.window[1])    
guiSetVisible(LobbyScreen.window[1],false)


