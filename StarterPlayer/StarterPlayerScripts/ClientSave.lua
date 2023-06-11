local autoSaveTime = 120
local errormodule = require(game.ReplicatedStorage.Modules.ErrorModule)
local plr = game.Players.LocalPlayer

while true do
	task.wait(autoSaveTime)
	if plr and plr:GetAttribute("CanSave") == true then
	game.ReplicatedStorage.Events.Serialize:FireServer()
	game.ReplicatedStorage.Events.SaveHandler:FireServer()
	task.wait(0.1)
	errormodule.infoFunc(plr,true)
	end
end