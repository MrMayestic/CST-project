local RS = game.ReplicatedStorage
local lsmodule = require(game.ReplicatedStorage.Modules.LeaderstatsModule)

task.wait(1)

while true do
	task.wait(2)
	lsmodule.Reset()
	lsmodule.SetLS()
end