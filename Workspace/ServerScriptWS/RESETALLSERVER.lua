local plotManager = require(game.ServerScriptService.ServerModules.PlotManager)
local Players = game.Players
local parkingScript = workspace.ServerScriptWS.PlotHandlers.ParkingHandler
local handleParking = parkingScript.handleParking

game.ReplicatedStorage.Events.RESETALL.OnServerEvent:Connect(function(plr)
	local supertoggle = true
	local sure = plr.PlayerGui:WaitForChild("BuildUI").ARJUSIUR
	local YES = sure.YES
	local NO = sure.NO
	
	sure.Visible = true
	sure.Active = true
	
	NO.MouseButton1Click:Connect(function()
		sure.Visible = false
		sure.Active = false
	end)
	
	YES.MouseButton1Click:Connect(function()
		if supertoggle then
			supertoggle = false

			sure.Visible = false
			sure.Active = false

			local plot = plotManager.returnPlot(workspace.Plots, plr)
			game.ReplicatedStorage.Events.RESETGUI:FireClient(plr)
			game.ReplicatedStorage.Events.RESETEXPANSIONGUI:FireClient(plr)
			wait(0.1)
			plr.leaderstats.Cash.Value = 10000
			plr.hidden.IleL.Value = 0
			plr.hidden.IleR.Value = 0
			plr.hidden.IleC.Value = 1
			plr.ValueFolder.MaxCapacity.Value = 0
			plot.Humans:ClearAllChildren()
			plot.Storemen:ClearAllChildren()
			plot.Kasjerzy:ClearAllChildren()
			plot.Cars:ClearAllChildren()
			plot.Packs:ClearAllChildren()
			plot.PlacedObjects:ClearAllChildren()
			plot.MoveFolder:ClearAllChildren()
			plr.rating.RatingMax.Value = 50
			plr.rating.RatingNow.Value = 0
			plr.SetFolder.parking.Value = 0
			plr.SetFolder.sign.Value = 0
			plr.SetFolder.NameShop.Value = ""
			plot.Plot:ClearAllChildren()
			plot.Plot.Material = "Plastic"
			plr.SetFolder.PlotMaterial.Value = "Plastic"
			plot.Plot.Color = Color3.new(0.639216, 0.635294, 0.647059)
			plr.SetFolder.PlotColorR.Value = 64706
			plr.SetFolder.PlotColorG.Value = 63529
			plr.SetFolder.PlotColorB.Value = 64706

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
			
			----------------

			for i,numa in ipairs(plr.TowarFolder:GetChildren()) do
				numa.Value = 0
			end
			
			game.ReplicatedStorage.Events.ExpansionEvents.ODPALEXPANSION:FireClient(plr,true)
			game.ReplicatedStorage.Events.MagazynEvents.WczytajMaxCap:FireClient(plr)
			game.ReplicatedStorage.Events.MagazynEvents.ExpandMagazinData:FireClient(plr)
			game.ReplicatedStorage.Events.MagazynEvents.WczytajTowar:FireClient(plr)
			game.ReplicatedStorage.Events.VALUEvents.ReadValue:FireClient(plr)
			game.ReplicatedStorage.Events.TowarEvents.Zlicz:FireClient(plr)
			game.ReplicatedStorage.Events.CashLabel:FireClient(plr)
			game.ReplicatedStorage.AllInfo:FireClient(plr)
		end
	end)

end)