local player = game.Players.LocalPlayer
local mainButton = script.Parent:WaitForChild("BuildSystemsAndInfo"):WaitForChild('OpenClose')
local openID = "rbxassetid://10018906670"
local closeID = "rbxassetid://10018904449"
local getPlot = game.ReplicatedStorage.Remotes.requestPlot
local plot = getPlot:InvokeServer()
local AudioPlayer = require(game.ReplicatedStorage.Modules:WaitForChild("AudioModule"))
local toggle = false

function startStop(actionName, inputState, inputObj,button)
	if not player:FindFirstChild("leaderstats") then
		return
	end
	if inputState ==  Enum.UserInputState.Begin and not player:GetAttribute("isBind") or not inputState and not player:GetAttribute("isBind") then
		if not toggle then
			AudioPlayer.playAudio("Click")
			game.ReplicatedStorage.Events.STARTEvent:FireServer(player, nil, plot)
			toggle = true
			mainButton.img.Image = openID
		elseif toggle then
			AudioPlayer.playAudio("Click")
			game.ReplicatedStorage.Events.STOP:FireServer(nil, player, plot)
			toggle = false
			mainButton.img.Image = closeID
		end
	end
end

local contextActionService = game:GetService("ContextActionService")
local bindFrame = player.PlayerGui.BuildUI:WaitForChild("BindFrame")

function convert()
	local input = bindFrame.OPENCLOSE:GetAttribute("Bind")
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

contextActionService:BindAction("startStopOC", startStop, false, convert())

bindFrame.OPENCLOSE.AttributeChanged:Connect(function()
	contextActionService:UnbindAction("startStopOC")
	wait()
	contextActionService:BindAction("startStopOC", startStop, false, convert())
end)


mainButton.MouseButton1Click:Connect(function()
	if not player:FindFirstChild("leaderstats") then
		return
	end
	startStop()
end)

game.ReplicatedStorage.Events.NPCEvents.showOpinion.OnClientEvent:Connect(function(npc,message,style)
	if npc and npc:FindFirstChild("Head") and math.random(1,10) > 4 then
		local opinionGui = npc.Head:FindFirstChild("Opinion")
		pcall(function() 
			if opinionGui then
				opinionGui.Frame.Style = style
				opinionGui.Frame.Text.Text = message
				wait()
				opinionGui.Enabled = true
				wait(math.random(4,6))
				opinionGui.Enabled = false
			end
		end)
	end
end)

game.ReplicatedStorage.Events.NPCEvents.paymentAnim.OnClientEvent:Connect(function(model,text)
	local succ,err = pcall(function()
		model.gui.BillboardGui.TextLabel.Text = "+"..text
		model.gui.BillboardGui.TextLabel.TextTransparency = 0.35
		model.gui.BillboardGui.TextLabel.Position = UDim2.new(0,0,0.5,0)
		task.wait(0.9)
		model.gui.BillboardGui.TextLabel:TweenPosition(UDim2.new(0,0,-1,0),0,0,0.7)
		for i=0,25 do
			task.wait(0.01)
			model.gui.BillboardGui.TextLabel.TextTransparency += 0.05
		end
		model.gui.BillboardGui.TextLabel.TextTransparency = 1
		task.wait(0.1)
	end)
	if not succ then
		warn(err)
	end
end)