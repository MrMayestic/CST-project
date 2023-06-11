local startCounter = script.startCounter

function Format(Int)
	return string.format("%02i", Int)
end

function convertToHMS(Seconds)
	local Minutes = (Seconds - Seconds%60)/60
	Seconds = Seconds - Minutes*60
	local Hours = (Minutes - Minutes%60)/60
	Minutes = Minutes - Hours*60
	local stringToReturn

	if Hours > 0 then
		stringToReturn = Format(Hours)..":"..Format(Minutes)..":"..Format(Seconds)
	else
		stringToReturn = Format(Minutes)..":"..Format(Seconds)
	end

	return stringToReturn
end

local function checkforPlrAttr(plr,isNullering)
	if not plr then
		return false
	end

	if not game.Players:FindFirstChild(plr.Name) then
		return false
	end

	if plr:GetAttribute("counterAbort") then
		if isNullering then
			plr:SetAttribute("counterAbort",false)
		end
		task.wait()
		return false
	end

	if not plr:FindFirstChild("RBFolder") then
		return false
	else
		if not plr.RBFolder:FindFirstChild("boostPerc") or not plr.RBFolder:FindFirstChild("boostTimeLeft") then
			return false
		end
	end
	return true
end

local function counter(plr,perc,boostTime,resume)

	if plr.RBFolder.boostTimeLeft.Value > 0 and not resume then
		plr:SetAttribute("counterAbort",true)
		while plr:GetAttribute("counterAbort") == true do
			wait()
		end
		task.wait()
	end

	local RBFolder = plr:WaitForChild("RBFolder")
	local endTime
	local boostInfo = plr.PlayerGui.BuildUI.BoostInfo

	if (plr.RBFolder.boostTimeLeft.Value >= 0 and not resume) then
		endTime = plr.RBFolder.boostTimeLeft.Value + (boostTime * 60)
		RBFolder.boostPerc.Value += perc
		boostInfo.boostPerc.Text = RBFolder.boostPerc.Value.."%"
		boostInfo.boostPerc.TextColor3 = Color3.new(0,170/255,0)
		boostInfo.HideShow.BackgroundColor3 = Color3.new(0,170/255,0)
	elseif (plr.RBFolder.boostTimeLeft.Value > 0 and resume) then
		endTime = plr.RBFolder.boostTimeLeft.Value
		boostInfo.boostPerc.Text = RBFolder.boostPerc.Value.."%"
		boostInfo.boostPerc.TextColor3 = Color3.new(0,170/255,0)
		boostInfo.HideShow.BackgroundColor3 = Color3.new(0,170/255,0)
	end

	local counter = 0

	local success, err = pcall(function()
		if(plr.RBFolder.boostTimeLeft.Value > 0 and resume) or (plr.RBFolder.boostTimeLeft.Value >= 0 and not resume) then
			repeat
				counter += wait(1)
				RBFolder.boostTimeLeft.Value = endTime - counter
				boostInfo.boostTimeLeft.Text = convertToHMS(math.round(RBFolder.boostTimeLeft.Value))
			until math.floor(counter) >= endTime or not checkforPlrAttr(plr)
		end
	end)
	
	task.wait()
	
	if checkforPlrAttr(plr,true) then
		plr.RBFolder.boostPerc.Value = 0
		plr.RBFolder.boostTimeLeft.Value = 0
		boostInfo.boostPerc.Text = RBFolder.boostPerc.Value.."%"
		boostInfo.boostPerc.TextColor3 = Color3.new(170/255,0,0)
		boostInfo.HideShow.BackgroundColor3 = Color3.new(1,1,1)
		boostInfo.boostTimeLeft.Text = convertToHMS(math.round(RBFolder.boostTimeLeft.Value))
	end
end

game.ReplicatedStorage.Events.RBEvents.resumeCounter.Event:Connect(function(plr)
	counter(plr,plr.RBFolder.boostPerc.Value,plr.RBFolder.boostTimeLeft.Value,true)
end)

startCounter.Event:Connect(counter)