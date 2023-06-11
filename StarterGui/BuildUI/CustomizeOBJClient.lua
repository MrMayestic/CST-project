local placementModule = require(game.ReplicatedStorage.Modules.PlacementModuleV3)
local getPlot = game.ReplicatedStorage.Remotes.requestPlot

local plot = getPlot:InvokeServer()
local AudioPlayer = require(game.ReplicatedStorage.Modules:WaitForChild("AudioModule"))
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local runService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local contextActionService = game:GetService("ContextActionService")
local bindFrame = player.PlayerGui.BuildUI:WaitForChild("BindFrame")
--local partBtn script.Parent.MainFrame.Part
local onOff = script.Parent:WaitForChild("BuildFrame").Paint

local shopFrame = player:WaitForChild("PlayerGui"):WaitForChild("BuildUI"):WaitForChild("ShopFrame")

local PaintFrame = script.Parent.PaintFrame
local cPB = PaintFrame.ColorPickerButton
local pickColor = PaintFrame.PickColor
local green = script.Parent.PaintFrame.Colors.Green
local red = script.Parent.PaintFrame.Colors.Red
local blue = script.Parent.PaintFrame.Colors.Blue
local yellow = script.Parent.PaintFrame.Colors.Yellow
local lightgray = script.Parent.PaintFrame.Colors["Light Gray"]
local orange = script.Parent.PaintFrame.Colors.Orange
local white = script.Parent.PaintFrame.Colors.White
local black = script.Parent.PaintFrame.Colors.Black
local gray = script.Parent.PaintFrame.Colors.Gray

local TweenService = game:GetService("TweenService")

local eventColor = game.ReplicatedStorage.Events.ColorOBJ
local color 
local Seccolor
local obj = nil
local canpaint
local WhichV = script.Parent.PaintFrame.Ktore

local buildButton = script.Parent.BuildSystemsAndInfo.Shop

local pickToggle = false
local firstPaint = false
local mobileToggle = true

local tar = nil
local LastPart = nil
local paint1 = script.Parent.PaintFrame.FirstColor
local paint2 = script.Parent.PaintFrame.SecColor

local change = PaintFrame.Change

local hideModule = require(game.ReplicatedStorage.Modules.HideModule)

local materialFrame = script.Parent:WaitForChild("MaterialSelector")

local setCustom = PaintFrame.SetCustom

local customToggle = false

local changeToggle = false

local errormodule = require(game.ReplicatedStorage.Modules.ErrorModule)

local selectionbox = Instance.new('SelectionBox');

selectionbox.LineThickness = 0.1
selectionbox.Parent = workspace.CurrentCamera;
selectionbox.Color3 = Color3.new(0,255,0)
selectionbox.Transparency = 0.6

local selectionboxSelected = Instance.new('SelectionBox');

selectionboxSelected.LineThickness = 0.15
selectionboxSelected.Parent = workspace.CurrentCamera;
selectionboxSelected.Color3 = Color3.new(1, 0, 0.0156863)
selectionboxSelected.Transparency = 0.5

local function findColor(toggle,ile,ile2,sectoggle)
	if ile and ile2 then
		game.ReplicatedStorage.Remotes.CPTopB:Invoke(toggle,ile,false)
		task.wait(0.05)
		game.ReplicatedStorage.Events.ColorPickerEvents.SetBottomB:Fire(toggle,ile2,sectoggle)
		task.wait()
	end
	return true
end

function ping()
	local t = tick()
	local cos = game.ReplicatedStorage.PingTest.RemoteFunction:InvokeServer()
	local ping = ((tick() - t) / 2) + 0.01
	return ping
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
		selectionboxSelected.Adornee = nil
	end
	return Enum.ContextActionResult.Pass
end

