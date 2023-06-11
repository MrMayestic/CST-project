local RS = game.ReplicatedStorage.Events.SettingsFolder
local RSr = game.ReplicatedStorage.Remotes.SettingsFolder
local errormodule = require(game.ReplicatedStorage.Modules.ErrorModule)
local Players = game:GetService("Players")
local plotManager = require(game.ServerScriptService.ServerModules.PlotManager)
local TextService = game:GetService("TextService")

local parkingScript = workspace.ServerScriptWS.PlotHandlers.ParkingHandler
local handleParking = parkingScript.handleParking

RS.Grid1Remote.OnServerEvent:Connect(function(plr)
	plr.SetFolder.whatgrid.Value = 1
end)
RS.Grid2Remote.OnServerEvent:Connect(function(plr)
	plr.SetFolder.whatgrid.Value = 2
end)
RS.SetVolume.OnServerEvent:Connect(function(plr,volume)
	plr.SetFolder.VolumeLvl.Value = volume
end)

----SHOPNAMESET

local function getTextObject(message, fromPlayerId)
	local textObject
	local success, errorMessage = pcall(function()
		textObject = TextService:FilterStringAsync(message, fromPlayerId)
	end)
	if success then
		return textObject
	elseif errorMessage then
		print("Error generating TextFilterResult:", errorMessage)
	end

	return false
end

local function getFilteredMessage(textObject)
	local filteredMessage
	local success, errorMessage = pcall(function()
		filteredMessage = textObject:GetNonChatStringForBroadcastAsync()
	end)
	if success then
		return filteredMessage
	elseif errorMessage then
		print("Error filtering message:", errorMessage)
	end
	return false
end

-- Fired when client sends a request to write on the sign
local function onSetSignText(player, text)

end


RS.ShopNameSet.OnServerEvent:Connect(function(plr,name)

	if name ~= "" then
		local plot = plotManager.returnPlot(workspace.Plots, plr)
		-- Filter the incoming message and send the filtered message
		local messageObject = getTextObject(name, plr.UserId)
		local filteredText = ""
		filteredText = getFilteredMessage(messageObject)

		local sign = plot[plot:GetAttribute("Sign")]
		for i,n in ipairs(sign:GetChildren()) do
			if n.Name == "Text" then
				n.SurfaceGui.TextL.Text = filteredText
			end
		end
		plr.SetFolder.NameShop.Value = filteredText
	end
end)

------------

RS.SignName.OnServerEvent:Connect(function(plr,nazwa,plot)

	local userId = plr.UserId
	local thumbType = Enum.ThumbnailType.HeadShot
	local thumbSize = Enum.ThumbnailSize.Size100x100
	local content, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
	local sign = plot[plot:GetAttribute("Sign")]

	for i,n in ipairs(sign:GetChildren()) do
		if n.Name == "Text" then
			n.SurfaceGui.TextL.Text = nazwa
		elseif n.Name == "AvatarText" then
			n.SurfaceGui.Avatar.Image = content
		end
	end
end)


RS.MaterialRE.OnServerEvent:Connect(function(plr,material,plot)
	plot.Plot.Material = material
	for i,n in pairs(plot.Plot:GetChildren()) do
		n.Material = material
	end
	plr.SetFolder.PlotMaterial.Value = material
end)

RS.PaintPlotRE.OnServerEvent:Connect(function(plr,color,button)
	local plot = plotManager.returnPlot(workspace.Plots, plr)
	plot.Plot.Color = color
	for i,n in pairs(plot.Plot:GetChildren()) do
		n.Color = color
	end
	plr.SetFolder.PlotColorR.Value = color.R*100000
	plr.SetFolder.PlotColorG.Value = color.G*100000
	plr.SetFolder.PlotColorB.Value = color.B*100000
	
	plr.SetFolder.plotTop.Value = button:GetAttribute("Top")
	plr.SetFolder.plotBottom.Value = button:GetAttribute("Bottom")
end)

