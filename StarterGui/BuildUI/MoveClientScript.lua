local itemPlacement = require(game.ReplicatedStorage.Modules.PlacementModuleV3)

local remote = game.ReplicatedStorage.Remotes.move	

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

local getPlot = game.ReplicatedStorage.Remotes.requestPlot

local plot = getPlot:InvokeServer()
local button = script.Parent:WaitForChild("BuildFrame").Move

local UserInputService = game:GetService("UserInputService")
local contextActionService = game:GetService("ContextActionService")
local runService = game:GetService("RunService")

local buildButton = script.Parent.BuildSystemsAndInfo.Shop

local gridEvent

local gridButton = script.Parent.ChangeGrid
local changeHideness = script.Parent.ChangeHideness
local dayNightToggle = script.Parent.ChangeDayNight

local shopFrame = player:WaitForChild("PlayerGui"):WaitForChild("BuildUI"):WaitForChild("ShopFrame")

local obj
local tar

local LastPart = nil
local moveToggle = false
local toggle = true
local specialtoggle = true
local mobileToggle = true

local errormodule = require(game.ReplicatedStorage.Modules.ErrorModule)
local AudioPlayer = require(game.ReplicatedStorage.Modules:WaitForChild("AudioModule"))
local hideModule = require(game.ReplicatedStorage.Modules.HideModule)

local selectionbox = Instance.new('SelectionBox');

selectionbox.LineThickness = 0.1
selectionbox.Parent = workspace.CurrentCamera;
selectionbox.Color3 = Color3.new(0,255,0)
selectionbox.Transparency = 0.6

local selectionboxSelected = Instance.new('SelectionBox');

selectionboxSelected.LineThickness = 0.05
selectionboxSelected.Parent = workspace.CurrentCamera
selectionboxSelected.Color3 = Color3.new(1, 0, 0.0156863)
selectionboxSelected.Transparency = 0.7

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

function startStop(actionName, inputState, inputObj)
	if inputState ==  Enum.UserInputState.Begin and not player:GetAttribute("isBind") or not inputState and not player:GetAttribute("isBind") then
		if moveToggle and player:GetAttribute("DoesTutorial")==false then
			game.ReplicatedStorage.ClockOn:Fire()
			AudioPlayer.playAudio("Click")
			obj = nil
			LastPart = nil
			runService:UnbindFromRenderStep("move")
			if UserInputService.TouchEnabled then
				contextActionService:UnbindAction("mobileAssist")
			end
			moveToggle = false	
			specialtoggle = false
			selectionbox.Adornee = nil
			button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
			if shopFrame:GetAttribute('isShown') then
				shopFrame:TweenPosition(UDim2.new(0, 0,0.839, 0),nil,nil,0.2)
				shopFrame.Roll.Rotation = 180
			else
				shopFrame:TweenPosition(UDim2.new(0, 0,1, 0),nil,nil,0.2)
				shopFrame.Roll.Rotation = 0
			end
			shutdown()
			hideModule.visibleOn()
		elseif not moveToggle and buildButton:GetAttribute("isOn") == true and player:GetAttribute("DoesTutorial")==false then
			itemPlacement:terminate()
			game.ReplicatedStorage.Events.SystemsEvents.shutdownSystemsB:Fire(button)
			AudioPlayer.playAudio("Click")
			game.ReplicatedStorage.ClockOff:Fire()
			moveToggle = true
			mobileToggle = true
			counter = 0
			specialtoggle = true
			runService:BindToRenderStep("move",1,moving)
			if UserInputService.TouchEnabled then
				contextActionService:BindAction("mobileAssist", mobileAssist, false, Enum.UserInputType.Touch)
			end
			button.BackgroundColor3 = Color3.new(0, 0.666667, 0)
			shopFrame:TweenPosition(UDim2.new(0, 0,1.139, 0),0,0,0.2)
			game.ReplicatedStorage.Events.RESETGUI:FireServer(true)
			hideModule.visibleOff(button)
		end
	end
end

local contextActionService = game:GetService("ContextActionService")
local bindFrame = player.PlayerGui.BuildUI:WaitForChild("BindFrame")

function convert(input)
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

contextActionService:BindAction("startStopMove", startStop, false, convert(bindFrame.MOVE:GetAttribute("Bind")))

bindFrame.MOVE.AttributeChanged:Connect(function()
	contextActionService:UnbindAction("startStopMove")
	wait()
	contextActionService:BindAction("startStopMove", startStop, false, convert( bindFrame.MOVE:GetAttribute("Bind")))
end)

button.MouseButton1Click:Connect(function()
	startStop()
end)

local function rotate(a,b,c)
	wait()
	itemPlacement:rotateM(a,b,c)