function setColorPickerColor(col)
	local top = tonumber(col:GetAttribute("Top"))
	local bottom = tonumber(col:GetAttribute("Bottom"))

	findColor(true,top,bottom,false)
	
	task.wait()
	
	if not WhichV.Value then
		paint1:SetAttribute("Top",script.Parent.ColorPicker.Top.ColorPickerFrame.ColorPickerArea.Picker.Position.X.Scale)
		paint1:SetAttribute("Bottom",script.Parent.ColorPicker.Bottom.ColorPickerFrame.ColorPickerArea.Picker.Position.X.Scale)
	else
		paint2:SetAttribute("Top",script.Parent.ColorPicker.Top.ColorPickerFrame.ColorPickerArea.Picker.Position.X.Scale)
		paint2:SetAttribute("Bottom",script.Parent.ColorPicker.Bottom.ColorPickerFrame.ColorPickerArea.Picker.Position.X.Scale)
	end
	
	script.Parent.ColorPicker.Reset:SetAttribute("Top",script.Parent.ColorPicker.Top.ColorPickerFrame.ColorPickerArea.Picker.Position.X.Scale)
	script.Parent.ColorPicker.Reset:SetAttribute("Bottom",script.Parent.ColorPicker.Bottom.ColorPickerFrame.ColorPickerArea.Picker.Position.X.Scale)
end


script.Parent.ColorPicker.Reset.MouseButton1Click:Connect(function()
	if canpaint then
		local top = script.Parent.ColorPicker.Reset:GetAttribute("Top")
		local bottom = script.Parent.ColorPicker.Reset:GetAttribute("Bottom")

		if not WhichV.Value then
			setColorPickerColor(script.Parent.ColorPicker.Reset)
			color = script.Parent.ColorPicker.Bottom.ColorPickerFrame.ColorShower.BackgroundColor3
			paint1.BackgroundColor3 = script.Parent.ColorPicker.Bottom.ColorPickerFrame.ColorShower.BackgroundColor3
		else
			setColorPickerColor(script.Parent.ColorPicker.Reset)
			Seccolor = script.Parent.ColorPicker.Bottom.ColorPickerFrame.ColorShower.BackgroundColor3
			paint2.BackgroundColor3 = script.Parent.ColorPicker.Bottom.ColorPickerFrame.ColorShower.BackgroundColor3
		end
		
		if color or Seccolor and canpaint and LastPart then
			eventColor:FireServer(obj, color,Seccolor,paint1:GetAttribute("Top"),paint1:GetAttribute("Bottom"),paint2:GetAttribute("Top"),paint2:GetAttribute("Bottom"))
		end
	end
end)

game.ReplicatedStorage.Events.ColorOBJ.OnClientEvent:Connect(function(col,seccol)
	if col then
		color = col
	end
	if seccol then
		Seccolor = seccol
	end
end)

game.ReplicatedStorage.Events.ColorPickerEvents.setColorsLocal.Event:Connect(function(col,seccol)
	if col then
		color = col
	end
	if seccol then
		Seccolor = seccol
	end
end)

paint1.MouseButton1Click:Connect(function()
	while changeToggle do
		wait()
	end
	
	changeToggle = true
	WhichV.Value = false
	paint2.UIStroke.Color = Color3.new(0,0,0)
	paint1.UIStroke.Color = Color3.new(1,1,1)
	game.ReplicatedStorage.Events.ColorPickerEvents.ChangeFSCB:Fire(paint1)

	findColor(true,paint1:GetAttribute("Top"),paint1:GetAttribute("Bottom"),true)
	
	task.wait(0.03)
	changeToggle = false
end)

paint2.MouseButton1Click:Connect(function()
	while changeToggle do
		wait()
	end
	
	changeToggle = true
	WhichV.Value = true
	paint1.UIStroke.Color = Color3.new(0,0,0)
	paint2.UIStroke.Color = Color3.new(1,1,1)
	game.ReplicatedStorage.Events.ColorPickerEvents.ChangeFSCB:Fire(paint2)
	
	findColor(true,paint2:GetAttribute("Top"),paint2:GetAttribute("Bottom"),true)
	
	task.wait(0.03)
	changeToggle = false
end)

