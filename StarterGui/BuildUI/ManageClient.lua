local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local getPlot = game.ReplicatedStorage.Remotes.requestPlot
local button = script.Parent:WaitForChild("BuildSystemsAndInfo").Manage
local plot = getPlot:InvokeServer()
local obj
local managetoggle
local tar
local contextActionService = game:GetService("ContextActionService")
local bindFrame = player.PlayerGui.BuildUI:WaitForChild("BindFrame")
local UIS = game:GetService("UserInputService")

local buildButton = script.Parent.BuildSystemsAndInfo.Shop

local modelframe = script.Parent.DisplayTableFrame
local shelfframe = script.Parent.ShelfFrame
local smallshelfframe = script.Parent.SmallShelfFrame
local ustawcapacity = 0

local errormodule = require(game.ReplicatedStorage.Modules.ErrorModule)
local AudioPlayer = require(game.ReplicatedStorage.Modules:WaitForChild("AudioModule"))
local specialtoggle = true
local rs = game:GetService('RunService')
local towarevents = game.ReplicatedStorage.Events.TowarEvents
local autoframe = script.Parent.AutoBuyFrame
local infoframe = script.Parent.InfoAutoBuyFrame
local lightframe = script.Parent.LightManage
local signframe = script.Parent.InfoSignFrame
local LastPart = nil
local mobileToggle = true

local errormodule = require(game.ReplicatedStorage.Modules.ErrorModule)

local selectionbox = Instance.new('SelectionBox');

local hideModule = require(game.ReplicatedStorage.Modules.HideModule)

selectionbox.LineThickness = 0.1
selectionbox.Parent = workspace.CurrentCamera;
selectionbox.Color3 = Color3.new(0,255,0)
selectionbox.Transparency = 0.6

local plr = game.Players.LocalPlayer
local setSignText = game.ReplicatedStorage.Events:WaitForChild("SetSignText")
local checkSignText = game.ReplicatedStorage.Events:WaitForChild("CheckSignText")
local closeest = signframe.ShopClose

local themeButtons = signframe.ThemeButtons
local currentTheme = signframe.CurrentTheme
local theme = signframe.ThemeVal

local shopFrame = player:WaitForChild("PlayerGui"):WaitForChild("BuildUI"):WaitForChild("ShopFrame")

local lightbuttonchange = signframe.ChangeLight

local handledModel = nil

local comp = nil

--local function GoTextGo(cos1,cos2)
--	local message = signframe.TextBox.Text
--end

local function GoCheckTextGo()
	local message = signframe.TextBox.Text
	if message ~= "" then
		checkSignText:FireServer(message)
	end
	setSignText:FireServer(message,obj)
end

local counter = 0

function mobileAssist(actionName, inputState, inputObj)
	if inputState == Enum.UserInputState.Change then
		counter += 1
		if counter >= 4 then
			mobileToggle = false
		end
	end
	if inputState == Enum.UserInputState.Begin and not mobileToggle then
		counter = 0
		mobileToggle = true
		tar = nil
		LastPart = nil
		obj = nil
		selectionbox.Adornee = nil
	end
	return Enum.ContextActionResult.Pass
end

--signframe.ACCEPT.MouseButton1Click:Connect(GoTextGo)

local lighttoggle1 = false

lightbuttonchange.MouseButton1Click:Connect(function()
	local onoff = signframe.ChangeLight
	local value = onoff:GetAttribute("KtoryTryb")
	
	if value == 0 then
		value = 1
		onoff:SetAttribute("KtoryTryb",value)
		onoff.Text = "ON"
	elseif value == 1 then
		value = 2
		onoff:SetAttribute("KtoryTryb",value)
		onoff.Text = "ON AT NIGHT"
	elseif value == 2 then
		value = 0
		onoff:SetAttribute("KtoryTryb",value)
		onoff.Text = "OFF"
	end
	
	game.ReplicatedStorage.Events.LightManage:FireServer(handledModel.Parent.Paintable2.LightPart.Light,nil,nil,onoff:GetAttribute("KtoryTryb"),nil)
end)

checkSignText.OnClientEvent:Connect(function(mess)
	signframe.TextBox.Text = mess
end)

closeest.MouseButton1Click:Connect(function()
	resetFrames()
	signframe.TextBox.Text = ""
	specialtoggle = true
	selectionbox.Adornee = nil
	LastPart = nil
	handledModel = nil
end) 