end
local function up(a,b,c)
	wait()
	itemPlacement:raiseFloorM(a,b,c)
end
local function down(a,b,c)
	wait()
	itemPlacement:lowerFloorM(a,b,c)
end
local function cancel(a,b,c)
	changeSelection(obj,false)
	mobileToggle = true
	counter = 0
	wait()
	obj=nil
	LastPart = nil
	specialtoggle = true
	gridButton.Visible = false
	changeHideness.Visible = false
	dayNightToggle.Visible = false
	selectionboxSelected.Adornee = nil
	selectionbox.Adornee = nil
	game.ReplicatedStorage.Events.BackParent:FireServer(plot,true)
end

function shutdown(toggle)
	mobileToggle = true
	counter = 0
	LastPart = nil
	obj = nil
	if UserInputService.TouchEnabled then
		contextActionService:UnbindAction("mobileAssist")
	end
	runService:UnbindFromRenderStep("move")
	moveToggle = false	
	specialtoggle = false
	selectionbox.Adornee = nil
	button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	gridButton.Visible = false
	changeHideness.Visible = false
	dayNightToggle.Visible = false
	game.ReplicatedStorage.Events.BackParent:FireServer(plot,true)
	if not toggle then
		itemPlacement:shutdown(true,plot)
	end
end

function ping()
	local t = tick()
	local cos = game.ReplicatedStorage.PingTest.RemoteFunction:InvokeServer()
	local ping = ((tick() - t) / 2)
	return ping + 0.01
end

function changeSelection(obj,toggle)
	if toggle then
		selectionboxSelected.Adornee = obj
	else
		selectionboxSelected.Adornee = nil
	end
end

mouse.Button1Up:Connect(function()
	task.wait(0.12)
	if LastPart and LastPart.Parent:IsA("Model") then --and tar.Parent.Parent.Parent.wazne.Owner.Value == player.Name then
		obj = LastPart
		specialtoggle = true
	end

	if obj and moveToggle and specialtoggle and mobileToggle then
		
		local otwarte = obj.Parent.Parent.Parent.Humans:GetChildren()

		if #otwarte > 0 then

			if obj.Parent.Name == "Shelf" or obj.Parent.Name == "SmallShelf" or obj.Parent.Name == "DisplayTable" then
				if (obj.Parent.SpotValues.LeftSpot.Value + obj.Parent.SpotValues.RightSpot.Value) > 0 or obj.Parent.beingHandled.Value == true  then
					errormodule.errorfuncGo(player,"You can't move this when it is in use.")
					specialtoggle = true
					return
				end
			end
		end
	
		itemPlacement.new(
			player.SetFolder.whatgrid.Value,
			plot.PlacedObjects,
			convert(bindFrame.ROTATE:GetAttribute("Bind")), convert(bindFrame.CANCEL:GetAttribute("Bind")), convert(bindFrame.RAISE:GetAttribute("Bind")), convert(bindFrame.LOWER:GetAttribute("Bind")), convert(bindFrame.PLACE:GetAttribute("Bind")),plot,remote
		)
		changeSelection(obj,true)
		gridButton.Visible = true
		changeHideness.Visible = true
		dayNightToggle.Visible = true

		pcall(function() 
			game.ReplicatedStorage.Events.MoveParent:FireServer(obj.Parent,true)	
		end)
		
		obj.Parent:SetAttribute("beingMoved",true)
		specialtoggle = false
		wait()
	

		itemPlacement:activate(obj.Parent.Name, plot.PlacedObjects, plot.Plot, false, true,true,convert(bindFrame.GRID:GetAttribute("Bind")))

		runService:UnbindFromRenderStep("move")
		runService:BindToRenderStep("move",0.6,moving)

	elseif not mobileToggle then
		mobileToggle = true
		counter = 0
		obj = nil
		LastPart = nil
		selectionboxSelected.Adornee = nil
		selectionbox.Adornee = nil
		tar = nil
	end
end)

function moving()
	if mouse.Target and moveToggle then

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


game.ReplicatedStorage.Events.RESETGUI.OnClientEvent:Connect(function(toggle)
	if not toggle then
		cancel()
	end
end)

game.ReplicatedStorage.Events.SystemsEvents.shutdownSystemsB.Event:Connect(function(current)
	if current ~= button and current ~= script.Parent.BuildSystemsAndInfo.Shop and current ~= script.Parent.BuildFrame.Copy then
		shutdown()
	elseif current == script.Parent.BuildSystemsAndInfo.Shop or current == script.Parent.BuildFrame.Copy then
		shutdown(true)
	end
end)

remote.cancel.OnInvoke = function(toggle)
	if toggle then
		shutdown()
	else
		cancel()
	end
end