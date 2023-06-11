local BadgeService = game:GetService("BadgeService")

local function awardBadge(player, badgeId)
	-- Fetch Badge information
	local success, badgeInfo = pcall(BadgeService.GetBadgeInfoAsync, BadgeService, badgeId)
	if success then
		-- Confirm that badge can be awarded
		if badgeInfo.IsEnabled then
			-- Award badge
			local awarded, errorMessage = pcall(BadgeService.AwardBadge, BadgeService, player.UserId, badgeId)
			if not awarded then
				warn("Error while awarding Badge:", errorMessage)
			end
		end
	else
		warn("Error while fetching Badge info!")
	end
end

game.ReplicatedStorage.Events.BadgesEvents.awardBadge.Event:Connect(awardBadge)