for i,n in pairs(themeButtons:GetChildren()) do
	n.MouseButton1Click:Connect(function()
		--theme:SetAttribute("Bg",n.BackgroundColor3)
		--theme:SetAttribute("Text",n.TextColor3)
		currentTheme.BackgroundColor3 = n.BackgroundColor3
		currentTheme.TextColor3 = n.TextColor3
		setSignText:FireServer(nil,handledModel,n.BackgroundColor3,n.TextColor3)
	end)
end

signframe.TextBox.FocusLost:Connect(GoCheckTextGo)

game.ReplicatedStorage.Events.ManageClose.OnClientEvent:Connect(function()
	game.ReplicatedStorage.ClockOn:Fire()
	wait(0.02)
	obj = nil
	rs:UnbindFromRenderStep("manage")
	managetoggle = false
	--aleodjazd()
	selectionbox.Adornee = nil
	LastPart = nil
	button.BackgroundColor3 = Color3.new(0.882353, 0.882353, 0.882353)
	resetFrames()
	if buildButton:GetAttribute("isOn") == true then
		if shopFrame:GetAttribute('isShown') then
			shopFrame:TweenPosition(UDim2.new(0, 0,0.839, 0),nil,nil,0.2)
			shopFrame.Roll.Rotation = 180
		else
			shopFrame:TweenPosition(UDim2.new(0, 0,1, 0),nil,nil,0.2)
			shopFrame.Roll.Rotation = 0
		end
	end
end)

function startStop(actionName, inputState, inputObj)
	if inputState ==  Enum.UserInputState.Begin and not player:GetAttribute("isBind") or not inputState and not player:GetAttribute("isBind") then
		if managetoggle then
			game.ReplicatedStorage.ClockOn:Fire()
			specialtoggle = false
			AudioPlayer.playAudio("Click")
			obj = nil
			rs:UnbindFromRenderStep("manage")
			if UIS.TouchEnabled then
				contextActionService:UnbindAction("mobileAssist")
			end
			managetoggle = false
			selectionbox.Adornee = nil
			LastPart = nil
			button.BackgroundColor3 = Color3.new(0.882353, 0.882353, 0.882353)
			if buildButton:GetAttribute("isOn") == true then
				if shopFrame:GetAttribute('isShown') then
					shopFrame:TweenPosition(UDim2.new(0, 0,0.839, 0),nil,nil,0.2)
					shopFrame.Roll.Rotation = 180
				else
					shopFrame:TweenPosition(UDim2.new(0, 0,1, 0),nil,nil,0.2)
					shopFrame.Roll.Rotation = 0
				end
			end
			resetFrames()
			hideModule.visibleOn()
		elseif not managetoggle then
			specialtoggle = true
			game.ReplicatedStorage.Events.SystemsEvents.shutdownSystemsB:Fire(button)
			AudioPlayer.playAudio("Click")
			game.ReplicatedStorage.ClockOff:Fire()
			managetoggle = true
			counter = 0
			mobileToggle = true
			rs:BindToRenderStep("manage",1,managing)
			if UIS.TouchEnabled then
				contextActionService:BindAction("mobileAssist", mobileAssist, false, Enum.UserInputType.Touch)
			end
			button.BackgroundColor3 = Color3.new(0.313725, 0.345098, 0.364706)
			game.ReplicatedStorage.Events.RESETGUI:FireServer(true)
			if buildButton:GetAttribute("isOn") == true then
				shopFrame:TweenPosition(UDim2.new(0, 0,1.139, 0),0,0,0.2)
			end
			hideModule.visibleOff(button)
		end
	end
end

function convert()
	local input = bindFrame.MANAGE:GetAttribute("Bind")
	if input == "1" then
		return Enum.KeyCode["One"]
	elseif input == "2" then
		return Enum.KeyCode["Two"]
	elseif input == "3" then
		return Enum.KeyCode["Three"]
	elseif input == "4" then
		return Enum.KeyCode["Four"]
	elseif input == "5" then
		return Enum.KeyCode["Five"]
	elseif input == "6" then
		return Enum.KeyCode["Six"]
	elseif input == "7" then
		return Enum.KeyCode["Seven"]
	elseif input == "8" then
		return Enum.KeyCode["Eight"]
	elseif input == "9" then
		return Enum.KeyCode["Nine"]
	elseif input == "0" then
		return Enum.KeyCode["Zero"]
	end
	return Enum.KeyCode[input]
end