RS.WczytajPaintRE.OnServerEvent:Connect(function(plr,plot)
	local color = Color3.new(plr.SetFolder.PlotColorR.Value/100000,plr.SetFolder.PlotColorG.Value/100000,plr.SetFolder.PlotColorB.Value/100000)
	plot.Plot.Color = color
	for i,n in pairs(plot.Plot:GetChildren()) do
		n.Color = color
	end	
end)

local function parkingSet(plr,toggle,isRobux)
	local arjusiur = plr.PlayerGui:WaitForChild("BuildUI").ARJUSIURPARKING
	local value = plr.SetFolder.parking.Value + 1

	if toggle and not isRobux then
		value -= 1
	end

	local frame = plr.PlayerGui:WaitForChild("BuildUI").SettingsFrame
	local shop = frame.Shop
	local upgparking = shop.UbgParking
	local ubgParkRobux = shop.UbgParkingRobux
	local cost = 0
	local plot = plotManager.returnPlot(workspace.Plots, plr)

	if value == 0 then
		cost = 0
	elseif value == 1 then
		cost = 10000
	elseif value == 2 then
		cost = 25000
	end
	if toggle then
		cost = 0
	end

	if plr.leaderstats.Cash.Value < cost then
		errormodule.errorfuncGo(plr,"You don't have enough money to buy that.")
		return false
	end

	if plr.leaderstats.Cash.Value >= cost then
		
		upgparking.Text = "UPGRADE NOW"
		ubgParkRobux.Text = "UPGRADE NOW"
		
		if value == 0 then
			upgparking.Cost.Text = "10000"
			ubgParkRobux.Cost.Text = "50"
		elseif value == 1 then
			upgparking.Cost.Text = "25000"
			ubgParkRobux.Cost.Text = "120"
		elseif value == 2 then
			upgparking.Cost.Text = "..."
			upgparking.Text = "You bought all upgrades."
			ubgParkRobux.Cost.Text = "..."
			ubgParkRobux.Text = "Done."
		end

		arjusiur.Visible = false
		frame.Visible = true

		local succes = handleParking:Invoke(plr,cost,value)

		plr.leaderstats.Cash.Value -= cost

		if not succes then
			arjusiur.Visible = false
			frame.Visible = true
		end

		if cost==0 then
			local valju = value * 100
			plr.rating.RatingMax.Value += valju 
		else
			plr.rating.RatingMax.Value += 100
		end
		plr.SetFolder.parking.Value = value

		arjusiur.Visible = false
		frame.Visible = true

		if not toggle then
			frame.Visible = true
		end
	end
end

RS.ParkingSet.OnServerEvent:Connect(parkingSet)

game.ReplicatedStorage.Events.RBEvents.parkingSet.Event:Connect(parkingSet)

