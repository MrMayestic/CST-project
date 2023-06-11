local frame = script.Parent
local shopbut = frame.ShopButton
local musicbut = frame.MusicButton
local shop = frame.Shop
local music = frame.MusicFrame
local other = frame.Other
local otherbut = frame.OtherButton
local lastframe = frame.Shop
local lastbut = shopbut
local RS = game.ReplicatedStorage.Events
local plr = game.Players.LocalPlayer
local getPlot = game.ReplicatedStorage.Remotes.requestPlot
local menu = shop.DropDown.Menu
local buttons = {menu.Brick,menu.Cobblestone,menu.Concrete,menu.DiamondPlate,menu.Granite,menu.Marble,menu.Metal,menu.Pebble,menu.Plastic,menu.Slate,menu.WoodPlanks}
local paintframe = script.Parent.Parent.PaintPlotFrame
local cPB = paintframe.ColorPickerButton
local materialRE = RS.SettingsFolder.MaterialRE
local paintRE = RS.SettingsFolder.PaintPlotRE
local colorbutton = shop.ColorButton
local paintclose = script.Parent.Parent.PaintPlotClose
local plot = getPlot:InvokeServer()
local upgparking = shop.UbgParking
local upgsign = shop.UbgSign
local ubgParkRobux = shop.UbgParkingRobux
local ubgSignRobux = shop.UbgSignRobux
local parkingvalue
local signvalue
local arjusiur = script.Parent.Parent.ARJUSIURPARKING
local arjusiursign = script.Parent.Parent.ARJUSIURSIGN

local shopFrame = plr:WaitForChild("PlayerGui"):WaitForChild("BuildUI"):WaitForChild("ShopFrame")

local buildButton = script.Parent.Parent.BuildSystemsAndInfo.Shop

local areYouSure = script.Parent.Parent.AreYouSure

local yesEvent,noEvent

local rotateButton = other.Rotate

local MarketplaceService = game:GetService("MarketplaceService")

local errormodule = require(game.ReplicatedStorage.Modules.ErrorModule)
local AudioPlayer = require(game.ReplicatedStorage.Modules:WaitForChild("AudioModule"))

local canpaint = false
local setCustom = paintframe.SetCustom
local customToggle = false
local canyou = plr:WaitForChild("ValueFolder").CanYou
local changeBinds = other.ChangeBinds

local parkingsIDs = {
	[1] = 1531917372;
	[2] = 1531917517;
}

local signsIDs = {
	[1] = 1531917724;
	[2] = 1531917804;
}

rotateButton.MouseButton1Click:Connect(function()
	frame.Visible = false
	yesEvent = areYouSure.YES.MouseButton1Click:Connect(function()
		
		yesEvent:Disconnect()
		noEvent:Disconnect()
		
		local succ = game.ReplicatedStorage.Remotes.SettingsFolder.rotateModels:InvokeServer()
		
		task.wait(0.15)
		
		if succ then
			game.ReplicatedStorage.Events.Other.unsetHR:Fire()
			local slPI
			pcall(function()
				slPI = plr.PlayerGui.BuildUI.SaveLoadPI
				slPI.Text = "Starting to rotate models..."
			end)
			plr.PlayerGui.BuildUI.SaveLoadPI.Visible = true
			wait()
			areYouSure.Visible = false
			game.ReplicatedStorage.Events.SaveHandler:FireServer(true)
			wait()
		end
		frame.Visible = true
	end)
	
	noEvent = areYouSure.NO.MouseButton1Click:Connect(function()
		areYouSure.Visible = false
		frame.Visible = true
		yesEvent:Disconnect()
		noEvent:Disconnect()
	end)
	
	areYouSure.TextLabel.Text = "Are you sure you want to rotate all furnitures?"
	areYouSure.Visible = true
end)

RS.SettingsFolder.ParkingWczytaj.OnClientEvent:Connect(function()
	RS.SettingsFolder.ParkingSet:FireServer(true)
end)

RS.SettingsFolder.WczytajSignParkingNazwe.OnClientEvent:Connect(function()
	parkingvalue = plr.SetFolder.parking.Value
	signvalue = plr.SetFolder.sign.Value
end)

