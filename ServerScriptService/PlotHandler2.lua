local players=game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")

local plotManager = require(script.Parent.ServerModules.PlotManager)
local remoteRF = replicatedStorage.Remotes.requestPlot

local players = game.Players

local function assignPlot(plr)
	plotManager.assignPlot(workspace.Plots, plr)
end

local function requestPlot(plr)
	return plotManager.returnPlot(workspace.Plots, plr)
end

remoteRF.OnServerInvoke = requestPlot
players.PlayerAdded:Connect(assignPlot)