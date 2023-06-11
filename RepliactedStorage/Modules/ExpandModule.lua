local expandmodule = {}

local PlotsStd = {"Plot1","Plot2","Plot3","Plot4"}
local PlotsRoz = {"Plot5","Plot6","Plot7","Plot8"}

function ReturnPlot(plotS)

	for i,n in pairs(PlotsStd) do
		if n == plotS then
			return "std"
		end
	end
	for i,n in pairs(PlotsRoz) do
		if n == plotS then
			return "roz"
		end
	end
end

local function handleTerrain(plot)
	local multi = 1
	local plotNum = string.sub(plot.Parent.Name,#plot.Parent.Name,#plot.Parent.Name)

	if tonumber(plotNum) > 4 then
		multi = -1
	end
	
	local vector = plot.Position+Vector3.new(1,0,51*multi)
	local cframe = CFrame.new(Vector3.new(vector.X,-4.35,vector.Z))

	game.Workspace.Terrain:FillBlock(cframe,Vector3.new(155,3,150),Enum.Material.Grass)
	
	wait()
	
	local vector = plot.Position
	cframe = CFrame.new(Vector3.new(vector.X,-4.35,vector.Z))

	game.Workspace.Terrain:FillBlock(cframe,Vector3.new(plot.Size.X,8,plot.Size.Z),Enum.Material.Air)
	
	wait()

	local vector = plot.Position
	cframe = CFrame.new(Vector3.new(vector.X,-4.35,vector.Z))

	game.Workspace.Terrain:FillBlock(cframe,Vector3.new(plot.Size.X,8,plot.Size.Z),Enum.Material.Air)
	
	wait()
	
	for i,n in pairs(plot:GetChildren()) do
		wait()
		local vector = n.Position
		cframe = CFrame.new(Vector3.new(vector.X,-4.35,vector.Z))

		game.Workspace.Terrain:FillBlock(cframe,Vector3.new(n.Size.X,8,n.Size.Z),Enum.Material.Air)
	end
end

function expandmodule.zmiana(plr, value, cost, plot, position,typ)
	if plr.leaderstats.Cash.Value >= cost then	
		plr.leaderstats.Cash.Value = plr.leaderstats.Cash.Value - cost
		expandmodule.plot(plr, plot, position,value,typ)
	else
		warn("YOU CAN'T")
	end		
end

function expandmodule.load(plr,plot,materialToggle)
	local ileL = plr.hidden.IleL.Value
	local ileC = plr.hidden.IleC.Value
	local ileR = plr.hidden.IleR.Value
	
	local check = true
	local newpos
	local newposZ
	if tonumber(string.sub(plot.Parent.Name,5,5)) > 4 then
		check = false
	end
	for i=1,ileL do
		local newplot = game.ReplicatedStorage.Plots.Plot:Clone()
		if check then
			newpos = plot.Position.X + plot.Size.X
			newposZ = plot.Position.Z +((plot.Size.Z * i)-plot.Size.Z)
		else
			newpos = plot.Position.X - plot.Size.X
			newposZ = plot.Position.Z -((plot.Size.Z * i)-plot.Size.Z)	
		end
		newplot.Position = Vector3.new(newpos,plot.Position.Y,newposZ)
		newplot.Parent = plot
		newplot.Name = "PlotL"..i
	end
	for i=2,ileC do
		local newplot = game.ReplicatedStorage.Plots.Plot:Clone()
		if check then
			newpos = plot.Position.X
			newposZ = plot.Position.Z +((plot.Size.Z * i)-plot.Size.Z)
		else
			newpos = plot.Position.X
			newposZ = plot.Position.Z -((plot.Size.Z * i)-plot.Size.Z)	
		end
		newplot.Position = Vector3.new(newpos,plot.Position.Y,newposZ)
		newplot.Parent = plot
		newplot.Name = "PlotC"..i
	end
	for i=1,ileR do
		local newplot = game.ReplicatedStorage.Plots.Plot:Clone()
		if check then
			newpos = plot.Position.X - plot.Size.X
			newposZ = plot.Position.Z +((plot.Size.Z * i)-plot.Size.Z)
		else
			newpos = plot.Position.X + plot.Size.X
			newposZ = plot.Position.Z -((plot.Size.Z * i)-plot.Size.Z)
		end
		newplot.Position = Vector3.new(newpos,plot.Position.Y,newposZ)
		newplot.Parent = plot
		newplot.Name = "PlotR"..i
	end
	if materialToggle then
		game.ReplicatedStorage.Events.SettingsFolder.WczytajMaterial:FireClient(plr)		
		game.ReplicatedStorage.Events.SettingsFolder.WczytajPaintRE:FireClient(plr)
	end
	
	local ratingMaxAdd = (ileL+ileR + (ileC - 1)) * 25
	
	plr.rating.RatingMax.Value += ratingMaxAdd
	
	wait()
	
	handleTerrain(plot)
end

function expandmodule.plot(plr, plot, position,value,typ,load)
	local ileL = plr.hidden.IleL
	local ileC = plr.hidden.IleC
	local ileR = plr.hidden.IleR
	local check = true
	if tonumber(string.sub(plot.Name,5,5)) > 4 then
		check = false
	end

	plot = plot.Plot
	local frame = plr.PlayerGui.BuildUI.ExpandPlotFrame
	local wich = ReturnPlot(plot.Name);
	local myvalue
	local newpos
	local newposZ

	if string.match(tostring(typ),"Left") then--or string.match(typ,"Left") then
		myvalue = "PlotL"..value
		if check then
			newpos = plot.Position.X + plot.Size.X
			newposZ = plot.Position.Z +((plot.Size.Z * value)-plot.Size.Z)
		else
			newpos = plot.Position.X - plot.Size.X
			newposZ = plot.Position.Z -((plot.Size.Z * value)-plot.Size.Z)	
		end
		if not load then
			ileL.Value +=1
		end
	elseif string.match(tostring(typ),"Right") then
		myvalue = "PlotR"..value
		if check then
			newpos = plot.Position.X - plot.Size.X
			newposZ = plot.Position.Z +((plot.Size.Z * value)-plot.Size.Z)
		else
			newpos = plot.Position.X + plot.Size.X
			newposZ = plot.Position.Z -((plot.Size.Z * value)-plot.Size.Z)
		end
		if not load then
			ileR.Value +=1
		end
	elseif string.match(tostring(typ),"Front") then
		myvalue = "PlotC"..value
		if check then
			newpos = plot.Position.X
			newposZ = plot.Position.Z +((plot.Size.Z * value)-plot.Size.Z)
		else
			newpos = plot.Position.X
			newposZ = plot.Position.Z -((plot.Size.Z * value)-plot.Size.Z)	
		end
		if not load then
			ileC.Value +=1
		end
	end
	local newplot = game.ReplicatedStorage.Plots.Plot:Clone()
	newplot.Position = Vector3.new(newpos,plot.Position.Y,newposZ)
	newplot.Parent = plot
	newplot.Name = myvalue
	newplot.Material = plot.Material
	newplot.Color = plot.Color

	plr.rating.RatingMax.Value += 25
	
	game.ReplicatedStorage.Events.ExpansionEvents.YepIboughtExp:FireClient(plr,typ)
	game.ReplicatedStorage.Events.AchivsEvents.ExpansionAdded:FireClient(plr)
	handleTerrain(plot)
end

return expandmodule
