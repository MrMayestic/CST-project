local max = script.Parent
local fire = max.Fire
local bar = max.Bar
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local uis = game:GetService("UserInputService")


local x = mouse.X
local down = false

max.MouseButton1Down:Connect(function()
	local ap = Vector2.new(max.AbsolutePosition.X, max.AbsolutePosition.Y)		
	bar.Size = UDim2.new(0, (mouse.X - ap.X), 1, 0)
	fire.Value = true
	down = true
 	
end)

uis.InputEnded:Connect(function(input, gp)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		
		down = false
		fire.Value = false
	
	end
	
end)

mouse.Move:Connect(function()
	local ap = Vector2.new(max.AbsolutePosition.X, max.AbsolutePosition.Y)
	local as = Vector2.new(max.AbsoluteSize.X, max.AbsoluteSize.Y)
	if down == true then
		
		fire.Value = false
		fire.Value = true
		
		if mouse.X < ap.X then
			
			bar.Size = UDim2.new(0, 0, 1, 0)
			
		elseif mouse.X > (ap.X + as.X) then
			
			bar.Size = UDim2.new(0, as.X, 1, 0)
		
		else
			
			bar.Size = UDim2.new(0, (mouse.X - ap.X), 1, 0)
			
		end
			
	end
	
end)
