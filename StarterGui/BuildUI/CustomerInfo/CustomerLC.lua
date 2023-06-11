local frame = script.Parent
local info = frame.info

local getPlot = game.ReplicatedStorage.Remotes.requestPlot

local plot = getPlot:InvokeServer()

while not plot do
	task.wait(0.1)
end

wait()

plot.Humans.ChildAdded:Connect(function()
	info.Text = #plot.Humans:GetChildren()
end)

plot.Humans.ChildRemoved:Connect(function()
	info.Text = #plot.Humans:GetChildren()
end)
