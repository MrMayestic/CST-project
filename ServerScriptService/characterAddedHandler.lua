local players = game:GetService('Players')
local physics = game:GetService("PhysicsService")

local playersCol = "Players"

physics:RegisterCollisionGroup(playersCol)

players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function(char)
		task.wait(1)
		for i, v in ipairs(char:GetChildren()) do
			if v.ClassName == "MeshPart" or v.ClassName == "Part" then
				v.CollisionGroup = playersCol
			end
		end
	end)
end)