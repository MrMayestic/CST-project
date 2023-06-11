local MarketplaceService = game:GetService("MarketplaceService")
local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local buyevents = game.ReplicatedStorage.Events.BUYEvents
local errormodule = require(game.ReplicatedStorage.Modules.ErrorModule)
-- Data store for tracking purchases that were successfully processed
local purchaseHistoryStore = DataStoreService:GetDataStore("PurchaseHistory")
local plotManager = require(game.ServerScriptService.ServerModules.PlotManager)
local expandmodule = require(game.ReplicatedStorage.Modules.ExpandModule)

local startCounter = script.Parent.HandleBoostsServer.startCounter
-- Table setup containing product IDs and functions for handling purchases
local productFunctions = {}

wait(1)

local expandsDictionary = {
	[1163446072] = "LeftExpand1",
	[1275701464] = "LeftExpand2",
	[1275701630] = "LeftExpand3",
	[1163902199] = "RightExpand1",
	[1275697549] = "RightExpand2",
	[1275700497] = "RightExpand3",
	[1163902200] = "FrontExpand2",
	[1163903525] = "FrontExpand3",
}

local magazineDictionary = {
	[1345371070] = "MagazineExpansion1",
	[1345372027] = "MagazineExpansion2",
	[1345374397] = "MagazineExpansion3",
	[1374930906] = "MagazineExpansion4",
	[1374931786] = "MagazineExpansion5",
}

local cashDictionary = {
	[1163619117] = 1000,
	[1163620567] = 2500,
	[1163620619] = 5000,
	[1163620648] = 10000,
	[1163621103] = 25000,
	[1163621139] = 30000,
	[1163621217] = 50000,
	[1163621338] = 75000,
	[1163621465] = 100000,
}

local boostsDictionary = {
	[1275701465] = "10%10",
	[1313486936] = "10%20",
	[1313487013] = "10%30",
	[1374948047] = "25%10",
	[1374948243] = "25%20",
	[1374948409] = "25%30",
	[1374949022] = "50%10",
	[1374949024] = "50%20",
	[1374949025] = "50%30",
	[1374949672] = "100%10",
	[1374949673] = "100%20",
	[1374949674] = "100%30",
}

local superBoostsDictionary = {
	[1375027287] = "10%10%250",
	[1375027588] = "10%20%500",
	[1375028052] = "10%30%750",
	[1375182373] = "25%10%500",
	[1375182459] = "25%20%1000",
	[1375182529] = "25%30%1500",
	[1375182642] = "50%10%1000",
	[1375182760] = "50%20%2000",
	[1375182834] = "50%30%3000",
	[1375182969] = "100%10%2500",
	[1375183056] = "100%20%5000",
	[1375183172] = "100%30%10000",
}

local parkingsIDs = {
	[1531917372] = "parkingLvl1";
	[1531917517] = "parkingLvl2";
}

local signsIDs = {
	[1531917724] = "signLvl1";
	[1531917804] = "signLvl2";
}


local customMusicPassID = 172117812

local function onPromptPurchaseFinished(player, purchasedPassID, purchaseSuccess)
	if purchaseSuccess and purchasedPassID == customMusicPassID then
		print(player.Name .. " purchased the Pass with ID " .. customMusicPassID)
		-- Assign this player the ability or bonus related to the Pass
	end
end

MarketplaceService.PromptGamePassPurchaseFinished:Connect(onPromptPurchaseFinished)

-------------------------------------PARKINGS----------------------------------------------------

local function handleParking(plr)
	game.ReplicatedStorage.Events.RBEvents.parkingSet:Fire(plr,true,true)
end

for i,n in pairs(parkingsIDs) do
	productFunctions[i] = function(receipt, player)
		handleParking(player)
		return true
	end
end

-------------------------------------SIGNS----------------------------------------------------

local function handleSign(plr)
	game.ReplicatedStorage.Events.RBEvents.signSet:Fire(plr,true,true)
end

for i,n in pairs(signsIDs) do
	productFunctions[i] = function(receipt, player)
		handleSign(player)
		return true
	end
end

-------------------------------------EXPANDS----------------------------------------------------

local function expandPlot(plr,ktore)
	local plot = plotManager.returnPlot(workspace.Plots, plr)
	local position = plot.Plot.Position
	local ileile = ktore:GetAttribute("ile")
	local cost = 0
	expandmodule.zmiana(plr,ileile,cost, plot, position,ktore)
end

for i,n in pairs(expandsDictionary) do
	productFunctions[i] = function(receipt, player)
		local ktory = player.PlayerGui.BuildUI.ExpandPlotFrame:FindFirstChild(n)
		expandPlot(player,ktory)
		return true
	end
end

------------------------------------CASH---------------------------------------------------------

for i,n in pairs(cashDictionary) do
	productFunctions[i] = function(receipt, player)
		player.leaderstats.Cash.Value += n
		return true
	end
end

------------------------------------BOOSTS---------------------------------------------------------

