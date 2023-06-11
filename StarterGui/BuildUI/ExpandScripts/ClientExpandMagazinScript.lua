local button = script.Parent.Parent.BuildSystemsAndInfo.Expands.Menu.ZwiekszMagazyn
local frame = script.Parent
local toggle = true
local zliczbutton = frame.ExpandButton
local robuxButton = frame.RobuxButton
local plr = game.Players.LocalPlayer
local close = script.Parent.Parent.ExpandMagazineClose
local errormodule = require(game.ReplicatedStorage.Modules.ErrorModule)
local AudioPlayer = require(game.ReplicatedStorage.Modules:WaitForChild("AudioModule"))

local areYouSure = script.Parent.Parent.AreYouSure
local yesEvent
local noEvent

local RS = game.ReplicatedStorage

local MarketplaceService = game:GetService("MarketplaceService")

local magazineDictionary = {
	[0] = 1345371070,
	[1] = 1345372027,
	[2] = 1345374397,
	[3] = 1374930906,
	[4] = 1374931786,
}

zliczbutton.MouseButton1Click:Connect(function()
	AudioPlayer.playAudio("Click")
	if plr.ValueFolder.MaxCapacity.Value < 5 then
		yesEvent = areYouSure.YES.MouseButton1Click:Connect(function()
			AudioPlayer.playAudio("Click")
			wait()
			areYouSure.Visible = false
			yesEvent:Disconnect()
			noEvent:Disconnect()
			RS.Events.MagazynEvents.ExpandMagazinSignal:FireServer()
		end)
		noEvent = areYouSure.NO.MouseButton1Click:Connect(function()
			AudioPlayer.playAudio("Click")
			areYouSure.Visible = false
			yesEvent:Disconnect()
			noEvent:Disconnect()
		end)
		areYouSure.TextLabel.Text = "Are you sure you want to buy this magazine expansion?"
		areYouSure.Visible = true
	end
end)

robuxButton.MouseButton1Click:Connect(function()
	AudioPlayer.playAudio("Click")
	if plr.ValueFolder.MaxCapacity.Value < 5 then
		MarketplaceService:PromptProductPurchase(plr, magazineDictionary[plr.ValueFolder.MaxCapacity.Value])
	end
end)

button.MouseButton1Click:Connect(function()
	if not plr:FindFirstChild("leaderstats") then
		return
	end
	AudioPlayer.playAudio("Click")
	if toggle and not plr:GetAttribute("DoesTutorial") then
		toggle = false
		close.Visible = true
		frame:TweenPosition(UDim2.new(0.379, 0,0.407, 0),0,0,0.5)
		wait(0.3)
	end
end)

close.MouseButton1Click:Connect(function()
	AudioPlayer.playAudio("Click")
	toggle = true
	close.Visible = false
	frame:TweenPosition(UDim2.new(0.379, 0,1.050, 0),0,0,0.5)
	wait(0.3)
end)

game.ReplicatedStorage.Events.MagazynEvents.ExpandMagazinData.OnClientEvent:Connect(function()
	game.ReplicatedStorage.Events.MagazynEvents.sprawdz:FireServer()
end)

game.ReplicatedStorage.Events.MagazynEvents.ExMg.OnClientEvent:Connect(function()
	game.ReplicatedStorage.Events.MagazynEvents.sprawdz:FireServer()
end)

game.ReplicatedStorage.Events.RESETGUI.OnClientEvent:Connect(function()
	toggle = true
	frame:TweenPosition(UDim2.new(0.379, 0,1.050, 0),0,0,0.5)
	wait(0.3)
	button.Text="Magazine"	
	close.Visible = false
end)
