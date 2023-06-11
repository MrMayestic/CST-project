local button = script.Parent
local nobek = true
local player = game.Players.LocalPlayer
local frame = player.PlayerGui.BuildUI.ExpandPlotFrame
local close = player.PlayerGui.BuildUI.ExpandPlotFrameClose
local AudioPlayer = require(game.ReplicatedStorage.Modules:WaitForChild("AudioModule"))

button.MouseButton1Click:Connect(function()
	if nobek and not player:GetAttribute("DoesTutorial") and player:FindFirstChild("leaderstats") then	
 		AudioPlayer.playAudio("Click")
		nobek = false
		frame:TweenPosition(UDim2.new(0.289, 0, 0.256, 0),0,0,0.5)
		close.Visible = true
	end
end)

close.MouseButton1Click:Connect(function()
	if not nobek then
		AudioPlayer.playAudio("Click")
		frame:TweenPosition(UDim2.new(0.289, 0, 1.110, 0),0,0,0.5)
		close.Visible = false
		nobek = true
	end
end)

game.ReplicatedStorage.Events.RESETGUI.OnClientEvent:Connect(function()
	frame:TweenPosition(UDim2.new(0.289, 0, 1.110, 0),0,0,0.5)
	nobek = true
	close.Visible = false
end)