contextActionService:BindAction("startStopManage", startStop, false, convert())

bindFrame.MANAGE.AttributeChanged:Connect(function()
	contextActionService:UnbindAction("startStopManage")
	wait()
	contextActionService:BindAction("startStopManage", startStop, false, convert())
end)



button.MouseButton1Click:Connect(function()
	startStop()
end)

function resetFrames(frame)
	if shelfframe.Position.Y.Scale < 1 and shelfframe ~= frame then
		shelfframe:TweenPosition(UDim2.new(0.36, 0, 1.1, 0),0,0,0.25)
	end
	
	if smallshelfframe.Position.Y.Scale < 1 and smallshelfframe ~= frame then
		smallshelfframe:TweenPosition(UDim2.new(0.36, 0, 1.1, 0),0,0,0.25)
	end
	
	if modelframe.Position.Y.Scale < 1 and modelframe ~= frame then
		modelframe:TweenPosition(UDim2.new(0.36, 0, 1.1, 0),0,0,0.25)
	end
	
	if autoframe.Position.Y.Scale < 1 and autoframe ~= frame then
		autoframe:TweenPosition(UDim2.new(0.353, 0, 1.376, 0),0,0,0.25)
		infoframe:TweenPosition(UDim2.new(0.353, 0, 1.278, 0),0,0,0.25)
		towarevents.EkranOff:FireServer(comp.Parent)
	end
	
	if lightframe.Position.Y.Scale < 1 and lightframe ~= frame then
		lightframe:TweenPosition(UDim2.new(0.312, 0, 1.1, 0),0,0,0.25)
	end
	
	if signframe.Position.Y.Scale < 1 and signframe ~= frame then
		signframe:TweenPosition(UDim2.new(0.333, 0, 1.1, 0),0,0,0.25)
	end
end


