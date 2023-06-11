local checker = game.Workspace:WaitForChild('Plots'):WaitForChild('Plot8'):WaitForChild('Plot')

wait(0.1)
local parkingScript = workspace.ServerScriptWS.PlotHandlers.ParkingHandler
local defaultParkings = parkingScript.defaultParkings

for i,n in pairs(game.Workspace.Plots:GetChildren()) do
	task.wait()
	defaultParkings:Invoke(n)
end