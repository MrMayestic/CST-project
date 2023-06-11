local frame = script.Parent
local cashFolder = frame.CashFolder
local cashButton = frame.CashButton

local boostButton = frame.BoostButton
local boostFolder = frame.BoostFolder

local superBoostButton = frame.SBButton
local superBoostFolder = frame.SuperBoostFolder

local shopInfo = frame.ShopInfo

local boostText = "Boosts allow you earn more money from sales. Boosts are addable, so if you buy a 10% boost for 10 minutes and then a 50% boost for 20 minutes, you will end up with a 60% boost for 30 minutes."

local superBoostText = "Super Boosts are the same as Boosts, but you also buy money. Super Boosts are also addable."

local cashText = "Here you can only buy money for robux without add-ons."

local otherText  = "In this section you can donate me with a tip if you want, I would be grateful."

local i1K = cashFolder.i1K
local i2I5K = cashFolder["i2,5K"]
local i5K = cashFolder.i5K
local i10K = cashFolder.i10K
local i25K = cashFolder.i25K
local i30K = cashFolder.i30K
local i50K = cashFolder.i50K
local i75K = cashFolder.i75K
local i100K = cashFolder.i100K

local b1010 = boostFolder["10%10min"]
local b1020 = boostFolder["10%20min"]
local b1030 = boostFolder["10%30min"]

local b2510 = boostFolder["25%10min"]
local b2520 = boostFolder["25%20min"]
local b2530 = boostFolder["25%30min"]

local b5010 = boostFolder["50%10min"]
local b5020 = boostFolder["50%20min"]
local b5030 = boostFolder["50%30min"]

local b10010 = boostFolder["100%10min"]
local b10020 = boostFolder["100%20min"]
local b10030 = boostFolder["100%30min"]

---------------------------------------------

local b1010s = superBoostFolder["10%10min+250"]
local b1020s = superBoostFolder["10%20min+500"]
local b1030s = superBoostFolder["10%30min+750"]

local b2510s = superBoostFolder["25%10min+500"]
local b2520s = superBoostFolder["25%20min+1000"]
local b2530s = superBoostFolder["25%30min+1500"]

local b5010s = superBoostFolder["50%10min+1000"]
local b5020s = superBoostFolder["50%20min+2000"]
local b5030s = superBoostFolder["50%30min+3000"]

local b10010s = superBoostFolder["100%10min+2500"]
local b10020s = superBoostFolder["100%20min+5000"]
local b10030s = superBoostFolder["100%30min+10000"]

local CashIDs = {
	[i1K] = 1163619117,
	[i2I5K] = 1163620567,
	[i5K] = 1163620619,
	[i10K] = 1163620648,
	[i25K] = 1163621103,
	[i30K] = 1163621139,
	[i50K] = 1163621217,
	[i75K] = 1163621338,
	[i100K] = 1163621465
}

local BoostIDs = {
	[b1010] = 1275701465,
	[b1020] = 1313486936,
	[b1030] = 1313487013,
	[b2510] = 1374948047,
	[b2520] = 1374948243,
	[b2530] = 1374948409,
	[b5010] = 1374949022,
	[b5020] = 1374949024,
	[b5030] = 1374949025,
	[b10010] = 1374949672,
	[b10020] = 1374949673,
	[b10030] = 1374949674,
}

local SuperBoostIDs = {
	[b1010s] = 1375027287,
	[b1020s] = 1375027588,
	[b1030s] = 1375028052,
	[b2510s] = 1375182373,
	[b2520s] = 1375182459,
	[b2530s] = 1375182529,
	[b5010s] = 1375182642,
	[b5020s] = 1375182760,
	[b5030s] = 1375182834,
	[b10010s] = 1375182969,
	[b10020s] = 1375183056,
	[b10030s] = 1375183172,
}

local RBshop = frame.Parent.BuildSystemsAndInfo.RBShop
local close = frame.Parent.RBFClose
local plr = game.Players.LocalPlayer

