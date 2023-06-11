local UI = script.Parent.Parent
local RM = script.Parent
local plr = game.Players.LocalPlayer
local toggle = true
local getPlot = game.ReplicatedStorage.Remotes.requestPlot
local plot = getPlot:InvokeServer()
local AudioPlayer = require(game.ReplicatedStorage.Modules:WaitForChild("AudioModule"))

UI.ResetMenu.MouseButton1Click:Connect(function()
	if not plr:FindFirstChild("leaderstats") then
		return
	end
	if toggle and not plr:GetAttribute("DoesTutorial") then
		AudioPlayer.playAudio("Click")
		toggle = false
		UI.ResetFrame.Active = true
		UI.ResetFrame.Visible = true
		UI.ResetMenu.Text = "Close"
	else
		toggle = true
		UI.ResetFrame.Active = false
		UI.ResetFrame.Visible = false
		UI.ResetMenu.Text = "Reset Menu"
		wait()
	end
end)


RM.ResetShop.MouseButton1Click:Connect(function()
	AudioPlayer.playAudio("Click")
	UI.ShopFrame.Visible = true
	UI.ShopFrame.Active = true
	UI.ShopFrame:TweenPosition(UDim2.new(0, 0,1.139, 0),0,0,0.2)
	wait(0.5)
	game.ReplicatedStorage.Events.RESETGUI:FireServer()
end)

RM.ResetMagazine.MouseButton1Click:Connect(function()
	AudioPlayer.playAudio("Click")
	UI.AddTowarFrame.Visible = true
	UI.InfoFrame.Visible = true
	UI.AddTowarFrame.Active = true
	UI.InfoFrame.Active = true
	UI.AddTowarFrame:TweenPosition(UDim2.new(0.353, 0, 1.376, 0),0,0,0.5) 
	UI.InfoFrame:TweenPosition(UDim2.new(0.353, 0,1.300, 0),0,0,0.5)
	game.ReplicatedStorage.Events.RESETGUI:FireServer()
end)

RM.ResetManageMenu.MouseButton1Click:Connect(function()
	AudioPlayer.playAudio("Click")
	UI.DisplayTableFrame.Visible = true
	UI.DisplayTableFrame.Active = true
	UI.DisplayTableFrame:TweenPosition(UDim2.new(0.16, 0, 1.322, 0),0,0,0.5)
	UI.ShelfFrame.Visible = true
	UI.ShelfFrame.Active = true
	UI.ShelfFrame:TweenPosition(UDim2.new(0.54, 0, 1.322, 0),0,0,0.5)
	game.ReplicatedStorage.Events.RESETGUI:FireServer()
end)

RM.ResetNPC.MouseButton1Click:Connect(function()
	AudioPlayer.playAudio("Click")
	game.ReplicatedStorage.Events.STOPNow:FireServer(plot)
end)


RM.RESETALL.MouseButton1Click:Connect(function()
	game.ReplicatedStorage.Events.Other.unsetHR:Fire()
	AudioPlayer.playAudio("Click")
	game.ReplicatedStorage.Events.RESETALL:FireServer()

end)
RM.RESETRBShop.MouseButton1Click:Connect(function()
	AudioPlayer.playAudio("Click")
	UI.RBFrame:TweenPosition(UDim2.new(0.297, 0,1.278, 0),0,0,0.5)
	wait(0.65)
	UI.RBFClose.Visible = true		
end)

game.ReplicatedStorage.Events.RESETGUI.OnClientEvent:Connect(function()
	toggle = true
	UI.ResetFrame.Active = false
	UI.ResetFrame.Visible = false
	UI.ResetMenu.Text = "Reset Menu"
	wait()
end)