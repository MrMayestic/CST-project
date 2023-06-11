local dialogModule = require(game.ReplicatedStorage.Modules.DialogModule)

--local Graph = require(GraphModule)

local plr = game.Players.LocalPlayer

local RS = game.ReplicatedStorage

RS.Events.NPCEvents.dialogReq.OnClientEvent:Connect(function(state,npcChar)
	RS.Events.NPCEvents.dialogRes:FireServer(dialogModule.activate(state,npcChar,plr))
end)