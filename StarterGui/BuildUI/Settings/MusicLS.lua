local box = script.Parent

local playButton = script.Parent.Parent.PlayMusic

local errormodule = require(game.ReplicatedStorage.Modules.ErrorModule)

local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

-- Function to prompt purchase of the Pass
local function playMusic()
	local player = Players.LocalPlayer
	local hasPass = false

	local success, message = pcall(function()
		hasPass = MarketplaceService:UserOwnsGamePassAsync(player.UserId, 172117812)
	end)

	if not success then
		errormodule.errorfuncGo(player,"Error while checking if player has pass: " .. tostring(message))
		return
	end
	
	if hasPass then
		game.ReplicatedStorage.Events.RBEvents.playMusic:FireServer(box.Text)
	else
		-- Player does NOT own the Pass; prompt them to purchase
		MarketplaceService:PromptGamePassPurchase(player, 172117812)
	end
end

--script.Parent.Parent.CustomMusicBuy.MouseButton1Click:Connect(promptPurchase)

playButton.MouseButton1Click:Connect(function()
	playMusic()
end)