paint1.MaterialInfo.MouseButton1Click:Connect(function()	
	while changeToggle do
		wait()
	end
	
	materialFrame:TweenPosition(UDim2.new(0.209,0,0.585,0),0,0,0.35)	
	
	changeToggle = true
	WhichV.Value = false
	paint2.UIStroke.Color = Color3.new(0,0,0)
	paint1.UIStroke.Color = Color3.new(1,1,1)
	game.ReplicatedStorage.Events.ColorPickerEvents.ChangeFSCB:Fire(paint1)

	findColor(true,paint1:GetAttribute("Top"),paint1:GetAttribute("Bottom"),true)

	task.wait(0.03)
	changeToggle = false
	
end)

paint2.MaterialInfo.MouseButton1Click:Connect(function()	
	while changeToggle do
		wait()
	end
	
	materialFrame:TweenPosition(UDim2.new(0.209,0,0.585,0),0,0,0.35)
	
	changeToggle = true
	WhichV.Value = true
	paint1.UIStroke.Color = Color3.new(0,0,0)
	paint2.UIStroke.Color = Color3.new(1,1,1)
	game.ReplicatedStorage.Events.ColorPickerEvents.ChangeFSCB:Fire(paint2)

	findColor(true,paint2:GetAttribute("Top"),paint2:GetAttribute("Bottom"),true)

	task.wait(0.03)
	changeToggle = false
end)

PaintFrame.SetMaterial.Event:Connect(function(material)
	if WhichV.Value then
		paint2.MaterialInfo.Text = material
		paint2:SetAttribute("Material",material)
	else
		paint1.MaterialInfo.Text = material
		paint1:SetAttribute("Material",material)
	end
	eventColor:FireServer(obj, nil,nil,nil,nil,nil,nil,paint1.MaterialInfo.Text,paint2.MaterialInfo.Text)
end)

change.MouseButton1Click:Connect(function()
	if change.Text == "All" then
		change.Text = "Color Only"
	elseif change.Text == "Color Only" then
		change.Text = "Material Only"
	elseif change.Text == "Material Only" then
		change.Text = "All"
	end
end)

PaintFrame.ResetModel.MouseButton1Click:Connect(function()
	obj = nil
	LastPart = nil
	selectionboxSelected.Adornee = nil
	game.ReplicatedStorage.Events.ColorPickerEvents.SendObjB:Fire(LastPart)
end)

pickColor.MouseButton1Click:Connect(function()
	if pickToggle then
		pickToggle = false
		pickColor.BackgroundColor3 = Color3.new(0.764706, 0, 0)
	else
		pickToggle = true
		pickColor.BackgroundColor3 = Color3.new(0, 0.74902, 0)
	end
end)

