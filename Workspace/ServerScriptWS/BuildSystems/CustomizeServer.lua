local plotManager = require(game.ServerScriptService.ServerModules.PlotManager)

local MarketplaceService = game:GetService("MarketplaceService")

local paidMaterials = {Enum.Material.Aluminum, Enum.Material.Granite, Enum.Material.Cobblestone, Enum.Material.Ice, Enum.Material.Marble, Enum.Material.Metal,Enum.Material.CorrodedMetal, Enum.Material.Sand, Enum.Material.Wood}

local function checkMaterials(material)
	return table.find(paidMaterials,Enum.Material[material])
end

game.ReplicatedStorage.Events.ColorOBJ.OnServerEvent:Connect(function(plr, obj, clr,secclr,Top1,Bottom1,Top2,Bottom2,material1,material2)
	local plot = plotManager.returnPlot(workspace.Plots, plr)

	if plr and obj then
		if material1 ~= "" and material1 then
			if checkMaterials(material1) then
				local hasPass = false

				local success, message = pcall(function()
					hasPass = MarketplaceService:UserOwnsGamePassAsync(plr.UserId, 172563240)
				end)

				if not success then
					material1 = nil
				end

				if not hasPass then
					material1 = nil
				end
			end
		end
		
		if material2 ~= "" and material2 then
			if checkMaterials(material2) then
				local hasPass = false

				local success, message = pcall(function()
					hasPass = MarketplaceService:UserOwnsGamePassAsync(plr.UserId, 172563240)
				end)

				if not success then
					material2 = nil
				end

				if not hasPass then
					material2 = nil
				end
			end
		end
		for i, v in pairs(obj.Parent.Paintable1:GetChildren()) do
			if v.Parent.Parent.Parent.Parent == plot then
				if clr then
					v.Color = clr
				end
				if material1 and material1 ~= "" then
					v.Material = Enum.Material[material1]
				end
			else
				warn("Don't try to paint other player models")
			end
		end
		for i, v in pairs(obj.Parent.Paintable2:GetChildren()) do
			if v.Parent.Parent.Parent.Parent == plot then
				if secclr then
					v.Color = secclr
				end
				if material2 and material2 ~= "" then
					v.Material = Enum.Material[material2]
				end
			else
				warn("Don't try to paint other player models")
			end
		end
		if Top1 then
			obj.Parent.Paintable1:SetAttribute("Top",Top1)
			obj.Parent.Paintable1:SetAttribute("Bottom",Bottom1)			
		end
		if Top2 then
			obj.Parent.Paintable2:SetAttribute("Top",Top2)
			obj.Parent.Paintable2:SetAttribute("Bottom",Bottom2)	
		end
	end

	game.ReplicatedStorage.Events.ColorOBJ:FireClient(plr,clr,secclr)
end)

game.ReplicatedStorage.Events.ColorPickerEvents.Pick.OnServerEvent:Connect(function(plr,frame)
	game.ReplicatedStorage.Events.ColorPickerEvents.Pick:FireClient(plr,frame)
end)

game.ReplicatedStorage.Events.ColorPickerEvents.ChangeFSC.OnServerEvent:Connect(function(plr,button)
	game.ReplicatedStorage.Events.ColorPickerEvents.ChangeFSC:FireClient(plr,button)
end)

game.ReplicatedStorage.Events.ColorPickerEvents.CustomProp.OnServerEvent:Connect(function(plr,obj,raz,dwa,secondCustom)
	obj:SetAttribute("Top",raz)
	obj:SetAttribute("Bottom",dwa)
	secondCustom:SetAttribute("Top",raz)
	secondCustom:SetAttribute("Bottom",dwa)
end)

game.ReplicatedStorage.Events.ColorPickerEvents.TeDrugie.OnServerEvent:Connect(function(plr)
	game.ReplicatedStorage.Events.ColorPickerEvents.TeDrugie:FireClient(plr)
end)

game.ReplicatedStorage.Events.ColorPickerEvents.SendObj.OnServerEvent:Connect(function(plr,obj,pickToggle)
	game.ReplicatedStorage.Events.ColorPickerEvents.SendObj:FireClient(plr,obj,pickToggle)
end)