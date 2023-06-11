local clientevent = game.ReplicatedStorage.Events.ModelEvents.ClientModel
local servermodel = game.ReplicatedStorage.Events.ModelEvents.ServerModel


clientevent.OnServerEvent:Connect(function(plr, namemodel)
	servermodel:FireClient(plr , namemodel)
end)

game.ReplicatedStorage.Events.ModelEvents.Close.OnServerEvent:Connect(function(plr)
	game.ReplicatedStorage.Events.ModelEvents.Close:FireClient(plr)
end)

game.ReplicatedStorage.Events.MagazynEvents.Close.OnServerEvent:Connect(function(plr)
	game.ReplicatedStorage.Events.MagazynEvents.Close:FireClient(plr)
end)