for i,n in pairs(boostsDictionary) do
	productFunctions[i] = function(receipt, player)
		local splitedString = string.split(n,"%")
		local percentageBoost = tonumber(splitedString[1])
		local boostTime = splitedString[2]
		
		startCounter:Fire(player,percentageBoost,tonumber(boostTime))
		
		return true
	end
end

--SUPER--

for i,n in pairs(superBoostsDictionary) do
	productFunctions[i] = function(receipt, player)
		local splitedString = string.split(n,"%")
		local percentageBoost = tonumber(splitedString[1])
		local boostTime = splitedString[2]
		local addCash = splitedString[3]

		startCounter:Fire(player,percentageBoost,tonumber(boostTime))
		
		player.leaderstats.Cash.Value += addCash

		return true
	end
end

------------------------------------MAGAZINE---------------------------------------------------------

for i,n in pairs(magazineDictionary) do
	productFunctions[i] = function(receipt, player)
		local frame = player.PlayerGui:WaitForChild("BuildUI"):WaitForChild("ExpandMagazinFrame")
		local toggle = true
		local zliczbutton = frame.ExpandButton
		local info = frame.IleInfoMagazyn
		local value = info.MagazinValue
		local zaplacisz = frame.IleZaplacisz
		local zaplac = zaplacisz.ZaplaciszValue
		local checkvalue = player.ValueFolder.MaxCapacity.Value
		local robuxPrice = frame.RobuxPrice

		if checkvalue < 5 then

			if checkvalue == 0 or checkvalue == nil then
				value.Value = 75
				zaplac.Value = 7500
				info.Text = value.Value
				zaplacisz.Text = zaplac.Value
				robuxPrice.Text = 40
			elseif checkvalue == 1 then
				value.Value = 100
				zaplac.Value = 10000
				info.Text = value.Value
				zaplacisz.Text = zaplac.Value
				robuxPrice.Text = 65
			elseif checkvalue == 2 then
				zaplac.Value = 12500
				value.Value = 150
				info.Text = value.Value
				zaplacisz.Text = zaplac.Value
				robuxPrice.Text = 80
			elseif checkvalue == 3 then
				zaplac.Value = 17500
				value.Value = 250
				info.Text = value.Value
				zaplacisz.Text = zaplac.Value
				robuxPrice.Text = 110
			elseif checkvalue == 4 then
				zaplac.Value = 25000
				value.Value = 500
				info.Text = value.Value
				zaplacisz.Text = zaplac.Value
				robuxPrice.Text = 150
			elseif checkvalue == 5 then
				zaplac.Value = 0
				zaplacisz.Text = ""
				info.Text = "All upgrades done"
				robuxPrice.Text = 0
			end

			player.PlayerGui.BuildUI.BuildSystemsAndInfo.Midyl.Frame.MagazynFrame.MaxCapacity.MaxValue.Value = value.Value
			player.ValueFolder.MaxCapacity.Value += 1
			
			game.ReplicatedStorage.Events.TowarEvents.Zlicz:FireClient(player)
			game.ReplicatedStorage.Events.MagazynEvents.ExMg:FireClient(player)
		end

		return true
	end
end

-- The core 'ProcessReceipt' callback function
local function processReceipt(receiptInfo)
	local plr = game.Players:GetPlayerByUserId(receiptInfo.PlayerId)
	-- Determine if the product was already granted by checking the data store  
	local playerProductKey = receiptInfo.PlayerId .. "_" .. receiptInfo.PurchaseId
	local purchased = false
	local success, errorMessage = pcall(function()
		purchased = purchaseHistoryStore:GetAsync(playerProductKey)
	end)
	-- If purchase was recorded, the product was already granted
	if success and purchased then
		return Enum.ProductPurchaseDecision.PurchaseGranted
	elseif not success then
		errormodule.errorfuncGo(plr,"Data store error: " .. errorMessage)
	end

	-- Find the player who made the purchase in the server
	local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
	if not player then
		-- The player probably left the game
		-- If they come back, the callback will be called again
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	-- Look up handler function from 'productFunctions' table above
	local handler = productFunctions[receiptInfo.ProductId]

	-- Call the handler function and catch any errors
	local success, result = pcall(handler, receiptInfo, player)
	if not success or not result then
		errormodule.errorfuncGo(plr,"Error occurred while processing a product purchase.")
		print("\nProductId:", receiptInfo.ProductId)
		print("\nPlayer:", player)
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	-- Record transaction in data store so it isn't granted again
	local success, errorMessage = pcall(function()
		purchaseHistoryStore:SetAsync(playerProductKey, true)
	end)
	if not success then
		errormodule.errorfuncGo(plr,"Cannot save purchase data: " .. errorMessage)
	end

	-- IMPORTANT: Tell Roblox that the game successfully handled the purchase
	return Enum.ProductPurchaseDecision.PurchaseGranted
end

-- Set the callback; this can only be done once by one script on the server! 
MarketplaceService.ProcessReceipt = processReceipt

