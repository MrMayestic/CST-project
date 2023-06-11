local butonframe = script.Parent.ButtonsFrame
local moveframe = script.Parent.MoveTutorial
local manageframe = script.Parent.ManageTutorial
local paintframe = script.Parent.PaintTutorial
local exnandframe = script.Parent.ExpandPlotTutorial
local deleteframe = script.Parent.DeleteTutorial
local magazineframe = script.Parent.MagazineTutorial
local saveframe = script.Parent.SaveTutorial
local buildframe = script.Parent.BuildTutorial
local shopframe = script.Parent.ShopTutorial
local autobuyframe = script.Parent.AutoBuyTutorial
local cashframe = script.Parent.CashTutorial
local npcframe = script.Parent.NPCTutorial
local start = script.Parent.TutorialStart
local cashier = script.Parent.CashiersTutorial
local setting = script.Parent.SettingsTutorial
local player = game.Players.LocalPlayer
local AudioPlayer = require(game.ReplicatedStorage.Modules:WaitForChild("AudioModule"))

start.MouseButton1Click:Connect(function()
	if not player:FindFirstChild("leaderstats") then
		return
	end
	if not player:GetAttribute("DoesTutorial") then
		AudioPlayer.playAudio("Click")
		butonframe.Visible = true
		butonframe:TweenPosition(UDim2.new(0.308, 0,0.23, 0),0,0,0.4)
	end
end)
butonframe.ShopClose.MouseButton1Click:Connect(function()
	AudioPlayer.playAudio("Click")
	butonframe:TweenPosition(UDim2.new(0.308, 0,1.23, 0),0,0,0.4)
end)
-----------------MOVE----------------------------

butonframe.move.MouseButton1Click:Connect(function()
	moveframe.Visible = true
	moveframe:TweenPosition(UDim2.new(.291, 0,0.29, 0),0,0,0.4)
	wait(0.6)
	butonframe.Visible = false
end)

moveframe.close.MouseButton1Click:Connect(function()
	moveframe:TweenPosition(UDim2.new(.291, 0,1.29, 0),0,0,0.4)
	butonframe.Visible = true
end)
-----------------MANGE----------------------------

butonframe.manage.MouseButton1Click:Connect(function()
	manageframe.Visible = true
	manageframe:TweenPosition(UDim2.new(.291, 0,0.29, 0),0,0,0.4)
	wait(0.6)
	butonframe.Visible = false
end)

manageframe.close.MouseButton1Click:Connect(function()
	manageframe:TweenPosition(UDim2.new(.291, 0,1.29, 0),0,0,0.4)
	butonframe.Visible = true
end)
-----------------PAINT----------------------------

butonframe.paint.MouseButton1Click:Connect(function()
	paintframe.Visible = true
	paintframe:TweenPosition(UDim2.new(.291, 0,0.29, 0),0,0,0.4)
	wait(0.6)
	butonframe.Visible = false
end)

paintframe.close.MouseButton1Click:Connect(function()
	paintframe:TweenPosition(UDim2.new(.291, 0,1.29, 0),0,0,0.4)
	butonframe.Visible = true
end)
-----------------DELETE----------------------------

butonframe.delete.MouseButton1Click:Connect(function()
	deleteframe.Visible = true
	deleteframe:TweenPosition(UDim2.new(.291, 0,0.29, 0),0,0,0.4)
	wait(0.6)
	butonframe.Visible = false
end)

deleteframe.close.MouseButton1Click:Connect(function()
	deleteframe:TweenPosition(UDim2.new(.291, 0,1.29, 0),0,0,0.4)
	butonframe.Visible = true
end)
-----------------EXPAND----------------------------

butonframe.expand.MouseButton1Click:Connect(function()
	exnandframe.Visible = true
	exnandframe:TweenPosition(UDim2.new(.291, 0,0.29, 0),0,0,0.4)
	wait(0.6)
	butonframe.Visible = false
end)

exnandframe.close.MouseButton1Click:Connect(function()
	exnandframe:TweenPosition(UDim2.new(.291, 0,1.29, 0),0,0,0.4)
	butonframe.Visible = true
end)
-----------------SAVE----------------------------

butonframe.save.MouseButton1Click:Connect(function()
	saveframe.Visible = true
	saveframe:TweenPosition(UDim2.new(.291, 0,0.29, 0),0,0,0.4)
	wait(0.6)
	butonframe.Visible = false
end)

saveframe.close.MouseButton1Click:Connect(function()
	saveframe:TweenPosition(UDim2.new(.291, 0,1.29, 0),0,0,0.4)
	butonframe.Visible = true
end)
-----------------BUILD----------------------------

butonframe.build.MouseButton1Click:Connect(function()
	buildframe.Visible = true
	buildframe:TweenPosition(UDim2.new(.291, 0,0.29, 0),0,0,0.4)
	wait(0.6)
	butonframe.Visible = false
end)

buildframe.close.MouseButton1Click:Connect(function()
	buildframe:TweenPosition(UDim2.new(.291, 0,1.29, 0),0,0,0.4)
	butonframe.Visible = true
end)
-----------------SHOP----------------------------