local MarketplaceService = game:GetService("MarketplaceService")
local AudioPlayer = require(game.ReplicatedStorage.Modules:WaitForChild("AudioModule"))

cashButton.MouseButton1Click:Connect(function()
	for i,n in pairs(boostFolder:GetChildren()) do
		n.Visible = false
	end
	for i,n in pairs(superBoostFolder:GetChildren()) do
		n.Visible = false
	end
	
	frame.Info10min.Visible = false
	frame.Info20min.Visible = false
	frame.Info30min.Visible = false
	
	for i,n in pairs(cashFolder:GetChildren()) do
		n.Visible = true
	end
	
	shopInfo.Text = cashText
	
	cashButton.UIStroke.Color = Color3.new(1,1,1)
	boostButton.UIStroke.Color = Color3.new(0,0,0)
	superBoostButton.UIStroke.Color = Color3.new(0,0,0)
end)

boostButton.MouseButton1Click:Connect(function()
	for i,n in pairs(cashFolder:GetChildren()) do
		n.Visible = false
	end
	for i,n in pairs(superBoostFolder:GetChildren()) do
		n.Visible = false
	end
	
	frame.Info10min.Visible = true
	frame.Info20min.Visible = true
	frame.Info30min.Visible = true
	
	for i,n in pairs(boostFolder:GetChildren()) do
		n.Visible = true
	end
	
	shopInfo.Text = boostText
	
	boostButton.UIStroke.Color = Color3.new(1,1,1)
	cashButton.UIStroke.Color = Color3.new(0,0,0)
	superBoostButton.UIStroke.Color = Color3.new(0,0,0)
end)

superBoostButton.MouseButton1Click:Connect(function()
	for i,n in pairs(cashFolder:GetChildren()) do
		n.Visible = false
	end
	for i,n in pairs(boostFolder:GetChildren()) do
		n.Visible = false
	end

	frame.Info10min.Visible = true
	frame.Info20min.Visible = true
	frame.Info30min.Visible = true

	for i,n in pairs(superBoostFolder:GetChildren()) do
		n.Visible = true
	end
	
	shopInfo.Text = superBoostText

	boostButton.UIStroke.Color = Color3.new(0,0,0)
	cashButton.UIStroke.Color = Color3.new(0,0,0)
	superBoostButton.UIStroke.Color = Color3.new(1,1,1)
end)

RBshop.MouseButton1Click:Connect(function()
	if not plr:FindFirstChild("leaderstats") then
		return
	end
	if not plr:GetAttribute("DoesTutorial") then
		AudioPlayer.playAudio("Click")
		RBshop.Visible = false
		frame:TweenPosition(UDim2.new(0.297, 0,0.278, 0),0,0,0.5)
		wait(0.75)
		close.Visible = true
	end		
end)

close.MouseButton1Click:Connect(function()
	AudioPlayer.playAudio("Click")
	close.Visible = false
	frame:TweenPosition(UDim2.new(0.297, 0,1.078, 0),0,0,0.5)
	wait(0.6)
	frame.CanvasPosition = Vector2.new(0,0)
	RBshop.Visible = true
end)

for i,n in pairs(cashFolder:GetChildren()) do
	n.MouseButton1Click:Connect(function()
		MarketplaceService:PromptProductPurchase(plr, CashIDs[n])
	end)
end

for i,n in pairs(boostFolder:GetChildren()) do
	n.MouseButton1Click:Connect(function()
		MarketplaceService:PromptProductPurchase(plr, BoostIDs[n])
	end)
end

for i,n in pairs(superBoostFolder:GetChildren()) do
	n.MouseButton1Click:Connect(function()
		MarketplaceService:PromptProductPurchase(plr, SuperBoostIDs[n])
	end)
end

game.ReplicatedStorage.Events.RESETGUI.OnClientEvent:Connect(function()
	close.Visible = false
	frame:TweenPosition(UDim2.new(0.297, 0,1.078, 0),0,0,0.5)
	wait(0.6)
	frame.CanvasPosition = Vector2.new(0,0)
	RBshop.Visible = true
end)