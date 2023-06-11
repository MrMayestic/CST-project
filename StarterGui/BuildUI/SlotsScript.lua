local plr = game.Players.LocalPlayer
local frame = script.Parent.KtorySlot
local waiter = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("BuildUI"):WaitForChild("ColorPicker")
local yesEvent
local noEvent

local AudioPlayer = require(game.ReplicatedStorage.Modules:WaitForChild("AudioModule"))
local hideModule = require(game.ReplicatedStorage.Modules.HideModule)

local areYouSure = script.Parent.AreYouSure

local RS = game.ReplicatedStorage.Events

function WczytajNazwe(name,value)
	local wlasciwy = frame:FindFirstChild("Slot"..value)
	if name then
		wlasciwy.Shopname.Text = name
	else
		wlasciwy.Shopname.Text = " "
	end
end

wait(0.2)

local toggle = true
local obiekty = {"CashFrame","MagazynFrame","BuildSystemsAndInfo","Clock"}

local function check(obj)
	for i,n in ipairs(obiekty) do
		if obj == n then
			return true
		end
	end
	return false
end

game.ReplicatedStorage.Events.SlotEvents.NazwaSlota.OnClientEvent:Connect(WczytajNazwe)

hideModule.visibleOffSlot()

wait(1.3)

function wczytajDane()
	hideModule.visibleOffSlot()
	frame:TweenPosition(UDim2.new(0.265, 0,0.357, 0),0,0,0.5)
	if toggle then
		for i,n in pairs(frame:GetChildren()) do
			n.Load.MouseButton1Click:Connect(function()
				pcall(function()
					plr.PlayerGui.BuildUI.SaveLoadPI.Visible = true
				end)
				--plr:WaitForChild("ValueFolder").CanYou.Value = true
				RS.SlotEvents.startLoading:FireServer(n:GetAttribute("ktory"))
				frame:TweenPosition(UDim2.new(0.265, 0,1.157, 0),0,0,0.5)
				hideModule.visibleOnSlot()
			end)
		end

		for i,n in pairs(frame:GetChildren()) do
			n.Reset.MouseButton1Click:Connect(function()
				AudioPlayer.playAudio("Click")
				yesEvent = areYouSure.YES.MouseButton1Click:Connect(function()
					areYouSure.Visible = false
					AudioPlayer.playAudio("Click")
					yesEvent:Disconnect()
					noEvent:Disconnect()
					RS.SlotEvents.ResetModel:FireServer(n:GetAttribute("ktory"))
				end)
				noEvent = areYouSure.NO.MouseButton1Click:Connect(function()
					AudioPlayer.playAudio("Click")
					areYouSure.Visible = false
					yesEvent:Disconnect()
					noEvent:Disconnect()
				end)
				areYouSure.TextLabel.Text = "Are you sure you want to reset this slot?"
				areYouSure.Visible = true
			end)
		end
		toggle = false
	end
	wait(1)
end

RS.SlotEvents.Reload.OnClientEvent:Connect(wczytajDane)

wczytajDane()