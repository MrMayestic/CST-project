local plr = game.Players.LocalPlayer

plr:WaitForChild("leaderstats"):WaitForChild("Cash")

local frame = script.Parent
local infoFrame = frame.Parent.MIInfo

local openButton = frame.Parent.OpenMIButton
local infoButton = frame.infoButton

local RS = game.ReplicatedStorage

local showPos = UDim2.new(0.158, 0,0.058, 0)
local hidePos = UDim2.new(0.158, 0,-0.04, 0)

local showPosB,hidePosB = UDim2.new(0.178, 0,0.057, 0),UDim2.new(0.178, 0,0.138, 0)

local showPosI,hidePosI = UDim2.new(0.385, 0,0.132, 0),UDim2.new(0.385, 0,-0.5, 0)

local showCol = Color3.fromRGB(133, 255, 131)
local hideCol = Color3.fromRGB(255, 85, 85)

local events = {} 

infoButton.MouseButton1Click:Connect(function()
	if infoFrame.Visible == false then
		infoFrame:TweenPosition(showPosI, "Out", "Quad", .3)
		task.wait(0.1)
		infoFrame.Visible = true
	else
		infoFrame:TweenPosition(hidePosI, "Out", "Quad", .3)
		task.wait(0.1)
		infoFrame.Visible = false
	end
end)

-- make openButton tweenPosition the frame after clicking openButton

openButton.MouseButton1Click:Connect(function()
	if frame.Visible == false then
		frame:TweenPosition(showPos, "Out", "Quad", .3)
		openButton:TweenPosition(hidePosB, "Out", "Quad", .3)
		task.wait(0.15)
		frame.Visible = true
		task.wait(0.15)
		openButton.BackgroundColor3 = hideCol
		openButton.Text = "Hide"
	else
		frame:TweenPosition(hidePos, "Out", "Quad", .3)
		openButton:TweenPosition(showPosB, "Out", "Quad", .3)
		task.wait(0.15)
		frame.Visible = false
		task.wait(0.15)
		openButton.BackgroundColor3 = showCol
		openButton.Text = "Products"
	end
end)

RS.Events.MagazynEvents.activateMagazineInfo.OnClientEvent:Connect(function()
	task.wait(0.05)
	for i,n in pairs(frame:GetChildren()) do
		if n.ClassName == "TextLabel" then
			events[#events] = plr.TowarFolder[n.Name].Changed:Connect(function()
				n.total.Text = plr.TowarFolder[n.Name].Value
			end)
			n.total.Text = plr.TowarFolder[n.Name].Value
		end
	end
end)

RS.Events.MagazynEvents.activateMagazineInfo.OnClientEvent:Connect(function()
	for i,n in pairs(events) do
		n:Disconnect()
	end
	task.wait()
	table.clear(events)
	for i,n in pairs(frame:GetChildren()) do
		if n.ClassName == "TextLabel" then
			n.total.Text = 0
		end
	end
end)

RS.Events.RESETGUI.OnClientEvent:Connect(function(toggle)
	if not toggle then
		frame.Visible = false
		frame.Position = hidePos
		openButton.Position = showPosB
		openButton.BackgroundColor3 = showCol
		openButton.Text = "Products"
		infoFrame:TweenPosition(hidePosI, "Out", "Quad", .3)
		infoFrame.Visible = false
	end
end)