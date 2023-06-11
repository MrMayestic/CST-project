--[[
	Created by MrSprinkleToes
	1/28/2019
--]]

-- MAIN CODE -- (Do not edit!)
local http = game:GetService("HttpService")
local AudioPlayer = require(game.ReplicatedStorage.Modules:WaitForChild("AudioModule"))
script.Parent.MouseButton1Click:Connect(function()
	AudioPlayer.playAudio("Click")
	if script.Parent.Parent.fdbk.Text == "" then return end
	local fb = script.Parent.Parent.fdbk.Text
	script.Parent.Parent.fdbk.Text = ""
	game:GetService("ReplicatedStorage").sendReport:FireServer(fb)
end)