function startStop(actionName, inputState, inputObj)
	if inputState ==  Enum.UserInputState.Begin and not player:GetAttribute("isBind") or not inputState and not player:GetAttribute("isBind") then
		if canpaint and not player:GetAttribute("DoesTutorial") then
			game.ReplicatedStorage.ClockOn:Fire()
			AudioPlayer.playAudio("Click")

			runService:UnbindFromRenderStep("paint")
			if UIS.TouchEnabled then
				contextActionService:UnbindAction("mobileAssist")
			end
			
			onOff.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
			script.Parent.PaintFrame:TweenPosition(UDim2.new(0.209,0,1.133,0),0,0,0.3)
			script.Parent.ColorPicker:TweenPosition(UDim2.new(0.298, 0,1.181, 0),0,0,0.3)
			materialFrame:TweenPosition(UDim2.new(0.209, 0,1.201, 0),0,0,0.3)
			if buildButton:GetAttribute("isOn") == true then
				
				if shopFrame:GetAttribute('isShown') then
					shopFrame:TweenPosition(UDim2.new(0, 0,0.839, 0),nil,nil,0.2)
					shopFrame.Roll.Rotation = 180
				else
					shopFrame:TweenPosition(UDim2.new(0, 0,1, 0),nil,nil,0.2)
					shopFrame.Roll.Rotation = 0
				end
			end
			canpaint = false
			pickToggle = false
			pickColor.BackgroundColor3 = Color3.new(0.764706, 0, 0)

			obj = nil
			LastPart = nil
			game.ReplicatedStorage.Events.ColorPickerEvents.SendObjB:Fire(LastPart)
			selectionbox.Adornee = nil
			selectionboxSelected.Adornee = nil
			local top = tonumber(paint1:GetAttribute("Top"))
			local bottom = tonumber(paint1:GetAttribute("Bottom"))
			
			script.Parent.ColorPicker.Reset:SetAttribute("Top",top)
			script.Parent.ColorPicker.Reset:SetAttribute("Bottom",bottom)
			
			hideModule.visibleOn()
			task.wait()
			script.Parent.PaintFrame.CanvasPosition = Vector2.new(0,0)
		elseif not canpaint and buildButton:GetAttribute("isOn") == true and not player:GetAttribute("DoesTutorial") then
			game.ReplicatedStorage.Events.SystemsEvents.shutdownSystemsB:Fire(onOff)
			game.ReplicatedStorage.ClockOff:Fire()
			AudioPlayer.playAudio("Click")

			canpaint = true
			counter = 0
			mobileToggle = true
			if buildButton:GetAttribute("isOn") == true then
				shopFrame:TweenPosition(UDim2.new(0, 0,1.139, 0),0,0,0.2)
			end
			script.Parent.PaintFrame:TweenPosition(UDim2.new(0.209,0,0.833,0),0,0,0.35)
			runService:BindToRenderStep("paint",1,painting)
			if UIS.TouchEnabled then
				contextActionService:BindAction("mobileAssist", mobileAssist, false, Enum.UserInputType.Touch)
			end
			onOff.BackgroundColor3 = Color3.new(0, 0.666667, 0)
			game.ReplicatedStorage.Events.RESETGUI:FireServer(true)

			game.ReplicatedStorage.Events.ColorPickerEvents.PickB:Fire(PaintFrame)
			hideModule.visibleOff(onOff)
		end
	end
end

function convert()
	local input = bindFrame.PAINT:GetAttribute("Bind")
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

contextActionService:BindAction("startStopPaint", startStop, false, convert())

bindFrame.PAINT.AttributeChanged:Connect(function()
	contextActionService:UnbindAction("startStopPaint")
	wait()
	contextActionService:BindAction("startStopPaint", startStop, false, convert())
end)


onOff.MouseButton1Click:Connect(function()
	startStop()
end)