local function signSet(plr,toggle,isRobux)
	local arjusiursign = plr.PlayerGui:WaitForChild("BuildUI").ARJUSIURSIGN
	local value = plr.SetFolder.sign.Value + 1
	if toggle and not isRobux then
		value -= 1
	end
	local nazwa = plr.SetFolder.NameShop.Value
	local frame = plr.PlayerGui:WaitForChild("BuildUI").SettingsFrame
	local shop = frame.Shop
	local upgsign = shop.UbgSign
	local ubgSignRobux = shop.UbgSignRobux
	local cost = 0
	local plot = plotManager.returnPlot(workspace.Plots, plr)
	local signnew 
	local signold
	local userId = plr.UserId
	local thumbType = Enum.ThumbnailType.HeadShot
	local thumbSize = Enum.ThumbnailSize.Size100x100
	local content, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
	
	if value == 0 then
		cost = 0
	elseif value == 1 then
		cost = 4500
	elseif value == 2 then
		cost = 10000
	end
	
	if toggle then
		cost = 0
	end

	if plr.leaderstats.Cash.Value < cost then
		errormodule.errorfuncGo(plr,"You don't have enough money to buy that.")
		return false
	end
	
	if plr.leaderstats.Cash.Value >= cost then
		
		upgsign.Text = "UPGRADE NOW"
		ubgSignRobux.Text = "UPGRADE NOW"
		
		if value == 0 then
			upgsign.Cost.Text = "4500"
			ubgSignRobux.Cost.Text = "25"
		elseif value == 1 then
			upgsign.Cost.Text = "10000"
			ubgSignRobux.Cost.Text = "60"
		elseif value == 2 then
			upgsign.Cost.Text = "..."
			upgsign.Text = "You bought all upgrades"
			ubgSignRobux.Cost.Text = "..."
			ubgSignRobux.Text = "Done."
		end

		if cost == 0 and value == 0 then
			signnew  = nil
			signold = nil
			plot:SetAttribute("Sign",plot["Sign"..plot.Name.."Lvl"..value].Name)
		elseif value > 0 and cost > 0 then
			signnew	= game.ReplicatedStorage.Signs["Sign"..plot.Name.."Lvl"..value]
			signold = plot["Sign"..plot.Name.."Lvl"..value-1]
		elseif value > 0 and cost == 0 then
			signnew	= game.ReplicatedStorage.Signs["Sign"..plot.Name.."Lvl"..value]
			signold = plot:FindFirstChild("Sign"..plot.Name.."Lvl"..value-1)
			if signold == nil then
				signold = plot:FindFirstChild("Sign"..plot.Name.."Lvl"..value-2)
			end
		end

		if signold and signnew then
			signold.Parent = game.ReplicatedStorage.Signs
			signnew.Parent = plot
			plot:SetAttribute("Sign",signnew.Name)
			for i,n in ipairs(signold:GetChildren()) do
				if n.Name == "Text" then
					n.SurfaceGui.TextL.Text = ""
				elseif n.Name == "AvatarText" then
					n.SurfaceGui.Avatar.Image = ""
				end
			end

			if cost==0 then
				local valju = value * 50
				plr.rating.RatingMax.Value += valju 
			else
				plr.rating.RatingMax.Value += 50
			end
			plr.SetFolder.sign.Value = value

			arjusiursign.Visible = false
			frame.Visible = true
		end

		if not toggle then
			frame.Visible = true
		end

		plr.leaderstats.Cash.Value -= cost
		wait()
		game.ReplicatedStorage.Events.SettingsFolder.ShopRESet:FireClient(plr)
	end
end

RS.SignSet.OnServerEvent:Connect(signSet)

game.ReplicatedStorage.Events.RBEvents.signSet.Event:Connect(signSet)



--game.ReplicatedStorage.Events.SettingsFolder.Start.OnServerEvent:Connect(function(plr)
--	game.ReplicatedStorage.Events.SettingsFolder.Start:FireClient(plr)
--end)

--game.ReplicatedStorage.Events.SettingsFolder.Quit.OnServerEvent:Connect(function(plr)
--	game.ReplicatedStorage.Events.SettingsFolder.Quit:FireClient(plr)
--end)



