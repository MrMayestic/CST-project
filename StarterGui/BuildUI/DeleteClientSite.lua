local runService = game:GetService("RunService")
local contextActionService = game:GetService("ContextActionService")
local UIS = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local getPlot = game.ReplicatedStorage.Remotes.requestPlot

local buildButton = script.Parent.BuildSystemsAndInfo.Shop

local shopFrame = player:WaitForChild("PlayerGui"):WaitForChild("BuildUI"):WaitForChild("ShopFrame")

local plot = getPlot:InvokeServer()
local deleteRE = game.ReplicatedStorage.Events.Delete
local obj
local tar = nil
local LastPart = nil
local deleteToggle = false
local mobileToggle = true
local errormodule = require(game.ReplicatedStorage.Modules.ErrorModule)
local bindFrame = player.PlayerGui.BuildUI:WaitForChild("BindFrame")

local deleteButton = script.Parent:WaitForChild("BuildFrame").Delete

local selectionbox = Instance.new('SelectionBox');

selectionbox.LineThickness = 0.1
selectionbox.Parent = workspace.CurrentCamera;
selectionbox.Color3 = Color3.new(0,255,0)
selectionbox.Transparency = 0.6

local AudioPlayer = require(game.ReplicatedStorage.Modules:WaitForChild("AudioModule"))
local hideModule = require(game.ReplicatedStorage.Modules.HideModule)

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
		if not deleteToggle and buildButton:GetAttribute("isOn") == true then
			game.ReplicatedStorage.Events.SystemsEvents.shutdownSystemsB:Fire(deleteButton)
			AudioPlayer.playAudio("Click")
			game.ReplicatedStorage.ClockOff:Fire()
			deleteToggle = true
			counter = 0
			mobileToggle = true
			deleteButton.BackgroundColor3 = Color3.new(0, 0.666667, 0)
			game.ReplicatedStorage.Events.RESETGUI:FireServer(true)
			runService:BindToRenderStep("delete",1,deleting)
			if buildButton:GetAttribute("isOn") == true then
				shopFrame:TweenPosition(UDim2.new(0, 0,1.139, 0),0,0,0.2)
			end

			if UIS.TouchEnabled then
				contextActionService:BindAction("mobileAssist", mobileAssist, false, Enum.UserInputType.Touch)
			end
			hideModule.visibleOff()
		elseif deleteToggle and not player:GetAttribute("DoesTutorial") then
			game.ReplicatedStorage.ClockOn:Fire()
			AudioPlayer.playAudio("Click")
			obj = nil
			LastPart = nil
			deleteToggle = false
			selectionbox.Adornee = nil
			deleteButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
			runService:UnbindFromRenderStep("delete")
			if UIS.TouchEnabled then
				contextActionService:UnbindAction("mobileAssist")
			end
			if shopFrame:GetAttribute('isShown') then
				shopFrame:TweenPosition(UDim2.new(0, 0,0.839, 0),nil,nil,0.2)
				shopFrame.Roll.Rotation = 180
			else
				shopFrame:TweenPosition(UDim2.new(0, 0,1, 0),nil,nil,0.2)
				shopFrame.Roll.Rotation = 0
			end
			hideModule.visibleOn()
		end
	end
end

deleteButton.MouseButton1Click:Connect(function()
	startStop()
end)

function convert()
	local input = bindFrame.DELETE:GetAttribute("Bind")
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

contextActionService:BindAction("startStopDelete", startStop, false, convert())

bindFrame.DELETE.AttributeChanged:Connect(function()
	contextActionService:UnbindAction("startStopDelete")
	wait()
	contextActionService:BindAction("startStopDelete", startStop, false, convert())
end)

mouse.Button1Up:Connect(function()
	task.wait(0.12)
	if LastPart then
		pcall(function()
			if LastPart.Parent then
				if LastPart.Parent:IsA("Model") then
					obj = LastPart
				end
			end
		end)
	end
	if obj and mobileToggle then
		pcall(function() 
			local otwarte = obj.Parent.Parent.Parent.Humans:GetChildren()
			if  obj.Parent.Parent.Parent.wazne.Owner.Value == player.Name and obj.Parent.Parent.Parent.Name == plot.Name then
				if  obj.Parent.Name == "Shelf" or obj.Parent.Name == "SmallShelf" or obj.Parent.Name == "DisplayTable" then
					if #otwarte > 0 then
						if (obj.Parent.SpotValues.LeftSpot.Value + obj.Parent.SpotValues.RightSpot.Value) > 0 and obj.Parent.Towar.IleArtykul.Value > 0 then
							errormodule.errorfuncGo(player,"You can't delete this when customers can/are using this.")
							return
						end
					end
				elseif obj.Parent.Name == "CashReg" or obj.Parent.Name == "CashRegType2" then
					if #otwarte > 0 then
						if obj.Parent.SpotValues.Spot.Value > 0 and obj.Parent.Towar.IleArtykul.Value > 0 then
							errormodule.errorfuncGo(player,"You can't delete this when customers can/are using this.")
							return
						end
					end
				elseif obj.Parent.Name == "Storage" then
					if #otwarte > 0 then
						errormodule.errorfuncGo(player,"You can't delete this when you have customers in your shop.")
						return
					end
				end
				deleteRE:FireServer(obj, plot)
			end
		end)
	elseif not mobileToggle then
		counter = 0
		mobileToggle = true
		selectionbox.Adornee = nil
		LastPart = nil
		tar = nil
		obj = nil
	end
end)

function deleting()
	if mouse.Target and deleteToggle then

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
		obj = nil
		LastPart = nil
		deleteToggle = false
		deleteButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
		if UIS.TouchEnabled then
			contextActionService:UnbindAction("mobileAssist")
		end
		counter = 0
		mobileToggle = true
		runService:UnbindFromRenderStep("delete")
	end
end)

game.ReplicatedStorage.Events.SystemsEvents.shutdownSystemsB.Event:Connect(function(current)
	if current ~= deleteToggle then
		selectionbox.Adornee = nil
		obj = nil
		LastPart = nil
		deleteToggle = false
		deleteButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
		if UIS.TouchEnabled then
			contextActionService:UnbindAction("mobileAssist")
		end
		counter = 0
		mobileToggle = true
		runService:UnbindFromRenderStep("delete")
	end
end)