mouse.Button1Up:Connect(function()
	task.wait(0.12)
	if LastPart and LastPart.Parent:IsA("Model") then
		obj = LastPart
	else
		obj = nil
	end
	local success,err = pcall(function()
		if obj and obj.Parent.Parent.Parent.wazne.Owner.Value == player.Name and obj.Parent.Parent.Parent.Name == plot.Name and mobileToggle then--and obj.Parent.Name ~= "LightPart" then
			local otwarte = obj.Parent.Parent.Parent.Humans:GetChildren()

			if #otwarte > 0 then

				if obj.Parent.Name == "Shelf" or obj.Parent.Name == "SmallShelf" or obj.Parent.Name == "DisplayTable" then
					if (obj.Parent.SpotValues.LeftSpot.Value + obj.Parent.SpotValues.RightSpot.Value) > 0 or obj.Parent.beingHandled.Value == true then
						errormodule.errorfuncGo(player,"You can't manage this when it is in use.")
						specialtoggle = true
						return
					end
				end
			end
			if obj.Parent.Name == "DisplayTable" then
				if obj.Parent.Towar.KtoryArtykul.Value then
					local co = obj.Parent.Towar.KtoryArtykul.Value
					if co == "telefony" then
						modelframe.CoInfo.Text = "Phones"
					elseif co == "aparaty" then
						modelframe.CoInfo.Text = "Cameras"
					elseif co == "tablety" then
						modelframe.CoInfo.Text = "Tablets"
					end
				end
				resetFrames(modelframe)
				modelframe:TweenPosition(UDim2.new(0.36, 0, 0.322, 0),0,0,0.25)		

			elseif obj.Parent.Name == "Shelf" then
				if obj.Parent.Towar.KtoryArtykul.Value then
					local co = obj.Parent.Towar.KtoryArtykul.Value
					if co == "telewizory" then
						shelfframe.CoInfo.Text = "TVs"
					elseif co == "konsole" then
						shelfframe.CoInfo.Text = "Consoles"
					elseif co == "komputery" then
						shelfframe.CoInfo.Text = "Computers"
					elseif co == "monitory" then
						shelfframe.CoInfo.Text = "Monitors"
					end
				end
				resetFrames(shelfframe)
				shelfframe:TweenPosition(UDim2.new(0.36, 0, 0.322, 0),0,0,0.25)
			elseif obj.Parent.Name == "SmallShelf" then
				if obj.Parent.Towar.KtoryArtykul.Value then
					local co = obj.Parent.Towar.KtoryArtykul.Value
					if co == "klawiatury" then
						smallshelfframe.CoInfo.Text = "Keyboards"
					elseif co == "myszki" then
						smallshelfframe.CoInfo.Text = "Mouses"
					elseif co == "glosniki" then
						smallshelfframe.CoInfo.Text = "Speakers"
					elseif co == "sluchawki" then
						smallshelfframe.CoInfo.Text = "Headphones"
					end
				end
				resetFrames(smallshelfframe)
				smallshelfframe:TweenPosition(UDim2.new(0.36, 0, 0.322, 0),0,0,0.25)
			elseif obj.Parent.Name == "ComputerTable" then
				comp = obj
				towarevents.EkranOn:FireServer(obj.Parent)
				resetFrames(autoframe)
				autoframe:TweenPosition(UDim2.new(0.353, 0, 0.376, 0),0,0,0.25)
				infoframe:TweenPosition(UDim2.new(0.353, 0,0.278, 0),0,0,0.25)
			elseif string.match(obj.Parent.Name,"Light") then
				handledModel = obj
				local modul = obj.Parent
				lightframe.Wartosci.AngleVal.Text = modul.LightPart.Light.Angle
				lightframe.Wartosci.BrightnessVal.Text = math.round(modul.LightPart.Light.Brightness*100)/100
				lightframe.Wartosci.RangeVal.Text = modul.LightPart.Light.Range
				local tryb = modul.LightPart.Light:GetAttribute("KtoryTryb")
				if tryb == 0 then
					lightframe.Wartosci.OnOffVal.Text = "OFF"
					lightframe.Wartosci.OnOffVal:SetAttribute("KtoryTryb",0)
				elseif tryb == 1 then
					lightframe.Wartosci.OnOffVal.Text = "ON"
					lightframe.Wartosci.OnOffVal:SetAttribute("KtoryTryb",1)
				elseif tryb == 2 then
					lightframe.Wartosci.OnOffVal.Text = "ON AT NIGHT"
					lightframe.Wartosci.OnOffVal:SetAttribute("KtoryTryb",2)
				end
				lightframe.Object.Value = modul
				resetFrames(lightframe)
				task.wait(0.05)
				lightframe.ShopClose.Visible = true
				lightframe:TweenPosition(UDim2.new(0.312, 0,0.679, 0),0,0,0.25)
				obj = nil
			elseif obj.Parent.Name == "InfoSignOnWall" or obj.Parent.Name == "InfoSignOnCelling" then
				handledModel = obj
				local modul = obj.Parent
				resetFrames(signframe)
				signframe:TweenPosition(UDim2.new(0.333, 0,0.741, 0),nil,nil,0.25)
				
				local tryb = modul.Paintable2.LightPart.Light:GetAttribute("KtoryTryb")
				
				if tryb == 0 then
					signframe.ChangeLight.Text = "OFF"
					signframe.ChangeLight:SetAttribute("KtoryTryb",0)
				elseif tryb == 1 then
					signframe.ChangeLight.Text = "ON"
					signframe.ChangeLight:SetAttribute("KtoryTryb",1)
				elseif tryb == 2 then
					signframe.ChangeLight.Text = "ON AT NIGHT"
					signframe.ChangeLight:SetAttribute("KtoryTryb",2)
				end
				signframe.TextBox.Text = obj.Parent.Part.SurfaceGui.TextLabel.Text
				currentTheme.BackgroundColor3 = obj.Parent.Part.SurfaceGui.TextLabel.BackgroundColor3
				currentTheme.TextColor3 = obj.Parent.Part.SurfaceGui.TextLabel.TextColor3
			end
			if player:GetAttribute("DoesTutorial") then
				game.ReplicatedStorage.Events.JestManageKlikniete:FireServer()
			end
		elseif not mobileToggle then
			counter = 0
			mobileToggle = true
			obj = nil
			LastPart = nil
			selectionbox.Adornee = nil
			tar = nil
		else
			resetFrames()
		end
	end)
end)

local function settowar(co, model)
	
	if not model then
		return
	end
	if player.TowarFolder:FindFirstChild(co).Value >= 6 then
		towarevents.UstalServer:FireServer(co, model, true)
	else	
		towarevents.UstalServer:FireServer(co, model, false)
	end
	specialtoggle = true	


	modelframe:TweenPosition(UDim2.new(0.36, 0, 1.022, 0),0,0,0.25)

	shelfframe:TweenPosition(UDim2.new(0.36, 0, 1.022, 0),0,0,0.25)
	smallshelfframe:TweenPosition(UDim2.new(0.36, 0, 1.022, 0),0,0,0.25)
	wait(0.2)
	modelframe.CoInfo.Text = " "
	shelfframe.CoInfo.Text = " "
	smallshelfframe.CoInfo.Text = " "