mouse.Button1Up:Connect(function()
	task.wait(0.12)
	if canpaint then
		if LastPart and LastPart.Parent:IsA("Model") then
			if pickToggle then
				game.ReplicatedStorage.Events.ColorPickerEvents.SendObjB:Fire(nil)
			end
			game.ReplicatedStorage.Events.ColorPickerEvents.SendObjB:Fire(LastPart,pickToggle)
			obj = LastPart
			selectionboxSelected.Adornee = obj;
			if firstPaint then
				firstPaint = false
				pickToggle = false
			end
			task.wait(0.1)
			if WhichV.Value then
				game.ReplicatedStorage.Events.ColorPickerEvents.ChangeFSCB:Fire(paint2)
			else
				game.ReplicatedStorage.Events.ColorPickerEvents.ChangeFSCB:Fire(paint1)
			end
		else
			obj = nil
			LastPart = nil
			selectionbox.Adornee = nil
			selectionboxSelected.Adornee = nil
			game.ReplicatedStorage.Events.ColorPickerEvents.SendObjB:Fire(nil)
		end
		if canpaint and obj and mobileToggle then
			task.wait()
			if not pickToggle then
				if change.Text == "Color Only" then
					eventColor:FireServer(obj, color,Seccolor,paint1:GetAttribute("Top"),paint1:GetAttribute("Bottom"),paint2:GetAttribute("Top"),paint2:GetAttribute("Bottom"),nil,nil)
				elseif change.Text == "Material Only" then
					eventColor:FireServer(obj, nil,nil,nil,nil,nil,nil,paint1.MaterialInfo.Text,paint2.MaterialInfo.Text)
				else
					eventColor:FireServer(obj, color,Seccolor,paint1:GetAttribute("Top"),paint1:GetAttribute("Bottom"),paint2:GetAttribute("Top"),paint2:GetAttribute("Bottom"),paint1.MaterialInfo.Text,paint2.MaterialInfo.Text)
				end		
			end
			
			if pickToggle and change.Name ~= "Color Only" then
				if obj:FindFirstChild("Paintable1") then
					paint1.MaterialInfo.Text = obj.Paintable1.PrimaryPart.Material.Name
					paint2.MaterialInfo.Text = obj.Paintable2.PrimaryPart.Material.Name
				else
					paint1.MaterialInfo.Text = obj.Parent.Paintable1.PrimaryPart.Material.Name
					paint2.MaterialInfo.Text = obj.Parent.Paintable2.PrimaryPart.Material.Name
				end
			end
		elseif not mobileToggle then
			counter = 0
			mobileToggle = true
			LastPart = nil
			selectionbox.Adornee = nil
			selectionboxSelected.Adornee = nil
			obj = nil
			tar = nil
		end
	end
end)

PaintFrame.MaterialButton.MouseButton1Click:Connect(function()
	materialFrame:TweenPosition(UDim2.new(0.209,0,0.585,0),0,0,0.35)
end)

