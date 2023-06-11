local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local dataStoreService = game:GetService("DataStoreService")
local dataStore
local serializeE = replicatedStorage.Events.Serialize
local location
local plotManager = require(script.Parent.ServerModules.PlotManager)
local plot
local dataLoaded = nil
local tries = 3
local position
local towarmodule = require(game.ReplicatedStorage.Modules.TowarModule)
local errormodule = require(game.ReplicatedStorage.Modules.ErrorModule)

local parkingScript = workspace.ServerScriptWS.PlotHandlers.ParkingHandler
local handleParking = parkingScript.handleParking

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

--Color3.new(0.639216, 0.635294, 0.635294)
-- Saves models currently placed on the plane/plot
local function serialize(plr,toggle)
	local slPI
	if dataLoaded then
		if plr then
			if not plr:GetAttribute("CanSave") then
				return
			end
		else
			return
		end		
		
		pcall(function()
			slPI = plr.PlayerGui.BuildUI.SaveLoadPI
			slPI.Text = "Preparing to save plot data..."
		end)
		
		plot = plotManager.returnPlot(workspace.Plots, plr)
		location = plot.PlacedObjects

		local key = "uid_" .. plr.userId
		local count = 0 

		local data = {}

		-- Saves properties from all objects
		for i, obj in ipairs(plot.PlacedObjects:GetChildren()) do
			if obj.Name =="DisplayTable" or obj.Name == "Shelf" or obj.Name == "SmallShelf" then
				table.insert(data, {
					["name"] = obj.Name,
					["transform"] = {
						["x"] = plot.Plot.CFrame:ToObjectSpace(CFrame.new(obj.PrimaryPart.CFrame.p)).X;
						["y"] = plot.Plot.CFrame:ToObjectSpace(CFrame.new(obj.PrimaryPart.CFrame.p)).Y;
						["z"] = plot.Plot.CFrame:ToObjectSpace(CFrame.new(obj.PrimaryPart.CFrame.p)).Z;
						["r"] = obj.PrimaryPart.Orientation.Y;
					},
					["Color"] = {
						["R"] = obj.Paintable1.PrimaryPart.Color.R;
						["G"] = obj.Paintable1.PrimaryPart.Color.G;
						["B"] = obj.Paintable1.PrimaryPart.Color.B;
					};
					["Color1"] = {
						["R"] = obj.Paintable2.PrimaryPart.Color.R;
						["G"] = obj.Paintable2.PrimaryPart.Color.G;
						["B"] = obj.Paintable2.PrimaryPart.Color.B;
					},
					["ColorPoses"] = {
						["Paint1Top"] = obj.Paintable1:GetAttribute("Top");
						["Paint1Bottom"] = obj.Paintable1:GetAttribute("Bottom");
						["Paint2Top"] = obj.Paintable2:GetAttribute("Top");
						["Paint2Bottom"] = obj.Paintable2:GetAttribute("Bottom");
					};
					
					["Material"] = {
						["Material1"] = obj.Paintable1.PrimaryPart.Material.Name;
						["Material2"] = obj.Paintable2.PrimaryPart.Material.Name;
					},

					["Towar"] = {
						["artykul"] = obj.Towar.KtoryArtykul.Value;
						["ileartykul"] = obj.Towar.IleArtykul.Value;
					}
				})
			elseif string.match(obj.Name,"Light") then
				table.insert(data, {
					["name"] = obj.Name,
					["transform"] = {
						["x"] = plot.Plot.CFrame:ToObjectSpace(CFrame.new(obj.PrimaryPart.CFrame.p)).X;
						["y"] = plot.Plot.CFrame:ToObjectSpace(CFrame.new(obj.PrimaryPart.CFrame.p)).Y;
						["z"] = plot.Plot.CFrame:ToObjectSpace(CFrame.new(obj.PrimaryPart.CFrame.p)).Z;
						["r"] = obj.PrimaryPart.Orientation.Y;
					},

					["Color"] = {
						["R"] = obj.Paintable1.PrimaryPart.Color.R;
						["G"] = obj.Paintable1.PrimaryPart.Color.G;
						["B"] = obj.Paintable1.PrimaryPart.Color.B;
					};
					["Color1"] = {
						["R"] = obj.Paintable2.PrimaryPart.Color.R;
						["G"] = obj.Paintable2.PrimaryPart.Color.G;
						["B"] = obj.Paintable2.PrimaryPart.Color.B;
					};

					["ColorPoses"] = {
						["Paint1Top"] = obj.Paintable1:GetAttribute("Top");
						["Paint1Bottom"] = obj.Paintable1:GetAttribute("Bottom");
						["Paint2Top"] = obj.Paintable2:GetAttribute("Top");
						["Paint2Bottom"] = obj.Paintable2:GetAttribute("Bottom");
					};
					
					["Material"] = {
						["Material1"] = obj.Paintable1.PrimaryPart.Material.Name;
						["Material2"] = obj.Paintable2.PrimaryPart.Material.Name;
					},

					["Light"] = {
						["angle"] = obj.LightPart.Light.Angle;
						["bright"] =obj.LightPart.Light.Brightness;
						["onoff"] =obj.LightPart.Light:GetAttribute("KtoryTryb");
						["range"] =obj.LightPart.Light.Range;
					}
				})
			elseif obj.Name == "InfoSignOnWall" or obj.Name == "InfoSignOnCelling" then
				table.insert(data, {
					["name"] = obj.Name,
					["transform"] = {
						["x"] = plot.Plot.CFrame:ToObjectSpace(CFrame.new(obj.PrimaryPart.CFrame.p)).X;
						["y"] = plot.Plot.CFrame:ToObjectSpace(CFrame.new(obj.PrimaryPart.CFrame.p)).Y;
						["z"] = plot.Plot.CFrame:ToObjectSpace(CFrame.new(obj.PrimaryPart.CFrame.p)).Z;
						["r"] = obj.PrimaryPart.Orientation.Y;
					},
					["Color"] = {
						["R"] = obj.Paintable1.PrimaryPart.Color.R;
						["G"] = obj.Paintable1.PrimaryPart.Color.G;
						["B"] = obj.Paintable1.PrimaryPart.Color.B;
					};
					["Color1"] = {
						["R"] = obj.Paintable2.PrimaryPart.Color.R;
						["G"] = obj.Paintable2.PrimaryPart.Color.G;
						["B"] = obj.Paintable2.PrimaryPart.Color.B;
					},

					["ColorPoses"] = {
						["Paint1Top"] = obj.Paintable1:GetAttribute("Top");
						["Paint1Bottom"] = obj.Paintable1:GetAttribute("Bottom");
						["Paint2Top"] = obj.Paintable2:GetAttribute("Top");
						["Paint2Bottom"] = obj.Paintable2:GetAttribute("Bottom");
					};
					
					["Material"] = {
						["Material1"] = obj.Paintable1.PrimaryPart.Material.Name;
						["Material2"] = obj.Paintable2.PrimaryPart.Material.Name;
					},

					["TextSettings"] = {
						["signText"] = tostring(obj.Part.SurfaceGui.TextLabel.Text);
						["onoff"] = obj.Paintable2.LightPart.Light:GetAttribute("KtoryTryb");
						["bg"] = tostring(obj.Part.SurfaceGui.TextLabel.BackgroundColor3.R..","..obj.Part.SurfaceGui.TextLabel.BackgroundColor3.G..","..
							obj.Part.SurfaceGui.TextLabel.BackgroundColor3.B);
						["textCol"] = tostring(obj.Part.SurfaceGui.TextLabel.TextColor3.R..","..obj.Part.SurfaceGui.TextLabel.TextColor3.G..","..
							obj.Part.SurfaceGui.TextLabel.TextColor3.B);
					}
				})
			else
				table.insert(data, {
					["name"] = obj.Name,
					["transform"] = {
						["x"] = plot.Plot.CFrame:ToObjectSpace(CFrame.new(obj.PrimaryPart.CFrame.p)).X;
						["y"] = plot.Plot.CFrame:ToObjectSpace(CFrame.new(obj.PrimaryPart.CFrame.p)).Y;
						["z"] = plot.Plot.CFrame:ToObjectSpace(CFrame.new(obj.PrimaryPart.CFrame.p)).Z;
						["r"] = obj.PrimaryPart.Orientation.Y;
					},
					["Color"] = {
						["R"] = obj.Paintable1.PrimaryPart.Color.R;
						["G"] = obj.Paintable1.PrimaryPart.Color.G;
						["B"] = obj.Paintable1.PrimaryPart.Color.B;
					};
					["Color1"] = {
						["R"] = obj.Paintable2.PrimaryPart.Color.R;
						["G"] = obj.Paintable2.PrimaryPart.Color.G;
						["B"] = obj.Paintable2.PrimaryPart.Color.B;
					};
					
					["ColorPoses"] = {
						["Paint1Top"] = obj.Paintable1:GetAttribute("Top");
						["Paint1Bottom"] = obj.Paintable1:GetAttribute("Bottom");
						["Paint2Top"] = obj.Paintable2:GetAttribute("Top");
						["Paint2Bottom"] = obj.Paintable2:GetAttribute("Bottom");
					};
					
					["Material"] = {
						["Material1"] = obj.Paintable1.PrimaryPart.Material.Name;
						["Material2"] = obj.Paintable2.PrimaryPart.Material.Name;
					},
				})
			end
		end
		
		task.wait(0.15)
		
		pcall(function()
			slPI.Text = "Trying to save plot data..."
		end)

		local success, err

		-- To prevent errors and data loss
		repeat
			success, err = pcall(function()
				dataStore:SetAsync(key, data)
			end)

			count = count + 1
			if not success then
				task.wait(1.5)
			end
		until success or count >= tries

		if not success then
			errormodule.errorfuncGo(plr,"Failed to serialize data: Error code " .. tostring(err))
			--game.ReplicatedStorage.sendErrorB:Fire(plr,"Failed to serialize data: Error code " .. tostring(err))

			return
		end
	else
		errormodule.errorfuncGo(plr,"Data has not beed loaded. Do not attempt to set data when it has not been loaded.")
		return
	end
	if toggle then
		task.wait()
		game.ReplicatedStorage.Events.SlotEvents.tycoonDataSaved:Fire(plr,plot)
		dataStore = nil
	end
	pcall(function()
		slPI.Text = "DONE"
	end)
	task.wait(0.7)
	game.ReplicatedStorage.Events.visibleOff:FireClient(plr)
