local button = script.Parent
local frame = script.Parent.Parent.Parent:WaitForChild("BuildInfoFrame")

local openToggle = false

button.MouseButton1Click:Connect(function()
	if not openToggle then
		frame.Visible = true
		button.BackgroundColor3 = Color3.fromRGB(170, 255, 255)
		openToggle = true
	elseif openToggle then
		frame.Visible = false
		button.BackgroundColor3 = Color3.fromRGB(255,255,255)
		openToggle = false
	end
end)

game.ReplicatedStorage.Events.RESETGUI.OnClientEvent:Connect(function() 
	frame.Visible = false
	button.BackgroundColor3 = Color3.fromRGB(255,255,255)
	openToggle = false
end)