RS.SettingsFolder.SignWczytaj.OnClientEvent:Connect(function()
	RS.SettingsFolder.SignSet:FireServer(true)--signvalue,plot,0,plr.SetFolder.NameShop.Value)
end)

upgparking.MouseButton1Click:Connect(function()
	AudioPlayer.playAudio("Click")
	if plot.wazne.Otwarte.Value == false then
		if plr.SetFolder.parking.Value < 2 then
			arjusiur.Visible = true
			frame.Visible = false
		end
	else
		errormodule.errorfuncGo(plr,"You must close shop and don't have anyone at parking to do this.")
	end
end)

upgsign.MouseButton1Click:Connect(function()
	AudioPlayer.playAudio("Click")
	if plot.wazne.Otwarte.Value == false then
		if plr.SetFolder.sign.Value < 2 then
			arjusiursign.Visible = true
			frame.Visible = false
		end
	else
		errormodule.errorfuncGo(plr,"You must close shop and don't have anyone at parking to do this.")
	end
end)

ubgParkRobux.MouseButton1Click:Connect(function()
	AudioPlayer.playAudio("Click")
	parkingvalue = plr.SetFolder.parking.Value
	if parkingvalue < 2 then
		MarketplaceService:PromptProductPurchase(plr, parkingsIDs[parkingvalue + 1])
	end
	arjusiur.Visible = false
	frame.Visible = true
end)

ubgSignRobux.MouseButton1Click:Connect(function()
	AudioPlayer.playAudio("Click")
	signvalue = plr.SetFolder.sign.Value
	if signvalue < 2 then
		MarketplaceService:PromptProductPurchase(plr, signsIDs[signvalue + 1])
	end
	frame.Visible = true
	arjusiursign.Visible = false
end)

arjusiursign.NO.MouseButton1Click:Connect(function()	

	AudioPlayer.playAudio("Click")
	arjusiursign.Visible = false
	frame.Visible = true

end)

arjusiursign.YES.MouseButton1Click:Connect(function()
	AudioPlayer.playAudio("Click")
	signvalue = plr.SetFolder.sign.Value
	if signvalue < 2 then
		RS.SettingsFolder.SignSet:FireServer()
	end
	frame.Visible = true
	arjusiursign.Visible = false
end)


-----------------------


arjusiur.NO.MouseButton1Click:Connect(function()	
	AudioPlayer.playAudio("Click")
	arjusiur.Visible = false
	frame.Visible = true
end)

arjusiur.YES.MouseButton1Click:Connect(function()
	AudioPlayer.playAudio("Click")
	parkingvalue = plr.SetFolder.parking.Value
	if parkingvalue < 2 then
		RS.SettingsFolder.ParkingSet:FireServer()
	end
	arjusiur.Visible = false
	frame.Visible = true
end)	



---------------------------------------------------------------------------

for i, v in pairs(buttons) do
	v.MouseButton1Click:Connect(function()
		AudioPlayer.playAudio("Click")
		materialRE:FireServer(v.Name,plot)
	end)
end

---------------------------------------------------------------------------

local function findColor(toggle,ile,ile2,sectoggle)
	
	game.ReplicatedStorage.Remotes.CPTopB:Invoke(toggle,ile)
	game.ReplicatedStorage.Events.ColorPickerEvents.SetBottomB:Fire(toggle,ile2,sectoggle)
	return true
end

function setColorPickerColor(col)
	local top = tonumber(col:GetAttribute("Top"))
	local bottom = tonumber(col:GetAttribute("Bottom"))
	
	findColor(true,top,bottom,false)

	script.Parent.Parent.ColorPicker.Reset:SetAttribute("Top",script.Parent.Parent.ColorPicker.Top.ColorPickerFrame.ColorPickerArea.Picker.Position.X.Scale)
script.Parent.Parent.ColorPicker.Reset:SetAttribute("Bottom",script.Parent.Parent.ColorPicker.Bottom.ColorPickerFrame.ColorPickerArea.Picker.Position.X.Scale)
end

