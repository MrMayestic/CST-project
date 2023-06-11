local resetGui = game.ReplicatedStorage.Events.RESETGUI

resetGui.OnServerEvent:Connect(function(plr,toggle)
	game.ReplicatedStorage.Events.RESETGUI:FireClient(plr,toggle)
end)