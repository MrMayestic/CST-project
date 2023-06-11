local itemPlacement = require(game.ReplicatedStorage.Modules.PlacementModuleV3)

local remote = game.ReplicatedStorage.Remotes.place
local player = game.Players.LocalPlayer

player.CameraMinZoomDistance = 0
player.CameraMaxZoomDistance = 90

local getPlot = game.ReplicatedStorage.Remotes.requestPlot

local plot = getPlot:InvokeServer()
local button = script.Parent

local shopframe , shop

shopframe = player:WaitForChild("PlayerGui"):WaitForChild("BuildUI"):WaitForChild('ShopFrame')

local gridButton = script.Parent.ChangeGrid
local changeHideness = script.Parent.ChangeHideness
local dayNightToggle = script.Parent.ChangeDayNight

local secondmodel

local can = false
local toggle = true

local bindFrame = script.Parent.BindFrame

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

local function cancel(toggle)
	can = false
	toggle = false
	gridButton.Visible = false
	changeHideness.Visible = false
	dayNightToggle.Visible = false

	if not toggle then
		if not player:GetAttribute("DoesTutorial") and shopframe then
			shopframe.Visible = true
			shopframe.Active = true
		else
			if shopframe:GetAttribute('isShown') then
				shopframe:TweenPosition(UDim2.new(0, 0,0.839, 0),nil,nil,0.2)
				shopframe.Roll.Rotation = 180
			else
				shopframe:TweenPosition(UDim2.new(0, 0,1, 0),nil,nil,0.2)
				shopframe.Roll.Rotation = 0
			end
		end
	end
end

function ogien()
	if can then	

		can = false

		itemPlacement:changeCanStatus(true)

		if not player:GetAttribute("DoesTutorial") then
			jazda(secondmodel)
		else
			game.ReplicatedStorage.Events.JestEKlkiniete:FireServer()
			game.ReplicatedStorage.ClockOn:Fire()
			cancel()
			wait()
		end

	end
end

function ping()
	local t = tick()
	local cos = game.ReplicatedStorage.PingTest.RemoteFunction:InvokeServer()
	local ping = ((tick() - t) / 2)
	return ping
end


function jazda(namemodel)
	if toggle then	

		pcall(function()		
			game.ReplicatedStorage.Events.RESETGUI:FireServer(true)
		end)

		itemPlacement.new(
			player.SetFolder.whatgrid.Value,--0.5,
			game.ReplicatedStorage.Models,
			convert(bindFrame.ROTATE:GetAttribute("Bind")), convert(bindFrame.CANCEL:GetAttribute("Bind")), convert(bindFrame.RAISE:GetAttribute("Bind")), convert(bindFrame.LOWER:GetAttribute("Bind")), convert(bindFrame.PLACE:GetAttribute("Bind")),plot,remote
		)
		--wait(ping()/3000)
		task.wait()
		can = true
		secondmodel = namemodel
		gridButton.Visible = true
		changeHideness.Visible = true
		dayNightToggle.Visible = true
		shopframe.Visible = false
		shopframe.Active = false
		itemPlacement:activate(namemodel, plot.PlacedObjects, plot.Plot, false, true,false,convert(bindFrame.GRID:GetAttribute("Bind")))
		task.wait(0.1)
	end
end

game.ReplicatedStorage.Events.PRZERWIJ.OnClientEvent:Connect(function(toggle)
	game.ReplicatedStorage.ClockOn:Fire()
	cancel()
end)

function odpal(modelus)
	if not player:GetAttribute("DoesTutorial") then
		itemPlacement:terminate()
		game.ReplicatedStorage.Events.SystemsEvents.shutdownSystemsB:Fire(button)
		task.wait(0.05)
		toggle = true
		game.ReplicatedStorage.ClockOff:Fire()
		jazda(modelus)
	elseif modelus == "DisplayTable" or modelus == "CashReg" then
		itemPlacement:terminate()
		game.ReplicatedStorage.Events.SystemsEvents.shutdownSystemsB:Fire(button)
		task.wait(0.05)
		toggle = true
		game.ReplicatedStorage.ClockOff:Fire()
		jazda(modelus)
		toggle = false		
	end
end

game.ReplicatedStorage.Events.ModelEvents.ServerModel.OnClientEvent:Connect(odpal)

game.ReplicatedStorage.Events.RESETGUI.OnClientEvent:Connect(function(toggle)
	if not toggle then
		cancel()
	end
end)

remote.cancel.OnInvoke = function(toggle)
	cancel()
end

game.ReplicatedStorage.Events.SystemsEvents.shutdownSystemsB.Event:Connect(function(current)
	if current ~= button and current ~= script.Parent.BuildFrame.Move and current ~= script.Parent.BuildFrame.Copy then
		cancel()
		itemPlacement:terminateALL()
	elseif current == script.Parent.BuildFrame.Move or current == script.Parent.BuildFrame.Copy then
		cancel()
	end
end)

game.ReplicatedStorage.Events.SystemsEvents.shutdownSystems.OnClientEvent:Connect(function()
	game.ReplicatedStorage.Remotes.move.cancel:Invoke(true)
	game.ReplicatedStorage.Remotes.copy.cancel:Invoke(true)
	game.ReplicatedStorage.Remotes.place.cancel:Invoke(true)
end)