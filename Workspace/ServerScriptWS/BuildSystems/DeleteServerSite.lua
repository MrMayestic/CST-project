local deleteRE = game.ReplicatedStorage.Events.Delete

deleteRE.OnServerEvent:Connect(function(plr, obj, plot)
	pcall(function()
		if obj.Parent.Name == "DisplayTable" or obj.Parent.Name == "Shelf" or obj.Parent.Name == "SmallShelf" or obj.Name == "DisplayTable" or obj.Name =="Shelf" or obj.Name =="SmallShelf" then
			local covalue = obj.Parent.Towar.KtoryArtykul.Value
			local ilevalue = obj.Parent.Towar.IleArtykul.Value

			if covalue then
				if covalue == "telefony" then

					local dodaj = 50 * ilevalue
					plr.leaderstats.Cash.Value += dodaj 

				elseif covalue == "tablety" then

					local dodaj = 75 * ilevalue
					plr.leaderstats.Cash.Value += dodaj

				elseif covalue == "aparaty" then

					local dodaj = 125 * ilevalue
					plr.leaderstats.Cash.Value += dodaj

				elseif covalue == "telewizory" then

					local dodaj = 750 * ilevalue
					plr.leaderstats.Cash.Value += dodaj

				elseif covalue == "konsole" then

					local dodaj = 350 * ilevalue
					plr.leaderstats.Cash.Value += dodaj

				elseif covalue == "komputery" then

					local dodaj = 500 * ilevalue
					plr.leaderstats.Cash.Value += dodaj
				elseif covalue == "klawiatury" then

					local dodaj = 35 * ilevalue
					plr.leaderstats.Cash.Value += dodaj
				elseif covalue == "myszki" then

					local dodaj = 15 * ilevalue
					plr.leaderstats.Cash.Value += dodaj
				elseif covalue == "glosniki" then

					local dodaj = 75 * ilevalue
					plr.leaderstats.Cash.Value += dodaj
				elseif covalue == "sluchawki" then

					local dodaj = 45 * ilevalue
					plr.leaderstats.Cash.Value += dodaj

				end

			end
		end 
		task.wait()
		if obj.Parent.Name == "PlacedObjects" and obj.Parent.Parent.Parent.Name == plot.Name then
			local stats = plr.leaderstats
			local cash = stats.Cash
			cash.Value += obj.Price.Value/2
			obj:Destroy()
		elseif obj.Parent.PrimaryPart then
			if obj.Parent.Name == "Paintable" then
				local stats = plr.leaderstats
				local cash = stats.Cash
				cash.Value += obj.Parent.Parent.Price.Value/2
				obj.Parent.Parent:Destroy()
			else 
				if obj and obj.Parent then
					local stats = plr.leaderstats
					local cash = stats.Cash
					cash.Value += obj.Parent.Price.Value/2
					obj.Parent:Destroy()
				end
			end

		end
	end)
end)