end

game.ReplicatedStorage.Events.MagazynEvents.Close.OnClientEvent:Connect(function()
	resetFrames()
	specialtoggle = true
	wait(0.2)
	modelframe.CoInfo.Text = " "
end)

modelframe.XButton.MouseButton1Click:Connect(function()
	resetFrames()
	specialtoggle = true
	wait(0.2)
	modelframe.CoInfo.Text = " "
end)
shelfframe.XButton.MouseButton1Click:Connect(function()
	resetFrames()
	specialtoggle = true
	wait(0.2)
	shelfframe.CoInfo.Text = " "
end)
smallshelfframe.XButton.MouseButton1Click:Connect(function()
	resetFrames()
	specialtoggle = true
	wait(0.2)
	smallshelfframe.CoInfo.Text = " "
end)

infoframe.XButton.MouseButton1Down:Connect(function()
	specialtoggle = true
	selectionbox.Adornee = nil
	LastPart = nil
	towarevents.EkranOff:FireServer(comp.Parent)
	comp = nil
end)

modelframe.telefony.MouseButton1Click:Connect(function()
	if not obj then
		errormodule.errorfuncGo(plr,"Something went wrong with choosing a furniture. Please try again.")
		return
	end
	settowar("telefony", obj.Parent)
end)
modelframe.aparaty.MouseButton1Click:Connect(function()
	if not obj then
		errormodule.errorfuncGo(plr,"Something went wrong with choosing a furniture. Please try again.")
		return
	end
	settowar("aparaty", obj.Parent)
end)
modelframe.tablety.MouseButton1Click:Connect(function()
	if not obj then
		errormodule.errorfuncGo(plr,"Something went wrong with choosing a furniture. Please try again.")
		return
	end
	settowar("tablety", obj.Parent)
end)
shelfframe.komputery.MouseButton1Click:Connect(function()
	if not obj then
		errormodule.errorfuncGo(plr,"Something went wrong with choosing a furniture. Please try again.")
		return
	end
	settowar("komputery", obj.Parent)
end)
shelfframe.telewizory.MouseButton1Click:Connect(function()
	if not obj then
		errormodule.errorfuncGo(plr,"Something went wrong with choosing a furniture. Please try again.")
		return
	end
	settowar("telewizory", obj.Parent)
end)
shelfframe.konsole.MouseButton1Click:Connect(function()
	if not obj then
		errormodule.errorfuncGo(plr,"Something went wrong with choosing a furniture. Please try again.")
		return
	end
	settowar("konsole", obj.Parent)
end)
shelfframe.monitory.MouseButton1Click:Connect(function()
	if not obj then
		errormodule.errorfuncGo(plr,"Something went wrong with choosing a furniture. Please try again.")
		return
	end
	settowar("monitory", obj.Parent)
end)
smallshelfframe.klawiatury.MouseButton1Click:Connect(function()
	if not obj then
		errormodule.errorfuncGo(plr,"Something went wrong with choosing a furniture. Please try again.")
		return
	end
	settowar("klawiatury", obj.Parent)
end)
smallshelfframe.myszki.MouseButton1Click:Connect(function()
	if not obj then
		errormodule.errorfuncGo(plr,"Something went wrong with choosing a furniture. Please try again.")
		return
	end
	settowar("myszki", obj.Parent)
end)
smallshelfframe.glosniki.MouseButton1Click:Connect(function()
	if not obj then
		errormodule.errorfuncGo(plr,"Something went wrong with choosing a furniture. Please try again.")
		return
	end
	settowar("glosniki", obj.Parent)
end)
smallshelfframe.sluchawki.MouseButton1Click:Connect(function()
	if not obj then
		errormodule.errorfuncGo(plr,"Something went wrong with choosing a furniture. Please try again.")
		return
	end
	settowar("sluchawki", obj.Parent)
end)

function mudzin()
	local checkvalue = player.ValueFolder.MaxCapacity.Value
	ustawcapacity = 0
	
	for i,numa in ipairs(player.TowarFolder:GetChildren()) do
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

