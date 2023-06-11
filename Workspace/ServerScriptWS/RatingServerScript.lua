local Ratingfolder = game.ReplicatedStorage.Events.RatingFolder

Ratingfolder.RatingSend.OnServerEvent:Connect(function(plr,wpisz)
	plr.leaderstats.Rating.Value = math.floor(wpisz*10)/10
end)