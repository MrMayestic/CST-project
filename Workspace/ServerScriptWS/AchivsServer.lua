local RS = game.ReplicatedStorage.Events.AchivsEvents

local cashRewards = {1000,2000,3000,4000,5000,7500,10000}
local ratingRewards = {1000,2000,3000,4000,5000}

local moneyBadgeID = 2144496895
local plotBadeID = 2144501722
local ratingBadgeID = 2144501705

RS.WklejMiValue.OnServerEvent:Connect(function(plr,object,value)
	object.Value = value
end)

RS.DajMiHajs.OnServerEvent:Connect(function(plr,lvl)
	pcall(function() 
		if lvl.Name == "CashLvl" then
			plr.leaderstats.Cash.Value += cashRewards[lvl.Value]
			if lvl.Value >= 7 then
				game.ReplicatedStorage.Events.BadgesEvents.awardBadge:Fire(plr,moneyBadgeID)
			end
		elseif lvl.Name == "RatLvl" then
			plr.leaderstats.Cash.Value += ratingRewards[lvl.Value]
			if lvl.Value >= 5 then
				game.ReplicatedStorage.Events.BadgesEvents.awardBadge:Fire(plr,ratingBadgeID)
			end
		elseif lvl.Name == "ExLvl" then
			plr.leaderstats.Cash.Value += 1000
			if lvl.Value >= 8 then
				game.ReplicatedStorage.Events.BadgesEvents.awardBadge:Fire(plr,plotBadeID)
			end
		end
	end)
end)