local npc = game.ReplicatedStorage.HumansRS.Customer
local errormodule = require(game.ReplicatedStorage.Modules.ErrorModule)
local Remotes = game.ReplicatedStorage.Remotes
local plotManager = require(game.ServerScriptService.ServerModules.PlotManager)

function makeStoremen(plot)
	local plr = game.Players:FindFirstChild(plot.wazne.Owner.Value) 
	local items = plot.PlacedObjects:GetChildren()

	local counterToggle = false
	local counter = 0
	local curCashiers,curStoremen

	local event = game.ReplicatedStorage.Events.Other.HRcurrentsRes.OnServerEvent:Connect(function(player,cc,cs)
		if player == plr then
			curCashiers,curStoremen = cc,cs
			counterToggle = true
		end
	end)

	game.ReplicatedStorage.Events.Other.HRcurrentsReq:FireClient(plr)

	repeat
		counter += task.wait(0.05)
	until counterToggle or counter >= 5

	pcall(function()
		event:Disconnect()
	end)

	if counter >= 5 then
		return false
	end

	local storemanCounter = 0
	local counter = 0

	while storemanCounter < curStoremen do
		if counter >= curStoremen + 1 then
			break
		end
		for i,n in pairs(items) do
			if n.Name == "Storage" then
				if storemanCounter + 1 <= curStoremen then
					wait(math.random(5,15)/10)
					storemanCounter += 1
					local storeman = game.ReplicatedStorage.HumansRS.Storeman:Clone()
					if math.random(0,1) == 0 then
						storeman.PrimaryPart.Position = n.findWait.Position + Vector3.new(math.random(0,3)*-1,3,math.random(0,3)*-1)
						storeman.PrimaryPart.Orientation = Vector3.new(0,math.random(-180,180),0)
					else
						storeman.PrimaryPart.Position = n.findWait.Position + Vector3.new(math.random(0,3),3,math.random(0,3))
						storeman.PrimaryPart.Orientation = Vector3.new(0,math.random(-180,180),0)
					end
					task.wait(0.1)
					storeman.Parent = plot.Storemen
				end
			end
		end
		counter += 1
	end
	script.startCounter:Fire(plr)
end

function getShopWorking(plr, plot)
	local items = plot.PlacedObjects:GetChildren()
	local cashierCounter,storemanCounter = 0,0

	local counterToggle = false
	local counter = 0
	local curCashiers,curStoremen

	local event = game.ReplicatedStorage.Events.Other.HRcurrentsRes.OnServerEvent:Connect(function(player,cc,cs)
		if player == plr then
			curCashiers,curStoremen = cc,cs
			counterToggle = true
		end
	end)

	game.ReplicatedStorage.Events.Other.HRcurrentsReq:FireClient(plr)

	repeat
		counter += task.wait(0.05)
	until counterToggle or counter >= 5

	pcall(function()
		event:Disconnect()
	end)

	if counter >= 5 then
		return false
	end
	for i,obj in pairs(items) do
		if obj.Name == "CashReg" or obj.Name == "CashRegType2" then
			if cashierCounter + 1 <= curCashiers then
				local cashier
				if obj:GetAttribute("isCashierOnboard") == false then
					cashier = game.ReplicatedStorage.HumansRS.Cashier:Clone()
					task.wait()
					cashier.PrimaryPart.Position = obj.CashierStart.Position + Vector3.new(0,1.9,0)
					cashier.PrimaryPart.Orientation = obj.CashierStart.Orientation
					obj:SetAttribute("isCashierOnboard",true)
					task.wait(0.65)

					local Rotation = (obj.CashierStart.CFrame) -- - kasjer.Torso.Position)
					cashier.Parent = plot.Kasjerzy

					cashierCounter += 1
					cashier = nil
				end
			end
		end
	end
	script.makeStoremen:Fire(plot)
	task.wait(1.5)
end


