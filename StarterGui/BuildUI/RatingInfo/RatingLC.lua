local frame = script.Parent
local rat = frame.rat

local plr = game.Players.LocalPlayer

local event

function ratingChanged(newval)
	rat.Text = newval
end

game.ReplicatedStorage.Events.Other.setRatingEvent.OnClientEvent:Connect(function()
	if event then
		event:Disconnect()
	end
	
	event =	plr:WaitForChild("leaderstats"):WaitForChild('Rating').Changed:Connect(ratingChanged)
	rat.Text = plr:WaitForChild("leaderstats"):WaitForChild('Rating').Value
end)