script.Parent.Parent.ColorPicker.Reset.MouseButton1Click:Connect(function()
	if canpaint then
		local top = script.Parent.Parent.ColorPicker.Reset:GetAttribute("Top")
		local bottom = script.Parent.Parent.ColorPicker.Reset:GetAttribute("Bottom")
		setColorPickerColor(script.Parent.Parent.ColorPicker.Reset)
		
		if canpaint then
			local v = script.Parent.Parent.ColorPicker.Bottom.ColorPickerFrame.ColorShower
			paintRE:FireServer(v.BackgroundColor3,v)
		end
	end
end)

cPB.MouseButton1Click:Connect(function()
	game.ReplicatedStorage.Events.ColorPickerEvents.PickB:Fire(paintframe)
	script.Parent.Parent.ColorPicker:TweenPosition(UDim2.new(0.298, 0,0.482, 0),0,0,0.35)
end)

for i, v in pairs(paintframe.Colors:GetChildren()) do
	v.MouseButton1Click:Connect(function()
		AudioPlayer.playAudio("Click")
		paintRE:FireServer(v.BackgroundColor3,v)
		colorbutton.BackgroundColor3 = v.BackgroundColor3
		setColorPickerColor(v)
		wait()
		paintframe.ColorColor.BackgroundColor3 = v.BackgroundColor3
	end)
end

setCustom.MouseButton1Click:Connect(function()
	if customToggle then
		customToggle = false
		setCustom.BackgroundColor3 = Color3.fromRGB(27, 42, 53)
	else
		customToggle = true
		setCustom.BackgroundColor3 = Color3.fromRGB(255,255,255)
	end
end)

for i, v in pairs(paintframe.Customs:GetChildren()) do
	v.MouseButton1Click:Connect(function()
		if not customToggle then
			setColorPickerColor(v)
			AudioPlayer.playAudio("Click")
			paintRE:FireServer(v.BackgroundColor3,v)
			colorbutton.BackgroundColor3 = v.BackgroundColor3
		else
			local secondCustom = script.Parent.Parent.PaintFrame.Customs[v.Name]		game.ReplicatedStorage.Events.ColorPickerEvents.CustomProp:FireServer(v,script.Parent.Parent.ColorPicker.Top.ColorPickerFrame.ColorPickerArea.Picker.Position.X.Scale,script.Parent.Parent.ColorPicker.Bottom.ColorPickerFrame.ColorPickerArea.Picker.Position.X.Scale,secondCustom)

			v.BackgroundColor3 = script.Parent.Parent.ColorPicker.Bottom.ColorPickerFrame.ColorShower.BackgroundColor3

			secondCustom.BackgroundColor3 = script.Parent.Parent.ColorPicker.Bottom.ColorPickerFrame.ColorShower.BackgroundColor3
		end
	end)
end

colorbutton.MouseButton1Click:Connect(function()
	if canyou then
		canyou.Value = false
		AudioPlayer.playAudio("Click")
		canpaint = true
		game.ReplicatedStorage.Events.ColorPickerEvents.PickB:Fire(paintframe)
		wait()	
		findColor(true,tonumber(paintframe.ColorColor:GetAttribute("Top")),tonumber(paintframe.ColorColor:GetAttribute("Bottom")))
		paintframe:TweenPosition(UDim2.new(0.209,0,0.809,0),0,0,0.35)
		
		game.ReplicatedStorage.Events.SystemsEvents.shutdownSystemsB:Fire(colorbutton)
		game.ReplicatedStorage.ClockOff:Fire()
		
		if buildButton:GetAttribute("isOn") == true then
			shopFrame:TweenPosition(UDim2.new(0, 0,1.139, 0),0,0,0.2)
		end
		script.Parent.Visible = false

		wait(0.1)
		paintclose.Visible = true
	else
		errormodule.errorfuncGo(plr,"You had already activated other system.")	
	end
end)

paintclose.MouseButton1Click:Connect(function()
	AudioPlayer.playAudio("Click")
	canyou.Value = true
	canpaint = false
	paintframe:TweenPosition(UDim2.new(0.209,0,1.133,0),0,0,0.3)
	script.Parent.Visible = true
	paintclose.Visible = false
end)

