local expandmodule = require(game.ReplicatedStorage.Modules.ExpandModule)
local valueodpal = game.ReplicatedStorage.Events.VALUEvents.VALUEODPAL
local errormodule = require(game.ReplicatedStorage.Modules.ErrorModule)
local plotManager = require(game.ServerScriptService.ServerModules.PlotManager)

local function plotodpal(plr, value, plot, position,slot)
	expandmodule.plot(plr, plot, position, value)
end

local function zmiana(plr, ktore)
	local plot = plotManager.returnPlot(workspace.Plots, plr)

	if ktore == "jojko" then
		expandmodule.load(plr, plot.Plot,true)
	else
		local position = plot.Plot.Position
		local ileile = ktore:GetAttribute("ile")
		local cost = ktore:GetAttribute("cost")
		if plr.leaderstats.Cash.Value >= cost then

			expandmodule.zmiana(plr,ileile,cost, plot, position,ktore)
		else
			errormodule.errorfuncGo(plr,"You don't have enough money to buy it.")
		end		
	end
end

valueodpal.OnServerEvent:Connect(zmiana)

--game.ReplicatedStorage.Events.ExpansionEvents.ServerExt.OnServerEvent:Connect(zmiana)