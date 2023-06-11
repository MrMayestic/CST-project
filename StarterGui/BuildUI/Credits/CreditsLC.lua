local frame = script.Parent
local button = script.Parent.Parent.CreditsButton
local openToggle = false
local plr = game.Players.LocalPlayer

button.MouseButton1Click:Connect(function()
	if not plr:FindFirstChild("leaderstats") then
		return
	end
	if not openToggle then
		frame:TweenPosition(UDim2.new(0.309, 0,0.206, 0),0,0,0.3)
		button.BackgroundColor3 = Color3.fromRGB(101, 158, 199)
		wait(0.2)
		openToggle = true
	else
		frame:TweenPosition(UDim2.new(0.309, 0,1.206, 0),0,0,0.3)
		button.BackgroundColor3 = Color3.fromRGB(27, 42, 53)
		wait(0.2)
		frame.CanvasPosition = Vector2.new(0,0)
		openToggle = false
	end
end)

game.ReplicatedStorage.Events.RESETGUI.OnClientEvent:Connect(function()
	frame:TweenPosition(UDim2.new(0.309, 0,1.206, 0),0,0,0.3)
	button.BackgroundColor3 = Color3.fromRGB(27, 42, 53)
	frame.CanvasPosition = Vector2.new(0,0)
	openToggle = false
end)