game.ReplicatedStorage.Events.Other.HRChanged.OnServerEvent:Connect(function(plr)
	local plot = plotManager.returnPlot(game.Workspace.Plots,plr)

	if plot.wazne.Owner.Value == plr.Name and not plot:GetAttribute("shopStarting") then
		
		task.wait(0.1)

		local counterToggle = false
		local counter = 0
		local curCashiers,curStoremen

		local event = game.ReplicatedStorage.Events.Other.HRcurrentsRes.OnServerEvent:Connect(function(player,cc,cs)
			if player == plr then
				curCashiers,curStoremen = cc,cs
				task.wait()
				counterToggle = true
			end
		end)

		game.ReplicatedStorage.Events.Other.HRcurrentsReq:FireClient(plr)

		repeat
			counter += task.wait(0.1)
		until counterToggle or counter >= 5

		pcall(function()
			event:Disconnect()
		end)

		if counter >= 5 then
			return false
		end

		pcall(function()
			plr.HRFolder.cashiersValue.Value = curCashiers
			plr.HRFolder.storagemenValue.Value = curStoremen
		end)

		if plot.wazne.Otwarte.Value == true then
			local oldCurCash,oldCurStore = #plot.Kasjerzy:GetChildren(),#plot.Storemen:GetChildren()
			local items = plot.PlacedObjects:GetChildren()
			if curCashiers - oldCurCash > 0 then
				for i,obj in pairs(items) do
					if obj.Name == "CashReg" or obj.Name == "CashRegType2" then
						if obj:GetAttribute("isCashierOnboard") == false then
							if oldCurCash + 1 <= curCashiers then
								local position = obj.CashierStart.Position
								local cashier = game.ReplicatedStorage.HumansRS.Cashier:Clone()
								local Rotation = (obj.CashierStart.CFrame)
								cashier.PrimaryPart.Position = obj.CashierStart.Position + Vector3.new(0,1.9,0)
								cashier.PrimaryPart.Orientation = obj.CashierStart.Orientation
								obj:SetAttribute("isCashierOnboard",true)
								task.wait(0.45)
								cashier.Parent = plot.Kasjerzy
								oldCurCash = #plot.Kasjerzy:GetChildren()
								task.wait(0.05)
							end
						end
					end
				end
			end

			for i,n in pairs(items) do
				if n.Name == "Storage" then
					if oldCurStore + 1 <= curStoremen then
						local storeman = game.ReplicatedStorage.HumansRS.Storeman:Clone()
						if math.random(0,1) == 0 then
							storeman.PrimaryPart.Position = n.findWait.Position + Vector3.new(math.random(0,3)*-1,3,math.random(0,3)*-1)
							storeman.PrimaryPart.Orientation = Vector3.new(0,math.random(-180,180),0)
						else
							storeman.PrimaryPart.Position = n.findWait.Position + Vector3.new(math.random(0,3),3,math.random(0,3))
							storeman.PrimaryPart.Orientation = Vector3.new(0,math.random(-180,180),0)
						end
						task.wait()
						storeman.Parent = plot.Storemen
						task.wait()
						oldCurStore = #plot.Storemen:GetChildren()
					end
				end
			end
		end
	end
end)


