local button = script.Parent
local plr = game.Players.LocalPlayer

local areYouSure = button.Parent.Parent.Parent.AreYouSure
local yesEvent
local noEvent

local getPlot = game.ReplicatedStorage.Remotes.requestPlot
local plot = getPlot:InvokeServer()
local RS = game.ReplicatedStorage

button.MouseButton1Click:Connect(function()
	yesEvent = areYouSure.YES.MouseButton1Click:Connect(function()
		game.ReplicatedStorage.Events.Other.unsetHR:Fire()
		plr.PlayerGui.BuildUI.SaveLoadPI.Visible = true
		wait()
		local slPI
		pcall(function()
			slPI = plr.PlayerGui.BuildUI.SaveLoadPI
			slPI.Text = "Starting to reload plot..."
		end)
		areYouSure.Visible = false
		yesEvent:Disconnect()
		noEvent:Disconnect()
		RS.Events.SaveHandler:FireServer(true)
	end)
	noEvent = areYouSure.NO.MouseButton1Click:Connect(function()
		areYouSure.Visible = false
		yesEvent:Disconnect()
		noEvent:Disconnect()
	end)
	areYouSure.TextLabel.Text = "Are you sure you want to reload slot?"
	areYouSure.Visible = true
end)

--RS.Events.SlotEvents.OkiejSaved.OnClientEvent:Connect(function()

--	RS.Events.SlotEvents.Reload:FireServer(plot)

--end)

--RS.Events.SlotEvents.OkiejSavedSec.OnClientEvent:Connect(function()

--	RS.Events.SlotEvents.ReloadSec:FireServer(plot)

--end)

