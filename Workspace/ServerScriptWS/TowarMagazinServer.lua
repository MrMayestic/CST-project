local towarevents= game.ReplicatedStorage.Events.TowarEvents
local errormodule = require(game.ReplicatedStorage.Modules.ErrorModule)
local towarmodule = require(game.ReplicatedStorage.Modules.TowarModule)

towarevents.ServerSet.OnServerEvent:Connect(function(plr, towarItems)
	for i, part in ipairs(towarItems) do
		part.Transparency = 0
	end
end)

towarevents.SetStep.OnServerEvent:Connect(function(plr,ktore,ile)
	ktore:SetAttribute("Step",ile)
end)

towarevents.SetValues.OnServerEvent:Connect(function(plr,toggle)
	local MarzaxD = 0
	local towary,ileTowarow
	
	local counterToggle = false
	local counter = 0

	local event = game.ReplicatedStorage.Events.TowarEvents.towarRes.OnServerEvent:Connect(function(player,it,t)
		if player == plr then
			ileTowarow,towary = it,t
			counterToggle = true
		end
	end)
	
	if not toggle then
		game.ReplicatedStorage.Events.TowarEvents.towarReq:FireClient(plr)
	else
		game.ReplicatedStorage.Events.TowarEvents.towarReqAB:FireClient(plr)
	end

	repeat
		counter += task.wait(0.05)
	until counterToggle or counter >= 5

	pcall(function()
		event:Disconnect()
	end)

	if counter >= 5 then
		return false
	end
	
	task.wait()

	for i,n in ipairs(towary) do
		MarzaxD += ileTowarow[i] * n:GetAttribute("Cost")
	end
	
	if MarzaxD > plr.leaderstats.Cash.Value then
		errormodule.errorfuncGo(plr,"You don't have enough money to buy these products.")
		return
	else
		for i,n in ipairs(towary) do
			plr.TowarFolder[n.Name].Value += ileTowarow[i]
		end

		plr.leaderstats.Cash.Value -= MarzaxD
		
		if toggle then
			errormodule.productsInfo(plr,"(Auto-buy) Bought products.")
		end
		
		towarevents.WezMiPodlicz:FireClient(plr)
	end
end)

local function countCapacity(plr)
	local checkvalue = plr.ValueFolder.MaxCapacity.Value
	local ustawcapacity = 0
	for i,numa in ipairs(plr.TowarFolder:GetChildren()) do
		ustawcapacity = ustawcapacity + numa.Value
	end
	if checkvalue == 0 or checkvalue == nil then
		return 50,ustawcapacity
	elseif checkvalue == 1 then
		return 75,ustawcapacity
	elseif checkvalue == 2 then
		return 100,ustawcapacity
	elseif checkvalue == 3 then
		return 150,ustawcapacity
	elseif checkvalue == 4 then
		return 250,ustawcapacity
	elseif checkvalue == 5 then
		return 500,ustawcapacity
	end
end

local function getFrame(plr,name)
	if name == "DisplayTable" then
		return plr.PlayerGui.BuildUI.DisplayTableFrame
	elseif name == "Shelf" then
		return plr.PlayerGui.BuildUI.ShelfFrame
	elseif name == "SmallShelf" then
		return plr.PlayerGui.BuildUI.SmallShelfFrame
	end
end

towarevents.FillUp.OnServerEvent:Connect(function(plr,obj,plot)
	local model = obj.Parent
	local moge = true
	if model.Name == "DisplayTable" or model.Name == "Shelf" or model.Name == "SmallShelf" then
		if model.Parent.Parent.wazne.Owner.Value == plr.Name then
			local ilevalue = model.Towar.IleArtykul
			local ktory = model.Towar.KtoryArtykul.Value
			if not ktory or ktory == "" then
				return
			end
			local ileMag = plr.TowarFolder:FindFirstChild(ktory)
			local towarModel = model.Towar:FindFirstChild(ktory)
			task.wait()
			local ileDodac = 6 - ilevalue.Value
			local towarCounter = 0
			for i,towar in ipairs(towarModel:GetChildren()) do
				if towar.Transparency == 0 then
					towarCounter += 1
				end
			end
			if towarCounter ~= ilevalue.Value then
				local capacity,ilejest = countCapacity(plr)
				towarmodule.erase(plr,model,getFrame(plr,model.Name),capacity,ilejest)
				task.wait()
				local ile = ileMag.Value
				local toggle 

				if ileMag.Value >= 6 then
					toggle = true
				else	
					toggle = false
				end

				towarmodule.towar(plr, ktory, model, toggle, ile)
				task.wait(0.2)
				game.ReplicatedStorage.Events.TowarEvents.Zlicz:FireClient(plr)
				return
			end
			if not ileMag or ileMag.Value == 0 then
				moge = false
			end
			local czeker = 0
			if ilevalue.Value < 6 and moge then
				for i,towar in ipairs(towarModel:GetChildren()) do
					if ilevalue.Value < 6 and ileMag.Value > 0 then
						if towar.Transparency == 1 then
							towar.Transparency = 0
							ilevalue.Value += 1
							ileMag.Value -= 1
						end
						if ilevalue.Value == 6 or ileMag.Value == 0 then
							wait()
							game.ReplicatedStorage.Events.TowarEvents.Zlicz:FireClient(plr)
							--break
						end
					end
				end
			elseif not moge then
				moge = true
			end
		end
	end
end)



game.ReplicatedStorage.Events.Jest6Telefonow.OnServerEvent:Connect(function(plejerr)
	game.ReplicatedStorage.Events.Jest6Telefonow:FireClient(plejerr)
end)

game.ReplicatedStorage.Events.JestEKlkiniete.OnServerEvent:Connect(function(plar)
	game.ReplicatedStorage.Events.JestEKlkiniete:FireClient(plar)
end)

game.ReplicatedStorage.Events.MagazynEvents.WczytajCeny.OnServerEvent:Connect(function(plr,co,ile)
	plr.CenaFolder:FindFirstChild(co).Value = ile
end)