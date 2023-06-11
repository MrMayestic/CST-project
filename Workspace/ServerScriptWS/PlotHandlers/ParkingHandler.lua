local fireParking = script.handleParking
local defaultParkings = script.defaultParkings

local plotManager = require(game.ServerScriptService.ServerModules.PlotManager)

local errormodule = require(game.ReplicatedStorage.Modules.ErrorModule)

local function deleteOld(plot)
	local success = pcall(function()
		plot.ParkingBaseOLD:Destroy()
	end)
end

local function handleTerrain(val,plot)
	local multi = 1
	local plotNum = string.sub(plot.Name,#plot.Name,#plot.Name)

	if tonumber(plotNum) > 4 then
		multi = -1
	end

	local vector = plot.Plot.Position+Vector3.new(65.5,0,-57.5*multi)
	local cframe = CFrame.new(Vector3.new(vector.X,-4.35,vector.Z))

	game.Workspace.Terrain:FillBlock(cframe,Vector3.new(58,5,66),Enum.Material.Air)

	wait()

	local vector = plot.Plot.Position+Vector3.new(-65.5,0,-57.5*multi)
	cframe = CFrame.new(Vector3.new(vector.X,-4.35,vector.Z))

	game.Workspace.Terrain:FillBlock(cframe,Vector3.new(58,5,66),Enum.Material.Air)

	wait()

	if val == 0 then
		local vector = plot.Plot.Position+Vector3.new(65.5,0,-57.5*multi)
		cframe = CFrame.new(Vector3.new(vector.X,-4.35,vector.Z))
		game.Workspace.Terrain:FillBlock(cframe,Vector3.new(58,3,66),Enum.Material.Grass)
		wait()
		local vector = plot.Plot.Position+Vector3.new(-65.5,0,-57.5*multi)
		cframe = CFrame.new(Vector3.new(vector.X,-4.35,vector.Z))
		game.Workspace.Terrain:FillBlock(cframe,Vector3.new(58,3,66),Enum.Material.Grass)
	elseif val == 1 then
		local vector = plot.Plot.Position + Vector3.new(78,0,-57.5*multi)
		cframe = CFrame.new(Vector3.new(vector.X,-4.35,vector.Z))
		game.Workspace.Terrain:FillBlock(cframe,Vector3.new(32,3,66),Enum.Material.Grass)
		wait()
		local vector = plot.Plot.Position+Vector3.new(-78.5,0,-57.5*multi)
		cframe = CFrame.new(Vector3.new(vector.X,-4.35,vector.Z))
		game.Workspace.Terrain:FillBlock(cframe,Vector3.new(32,3,66),Enum.Material.Grass)
	end
end

local function makeDefaultParkings(plot)
	local base = game.ReplicatedStorage.Parkings:WaitForChild('ParkingBaseLvl0'):Clone()
	--negPart.Transparency = 1p
	--negPart.Transparency = 1p
	local X = 0.44
	local Y = -4.5
	local Z = -62.737
	local plotNum = string.sub(plot.Name,#plot.Name,#plot.Name)
	local Zchange = 1
	local plotNumSub = 1
	if tonumber(plotNum) > 4 then
		--orientDecrease = 180
		Z = -168.475
		plotNumSub = 4
		Zchange = -1
	end
	local cframe = CFrame.new(Vector3.new(plot.Plot.Position.X-X,Y,Z)) * CFrame.Angles(0,math.rad(plot.Plot.Orientation.Y),0)
	--base.PrimaryPart.Orientation = plot.Plot.Orientation
	--base.PrimaryPart.Position = plot.Plot.Position - Vector3.new(0,Y,Z)
	base:SetPrimaryPartCFrame(cframe)
	base.Parent = plot
	base.Name = "ParkingBase"
	handleTerrain(0,plot)
	plot:SetAttribute("Parking",0)
	return true
end

local function handleParking(plr,cost,value,plotSended)
	if plr then
		if plr.leaderstats.Cash.Value < cost and plr then
			errormodule.errorfuncGo(plr,"You don't have enough money to buy that.")
			return false
		end
	end
	
	local plot
	
	if plotSended then
		plot = plotSended
	else
		plot = plotManager.returnPlot(workspace.Plots, plr)
	end
	
	plot.ParkingBase.Name = "ParkingBaseOLD"
	
	plot:SetAttribute("Parking",value)

	local base = game.ReplicatedStorage.Parkings:FindFirstChild('ParkingBaseLvl'..value):Clone()
	--negPart.Transparency = 1p
	local X = 0.44
	local Y = -4.5
	local Z = -62.737

	local plotNum = string.sub(plot.Name,#plot.Name,#plot.Name)
	local Ychange = 1
	local plotNumSub = 1
	
	if tonumber(plotNum) > 4 then
		Z = -168.475  
		plotNumSub = 4
		Ychange = -1
	end
	base.Parent = plot
	base.Name = "ParkingBase"
	task.wait(1.5)
	local cframe = CFrame.new(Vector3.new(plot.Plot.Position.X-X,Y,Z)) * CFrame.Angles(0,math.rad(plot.Plot.Orientation.Y),0)
	base:SetPrimaryPartCFrame(cframe)
	
	local counter = 0

	handleTerrain(value,plot)
	plot:SetAttribute("Parking",value)
	task.wait(0.2)
	deleteOld(plot)
	wait()
	return true
end

fireParking.OnInvoke = handleParking
defaultParkings.OnInvoke = makeDefaultParkings