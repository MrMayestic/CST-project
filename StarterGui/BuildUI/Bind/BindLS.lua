local plr = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local inputToggle = false
local myFrame

local ctrlSwitch = script.Parent.SwitchCTRL
local shiftSwitch = script.Parent.SwitchSHIFT

local waiter = plr:WaitForChild('CzyTutorialDone')
wait(1)

local ctrlToggle,shiftToggle = ctrlSwitch:GetAttribute('isOn'),shiftSwitch:GetAttribute('isOn')

local off,on = UDim2.new(-0.176, 0,-0.212, 0),UDim2.new(0.559, 0,-0.212, 0)

ctrlSwitch.MouseButton1Click:Connect(function()
	if ctrlToggle then
		ctrlToggle = false
		ctrlSwitch.Switch:TweenPosition(off,nil,nil,0.3)
		ctrlSwitch.BackgroundColor3 = Color3.new(0.92549, 0, 0)
		ctrlSwitch:SetAttribute('isOn',false)
		script.Parent.LOWERCAMERA.Transparency = 0
		script.Parent.LOWERCAMERA.Button.Transparency = 0
		script.Parent.LOWERCAMERA:SetAttribute('activated',true)
		script.Parent.RAISECAMERA.Transparency = 0
		script.Parent.RAISECAMERA.Button.Transparency = 0
		script.Parent.RAISECAMERA:SetAttribute('activated',true)
		sendToServer()
	elseif not ctrlToggle then
		ctrlToggle = true
		ctrlSwitch.Switch:TweenPosition(on,nil,nil,0.3)
		ctrlSwitch.BackgroundColor3 = Color3.new(0, 0.666667, 0)
		ctrlSwitch:SetAttribute('isOn',true)
		script.Parent.LOWERCAMERA.Transparency = 0.6
		script.Parent.LOWERCAMERA.Button.Transparency = 0.6
		script.Parent.LOWERCAMERA:SetAttribute('activated',false)
		script.Parent.RAISECAMERA.Transparency = 0.6
		script.Parent.RAISECAMERA.Button.Transparency = 0.6
		script.Parent.RAISECAMERA:SetAttribute('activated',false)
		sendToServer()
	end
end)

shiftSwitch.MouseButton1Click:Connect(function()
	if shiftToggle then
		shiftToggle = false
		shiftSwitch.Switch:TweenPosition(off,nil,nil,0.3)
		shiftSwitch.BackgroundColor3 = Color3.new(0.92549, 0, 0)
		shiftSwitch:SetAttribute('isOn',false)
		script.Parent.ROTATEDOWN.Transparency = 0
		script.Parent.ROTATEDOWN.Button.Transparency = 0
		script.Parent.ROTATEDOWN:SetAttribute('activated',true)
		script.Parent.ROTATEUP.Transparency = 0
		script.Parent.ROTATEUP.Button.Transparency = 0
		script.Parent.ROTATEUP:SetAttribute('activated',true)
		sendToServer()
	elseif not shiftToggle then
		shiftToggle = true
		shiftSwitch.Switch:TweenPosition(on,nil,nil,0.3)
		shiftSwitch.BackgroundColor3 = Color3.new(0, 0.666667, 0)
		shiftSwitch:SetAttribute('isOn',true)
		script.Parent.ROTATEDOWN.Transparency = 0.6
		script.Parent.ROTATEDOWN.Button.Transparency = 0.6
		script.Parent.ROTATEDOWN:SetAttribute('activated',false)
		script.Parent.ROTATEUP.Transparency = 0.6
		script.Parent.ROTATEUP.Button.Transparency = 0.6
		script.Parent.ROTATEUP:SetAttribute('activated',false)
		sendToServer()
	end
end)


script.Parent.Close.MouseButton1Click:Connect(function()
	script.Parent:TweenPosition(UDim2.new(0.259, 0,1.183, 0),0,0,0.4)
end)

function checkIfTheSame(input)
	for i,n in pairs(script.Parent:GetChildren()) do
		if n.ClassName == "TextLabel" and n.Name ~= myFrame.Name and n:GetAttribute('activated') then
			if n:GetAttribute("Bind") == tostring(convert(input.KeyCode)) then
			return true
			end
		end	
	end
	return false
end

function checkIsGood(input)
	if input.KeyCode.Value > 47 and input.KeyCode.Value < 58 or input.KeyCode.Value > 96 and input.KeyCode.Value < 123 and input.KeyCode.Value ~= 97 and input.KeyCode.Value ~= 100 and input.KeyCode.Value ~= 115 and input.KeyCode.Value ~= 119 then
		if not checkIfTheSame(input) then	
		return true
		end
	end
	return false
end

function convert(input)
	if input.Value > 47 and input.Value < 58 then
		if input.Name == "One" then
		return "1"
		elseif input.Name == "Two" then
		return "2"
		elseif input.Name == "Three" then
		return "3"
		elseif input.Name == "Four" then
		return "4"
		elseif input.Name == "Five" then
		return "5"
		elseif input.Name == "Six" then
		return "6"
		elseif input.Name == "Seven" then
		return "7"
		elseif input.Name == "Eight" then
		return "8"
		elseif input.Name == "Nine" then
		return "9"
		elseif input.Name == "Zero" then
		return "0"
 		end
	else
	return input.Name
	end
end

for i,n in pairs(script.Parent:GetChildren()) do
	if n.ClassName == "TextLabel" then
		n.Button.MouseButton1Click:Connect(function()
			myFrame = n
			inputToggle = true
			myFrame.Button.Text = "Press key..."
			plr:SetAttribute("isBind",true)
		end)
	end
end

function sendToServer()
	local sendData = {}
	for i,n in pairs(script.Parent:GetChildren()) do
		if n.ClassName == "TextLabel" then
			sendData[n.Name] = n:GetAttribute('Bind')
		end
	end
	sendData[ctrlSwitch.Name] = ctrlSwitch:GetAttribute('isOn')
	sendData[shiftSwitch.Name] = shiftSwitch:GetAttribute('isOn')
	game.ReplicatedStorage.Events.BindEvents.sendBindData:FireServer(sendData)
end

uis.InputBegan:Connect(function(input)
	if inputToggle then
		if checkIsGood(input) then
			myFrame:SetAttribute("Bind",tostring(convert(input.KeyCode)))
			myFrame.Button.Text = tostring(convert(input.KeyCode))
			inputToggle = false
			plr:SetAttribute("isBind",false)
			sendToServer()
		end
	end
end)

game.ReplicatedStorage.Events.RESETGUI.OnClientEvent:Connect(function()
	script.Parent:TweenPosition(UDim2.new(0.259, 0,1.183, 0),0,0,0.4)
end)