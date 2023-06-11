local object = script.Parent
local player = game.Players.LocalPlayer

local controls = require(player.PlayerScripts.PlayerModule):GetControls()

local toggle = false

local buildFrame = script.Parent.Parent.Parent.BuildFrame
local shopframe = player:WaitForChild("PlayerGui").BuildUI.ShopFrame
--local shopclose = player:WaitForChild("PlayerGui").BuildUI.ShopClose
local bindFrame = player.PlayerGui.BuildUI:WaitForChild("BindFrame")

local UIS = game:GetService('UserInputService')

local contextActionService = game:GetService("ContextActionService")

local cameraModule = require(game.ReplicatedStorage:WaitForChild("Modules"):WaitForChild("BuildCameraModule"))
local AudioPlayer = require(game.ReplicatedStorage.Modules:WaitForChild("AudioModule"))

local hideModule = require(game.ReplicatedStorage.Modules.HideModule)

local slider = script.Parent.Parent.Parent:WaitForChild('Slider')
local sliderframeLR = script.Parent.Parent.Parent:WaitForChild('RotateLR')
local sliderframeUD = script.Parent.Parent.Parent:WaitForChild('RotateUD')

local sliderLR = script.Parent.Parent.Parent:WaitForChild('SliderLR')
local sliderUD = script.Parent.Parent.Parent:WaitForChild('SliderUD')

local sliderFrame = script.Parent.Parent.Parent:WaitForChild('CameraSterringSlider')

function convert()
	local input = bindFrame.BUILD:GetAttribute("Bind")
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

function quit()
	wait()
	toggle = false
	--shopclose.Visible = false
	--shopclose.Active = false
	cameraModule.stop()
	buildFrame:TweenPosition(UDim2.new(-0.2, 0,0.482, 0),nil,nil,0.3)
	object.BackgroundColor3 = Color3.new(0.882353, 0.882353, 0.882353)
	--shopframe.Visible = false
	shopframe:TweenPosition(UDim2.new(0, 0,1.1, 0),0,0,0.2)
	game.ReplicatedStorage.Events.SystemsEvents.shutdownSystemsB:Fire()
	wait(0.05)
	--shopframe.CanvasPosition = Vector2.new(0,0)
	sliderFrame.Visible = false
	slider.Visible = false

	sliderframeLR.Visible = false
	sliderLR.Visible = false

	sliderframeUD.Visible = false
	sliderUD.Visible = false

	object.Visible = true
	object:SetAttribute("isOn",false)
	wait()
	hideModule.visibleOn()
	controls:Enable()
end

local function startStop(actionName, inputState, inputObj)
	if inputState ==  Enum.UserInputState.Begin and not player:GetAttribute("isBind") or not inputState and not player:GetAttribute("isBind") then
		if player:FindFirstChild('leaderstats') then
			if not toggle then
				toggle = true
				object.BackgroundColor3 = Color3.new(0.313725, 0.345098, 0.364706)
				AudioPlayer.playAudio("Click")
				cameraModule.start()
				if UIS.TouchEnabled then
					sliderFrame.Visible = true
					slider.Visible = true

					sliderframeLR.Visible = true
					sliderLR.Visible = true

					sliderframeUD.Visible = true
					sliderUD.Visible = true
				end
				buildFrame:TweenPosition(UDim2.new(-0.01, 0,0.482, 0),nil,nil,0.25)
				if shopframe:GetAttribute('isShown') then
					shopframe:TweenPosition(UDim2.new(0, 0,0.839, 0),nil,nil,0.2)
					shopframe.Roll.Rotation = 180
				else
					shopframe:TweenPosition(UDim2.new(0, 0,1, 0),nil,nil,0.2)
					shopframe.Roll.Rotation = 0
				end
				object:SetAttribute("isOn",true)
				game.ReplicatedStorage.Events.RESETGUI:FireServer(true)
				controls:Disable()
			else
				game.ReplicatedStorage.ClockOn:Fire()
				AudioPlayer.playAudio("Click")
				script.Parent.Parent.Parent.SettingsBut.Visible = true
				quit()
			end
		end
	end
end

object.MouseButton1Click:Connect(function()
	startStop()
end)

contextActionService:BindAction("startStopBuild", startStop, false, convert())

bindFrame.BUILD.AttributeChanged:Connect(function()
	contextActionService:UnbindAction("startStopBuild")
	wait()
	contextActionService:BindAction("startStopBuild", startStop, false, convert())
end)
--shopclose.MouseButton1Click:Connect(quit)

game.ReplicatedStorage.Events.ModelEvents.Close.OnClientEvent:Connect(quit)

game.ReplicatedStorage.Events.RESETGUI.OnClientEvent:Connect(function(toggle)
	if not toggle then
		quit()
	end
end)
