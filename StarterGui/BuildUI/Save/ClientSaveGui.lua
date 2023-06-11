local errormodule = require(game.ReplicatedStorage.Modules.ErrorModule)
local plr = game.Players.LocalPlayer
local toggle = true
local AudioPlayer = require(game.ReplicatedStorage.Modules:WaitForChild("AudioModule"))

script.Parent.MouseButton1Click:Connect(function()
	if not plr:FindFirstChild("leaderstats") then
		return
	end

	if toggle and not plr:GetAttribute("DoesTutorial") then
		toggle = false
		AudioPlayer.playAudio("Click")
		if plr:GetAttribute("CanSave") == true then
			game.ReplicatedStorage.Events.Serialize:FireServer()
			wait()
			game.ReplicatedStorage.Events.SaveHandler:FireServer()
			wait(0.05)
			errormodule.infoFunc(plr,true)
		end
		wait(7)
		toggle = true
	end
end)

game.ReplicatedStorage.Events.visibleOff.OnClientEvent:Connect(function()
	plr.PlayerGui.BuildUI.SaveLoadPI.Visible = false
end)