game.ReplicatedStorage.Events.STARTEvent.OnServerEvent:Connect(function(plr, button, dzejnys)
	task.wait()
	local plot = plotManager.returnPlot(game.Workspace.Plots,plr)

	if plot.wazne.Owner.Value == plr.Name and not plot:GetAttribute("shopStarting") then
		local isludzie = #plot.Humans:GetChildren() > 0
		local iskasjer = #plot.Kasjerzy:GetChildren() > 0
		if isludzie then
			plot.wazne.Otwarte.Value = true
			task.wait()
		elseif iskasjer then
			errormodule.errorfuncGo(plr,"Casiers hadn't leave the area yet.")
		elseif not isludzie and not iskasjer then
			plot:SetAttribute("shopStarting",true)
			plot.Kasjerzy:ClearAllChildren()
			plot.Packs:ClearAllChildren()
			game.ReplicatedStorage.Events.OpenCloseNow:FireClient(plr)
			plot.wazne.Otwarte.Value = true
			
			task.wait(math.random(0,3))
			
			local divider = 41.2 --41.2
			
			local clockValue = game.Workspace.Clock.Value
			
			if clockValue > 12 and clockValue < 16.2 then
				divider = 29.3
			elseif clockValue >= 16.2 and clockValue < 20 then
				divider = 22.7
			elseif clockValue >= 21 and clockValue < 23 then
				divider = 45
			elseif clockValue >= 23 or clockValue < 1 then
				divider = 60
			elseif clockValue >= 1 and clockValue < 3 then
				divider = 100
			elseif clockValue >= 3 and clockValue < 5.5 then
				divider = 60
			elseif clockValue >= 5.5 and clockValue < 7 then
				divider = 45
			elseif clockValue >= 7 and clockValue < 8.5 then
				divider = 35.2
			end
			
			local rat = plr.leaderstats.Rating.Value
			
			local linearMinus = ((5 - rat) * 6)/100
			
			divider = divider - (divider * linearMinus) 

			local ilerazy = math.floor((rat * 100) / divider)
			
			if ilerazy <= 0 then
				ilerazy = 2
			elseif ilerazy == 1 then
				ilerazy += 1
			end
			
			task.wait(0.35)

			getShopWorking(plr, plot)

			task.wait(0.35)
			for i=1,ilerazy do
				task.wait()
				if plot.wazne.Otwarte.Value == false or (math.random(1,100) < 28 and i ~= 1) then
					continue
				end
				local car = game.ReplicatedStorage.Car:Clone()
				local parking = plot.ParkingBase
				local czeker = 0
				local miejsca = {}
				local miejsce = nil
				local counter = 0
				local npcp = npc:Clone()

				for i,n in pairs(parking.Miejsca:GetChildren()) do
					if n.Zajete.Value == false then
						table.insert(miejsca,n)
					end
				end
				if #miejsca > 0 then
					repeat
						counter += 1
						miejsce = miejsca[math.random(1,#miejsca)]
					until miejsce.Zajete.Value == false or counter == 60

					if counter == 60 then
						miejsce = nil
					end
				end
				
				npcp:MoveTo(plot.Spawnery.Spawner.Position + Vector3.new(0,2,0))

				task.wait(0.15)
				
				npcp.Parent = plot.Humans
				
				for i,j in pairs(npcp:GetChildren()) do
					if j.ClassName == "Part" or j.ClassName == "MeshPart" then
						if j.Name == "HumanoidRootPart" or j.Name == "Head" or string.match(j.Name,"Torso") or string.match(j.Name,"Leg") or string.match(j.Name,"Arm") then
							j:SetNetworkOwner(nil)
						else
							j:SetNetworkOwner(plr)
						end
					end
				end
				
				if miejsce then
					miejsce.Zajete.Value = true
					npcp:SetAttribute("KtoreMiejsce", miejsce.Name)
					local addOrient = 0

					if math.random(1,2) == 2 then
						addOrient = 180
					end
					car:SetPrimaryPartCFrame(CFrame.new(miejsce.Position+Vector3.new(0,3.9,0))*CFrame.Angles(0,math.rad(miejsce.Orientation.Y+addOrient),0))
					local r = math.random(1,255)
					local g = math.random(1,255)
					local b = math.random(1,255)

					for i,n in pairs(car.ChangeThis:GetChildren()) do
						n.Color = Color3.fromRGB(r,g,b)
					end
					car.Parent = plot.Cars
					npcp.WichPark.Value = car
					npcp:MoveTo(car.Starter.Position + Vector3.new(0,2.35,0))
				else
					local plotCos = math.cos(math.rad(plot.Plot.Orientation.Y))
					local addToTempPos1
					local tempPos
					addToTempPos1 = Vector3.new(math.random(0,5) * math.random(-1,1),1.5,math.random(-5,0) * plotCos)
					tempPos = plot.Spawnery.Spawner.Position + addToTempPos1
					npcp:MoveTo(tempPos)
				end
				if not npcp.PrimaryPart then
					npcp.PrimaryPart = npcp.HumanoidRootPart
				end
				task.wait(math.random(12,24)/10)
			end
		end
	end
	plot:SetAttribute("shopStarting",false)
end)

function stop(plot)
	plot.wazne.Otwarte.Value = false
	local czeker = true
	local waiter = 0
	while czeker do
		waiter += task.wait(1)
		local isobj = #plot.Humans:GetChildren() > 0
		if isobj then
			task.wait()
		elseif not isobj or waiter >= 300 then
			plot.Kasjerzy:ClearAllChildren()
			plot.Packs:ClearAllChildren()
			for i,n in pairs(plot.PlacedObjects:GetChildren()) do
				if n.Name == "CashReg" or n.Name == "CashRegType2" then
					n:SetAttribute("isCashierOnboard",false)
				end
				if n.Name == "DisplayTable" or string.match(n.Name,"Shelf") then
					n.SpotValues.LeftSpot.Value = 0
					n.SpotValues.RightSpot.Value = 0
					n.NPCsModule:SetAttribute("isReseting",false)
					n.beingHandled.Value = false
				end
			end
			czeker = false
			break
		end 
	end
	plot:SetAttribute("shopStarting",false)
end

game.ReplicatedStorage.Events.STOPNow.OnServerEvent:Connect(function(plr, plot)
	plot.Humans:ClearAllChildren()
	plot.Storemen:ClearAllChildren()
	plot.Cars:ClearAllChildren()
	plot.Kasjerzy:ClearAllChildren()
	plot.Packs:ClearAllChildren()
	for i,n in pairs(plot.PlacedObjects:GetChildren()) do
		if n.Name == "CashReg" or n.Name == "CashRegType2" then
			n:SetAttribute("isCashierOnboard",false)
		end
		if n.Name == "DisplayTable" or string.match(n.Name,"Shelf") then
			n.SpotValues.LeftSpot.Value = 0
			n.SpotValues.RightSpot.Value = 0
			n.NPCsModule:SetAttribute("isReseting",false)
			n.beingHandled.Value = false
		end
	end
	local plotnow = plot.ParkingBase
	for i,n in ipairs(plotnow.Miejsca:GetChildren()) do
		n.Zajete.Value = false
	end
end)

game.ReplicatedStorage.Events.STOP.OnServerEvent:Connect(function(name, player,  kiczu,  plot)
	stop(plot)
end)

game.ReplicatedStorage.Events.DialogEvents.abortDialog.OnServerEvent:Connect(function(plr)
	wait()
	game.ReplicatedStorage.Events.DialogEvents.abortDialog:FireClient(plr)
end)

script.makeStoremen.Event:Connect(makeStoremen)

local function counter(plr)
	local plot = plotManager.returnPlot(game.Workspace.Plots,plr)
	local cost
	pcall(function() 
		repeat
			task.wait(120)
			cost = (#plot.Kasjerzy:GetChildren() + #plot.Storemen:GetChildren()) * 10
			if plr.leaderstats.Cash.Value >= cost then
				plr.leaderstats.Cash.Value -= cost
				if cost ~= 0 then
					errormodule.paymentInfo(plr,true,"Payments: "..tostring(cost))
				end
			else
				errormodule.errorfuncGo(plr,"You don't enough money to pay your cashier.")
				stop(plot)
				break
			end
		until #plot.Kasjerzy:GetChildren() == 0
	end)
end

script.startCounter.Event:Connect(counter)

game.ReplicatedStorage.Remotes.HR.countPOBJ.OnServerInvoke = function(plr)
	local plot = plotManager.returnPlot(workspace.Plots, plr)
	local sm,cr = 0,0

	for i,n in pairs(plot.PlacedObjects:GetChildren()) do
		if n.Name == "Storage" then
			sm += 1
		end
		if n.Name == "CashReg" or n.Name == "CashRegType2" then
			cr += 1
		end
	end
	return sm,cr
end