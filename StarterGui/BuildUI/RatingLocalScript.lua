local plr = game.Players.LocalPlayer
local rating = plr:WaitForChild("rating")

task.wait(0.5)

local RatingNow = rating.RatingNow
local Ratingfolder = game.ReplicatedStorage.Events.RatingFolder

function rated()
	local wpisz = RatingNow.Value/100
	Ratingfolder.RatingSend:FireServer(wpisz)
end

RatingNow.Changed:Connect(rated)