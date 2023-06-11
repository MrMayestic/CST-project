local plr = game.Players.LocalPlayer
local leaderstats = script.Parent
local ldstatsbutton = script.Parent.Parent.BuildSystemsAndInfo.LeaderstatsButton
local close = script.Parent.Parent.LeaderstatsClose
local AudioPlayer = require(game.ReplicatedStorage.Modules:WaitForChild("AudioModule"))
local RS = game.ReplicatedStorage

local FormatNumber = require(game.ReplicatedStorage.Modules.FormatNumber)
local formatter = FormatNumber.NumberFormatter.with()

ldstatsbutton.MouseButton1Click:Connect(function()
	if not plr:FindFirstChild("leaderstats") then
		return
	end
	AudioPlayer.playAudio("Click")
	if not plr:GetAttribute("DoesTutorial") then
		ldstatsbutton.Visible = false
		leaderstats.Visible = true
		close.Visible = true
	end
end)

close.MouseButton1Click:Connect(function()
	AudioPlayer.playAudio("Click")
	ldstatsbutton.Visible = true
	leaderstats.Visible = false
	close.Visible = false
end)

game.ReplicatedStorage.AllInfo.OnClientEvent:Connect(function(LSTable)
	pcall(function() 
		for i,n in pairs(leaderstats.Frames:GetChildren()) do
			if LSTable[i] ~= nil then
				local player = game.Players:FindFirstChild(LSTable[i])

				local userId = player.UserId
				local thumbType = Enum.ThumbnailType.HeadShot
				local thumbSize = Enum.ThumbnailSize.Size100x100
				local content, isReady = game.Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)

				n.Avatar.Image = content
				n.Cash.Text = formatter:Format(player.leaderstats.Cash.Value) 
				n.PlayerName.Text = player.Name
				n.Rating.Text = player.leaderstats.Rating.Value
			else
				n.Avatar.Image = ""
				n.Cash.Text = ""
				n.PlayerName.Text = ""
				n.Rating.Text = ""
			end
		end
	end)
end)

game.ReplicatedStorage.Events.RESETGUI.OnClientEvent:Connect(function()
	ldstatsbutton.Visible = true
	leaderstats.Visible = false
	close.Visible = false
end)