game.ReplicatedStorage.Events.ColorPickerEvents.TeDrugie.OnClientEvent:Connect(function()
	for i,v in pairs(script.Parent.Parent.PaintPlotFrame.Customs:GetChildren()) do
		local top = tonumber(v:GetAttribute("Top"))
		local bottom = tonumber(v:GetAttribute("Bottom"))
		findColor(true,top,bottom)
		wait()
		v.BackgroundColor3 = script.Parent.Parent.ColorPicker.Bottom.ColorPickerFrame.ColorShower.BackgroundColor3
	end
	findColor(true,0,0.5)
end)

---------------------------------------------------------------------------
shopbut.MouseButton1Click:Connect(function()
	AudioPlayer.playAudio("Click")
	lastframe.Visible = false
	lastbut.BackgroundColor3 = Color3.new(1,1, 1)
	lastbut.BorderSizePixel = 1
	lastbut = shopbut
	lastframe = shop
	shopbut.BackgroundColor3 = Color3.new(0.529,0.529, 0.529)
	shopbut.BorderSizePixel = 5
	shop.Visible = true
end)

musicbut.MouseButton1Click:Connect(function()
	AudioPlayer.playAudio("Click")
	lastframe.Visible = false
	lastbut.BackgroundColor3 = Color3.new(1,1, 1)
	lastbut.BorderSizePixel = 1
	lastbut = musicbut
	lastframe = music
	musicbut.BackgroundColor3 = Color3.new(0.529,0.529, 0.529)
	musicbut.BorderSizePixel = 5
	music.Visible = true
end)

otherbut.MouseButton1Click:Connect(function()
	AudioPlayer.playAudio("Click")
	lastframe.Visible = false
	lastbut.BackgroundColor3 = Color3.new(1,1, 1)
	lastbut.BorderSizePixel = 1
	lastbut = otherbut
	lastframe = other
	otherbut.BackgroundColor3 = Color3.new(0.529,0.529, 0.529)
	otherbut.BorderSizePixel = 5
	other.Visible = true
end)
---------------------------
changeBinds.MouseButton1Click:Connect(function()
	script.Parent.Parent.BindFrame:TweenPosition(UDim2.new(0.259, 0,0.483, 0))
end)

---------------------------------------------------------------------------

----------------------------------------------------------------------------
shop.NameShop.FocusLost:Connect(function(zmieniono)
	RS.SettingsFolder.ShopNameSet:FireServer(shop.NameShop.Text,plot)
end)

RS.SettingsFolder.ShopNameSet.OnClientEvent:Connect(function(message)
	shop.NameShop.Text = message
end)

-----ANIMS-----

local animSwitch = other.animSwitch

local animToggle = false

local off,on = UDim2.new(-0.176, 0,-0.212, 0),UDim2.new(0.559, 0,-0.212, 0)

local animEvent = RS.AnimationEvents.setAnimSettings

animSwitch.MouseButton1Click:Connect(function()
	if animToggle then
		animToggle = false
		animSwitch.Switch:TweenPosition(off,nil,nil,0.3)
		animSwitch.BackgroundColor3 = Color3.new(0.92549, 0, 0)
	elseif not animToggle then
		animToggle = true
		animSwitch.Switch:TweenPosition(on,nil,nil,0.3)
		animSwitch.BackgroundColor3 = Color3.new(0, 0.666667, 0)
	end
	animEvent:FireServer(animToggle)
end)

animEvent.OnClientEvent:Connect(function()
	animToggle = plr.SetFolder.localAnims.Value
	if animToggle then
		animSwitch.Switch:TweenPosition(on,nil,nil,0.3)
		animSwitch.BackgroundColor3 = Color3.new(0, 0.666667, 0)
	elseif not animToggle then
		animSwitch.Switch:TweenPosition(off,nil,nil,0.3)
		animSwitch.BackgroundColor3 = Color3.new(0.92549, 0, 0)
	end
end)


game.ReplicatedStorage.Events.RESETGUI.OnClientEvent:Connect(function(toggle)
	if not toggle then
		paintframe:TweenPosition(UDim2.new(0.209,0,1.133,0),0,0,0.3)
	end
end)