end


-- Loads the data back into the game
local function deserialize(plr,jojko,slot)
	task.wait()
	local slPI
	
	pcall(function()
		slPI = plr.PlayerGui.BuildUI.SaveLoadPI
		slPI.Text = "Getting plot data..."
	end)
	dataStore = dataStoreService:GetDataStore("DataBaseV"..slot)
	pcall(function()
		slPI.Text = "Loading plot data..."
	end)
	
	local key = "uid_" .. plr.userId
	local data

	local count = 0
	local success, err

	repeat
		success, err = pcall(function()
			data = dataStore:GetAsync(key)
		end)
		count = count + 1
		if not success then
			task.wait(1.5)
		end
	until  count >= tries or success 

	if not success then
		warn("Failed to read data: Error code " .. tostring(err))
		--game.ReplicatedStorage.sendErrorB:Fire(plr,"Failed to read data: Error code " .. tostring(err))
		return
	end
	
	task.wait()
	
	if data then
		local plot = plotManager.returnPlot(workspace.Plots, plr)
		-- Loads data
		for i, saved in pairs(data) do
			if saved.name == "model0" or saved.name == "model1" then
				dataLoaded = true
				return
			end
			local loadedModel
			local succ,err = pcall(function() 
				loadedModel = replicatedStorage.Models:FindFirstChild(saved.name):Clone()
			end)
				
			-- Makes sure a model is created only per model
			if succ then

				for _, o in pairs(loadedModel:FindFirstChild("Paintable1"):GetChildren()) do
					--wait()
					if o then
						o.Color = Color3.new(saved.Color.R, saved.Color.G, saved.Color.B)
					end
				end
				for _, o in pairs(loadedModel:FindFirstChild("Paintable2"):GetChildren()) do

					--wait()
					if o and saved.Color1 and saved.Color1.R and saved.Color1.G and saved.Color1.B then
						o.Color = Color3.new(saved.Color1.R, saved.Color1.G, saved.Color1.B)
					end
					--SET COLOR POSES--
					if o and saved.ColorPoses then
						if saved.ColorPoses.Paint1Top and saved.ColorPoses.Paint1Bottom then
							loadedModel:FindFirstChild("Paintable1"):SetAttribute("Top",saved.ColorPoses.Paint1Top)
							loadedModel:FindFirstChild("Paintable1"):SetAttribute("Bottom",saved.ColorPoses.Paint1Bottom)
						end
						if saved.ColorPoses.Paint2Top and saved.ColorPoses.Paint2Bottom then
							loadedModel:FindFirstChild("Paintable2"):SetAttribute("Top",saved.ColorPoses.Paint2Top)
							loadedModel:FindFirstChild("Paintable2"):SetAttribute("Bottom",saved.ColorPoses.Paint2Bottom)
						end
					end
				end
				if string.match(loadedModel.Name,"Light") then
					if saved.Light then
						loadedModel.LightPart.Light.Angle = saved.Light.angle
						loadedModel.LightPart.Light.Brightness = saved.Light.bright
						loadedModel.LightPart.Light:SetAttribute("KtoryTryb",saved.Light.onoff)

						local clock = workspace.Clock

						if saved.Light.onoff == 0 then
							loadedModel.LightPart.BrickColor = BrickColor.new(0.5,0.5,0.5)
							loadedModel.LightPart.Light.Enabled = false
						end
						if saved.Light.onoff == 1 then
							loadedModel.LightPart.BrickColor = BrickColor.new(1,1,1)
							loadedModel.LightPart.Light.Enabled = true
						end
						if saved.Light.onoff == 2 then
							if clock.Value >= 17.5 and clock.Value <= 6.5 then
								loadedModel.LightPart.BrickColor = BrickColor.new(1,1,1)
								loadedModel.LightPart.Light.Enabled = true
							end
							if clock.Value >= 6.5 and clock.Value <= 17.5 then
								loadedModel.LightPart.BrickColor = BrickColor.new(0.5,0.5,0.5)
								loadedModel.LightPart.Light.Enabled = false
							end
						end
						loadedModel.LightPart.Light.Range = saved.Light.range
					end

				end

				if loadedModel.Name == "InfoSignOnWall" or loadedModel.Name == "InfoSignOnCelling" then
					if saved.TextSettings then
						if saved.TextSettings.signText then
							loadedModel.Part.SurfaceGui.TextLabel.Text = saved.TextSettings.signText
						end
						if saved.TextSettings.onoff then
							local clock = workspace.Clock
							loadedModel.Paintable2.LightPart.Light:SetAttribute("KtoryTryb",saved.TextSettings.onoff)
							if saved.TextSettings.onoff == 0 then
								loadedModel.Paintable2.LightPart.BrickColor = BrickColor.new(0.5,0.5,0.5)
								loadedModel.Paintable2.LightPart.Light.Enabled = false

							elseif saved.TextSettings.onoff == 1 then
								loadedModel.Paintable2.LightPart.BrickColor = BrickColor.new(1,1,1)
								loadedModel.Paintable2.LightPart.Light.Enabled = true
							elseif saved.TextSettings.onoff == 2 then
								if clock.Value >= 17.5 and clock.Value <= 6.5 then
									loadedModel.Paintable2.LightPart.BrickColor = BrickColor.new(1,1,1)
									loadedModel.Paintable2.LightPart.Light.Enabled = true
								end
								if clock.Value >= 6.5 and clock.Value <= 17.5 then
									loadedModel.Paintable2.LightPart.BrickColor = BrickColor.new(0.5,0.5,0.5)
									loadedModel.Paintable2.LightPart.Light.Enabled = false
								end
							end
						end

						if saved.TextSettings.bg then
							local color = string.split(saved.TextSettings.bg,",")
							local color3 = Color3.new(color[1],color[2],color[3])
							loadedModel.Part.SurfaceGui.TextLabel.BackgroundColor3 = color3
						end

						if saved.TextSettings.textCol then
							local color = string.split(saved.TextSettings.textCol,",")
							local color3 = Color3.new(tonumber(color[1]),tonumber(color[2]),tonumber(color[3]))
							loadedModel.Part.SurfaceGui.TextLabel.TextColor3 = color3
						end
					end
				end

				if loadedModel.Name == "DisplayTable" or loadedModel.Name == "Shelf" or loadedModel.Name == "SmallShelf" then
					if saved.Towar then

						loadedModel.Towar.KtoryArtykul.Value = saved.Towar.artykul
						loadedModel.Towar.IleArtykul.Value = saved.Towar.ileartykul
						loadedModel.Guiile.ile.Text = loadedModel.Towar.IleArtykul.Value

						if loadedModel.Name == "DisplayTable" then
							if loadedModel.Towar.KtoryArtykul.Value then
								local co = loadedModel.Towar.KtoryArtykul.Value
								if co == "telefony" then
									loadedModel.GuiCo.Co.Text = "Phones"
								elseif co == "aparaty" then
									loadedModel.GuiCo.Co.Text = "Cameras"
								elseif co == "tablety" then
									loadedModel.GuiCo.Co.Text = "Tablets"
								end
							end

						elseif loadedModel.Name == "Shelf" then
							if loadedModel.Towar.KtoryArtykul.Value then
								local co = loadedModel.Towar.KtoryArtykul.Value
								if co == "telewizory" then
									loadedModel.GuiCo.Co.Text = "TVs"
								elseif co == "konsole" then
									loadedModel.GuiCo.Co.Text = "Consoles"
								elseif co == "komputery" then
									loadedModel.GuiCo.Co.Text = "Computers"
								elseif co == "monitory" then
									loadedModel.GuiCo.Co.Text = "Monitors"
								end
							end
						elseif loadedModel.Name == "SmallShelf" then
							if loadedModel.Towar.KtoryArtykul.Value then
								local co = loadedModel.Towar.KtoryArtykul.Value
								if co == "klawiatury" then
									loadedModel.GuiCo.Co.Text = "Keyboards"
								elseif co == "myszki" then
									loadedModel.GuiCo.Co.Text = "Mouses"
								elseif co == "glosniki" then
									loadedModel.GuiCo.Co.Text = "Speakers"
								elseif co == "sluchawki" then
									loadedModel.GuiCo.Co.Text = "Headphones"
								end
							end

						end
						towarmodule.wczytaj(plr, loadedModel)
					end
				end
				
				
				if saved.Material then
					if saved.Material.Material1 and saved.Material.Material2 then
						for i,n in pairs(loadedModel.Paintable1:GetChildren()) do
							n.Material = Enum.Material[saved.Material.Material1]
						end
						for i,n in pairs(loadedModel.Paintable2:GetChildren()) do
							n.Material = Enum.Material[saved.Material.Material2]
						end
					end
				end

				local rot = saved.transform.r
				loadedModel:SetPrimaryPartCFrame(plot.Plot.CFrame*CFrame.new(saved.transform.x, saved.transform.y, saved.transform.z)*CFrame.Angles(0, math.rad(rot), 0))
				if ReturnPlot(plot.Name) == ReturnPlot(plr.ValueFolder.KtoryPlot.Value) and ReturnPlot(plot.Name)=="roz"then
					if saved.transform.r > 0 then
						rot = saved.transform.r - 180
					elseif saved.transform.r <= 0 then
						rot = saved.transform.r + 180
					end
				elseif ReturnPlot(plot.Name) ~= ReturnPlot(plr.ValueFolder.KtoryPlot.Value) and ReturnPlot(plot.Name)=="std" then
					if saved.transform.r > 0 then
						rot = saved.transform.r + 180
					elseif saved.transform.r <= 0 then
						rot = saved.transform.r - 180
					end
				end
				loadedModel:SetPrimaryPartCFrame(plot.Plot.CFrame*CFrame.new(saved.transform.x, saved.transform.y, saved.transform.z)*CFrame.Angles(0, math.rad(rot), 0))	

				loadedModel.PrimaryPart.CanCollide = false
				loadedModel.PrimaryPart.Transparency = 1
				loadedModel.Parent = plot.PlacedObjects
			else
				continue
			end

		end
		game.ReplicatedStorage.Events.Other.setHR:FireClient(plr)
		--game.ReplicatedStorage.Events.MagazynEvents.MozeszTowar:FireClient(plr)
		dataLoaded = true
		task.wait(0.05)
		plr:WaitForChild("ValueFolder"):WaitForChild("KtoryPlot").Value = plot.Name
		pcall(function()
			slPI.Text = "DONE"
		end)
		wait(0.4)	
		game.ReplicatedStorage.Events.visibleOff:FireClient(plr)
		return data
	else
		game.ReplicatedStorage.Events.Other.setHR:FireClient(plr)
		dataLoaded = true
		pcall(function()
			slPI.Text = "DONE"
		end)
		wait(0.4)	
		game.ReplicatedStorage.Events.visibleOff:FireClient(plr)
		return {}
	end