for i, v in pairs(PaintFrame.Colors:GetChildren()) do
	v.MouseButton1Click:Connect(function()
		if not WhichV.Value then
			color = v.BackgroundColor3
			paint1.BackgroundColor3 = v.BackgroundColor3
			
			setColorPickerColor(v)
		else
			Seccolor = v.BackgroundColor3
			paint2.BackgroundColor3 = v.BackgroundColor3
			setColorPickerColor(v)
		end
		
		if canpaint and obj then
			eventColor:FireServer(obj, color,Seccolor,paint1:GetAttribute("Top"),paint1:GetAttribute("Bottom"),paint2:GetAttribute("Top"),paint2:GetAttribute("Bottom"))
		end
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

for i, v in pairs(PaintFrame.Customs:GetChildren()) do
	v.MouseButton1Click:Connect(function()
		if not customToggle then
			if not WhichV.Value then
				color = v.BackgroundColor3
				paint1.BackgroundColor3 = v.BackgroundColor3
				setColorPickerColor(v)
			else
				Seccolor = v.BackgroundColor3
				paint2.BackgroundColor3 = v.BackgroundColor3
				setColorPickerColor(v)
			end
			
			if canpaint and obj then
				eventColor:FireServer(obj, color,Seccolor,paint1:GetAttribute("Top"),paint1:GetAttribute("Bottom"),paint2:GetAttribute("Top"),paint2:GetAttribute("Bottom"))
			end
		else
			local secondCustom = script.Parent.PaintPlotFrame.Customs:FindFirstChild(v.Name)	game.ReplicatedStorage.Events.ColorPickerEvents.CustomProp:FireServer(v,script.Parent.ColorPicker.Top.ColorPickerFrame.ColorPickerArea.Picker.Position.X.Scale,script.Parent.ColorPicker.Bottom.ColorPickerFrame.ColorPickerArea.Picker.Position.X.Scale,secondCustom)

			v.BackgroundColor3 = script.Parent.ColorPicker.Bottom.ColorPickerFrame.ColorShower.BackgroundColor3


			secondCustom.BackgroundColor3 = script.Parent.ColorPicker.Bottom.ColorPickerFrame.ColorShower.BackgroundColor3
		end
	end)
end


cPB.MouseButton1Click:Connect(function()
	game.ReplicatedStorage.Events.ColorPickerEvents.PickB:Fire(PaintFrame)
	if not WhichV.Value then
		findColor(true,paint1:GetAttribute("Top"),paint1:GetAttribute("Bottom"),false)
	else
		findColor(true,paint2:GetAttribute("Top"),paint2:GetAttribute("Bottom"),false)
	end

	script.Parent.ColorPicker:TweenPosition(UDim2.new(0.298, 0,0.482, 0),0,0,0.4)
end)

script.Parent.ColorPicker.Set.MouseButton1Click:Connect(function()
	script.Parent.ColorPicker:TweenPosition(UDim2.new(0.298, 0,1.181, 0),0,0,0.4)
end)

function painting()
	if mouse.Target and canpaint then
		
		tar = mouse.Target
		
		if tar.Name == "Primary" and tar.Parent.Parent.Parent:IsA("Model")  then
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


game.ReplicatedStorage.Events.ColorPickerEvents.SetCustoms.OnClientEvent:Connect(function()
	game.ReplicatedStorage.Events.ColorPickerEvents.PickB:Fire(nil)
	for i,v in pairs(script.Parent.PaintFrame.Customs:GetChildren()) do
		local top = tonumber(v:GetAttribute("Top"))
		local bottom = tonumber(v:GetAttribute("Bottom"))
		findColor(true,top,bottom,true)
		task.wait()
		v.BackgroundColor3 = script.Parent.ColorPicker.Bottom.ColorPickerFrame.ColorShower.BackgroundColor3

	end
	task.wait()
	game.ReplicatedStorage.Events.ColorPickerEvents.TeDrugie:FireServer()
end)

game.ReplicatedStorage.Events.RESETGUI.OnClientEvent:Connect(function(toggle)
	if not toggle then
		runService:UnbindFromRenderStep("paint")
		onOff.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
		script.Parent.PaintFrame:TweenPosition(UDim2.new(0.209,0,1.133,0),0,0,0.3)
		materialFrame:TweenPosition(UDim2.new(0.209, 0,1.201, 0),0,0,0.3)
		counter = 0
		mobileToggle = true
		canpaint = false
		obj = nil
		if UIS.TouchEnabled then
			contextActionService:UnbindAction("mobileAssist")
		end
		LastPart = nil
		selectionbox.Adornee = nil
		selectionboxSelected.Adornee = nil
		task.wait(0.05)
		script.Parent.PaintFrame.CanvasPosition = Vector2.new(0,0)
		script.Parent.ColorPicker:TweenPosition(UDim2.new(0.298, 0,1.181, 0),0,0,0.4)
	end
end)

game.ReplicatedStorage.Events.SystemsEvents.shutdownSystemsB.Event:Connect(function(current)
	if current ~= onOff then
		runService:UnbindFromRenderStep("paint")
		onOff.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
		script.Parent.PaintFrame:TweenPosition(UDim2.new(0.209,0,1.133,0),0,0,0.3)
		materialFrame:TweenPosition(UDim2.new(0.209, 0,1.201, 0),0,0,0.3)
		counter = 0
		mobileToggle = true
		canpaint = false
		obj = nil
		LastPart = nil
		if UIS.TouchEnabled then
			contextActionService:UnbindAction("mobileAssist")
		end
		selectionbox.Adornee = nil
		selectionboxSelected.Adornee = nil
		task.wait(0.05)
		script.Parent.PaintFrame.CanvasPosition = Vector2.new(0,0)
		script.Parent.ColorPicker:TweenPosition(UDim2.new(0.298, 0,1.181, 0),0,0,0.4)
	end
end)