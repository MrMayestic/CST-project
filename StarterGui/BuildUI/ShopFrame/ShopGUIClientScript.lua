local clientmodel = game.ReplicatedStorage.Events.ModelEvents.ClientModel

local getPlot = game.ReplicatedStorage.Remotes.requestPlot
local plot

local navButtons = script.Parent.NavButtons

local rollButton = script.Parent.Roll
local rollToggle = true
local AudioPlayer = require(game.ReplicatedStorage.Modules:WaitForChild("AudioModule")) 
local model = {}

script.Parent:WaitForChild("DecorationsFrame"):WaitForChild("LittleTree")

wait()
--Function to fast change visible of all model's frames to false
local function clearAll()
	for i,n in pairs(script.Parent:GetChildren()) do
		if n.ClassName == "ScrollingFrame" then
			n.Visible = false
		end
	end
	
	for i,n in pairs(navButtons:GetChildren()) do
		n.BackgroundColor3 = Color3.new(1,1,1)
		n.BackgroundTransparency = 0.15
	end
end

--Add to tabel model's buttons
for i,n in next, script.Parent:GetChildren() do
	if n.ClassName == "ScrollingFrame" then
		for i,n in next, n:GetChildren() do
			if n.ClassName == "TextButton" then
				table.insert(model,i,n)
			end
		end
	end
end

plot = getPlot:InvokeServer()

--Add function for each model's button
for i,n in pairs(model) do
	n.MouseButton1Click:Connect(function()
		wait()
	    clientmodel:FireServer(n.Name) 	
		AudioPlayer.playAudio("Click")
		wait()
	end)
end

for i,n in pairs(navButtons:GetChildren()) do
	n.MouseButton1Click:Connect(function()
		clearAll()
		script.Parent:FindFirstChild(n.Name.."Frame").Visible = true
		n.BackgroundColor3 = Color3.new(0.505882, 0.556863, 0.588235)
		n.BackgroundTransparency = 0.1
	end)
end

local function rollOnOff()
	if rollToggle then
		rollToggle = false
		script.Parent:TweenPosition(UDim2.new(0, 0,1, 0),nil,nil,0.35)
		rollButton.Rotation = 0
		script.Parent:SetAttribute('isShown',false)
	else
		rollToggle = true
		script.Parent:TweenPosition(UDim2.new(0, 0,0.839, 0),nil,nil,0.35)
		rollButton.Rotation = 180
		script.Parent:SetAttribute('isShown',true)
	end
end

rollButton.MouseButton1Click:Connect(function()
	rollOnOff()
end)