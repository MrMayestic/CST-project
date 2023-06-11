local errormodule = require(game.ReplicatedStorage.Modules.ErrorModule)

local function sprawdz(plr)
	local frame = plr.PlayerGui:WaitForChild("BuildUI"):WaitForChild("ExpandMagazinFrame")
	local toggle = true
	local zliczbutton = frame.ExpandButton
	local info = frame.IleInfoMagazyn
	local value = info.MagazinValue
	local zaplacisz = frame.IleZaplacisz
	local zaplac = zaplacisz.ZaplaciszValue
	local checkvalue = plr.ValueFolder.MaxCapacity.Value
	local robuxPrice = frame.RobuxPrice
	
	if checkvalue == 0 or checkvalue == nil then
		value.Value = 75
		zaplac.Value = 7500
		info.Text = value.Value
		zaplacisz.Text = zaplac.Value
		robuxPrice.Text = 40
	elseif checkvalue == 1 then
		value.Value = 100
		zaplac.Value = 10000
		info.Text = value.Value
		zaplacisz.Text = zaplac.Value
		robuxPrice.Text = 65
	elseif checkvalue == 2 then
		zaplac.Value = 12500
		value.Value = 150
		info.Text = value.Value
		zaplacisz.Text = zaplac.Value
		robuxPrice.Text = 80
	elseif checkvalue == 3 then
		zaplac.Value = 17500
		value.Value = 250
		info.Text = value.Value
		zaplacisz.Text = zaplac.Value
		robuxPrice.Text = 110
	elseif checkvalue == 4 then
		zaplac.Value = 25000
		value.Value = 500
		info.Text = value.Value
		zaplacisz.Text = zaplac.Value
		robuxPrice.Text = 150
	elseif checkvalue == 5 then
		zaplac.Value = 0
		zaplacisz.Text = ""
		info.Text = "All upgrades done"
		robuxPrice.Text = 0
	end
	
	return zaplac.Value,value.Value
end

game.ReplicatedStorage.Events.MagazynEvents.sprawdz.OnServerEvent:Connect(sprawdz)

game.ReplicatedStorage.Events.MagazynEvents.ExpandMagazinSignal.OnServerEvent:Connect(function(plr)

	local zaplac,value = sprawdz(plr)

	if plr.leaderstats.Cash.Value < zaplac then
		errormodule.errorfuncGo(plr,"You don't have enough money to buy this expand.")
		return
	else
		if plr.ValueFolder.MaxCapacity.Value < 5 then
			plr.ValueFolder.MaxCapacity.Value += 1

			plr.PlayerGui.BuildUI.BuildSystemsAndInfo.Midyl.Frame.MagazynFrame.MaxCapacity.MaxValue.Value = value
			
			task.wait(0.15)
			
			game.ReplicatedStorage.Events.TowarEvents.Zlicz:FireClient(plr)
			game.ReplicatedStorage.Events.MagazynEvents.ExMg:FireClient(plr)
			
			plr.leaderstats.Cash.Value -= zaplac
		end
	end
end)