local function handleTerrain(plot)
	local multi = 1
	local plotNum = string.sub(plot.Name,#plot.Name,#plot.Name)

	if tonumber(plotNum) > 4 then
		multi = -1
	end

	if plot:FindFirstChild("Plot") then
		plot = plot.Plot		
	end

	local vector = plot.Position+Vector3.new(1,0,51*multi)

	local cframe = CFrame.new(Vector3.new(vector.X,-4.35,vector.Z))

	game.Workspace.Terrain:FillBlock(cframe,Vector3.new(155,3,150),Enum.Material.Grass)

	vector = plot.Position
	cframe = CFrame.new(Vector3.new(vector.X,-4.35,vector.Z))

	game.Workspace.Terrain:FillBlock(cframe,Vector3.new(plot.Size.X,8,plot.Size.Z),Enum.Material.Air)

	vector = plot.Position
	cframe = CFrame.new(Vector3.new(vector.X,-4.35,vector.Z))

	game.Workspace.Terrain:FillBlock(cframe,Vector3.new(plot.Size.X,8,plot.Size.Z),Enum.Material.Air)

	for i,n in pairs(plot:GetChildren()) do
		vector = n.Position
		cframe = CFrame.new(Vector3.new(vector.X,-4.35,vector.Z))

		game.Workspace.Terrain:FillBlock(cframe,Vector3.new(n.Size.X,8,n.Size.Z),Enum.Material.Air)
	end
end


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


game.ReplicatedStorage.Events.SlotEvents.tycoonDataSaved.Event:Connect(function(plr,plot)
	plot.Humans:ClearAllChildren()
	plot.Storemen:ClearAllChildren()
	plot.Kasjerzy:ClearAllChildren()
	plot.Packs:ClearAllChildren()
	plot.Cars:ClearAllChildren()
	plot.MoveFolder:ClearAllChildren()
	plot.Plot:ClearAllChildren()
	task.wait()
	plot.PlacedObjects:ClearAllChildren()
	handleTerrain(plot)
end)



game.ReplicatedStorage.Events.SlotEvents.playerDataSaved.Event:Connect(function(plr,plot)
	game.ReplicatedStorage.Events.RESETGUI:FireClient(plr)
	game.ReplicatedStorage.Events.RESETEXPANSIONGUI:FireClient(plr)
	game.ReplicatedStorage.Events.MagazynEvents.terminateMagazineInfo:FireClient(plr)

	plr.PlayerGui.BuildUI.BoostInfo.boostPerc.Text = "0%"
	plr.PlayerGui.BuildUI.BoostInfo.boostPerc.TextColor3 = Color3.new(170/255,0,0)
	plr.PlayerGui.BuildUI.BoostInfo.boostTimeLeft.Text = "00:00"
	plot.Plot.Material = "Plastic"
	plot.Plot.Color = Color3.new(0.639216, 0.635294, 0.647059)

	local succes = handleParking:Invoke(plr,0,0)

	local signdef = game.ReplicatedStorage.Signs:FindFirstChild("Sign"..plot.Name.."Lvl"..0)
	local signnow = plot:FindFirstChild(plot:GetAttribute("Sign"))
	if signdef then
		signnow.Parent = game.ReplicatedStorage.Signs
		signdef.Parent = plot
	end


	-----------
	if signnow then
		local userId = plr.UserId
		local thumbType = Enum.ThumbnailType.HeadShot
		local thumbSize = Enum.ThumbnailSize.Size100x100
		local content, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
		for i,n in ipairs(signnow:GetChildren()) do
			if n.Name == "Text" then
				n.SurfaceGui.TextL.Text = ""
			elseif n.Name == "AvatarText" then
				n.SurfaceGui.Avatar.Image = content
			end
		end
	end
	plot.wazne.Otwarte.Value = false
	plot:SetAttribute("Parking","")
	plot:SetAttribute("Sign","")

	for im,ni in pairs(plr:GetChildren()) do
		if ni.Name == "hidden" or ni.Name == "TowarFolder" or ni.Name == "SetFolder" or ni.Name == "leaderstats" or ni.Name == "rating" or ni.Name == "ValueFolder" or ni.Name == "CzyTutorialDone" or ni.Name == "AchiveFolder" or ni.Name == "ProgressFolder" or ni.Name=="waiting" or ni.Name=="CenaFolder" or ni.Name == "RBFolder" or ni.Name == "HRFolder" then
			ni:Destroy()
		end 
	end
	wait()
	game.ReplicatedStorage.Events.SlotEvents.Reload:FireClient(plr)
	wait(1)
end)

RSr.rotateModels.OnServerInvoke = function(plr)
	local succ,err = pcall(function()
		local currentPlot = plr.ValueFolder.KtoryPlot
		local plotNum = tonumber(string.sub(currentPlot.Value,#currentPlot.Value,#currentPlot.Value))

		if plotNum > 4 then
			currentPlot.Value = "Plot1"
		elseif plotNum < 4 then
			currentPlot.Value = "Plot8"
		end
	end)

	if succ then
		return true
	else
		errormodule.errorfuncGo(plr,"Error occured when trying to prepare your plot for rotation of models.")
		return false
	end
end

----ANIMS----

game.ReplicatedStorage.Events.AnimationEvents.setAnimSettings.OnServerEvent:Connect(function(plr,value)
	plr.SetFolder.localAnims.Value = value
end)