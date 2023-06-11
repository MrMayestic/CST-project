local runService = game:GetService("RunService")
local contextActionService = game:GetService("ContextActionService")
local UIS = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local getPlot = game.ReplicatedStorage.Remotes.requestPlot

local buildButton = script.Parent.BuildSystemsAndInfo.Shop

local shopFrame = player:WaitForChild("PlayerGui"):WaitForChild("BuildUI"):WaitForChild("ShopFrame")

local hideModule = require(game.ReplicatedStorage.Modules.HideModule)

local plot = getPlot:InvokeServer()
local fillRE = game.ReplicatedStorage.Events.TowarEvents.FillUp
local obj
local tar = nil
local LastPart = nil
local fillupToggle = false
local toggle = true

local mobileToggle = true

local errormodule = require(game.ReplicatedStorage.Modules.ErrorModule)
local bindFrame = player.PlayerGui.BuildUI:WaitForChild("BindFrame")

local fillupButton = script.Parent.BuildSystemsAndInfo.MagazineButton.FillupButton

local selectionbox = Instance.new('SelectionBox');

selectionbox.LineThickness = 0.1
selectionbox.Parent = workspace.CurrentCamera;
selectionbox.Color3 = Color3.new(0,255,0)
selectionbox.Transparency = 0.6
local AudioPlayer = require(game.ReplicatedStorage.Modules:WaitForChild("AudioModule"))

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

function startStop(actionName, inputState, inputObj)
	if inputState ==  Enum.UserInputState.Begin and not player:GetAttribute("isBind") or not inputState and not player:GetAttribute("isBind") then
		if not fillupToggle then
			game.ReplicatedStorage.Events.SystemsEvents.shutdownSystemsB:Fire(fillupButton)
			AudioPlayer.playAudio("Click")
			fillupToggle = true
			fillupButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
			game.ReplicatedStorage.Events.RESETGUI:FireServer(true)
			runService:BindToRenderStep("fill",1,filling)
			if UIS.TouchEnabled then
				contextActionService:BindAction("mobileAssist", mobileAssist, false, Enum.UserInputType.Touch)
			end
			if buildButton:GetAttribute("isOn") == true then
				shopFrame:TweenPosition(UDim2.new(0, 0,1.139, 0),0,0,0.2)
			end
			hideModule.visibleOff(fillupButton)
		elseif fillupToggle and not player:GetAttribute("DoesTutorial") then
			AudioPlayer.playAudio("Click")
			obj = nil
			LastPart = nil
			fillupToggle = false
			selectionbox.Adornee = nil
			fillupButton.BackgroundColor3 = Color3.fromRGB(225, 225, 225)
			if UIS.TouchEnabled then
				contextActionService:UnbindAction("mobileAssist")
			end
			runService:UnbindFromRenderStep("fill")
			if buildButton:GetAttribute("isOn") == true then
				if shopFrame:GetAttribute('isShown') then
					shopFrame:TweenPosition(UDim2.new(0, 0,0.839, 0),nil,nil,0.2)
					shopFrame.Roll.Rotation = 180
				else
					shopFrame:TweenPosition(UDim2.new(0, 0,1, 0),nil,nil,0.2)
					shopFrame.Roll.Rotation = 0
				end
			end
			hideModule.visibleOn()
		end
	end
end

fillupButton.MouseButton1Click:Connect(function()
	startStop()
end)

function convert()
	local input = bindFrame.FILLUP:GetAttribute("Bind")
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

contextActionService:BindAction("startStopFill", startStop, false, convert())

bindFrame.FILLUP.AttributeChanged:Connect(function()
	contextActionService:UnbindAction("startStopFill")
	wait()
	contextActionService:BindAction("startStopFill", startStop, false, convert())
end)

mouse.Button1Up:Connect(function()
	task.wait(0.12)
	if LastPart and LastPart.Parent:IsA("Model") then
		obj = LastPart
	end
	if obj and mobileToggle then
		local otwarte = obj.Parent.Parent.Parent.Humans:GetChildren()
		if  obj.Parent.Parent.Parent.wazne.Owner.Value == player.Name and obj.Parent.Parent.Parent.Name == plot.Name then
			if  obj.Parent.Name == "Shelf" or obj.Parent.Name == "SmallShelf" or obj.Parent.Name == "DisplayTable" then
				fillRE:FireServer(obj, plot)
			end
		end
	elseif not mobileToggle then
		counter = 0
		mobileToggle = true
		obj = nil
		LastPart = nil
		selectionbox.Adornee = nil
		tar = nil
	end
end)

function filling()
	if mouse.Target and fillupToggle then

		tar = mouse.Target
		if tar.Name == "Primary" and tar.Parent.Parent.Parent:IsA("Model")  then

			if tar.Parent.Parent.Parent.wazne.Owner.Value == player.Name and tar.Parent.Parent.Parent.Name == plot.Name then
				LastPart = tar
				if  tar.Parent.Name == "Shelf" or tar.Parent.Name == "SmallShelf" or tar.Parent.Name == "DisplayTable" then
					selectionbox.Adornee = mouse.Target
				end
			end

		else
			selectionbox.Adornee = nil
			LastPart = nil
		end

	end
end



game.ReplicatedStorage.Events.RESETGUI.OnClientEvent:Connect(function(toggle)
	if not toggle then
		obj = nil
		LastPart = nil
		fillupToggle = false
		counter = 0
		mobileToggle = true
		if UIS.TouchEnabled then
			contextActionService:UnbindAction("mobileAssist")
		end
		selectionbox.Adornee = nil
		fillupButton.BackgroundColor3 = Color3.fromRGB(225, 225, 225)
		runService:UnbindFromRenderStep("fill")
	end
end)

game.ReplicatedStorage.Events.SystemsEvents.shutdownSystemsB.Event:Connect(function(current)
	if current ~= fillupToggle then
		selectionbox.Adornee = nil
		obj = nil
		LastPart = nil
		fillupToggle = false
		counter = 0
		mobileToggle = true
		if UIS.TouchEnabled then
			contextActionService:UnbindAction("mobileAssist")
		end
		fillupButton.BackgroundColor3 = Color3.fromRGB(225, 225, 225)
		runService:UnbindFromRenderStep("fill")
	end
end)