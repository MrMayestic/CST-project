local button = script.Parent.BuildSystemsAndInfo.Display
local getPlot = game.ReplicatedStorage.Remotes.requestPlot
local plot = getPlot:InvokeServer()
local plr = game.Players.LocalPlayer
local toggle = false
local AudioPlayer = require(game.ReplicatedStorage.Modules:WaitForChild("AudioModule"))


local function alewjazd()
	for i,model in ipairs(plot.PlacedObjects:GetChildren()) do
		if model.Name == "DisplayTable" or model.Name=="Shelf" or model.Name == "SmallShelf" and model.Towar then
			model.Guiile.Enabled = true
			model.GuiCo.Enabled = true
		end
	end
end

local function aleodjazd()
	for i,model in ipairs(plot.PlacedObjects:GetChildren()) do
		local check = model:FindFirstChild("GuiCo")
		if model.Name == "DisplayTable" or model.Name=="Shelf" or model.Name == "SmallShelf" and model.Towar then
			model.Guiile.Enabled = false
			model.GuiCo.Enabled = false
		end
	end
end

function startStop(actionName, inputState, inputObj)
	if inputState ==  Enum.UserInputState.Begin and not plr:GetAttribute("isBind") or not inputState and not plr:GetAttribute("isBind") then	
		if toggle and not plr:GetAttribute("DoesTutorial") then
			toggle = false
			AudioPlayer.playAudio("Click")
			aleodjazd()
			button.BackgroundColor3 = Color3.new(0.882353, 0.882353, 0.882353)
		elseif not toggle and plr:GetAttribute("DoesTutorial")==false then
			AudioPlayer.playAudio("Click")
			toggle = true
			alewjazd()
			button.BackgroundColor3 = Color3.new(0, 0.666667, 0)
		end
	end
end

local contextActionService = game:GetService("ContextActionService")
local bindFrame = plr.PlayerGui.BuildUI:WaitForChild("BindFrame")

function convert()
	local input = bindFrame.DISPLAY:GetAttribute("Bind")
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

contextActionService:BindAction("startStopDisplay", startStop, false, convert())

bindFrame.DISPLAY.AttributeChanged:Connect(function()
	contextActionService:UnbindAction("startStopDisplay")
	wait()
	contextActionService:BindAction("startStopDisplay", startStop, false, convert())
end)

button.MouseButton1Click:Connect(function()
	startStop()
end)

game.ReplicatedStorage.Events.ModelEvents.showBanner.OnClientEvent:Connect(function(model)
	if model and toggle then
		model.Guiile.Enabled = true
		model.GuiCo.Enabled = true
	end
end)

game.ReplicatedStorage.Events.RESETGUI.OnClientEvent:Connect(function(localtoggle)
	if not localtoggle then
		toggle = false
		aleodjazd()
		button.BackgroundColor3 = Color3.new(0.882353, 0.882353, 0.882353)
	end
end)