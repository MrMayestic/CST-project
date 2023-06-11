local button = script.Parent
local toggle = true
local plr = game.Players.LocalPlayer
local frame = script.Parent.Parent.SettingsFrame
local getPlot = game.ReplicatedStorage.Remotes.requestPlot

local plot = getPlot:InvokeServer()

function start()
	toggle = false
	local lala = plr.PlayerGui:FindFirstChild("ContextActionGui")
	if lala then
		lala.ContextButtonFrame.Sprint.Visible = false
	end
	frame:TweenPosition(UDim2.new(0.643, 0,0.125, 0),0,0,0.5)
	for i=1,18 do
		wait()
		button.Image.Rotation -= 5
	end
end

function quit()
	--game.ReplicatedStorage.Events.ColorPickerEvents.Pick:FireServer(nil)
	toggle = true
	local lala = plr.PlayerGui:FindFirstChild("ContextActionGui")
	if lala then
		lala.ContextButtonFrame.Sprint.Visible = true
	end
	frame:TweenPosition(UDim2.new(1.175, 0,0.125, 0),0,0,0.5)
	for i=1,18 do
		wait()
		button.Image.Rotation += 5
	end
	frame.CanvasPosition = Vector2.new(0,0)
end


button.MouseButton1Click:Connect(function()
	if not plr:FindFirstChild("leaderstats") then
		return
	end
	if toggle then
		start()
	elseif not toggle then
		quit()
	end
end)

local max = plr.PlayerGui.BuildUI.SettingsFrame.MusicFrame.Slider.Max
local fire = max.Fire
local bar = max.Bar
local as = Vector2.new(max.AbsoluteSize.X, max.AbsoluteSize.Y)

game.ReplicatedStorage.Events.SettingsFolder.UstawSuwak.OnClientEvent:Connect(function()
	local value = plr.SetFolder.VolumeLvl.Value
	bar.Size = UDim2.new(0, ((value / 100) * as.X), 1, 0)
	plr.PlayerGui.BuildUI.SettingsFrame.MusicFrame.Slider.TextControl.Text = math.floor(value)
	local mudzin = plr.SetFolder.whatgrid.Value
end)
game.ReplicatedStorage.Events.SettingsFolder.ShopRESet.OnClientEvent:Connect(function()
	script.Parent.Parent.SettingsFrame.Shop.NameShop.Text = plr.SetFolder.NameShop.Value
	game.ReplicatedStorage.Events.SettingsFolder.SignName:FireServer(plr.SetFolder.NameShop.Value,plot)
end)

game.ReplicatedStorage.Events.SettingsFolder.WczytajMaterial.OnClientEvent:Connect(function()
	game.ReplicatedStorage.Events.SettingsFolder.MaterialRE:FireServer(plr.SetFolder.PlotMaterial.Value,plot)
	wait(0.2)
	plr.PlayerGui.BuildUI.SettingsFrame.Shop.DropDown.Selection.Text = plr.SetFolder.PlotMaterial.Value
end)

game.ReplicatedStorage.Events.SettingsFolder.WczytajPaintRE.OnClientEvent:Connect(function()
	plr.PlayerGui.BuildUI.PaintPlotFrame.ColorColor:SetAttribute("Top",plr.SetFolder.plotTop.Value)
	plr.PlayerGui.BuildUI.PaintPlotFrame.ColorColor:SetAttribute("Bottom",plr.SetFolder.plotBottom.Value)
	plr.PlayerGui.BuildUI.PaintPlotFrame.ColorColor.BackgroundColor3 = Color3.new(plr.SetFolder.PlotColorR.Value/100000,plr.SetFolder.PlotColorG.Value/100000,plr.SetFolder.PlotColorB.Value/100000)
	plr.PlayerGui.BuildUI.SettingsFrame.Shop.ColorButton.BackgroundColor3 = Color3.new(plr.SetFolder.PlotColorR.Value/100000,plr.SetFolder.PlotColorG.Value/100000,plr.SetFolder.PlotColorB.Value/100000)
	--plr.PlayerGui.BuildUI.SettingsFrame.Shop.ColorButton.Text = plr.SetFolder.ColorName.Value
	task.wait(0.1)
	game.ReplicatedStorage.Events.SettingsFolder.WczytajPaintRE:FireServer(plot)
end)

--game.ReplicatedStorage.Events.SettingsFolder.Start.OnClientEvent:Connect(function()
--	start()
--end)

--game.ReplicatedStorage.Events.SettingsFolder.Quit.OnClientEvent:Connect(function()
--	quit()
--end)


game.ReplicatedStorage.Events.RESETGUI.OnClientEvent:Connect(function(toggle)
	if not toggle then
		quit()
	end
end)