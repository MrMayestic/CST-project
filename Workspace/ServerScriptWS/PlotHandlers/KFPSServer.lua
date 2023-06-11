local RS = game.ReplicatedStorage

local plotManager = require(game.ServerScriptService.ServerModules.PlotManager)

local function ZwrotID(id)

	for i,n in pairs(game.Players:GetChildren()) do
		if n.UserId == id then
			return n
		end
	end

end

local function czyjest(tablica,name)
	local chekcer = false

	for i,n in pairs(tablica) do
		if n == name then
			chekcer=true
		end		
	end

	if chekcer then
		return false
	else
		return true
	end
end

function Kick(plr,ktorzy)
	local plot = plotManager.returnPlot(game.Workspace.Plots,plr)
	if plot.wazne.Owner.Value == plr.Name and plot then

		local cos = math.cos(math.rad(plot.Plot.Orientation.Y))

		local maxPosX = plot.Plot.Position.X + 95
		local minPosX = plot.Plot.Position.X - 95

		local maxPosZ = plot.Plot.Position.Z + ((plot.Base.Size.Z - plot.Plot.Size.Z/2) * cos)
		local minPosZ = plot.Plot.Position.Z - (90 * cos)

		if cos < 1 then
			local temp = maxPosZ
			maxPosZ = minPosZ
			minPosZ = temp
		end

		local function isInsideBrick(position)
			return position.X <= maxPosX and position.X >= minPosX
				and position.Z >= minPosZ and position.Z <= maxPosZ
		end

		for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
			local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
			if (hrp and isInsideBrick(hrp.Position)) and player.Name ~= plr.Name and czyjest(ktorzy,player.UserId) then
				local plrsPlot = plotManager.returnPlot(game.Workspace.Plots,player)
				hrp.Position = plrsPlot.Spawnery.Spawner.Position
			end
		end
	end
end


RS.Tester.OnServerEvent:Connect(Kick)

function Blist(plr,typo,toggle)
	local plot = plotManager.returnPlot(game.Workspace.Plots,plr)
	task.wait(0.1)
	if plot.wazne.Owner.Value == plr.Name then
		local choosedPlr = ZwrotID(typo)
		task.wait(0.1)
		pcall(function() 
			if toggle then
				RS.Events.BLISTClient:FireClient(choosedPlr,plot,true)
			else
				RS.Events.BLISTClient:FireClient(choosedPlr,plot,false)
			end
		end)
	end
end

RS.Events.BLIST.OnServerEvent:Connect(Blist)