modelframe.Erase.MouseButton1Click:Connect(function()
	if not obj then
		errormodule.errorfuncGo(plr,"Something went wrong with choosing a furniture. Please try again.")
		return
	end
	towarevents.Erase:FireServer(obj.Parent)
	modelframe.CoInfo.Text = " "
end)
shelfframe.Erase.MouseButton1Click:Connect(function()
	if not obj then
		errormodule.errorfuncGo(plr,"Something went wrong with choosing a furniture. Please try again.")
		return
	end
	towarevents.Erase:FireServer(obj.Parent)
	shelfframe.CoInfo.Text = " "
end)
smallshelfframe.Erase.MouseButton1Click:Connect(function()
	if not obj then
		errormodule.errorfuncGo(plr,"Something went wrong with choosing a furniture. Please try again.")
		return
	end
	towarevents.Erase:FireServer(obj.Parent)
	smallshelfframe.CoInfo.Text = " "
end)

--SPECIAL TOGGLE CHANGES

modelframe.MouseEnter:Connect(function()
	specialtoggle = false
end)

modelframe.MouseLeave:Connect(function()
	specialtoggle = true
end)

shelfframe.MouseEnter:Connect(function()
	specialtoggle = false
end)

shelfframe.MouseLeave:Connect(function()
	specialtoggle = true
end)

smallshelfframe.MouseEnter:Connect(function()
	specialtoggle = false
end)

smallshelfframe.MouseLeave:Connect(function()
	specialtoggle = true
end)

infoframe.MouseEnter:Connect(function()
	specialtoggle = false
end)

infoframe.MouseLeave:Connect(function()
	specialtoggle = true
end)

signframe.MouseEnter:Connect(function()
	specialtoggle = false
end)

signframe.MouseLeave:Connect(function()
	specialtoggle = true
end)

lightframe.MouseEnter:Connect(function()
	specialtoggle = false
end)

lightframe.MouseLeave:Connect(function()
	specialtoggle = true
end)

autoframe.MouseEnter:Connect(function()
	specialtoggle = false
end)

autoframe.MouseLeave:Connect(function()
	specialtoggle = true
end)

function managing()
	if mouse.Target and managetoggle and specialtoggle then

		tar = mouse.Target

		if tar.Name == "Primary" and tar.Parent.Name == "DisplayTable" or tar.Parent.Name == "Shelf" or tar.Parent.Name == "ComputerTable" 
			or tar.Parent.Name == "SmallShelf" or string.match(tar.Parent.Name,"Light") or tar.Parent.Name == "InfoSignOnWall" or tar.Parent.Name == "InfoSignOnCelling"   then
			if tar.Parent.Parent.Parent.wazne.Owner.Value == player.Name and tar.Parent.Parent.Parent.Name == plot.Name then

				LastPart = tar

				selectionbox.Adornee = mouse.Target;	
			end

		else
			selectionbox.Adornee = nil
			LastPart = nil
		end
	else
		selectionbox.Adornee = nil
		LastPart = nil
		tar = nil
	end
end

local close = lightframe.ShopClose

close.MouseButton1Click:Connect(function()

	lightframe:TweenPosition(UDim2.new(0.312, 0,1.279, 0),0,0,0.25)

	specialtoggle = true
	selectionbox.Adornee = nil
	LastPart = nil
	handledModel = nil
end)

game.ReplicatedStorage.Events.RESETGUI.OnClientEvent:Connect(function(toggle)
	if not toggle then
		obj = nil
		rs:UnbindFromRenderStep("manage")
		counter = 0
		mobileToggle = true
		handledModel = nil
		if UIS.TouchEnabled then
			contextActionService:UnbindAction("mobileAssist")
		end
		managetoggle = false
		specialtoggle = true
		button.BackgroundColor3 = Color3.new(0.882353, 0.882353, 0.882353)
		selectionbox.Adornee = nil
		LastPart = nil
		resetFrames()
	end
end)

game.ReplicatedStorage.Events.SystemsEvents.shutdownSystemsB.Event:Connect(function(current)
	if current ~= button then
		obj = nil
		rs:UnbindFromRenderStep("manage")
		counter = 0
		mobileToggle = true
		if UIS.TouchEnabled then
			contextActionService:UnbindAction("mobileAssist")
		end
		managetoggle = false
		specialtoggle = true
		handledModel = nil
		selectionbox.Adornee = nil
		LastPart = nil
		button.BackgroundColor3 = Color3.new(0.882353, 0.882353, 0.882353)
		resetFrames()
	end
end)