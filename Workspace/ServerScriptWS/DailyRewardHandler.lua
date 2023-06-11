local dss = game:GetService("DataStoreService")

local dailyRewardDS = dss:GetDataStore("DailyRewards")


local rewardsForStreak = 
{
	[1] = 100,
	[2] = 250,
	[3] = 500,
	[4] = 1000,
	[5] = 2200,
	[6] = 3500,
	[7] = 8000,
}


game.ReplicatedStorage.Events.Other.makeDailyReward.OnServerEvent:Connect(function(plr)
	local success, dailyRewardInfo = pcall(function()
		return dailyRewardDS:GetAsync(plr.UserId .. "_DR")
	end)
	if type(dailyRewardInfo) ~= "table" then dailyRewardInfo = {nil, nil} end
	
	
	local cash = 0
	
	--cash = dailyRewardInfo[1] or 0
	
	--plr.leaderstats.Cash.Value += cash
	
	local lastOnline = dailyRewardInfo[1]
	local currentTime = os.time()
	
	local timeDifference
	
	if lastOnline then	
		timeDifference = currentTime - lastOnline
	end

	if not timeDifference or timeDifference >= 24*60*60 then
		
		local streak = dailyRewardInfo[2] or 1
		local reward = rewardsForStreak[streak]
		
		local dailyRewardGui = plr.PlayerGui:WaitForChild("DailyRewardGui")
		local mainGui = dailyRewardGui:WaitForChild("MainGui")
		local claimBtn = mainGui:WaitForChild("ClaimButton")
		local rewardLabel = mainGui:WaitForChild("RewardLabel")
		
		mainGui:TweenPosition(UDim2.new(0.511, 0,0.499, 0),0,0,0.4)
		rewardLabel.Text = reward
		
		dailyRewardGui.Enabled = true
		
		claimBtn.MouseButton1Click:Connect(function()
			
			plr.leaderstats.Cash.Value += reward
			
			dailyRewardGui.Enabled = false
			
			local streak = streak + 1
			if streak > 7 then streak = 1 end
			
			local success, errormsg = pcall(function()
				
				dailyRewardDS:SetAsync(plr.UserId .. "_DR", {os.time(), streak})
			end)
			mainGui:TweenPosition(UDim2.new(0.511, 0,1.299, 0),0,0,0.4)
		end)
		
	elseif timeDifference then
		
		wait((24*60*60) - timeDifference)
		
		if game.Players:FindFirstChild(plr) then
			
			local streak = dailyRewardInfo[2] or 1
			local reward = rewardsForStreak[streak]
			
			local dailyRewardGui = plr.PlayerGui:WaitForChild("DailyRewardGui")
			local mainGui = dailyRewardGui:WaitForChild("MainGui")
			local claimBtn = mainGui:WaitForChild("ClaimButton")
			local rewardLabel = mainGui:WaitForChild("RewardLabel")
			
			mainGui:TweenPosition(UDim2.new(0.511, 0,0.499, 0),0,0,0.4)
			
			rewardLabel.Text = reward
			
			dailyRewardGui.Enabled = true
			
			claimBtn.MouseButton1Click:Connect(function()
				
				plr.leaderstats.Cash.Value += reward
				
				dailyRewardGui.Enabled = false
				
				local streak = streak + 1
				if streak > 7 then streak = 1 end
				
				pcall(function()
					
					dailyRewardDS:SetAsync(plr.UserId .. "_DR", {os.time(), streak})
				end)
				mainGui:TweenPosition(UDim2.new(0.511, 0,1.299, 0))
			end)
		end
	end
end)