local frame = script.Parent

local errormodule = require(game.ReplicatedStorage.Modules.ErrorModule)

local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

task.wait(0.15)

local frees = frame.Free:GetChildren()
local paid = frame.Paid:GetChildren()

local MaterialPassID = 172563240

local setMaterial = script.Parent.Parent:WaitForChild("PaintFrame"):WaitForChild("SetMaterial")

for i,n in pairs(frees) do
	n.MouseButton1Click:Connect(function()
		setMaterial:Fire(n.Name)
	end) 
	n.ImageButton.MouseButton1Click:Connect(function()
		setMaterial:Fire(n.Name)
	end)
end

local function paidMaterial(button)
	local player = Players.LocalPlayer
	local hasPass = false

	local success, message = pcall(function()
		hasPass = MarketplaceService:UserOwnsGamePassAsync(player.UserId, 172563240)
	end)

	if not success then
		errormodule.errorfuncGo(player,"Error while checking if player has pass: " .. tostring(message))
		return
	end

	if hasPass then
		setMaterial:Fire(button.Name)
	else
		MarketplaceService:PromptGamePassPurchase(player, 172563240)
	end
end

for i,n in pairs(paid) do
	n.MouseButton1Click:Connect(function()
		paidMaterial(n)
	end) 
	n.ImageButton.MouseButton1Click:Connect(function()
		paidMaterial(n)
	end) 
end

frame.Close.MouseButton1Click:Connect(function()
	frame:TweenPosition(UDim2.new(0.2,0,1.209,0),0,0,0.35)
end)