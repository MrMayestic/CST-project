local frame = script.Parent
local hideShow = frame.HideShow
local showToggle = false

hideShow.MouseButton1Click:Connect(function()
	if showToggle then
		frame:TweenPosition(UDim2.new(1,0,0.122,0),0,0,0.25)
		showToggle = false
		hideShow.Text = "<<"
	else
		frame:TweenPosition(UDim2.new(0.914,0,0.122,0),0,0,0.25)
		showToggle = true
		hideShow.Text = ">>"
	end
end)

game.ReplicatedStorage.Events.RESETGUI.OnClientEvent:Connect(function(toggle)
	if not toggle then
		frame:TweenPosition(UDim2.new(1,0,0.122,0),0,0,0.25)
		showToggle = false
		hideShow.Text = "<<"
	end
end)