local lighting = game.Lighting
local can = false

function CanTrue()
	lighting.ClockTime = game.Workspace.Clock.Value
	can = true
end
function CanFalse(toggle)
	if toggle then
		lighting.ClockTime = 0
	else
		lighting.ClockTime = 12
	end
	can = false
end

game.ReplicatedStorage.ClockOn.Event:Connect(CanTrue)
game.ReplicatedStorage.ClockOff.Event:Connect(CanFalse)

while task.wait(0.01) do
	if can then
		game.Lighting.ClockTime = game.Workspace.Clock.Value
	end
end