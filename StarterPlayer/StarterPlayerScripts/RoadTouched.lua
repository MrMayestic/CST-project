
local plr = game.Players.LocalPlayer
local toggle = true
local road = workspace.Road
local tochers = workspace:WaitForChild("Tochers")
local waiter = plr:WaitForChild("PlayerGui"):WaitForChild("BuildUI"):WaitForChild("RBFrame")
local waiter2 = workspace:WaitForChild("Seaside"):WaitForChild("Model")

task.wait(6)

for i,n in pairs(tochers:GetChildren()) do
	task.wait()
	n.Touched:Connect(function(hit)
		wait()
		--pcall(function() 
			if hit.Parent.Name == plr.Name and toggle then
				toggle = false
				hit.Parent.Humanoid.WalkSpeed += 50
			end
		--end)
	end)
	task.wait()
	n.TouchEnded:Connect(function(hit)
		--pcall(function() 
			if hit.Parent.Name == plr.Name and not toggle then
				toggle = true
				hit.Parent.Humanoid.WalkSpeed -= 50
			end
		--end)
	end)
	task.wait()
end

