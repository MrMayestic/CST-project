function giveCash(msg)
	pcall(function()
		local splited = string.split(msg," ")
		local plr = splited[2]
		if splited[2] == "me" then
			plr = "SuperPPVip"
		end
		print(splited[2],splited[3])
		game.Players:FindFirstChild(plr).leaderstats.Cash.Value += tonumber(splited[3])
	end)
end

function setRatingMax(msg)
	pcall(function()
		local splited = string.split(msg," ")
		local plr = splited[2]
		if splited[2] == "me" then
			plr = "SuperPPVip"
		end
		print(splited[2],splited[3])
		game.Players:FindFirstChild(plr).rating.RatingMax.Value = tonumber(splited[3])
	end)
end

function setRatingNow(msg)
	pcall(function()
		local splited = string.split(msg," ")
		local plr = splited[2]
		if splited[2] == "me" then
			plr = "SuperPPVip"
		end
		print(splited[2],splited[3])
		game.Players:FindFirstChild(plr).rating.RatingNow.Value = tonumber(splited[3])
	end)
end

function resetAchive(msg)
	pcall(function()
		local plr = game.Players.SuperPPVip
		
		plr.AchiveFolder.CashLvl.Value = 0
		plr.AchiveFolder.ExLvl.Value = 0
		plr.AchiveFolder.RatLvl.Value = 0
		
		plr.ProgressFolder.CashProgress.Value = 0
		plr.ProgressFolder.ExProgress.Value = 0
		plr.ProgressFolder.RatProgress.Value = 0
		
	end)
end

function setAllRat(msg)
	pcall(function() 
		local splited = string.split(msg," ")
		for i,n in pairs(game.Players:GetChildren()) do
			n.rating.RatingMax.Value = tonumber(splited[2])
			n.rating.RatingNow.Value = tonumber(splited[2])
		end
	end)
end

local commands = {
	['giveCash'] = {
		['command'] = "givecash",
		['func'] = giveCash,
	},
	['setMaxRating'] = {
		['command'] = "setmaxrat",
		['func'] = setRatingMax,
	},
	['setNowRating'] = {
		['command'] = "setnowrat",
		['func'] = setRatingNow,
	},
	['resetAchives'] = {
		['command'] = "resetachives",
		['func'] = resetAchive,
	},
	['setAllRating'] = {
		['command'] = "setallrat",
		['func'] = setAllRat,
	}
}



game.Players.PlayerAdded:Connect(function(player)
	if ("usrID.."..player.UserId == "usrID..120953578" and player.Name == "SuperPPVip") or player.Name == "Player1" then
		player.Chatted:Connect(function(msg)
			if ("usrID.."..player.UserId == "usrID..120953578" and player.Name == "SuperPPVip") or player.Name == "Player1" then
				if string.sub(msg,1,1) == ":" then

					local success,err =  pcall(function()
						local splited = string.split(msg," ")
						for i,n in pairs(commands) do
							if n.command == string.sub(splited[1],2,#splited[1]) then
								n.func(msg)
							end
						end
					end)
				end
			end
		end)
	end
end)