end

local function usun(plot)

	if plot.Name == "Plot1" then
		position = Vector3.new(275, -0.333, -5)
	elseif plot.Name == "Plot2" then
		position = Vector3.new(70, -0.333, -5)
	elseif plot.Name == "Plot3" then
		position = Vector3.new(-140, -0.333, -5)
	elseif plot.Name == "Plot4" then
		position = Vector3.new(-350, -0.333, -5)
	end
	
	plot.Plot:ClearAllChildren()
	plot.Plot.Size = Vector3.new(50, 1, 50)
	plot.Plot.Position = position
end

local function unload(plr)
	local slPI
	pcall(function()
		slPI = plr.PlayerGui.BuildUI.SaveLoadPI
		slPI.Text = "Preparing to save plot data..."
	end)
	local plot = plotManager.returnPlot(workspace.Plots, plr)
	
	serialize(plr)

	task.wait(1)
	
	plot.Humans:ClearAllChildren()
	plot.Storemen:ClearAllChildren()
	plot.Kasjerzy:ClearAllChildren()
	plot.Cars:ClearAllChildren()
	plot.Packs:ClearAllChildren()
	task.wait()
	plot.PlacedObjects:ClearAllChildren()

	usun(plot)
	plot.wazne.Owner.Value = ""
	--plot.Sign.Text.SurfaceGui.TextL.Text = " "
	plot.Plot.Material = "Plastic"
	plot.Plot.Color = Color3.new(0.639216, 0.635294, 0.647059)

	handleParking:Invoke(nil,0,0,plot)

	local signdef = game.ReplicatedStorage.Signs:FindFirstChild("Sign"..plot.Name.."Lvl"..0)
	local signnow = plot:FindFirstChild(plot:GetAttribute("Sign"))
	
	if signdef and not string.match(signnow.Name,"Lvl0") then
		signnow.Parent = game.ReplicatedStorage.Signs
		signdef.Parent = plot
	end
	-----------
	if signnow then
		for i,n in ipairs(signnow:GetChildren()) do
			if n.Name == "Text" then
				n.SurfaceGui.TextL.Text = ""
			elseif n.Name == "AvatarText" then
				n.SurfaceGui.Avatar.Image = ""
			end
		end
	end
	plot.Cars:ClearAllChildren()
	plot.wazne.Otwarte.Value = false
	plot:SetAttribute("Parking","")
	plot:SetAttribute("Sign","")
	----------------
end

-- calls
replicatedStorage.Events.ExpansionEvents.ServerExt.OnServerEvent:Connect(deserialize)
players.PlayerRemoving:Connect(unload)
serializeE.OnServerEvent:Connect(serialize)
game.ReplicatedStorage.Events.SaveHandler.OnServerEvent:Connect(serialize)



local function Reset(plr,slot)
	local DataStore = dataStoreService:GetDataStore("DataBaseV"..slot)
	local savedData
	local key = "uid_" .. plr.userId
	
	local succes, err = pcall(function()
		savedData = DataStore:GetAsync(key)
		return savedData
	end)
	
	if not succes then
		errormodule.errorfuncGo(plr,"Failed to GetAsync from TycoonDataManager: " .. tostring(err))
	end
	local null = {}
	local succes1, err1 = pcall(function()
		DataStore:SetAsync(key, null)
	end)
	if not succes1 then
		errormodule.errorfuncGo(plr,"Failed to setAsync from TycoonDataManager: " .. tostring(err1))
	end

end

game.ReplicatedStorage.Events.SlotEvents.ResetModel.OnServerEvent:Connect(Reset)

game:BindToClose(function()
	for i, plr in pairs(players:GetChildren()) do
		unload(plr)
	end
end)