butonframe.shop.MouseButton1Click:Connect(function()
	shopframe.Visible = true
	shopframe:TweenPosition(UDim2.new(.291, 0,0.29, 0),0,0,0.2)
	wait(0.6)
	butonframe.Visible = false
end)

shopframe.close.MouseButton1Click:Connect(function()
	shopframe:TweenPosition(UDim2.new(.291, 0,1.29, 0),0,0,0.2)
	butonframe.Visible = true
end)
-----------------NPC----------------------------

butonframe.open.MouseButton1Click:Connect(function()
	npcframe.Visible = true
	npcframe:TweenPosition(UDim2.new(.291, 0,0.29, 0),0,0,0.4)
	wait(0.6)
	butonframe.Visible = false
end)

npcframe.close.MouseButton1Click:Connect(function()
	npcframe:TweenPosition(UDim2.new(.291, 0,1.29, 0),0,0,0.4)
	butonframe.Visible = true
end)
-----------------MAGAZINE----------------------------

butonframe.magazine.MouseButton1Click:Connect(function()
	magazineframe.Visible = true
	magazineframe:TweenPosition(UDim2.new(.291, 0,0.29, 0),0,0,0.4)
	wait(0.6)
	butonframe.Visible = false
end)

magazineframe.close.MouseButton1Click:Connect(function()
	magazineframe:TweenPosition(UDim2.new(.291, 0,1.29, 0),0,0,0.4)
	butonframe.Visible = true
end)
-----------------Cash----------------------------

butonframe.cash.MouseButton1Click:Connect(function()
	cashframe.Visible = true
	cashframe:TweenPosition(UDim2.new(.291, 0,0.29, 0),0,0,0.4)
	wait(0.6)
	butonframe.Visible = false
end)

cashframe.close.MouseButton1Click:Connect(function()
	cashframe:TweenPosition(UDim2.new(.291, 0,1.29, 0),0,0,0.4)
	butonframe.Visible = true
end)
-----------------AutoBuy----------------------------

butonframe.autobuy.MouseButton1Click:Connect(function()
	autobuyframe.Visible = true
	autobuyframe:TweenPosition(UDim2.new(.291, 0,0.29, 0),0,0,0.4)
	wait(0.6)
	butonframe.Visible = false
end)

autobuyframe.close.MouseButton1Click:Connect(function()
	autobuyframe:TweenPosition(UDim2.new(.291, 0,1.29, 0),0,0,0.4)
	butonframe.Visible = true
end)
-----------------Cashiers----------------------------

butonframe.cashiers.MouseButton1Click:Connect(function()
	cashier.Visible = true
	cashier:TweenPosition(UDim2.new(.291, 0,0.29, 0),0,0,0.4)
	wait(0.6)
	butonframe.Visible = false
end)

cashier.close.MouseButton1Click:Connect(function()
	cashier:TweenPosition(UDim2.new(.291, 0,1.29, 0),0,0,0.4)
	butonframe.Visible = true
end)
-----------------Settings----------------------------

butonframe.settings.MouseButton1Click:Connect(function()
	setting.Visible = true
	setting:TweenPosition(UDim2.new(.291, 0,0.29, 0),0,0,0.4)
	wait(0.6)
	butonframe.Visible = false
end)

setting.close.MouseButton1Click:Connect(function()
	setting:TweenPosition(UDim2.new(.291, 0,1.29, 0),0,0,0.4)
	butonframe.Visible = true
end)

game.ReplicatedStorage.Events.RESETGUI.OnClientEvent:Connect(function()
	butonframe:TweenPosition(UDim2.new(0.308, 0,1.23, 0),0,0,0.4)
	moveframe:TweenPosition(UDim2.new(.291, 0,1.29, 0),0,0,0.4)
	manageframe:TweenPosition(UDim2.new(.291, 0,1.29, 0),0,0,0.4)
	paintframe:TweenPosition(UDim2.new(.291, 0,1.29, 0),0,0,0.4)
	exnandframe:TweenPosition(UDim2.new(.291, 0,1.29, 0),0,0,0.4)
	deleteframe:TweenPosition(UDim2.new(.291, 0,1.29, 0),0,0,0.4)
	magazineframe:TweenPosition(UDim2.new(.291, 0,1.29, 0),0,0,0.4)
	saveframe:TweenPosition(UDim2.new(.291, 0,1.29, 0),0,0,0.4)
	buildframe:TweenPosition(UDim2.new(.291, 0,1.29, 0),0,0,0.4)
	shopframe:TweenPosition(UDim2.new(.291, 0,1.29, 0),0,0,0.2)
	autobuyframe:TweenPosition(UDim2.new(.291, 0,1.29, 0),0,0,0.4)
	cashframe:TweenPosition(UDim2.new(.291, 0,1.29, 0),0,0,0.4)
	npcframe:TweenPosition(UDim2.new(.291, 0,1.29, 0),0,0,0.4)
	start.Visible = true
	cashier:TweenPosition(UDim2.new(.291, 0,1.29, 0),0,0,0.4)
	setting:TweenPosition(UDim2.new(.291, 0,1.29, 0),0,0,0.4)
end)