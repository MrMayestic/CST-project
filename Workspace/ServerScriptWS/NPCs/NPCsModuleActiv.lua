--local SPMoudule = require(game.ReplicatedStorage:WaitForChild('Modules').NPCsModule)
--local spawnModule = require(game.ReplicatedStorage.Modules.NPCsSpawnModule)
local waiter = game.Workspace:WaitForChild('Plots'):WaitForChild('Plot8'):WaitForChild('PlacedObjects')

task.wait(1.5)

for i,n in pairs(game.Workspace.Plots:GetChildren()) do
	n.PlacedObjects.ChildAdded:Connect(function(model)
		if model:FindFirstChild('NPCsModule') then
			local module = require(model.NPCsModule)
			module.makeEvent()
			wait()
			local start = model.NPCsModule.Start
			wait()
			start:Fire()
		end
	end)
	if n:FindFirstChild('NPCsSpawnModule') then
		local module = require(n.NPCsSpawnModule)
		module.makeEvent()
		wait()
		local start = n.NPCsSpawnModule.Start
		wait()
		start:Fire()
	end
	if n:FindFirstChild('StoremanWorkModule') then
		local module = require(n.StoremanWorkModule)
		module.makeEvent()
		wait()
		local start = n.StoremanWorkModule.Start
		wait()
		start:Fire()
	end
end



--spawnModule.doTasks()