local frame = script.Parent.AchiveFrame
local mainbutton = script.Parent.BuildSystemsAndInfo.Achievs
local info = mainbutton.Info
local plr = game.Players.LocalPlayer
local achivefolder
local RS = game.ReplicatedStorage.Events.AchivsEvents
local rewardCopy = script.Parent.Reward
local FormatNumber = require(game.ReplicatedStorage.Modules.FormatNumber)
local formatter = FormatNumber.NumberFormatter.with()
local nowprogc
local nowprogr
local nowproge
local lastchange
local lastrat
local valuetable
local cashachivebool = false
local ratachivebool = false
local expachivebool = false
local deleteToggle = false
local wczytano = false
local canAddCash = true
local expDone = false

local cashEvent
local ratingEvent

local Achive1Event

local Achive2Event

local Achive3Event

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Require audio player module
local AudioPlayer = require(ReplicatedStorage.Modules:WaitForChild("AudioModule"))


-- Set up audio tracks
AudioPlayer.setupAudio({
	["CashUp"] = 6519564325,
	["Click"] = 318763788,
	["Close"] = 1673280232,
})


mainbutton.MouseButton1Click:Connect(function()
	if not plr:FindFirstChild("leaderstats") then
		return
	end
	if deleteToggle and plr:GetAttribute("DoesTutorial")==false then
		AudioPlayer.playAudio("Click")
		info.Visible = false
		frame:TweenPosition(UDim2.new(1.109, 0,0.102, 0),0,0,0.4)
		wait(0.5)
		deleteToggle = false	
	elseif not deleteToggle and plr:GetAttribute("DoesTutorial")==false then
		AudioPlayer.playAudio("Click")
		info.Visible = false
		frame:TweenPosition(UDim2.new(0.709, 0,0.102, 0),0,0,0.4)
		wait(0.5)
		deleteToggle = true	
	end
end)


function wesWstaw(object,text,value)
	object.Info.Text = text
	if object.Name == "Achive1" then
		if value == -1 then
			object.Status.Text = "(/)"
			cashachivebool = false
			object.Collect.AutoButtonColor = false
			object.Collect.BackgroundTransparency = 0.75
			object.Collect.TextTransparency = 0.75
			object.Collect.TextStrokeTransparency = 0.75

			frame.Achive1:SetAttribute("Progress",value)
			return
		end
		object.Status.Text = "("..formatter:Format(nowprogc.Value).."/"..formatter:Format(value)..")"
		if nowprogc.Value >= value then
			cashachivebool = true
			object.Collect.AutoButtonColor = true
			object.Collect.BackgroundTransparency = 0
			object.Collect.TextTransparency = 0
			object.Collect.TextStrokeTransparency = 0
			info.Visible = true
		else
			cashachivebool = false
			object.Collect.AutoButtonColor = false
			object.Collect.BackgroundTransparency = 0.75
			object.Collect.TextTransparency = 0.75
			object.Collect.TextStrokeTransparency = 0.75
		end
		frame.Achive1:SetAttribute("Progress",value)

	elseif object.Name == "Achive2" then
		if value == -1 then
			object.Status.Text = "(/)"
			cashachivebool = false
			object.Collect.AutoButtonColor = false
			object.Collect.BackgroundTransparency = 0.75
			object.Collect.TextTransparency = 0.75
			object.Collect.TextStrokeTransparency = 0.75

			frame.Achive2:SetAttribute("Progress",value)
			return
		end
		
		local wstaw
		
		if plr.leaderstats.Rating.Value >= value then

			wstaw = plr.leaderstats.Rating.Value
			object.Collect.AutoButtonColor = true
			object.Collect.BackgroundTransparency = 0
			object.Collect.TextTransparency = 0
			object.Collect.TextStrokeTransparency = 0
			info.Visible = true
			ratachivebool = true
		else
			wstaw = plr.ProgressFolder.RatProgress.Value
			ratachivebool = false
			object.Collect.AutoButtonColor = false
			object.Collect.BackgroundTransparency = 0.75
			object.Collect.TextTransparency = 0.75
			object.Collect.TextStrokeTransparency = 0.75
		end
		
		object.Status.Text = "("..wstaw.."/"..formatter:Format(value)..")"
		
		frame.Achive2:SetAttribute("Progress",value)

	elseif object.Name == "Achive3" then
		if value == -1 then
			object.Status.Text = "(/)"
			cashachivebool = false
			object.Collect.AutoButtonColor = false
			object.Collect.BackgroundTransparency = 0.75
			object.Collect.TextTransparency = 0.75
			object.Collect.TextStrokeTransparency = 0.75

			frame.Achive3:SetAttribute("Progress",value)
			return
		end
		
		local newvalue = plr.hidden.IleR.Value + plr.hidden.IleC.Value + plr.hidden.IleL.Value - 1
		
		object.Status.Text = "("..newvalue.."/"..formatter:Format(value)..")"
		
		frame.Achive3:SetAttribute("Progress",value)
		
		if newvalue >= value then
			expachivebool = true
			object.Collect.AutoButtonColor = true
			object.Collect.BackgroundTransparency = 0
			object.Collect.TextTransparency = 0
			object.Collect.TextStrokeTransparency = 0
			info.Visible = true
		else
			expachivebool = false
			object.Collect.AutoButtonColor = false
			object.Collect.BackgroundTransparency = 0.75
			object.Collect.TextTransparency = 0.75
			object.Collect.TextStrokeTransparency = 0.75
		end
	end
end

function Zdobyto(object)

end

function ustawienieAll()
	for i,n in pairs(valuetable) do
		if i == 1 then
			local value = valuetable[i]
			if value == 0 then
				wesWstaw(frame.Achive1,"Collect 10,000 Money. Reward 1,000.",10000)
			elseif value == 1 then
				wesWstaw(frame.Achive1,"Collect 25,000 Money. Reward 2,000.",25000)
			elseif value == 2 then
				wesWstaw(frame.Achive1,"Collect 50,000 Money. Reward 3,000.",50000)
			elseif value == 3 then
				wesWstaw(frame.Achive1,"Collect 100,000 Money. Reward 4,000.",100000)
			elseif value == 4 then
				wesWstaw(frame.Achive1,"Collect 250,000 Money. Reward 5,000.",250000)
			elseif value == 5 then
				wesWstaw(frame.Achive1,"Collect 500,000 Money. Reward 7,500.",500000)
			elseif value == 6 then
				wesWstaw(frame.Achive1,"Collect 1,000,000 Money. Reward 10,000.",1000000)
			else
				wesWstaw(frame.Achive1,"You collect 1,000,000 Money! Congrats!",-1)
				pcall(function() 
					cashEvent:Disconnect()
					Achive1Event:Disconnect()
				end)
			end
		elseif i == 2 then
			local value = valuetable[i]
			if value == 0 then
				wesWstaw(frame.Achive2,"Get Rating of 1.0. Reward 1,000 of Money.",1.0)
			elseif value == 1 then
				wesWstaw(frame.Achive2,"Get Rating of 2.0. Reward 2,000 of Money.",2.0)
			elseif value == 2 then
				wesWstaw(frame.Achive2,"Get Rating of 3.0. Reward 3,000 of Money.",3.0)
			elseif value == 3 then
				wesWstaw(frame.Achive2,"Get Rating of 4.0. Reward 4,000 of Money.",4.0)
			elseif value == 4 then
				wesWstaw(frame.Achive2,"Get Rating of 5.0. Reward 5,000 of Money.",5.0)
			else
				wesWstaw(frame.Achive2,"You achived rating of 5,0. Congrats!.",-1)
				pcall(function() 
					ratingEvent:Disconnect()
					Achive2Event:Disconnect()
				end)
			end
		elseif i == 3 then
			local value = valuetable[i]
			if value < 8  then
				wesWstaw(frame.Achive3,"Get next plot expansion.",achivefolder.ExLvl.Value + 1)
			elseif value >= 8 and achivefolder.ExLvl.Value == 8 then
				expDone = true
				wesWstaw(frame.Achive3,"You fully expanded your plot. Congrats!.",-1)
				Achive3Event:Disconnect()
			end
		end		
	end
end

game.ReplicatedStorage.Events.AchivsEvents.DobraWczytaj.OnClientEvent:Connect(function()
	achivefolder = plr:WaitForChild("AchiveFolder")
	wait(0.1)
	nowprogc = plr.ProgressFolder.CashProgress
	local cashvalue = frame.Achive1:GetAttribute("Progress")

	if nowprogc.Value >= cashvalue then
		cashachivebool = true
		frame.Achive1.Collect.AutoButtonColor = true
		frame.Achive1.Collect.BackgroundTransparency = 0
		frame.Achive1.Collect.TextTransparency = 0
		frame.Achive1.Collect.TextStrokeTransparency = 0
		info.Visible = true
	end
	nowprogr = plr.ProgressFolder.RatProgress
	nowproge = plr.ProgressFolder.ExProgress
	lastchange = plr.leaderstats.Cash.Value
	lastrat = plr.leaderstats.Rating.Value
	valuetable = {achivefolder.CashLvl.Value,achivefolder.RatLvl.Value,achivefolder.ExLvl.Value}
	wczytano = true
	ustawienieAll()
	setEvents()
end)


function CashChanged(newvalue)
	if wczytano and canAddCash then
		local cashvalue = frame.Achive1:GetAttribute("Progress")
		if newvalue > lastchange then
			nowprogc.Value += newvalue - lastchange
			RS.WklejMiValue:FireServer(nowprogc,nowprogc.Value)
			frame.Achive1.Status.Text = "("..formatter:Format(nowprogc.Value).."/"..formatter:Format(cashvalue)..")"
		end
		if nowprogc.Value >= cashvalue then
			cashachivebool = true
			frame.Achive1.Collect.AutoButtonColor = true
			frame.Achive1.Collect.BackgroundTransparency = 0
			frame.Achive1.Collect.TextTransparency = 0
			frame.Achive1.Collect.TextStrokeTransparency = 0
			info.Visible = true
		end
		lastchange = newvalue
	end
end

function RatingChanged(newvalue)
	if wczytano then
		local ratvalue = frame.Achive2:GetAttribute("Progress")
		if newvalue > lastrat then
			nowprogr.Value = newvalue
			RS.WklejMiValue:FireServer(nowprogr,nowprogr.Value)
			frame.Achive2.Status.Text = "("..formatter:Format(newvalue).."/"..formatter:Format(ratvalue)..")"
		end
		if newvalue >= ratvalue then
			ratachivebool = true
			frame.Achive2.Collect.AutoButtonColor = true
			frame.Achive2.Collect.BackgroundTransparency = 0
			frame.Achive2.Collect.TextTransparency = 0
			frame.Achive2.Collect.TextStrokeTransparency = 0
			info.Visible = true
		end
		lastrat = newvalue
	end
end

function ExpandChanged()
	local newvalue = plr.hidden.IleR.Value + plr.hidden.IleC.Value + plr.hidden.IleL.Value - 1
	if wczytano and newvalue < 9 then
		if newvalue >= achivefolder.ExLvl.Value + 1 then
			frame.Achive3.Status.Text = "("..newvalue.."/"..(achivefolder.ExLvl.Value + 1)..")"
			expachivebool = true
			frame.Achive3.Collect.AutoButtonColor = true
			frame.Achive3.Collect.BackgroundTransparency = 0
			frame.Achive3.Collect.TextTransparency = 0
			frame.Achive3.Collect.TextStrokeTransparency = 0
			info.Visible = true
		end
	end
end

Achive1Event = frame.Achive1.Collect.MouseButton1Click:Connect(function()
	if cashachivebool == true then
		cashachivebool = false
		canAddCash = false
		
		frame.Achive1.Collect.AutoButtonColor = false
		frame.Achive1.Collect.BackgroundTransparency = 0.75
		frame.Achive1.Collect.TextTransparency = 0.75
		frame.Achive1.Collect.TextStrokeTransparency = 0.75
		
		local reward = rewardCopy:Clone()
		reward.Parent = rewardCopy.Parent 

		local importantthing = frame.Achive1:GetAttribute("Progress")

		AudioPlayer.playAudio("CashUp")
		if achivefolder.CashLvl.Value + 1 == 1 then
			RS.WklejMiValue:FireServer(achivefolder.CashLvl,achivefolder.CashLvl.Value + 1)

			reward.Position = UDim2.new(0.918, 0,0.158, 0)
			reward.Text = "+1,000"
			reward.Visible = true
			--wait(0.8)
			reward:TweenPosition(UDim2.new(0.064, 0,0.471, 0),0,0,1)
			--wait(0.6)
			nowprogc.Value = nowprogc.Value - importantthing

			RS.WklejMiValue:FireServer(nowprogc,nowprogc.Value)
			
			RS.DajMiHajs:FireServer(achivefolder.CashLvl)

			for i=0,25 do
				task.wait(0.05)
				reward.TextTransparency += 0.1
			end

			lastchange = plr.leaderstats.Cash.Value

			reward.Visible = false
			reward.TextStrokeTransparency = 0

			wesWstaw(frame.Achive1,"Collect 25,000 Money. Reward 2,000.",25000)
		elseif achivefolder.CashLvl.Value + 1 == 2 then
			RS.WklejMiValue:FireServer(achivefolder.CashLvl,achivefolder.CashLvl.Value+1)
			reward.Position = UDim2.new(0.918, 0,0.158, 0)
			reward.Text = "+2,000"
			reward.Visible = true
			--wait(0.8)
			reward:TweenPosition(UDim2.new(0.064, 0,0.471, 0),0,0,1)

			nowprogc.Value = nowprogc.Value - importantthing

			RS.WklejMiValue:FireServer(nowprogc,nowprogc.Value)


			--wait(0.6)
			RS.DajMiHajs:FireServer(achivefolder.CashLvl)

			for i=0,25 do
				task.wait(0.05)
				reward.TextTransparency += 0.1
			end
	
			
			lastchange = plr.leaderstats.Cash.Value

			reward.Visible = false
			reward.TextStrokeTransparency = 0
			wesWstaw(frame.Achive1,"Collect 50,000 Money. Reward 3,000.",50000)
		elseif achivefolder.CashLvl.Value + 1 == 3 then
			RS.WklejMiValue:FireServer(achivefolder.CashLvl,achivefolder.CashLvl.Value+1)
			reward.Position = UDim2.new(0.918, 0,0.158, 0)
			reward.Text = "+3,000"
			reward.Visible = true
			--wait(0.8)
			reward:TweenPosition(UDim2.new(0.064, 0,0.471, 0),0,0,1)

			nowprogc.Value = nowprogc.Value - importantthing
			RS.WklejMiValue:FireServer(nowprogc,nowprogc.Value)
			--wait(0.6)


			RS.DajMiHajs:FireServer(achivefolder.CashLvl)

			for i=0,25 do
				task.wait(0.05)
				reward.TextTransparency += 0.1
			end
			


			lastchange = plr.leaderstats.Cash.Value

			reward.Visible = false
			reward.TextStrokeTransparency = 0
			
			wesWstaw(frame.Achive1,"Collect 100,000 Money. Reward 4,000.",100000)
		elseif achivefolder.CashLvl.Value + 1 == 4 then
			RS.WklejMiValue:FireServer(achivefolder.CashLvl,achivefolder.CashLvl.Value+1)
			reward.Position = UDim2.new(0.918, 0,0.158, 0)
			reward.Text = "+4,000"
			reward.Visible = true
			--wait(0.8)
			reward:TweenPosition(UDim2.new(0.064, 0,0.471, 0),0,0,1)
			--wait(0.6)
			nowprogc.Value = nowprogc.Value - importantthing
			RS.WklejMiValue:FireServer(nowprogc,nowprogc.Value)


			RS.DajMiHajs:FireServer(achivefolder.CashLvl)

			for i=0,25 do
				task.wait(0.05)
				reward.TextTransparency += 0.1
			end

			lastchange = plr.leaderstats.Cash.Value

			reward.Visible = false
			reward.TextStrokeTransparency = 0
			wesWstaw(frame.Achive1,"Collect 250,000 Money. Reward 5,000.",250000)
		elseif achivefolder.CashLvl.Value + 1 == 5 then
			RS.WklejMiValue:FireServer(achivefolder.CashLvl,achivefolder.CashLvl.Value+1)
			reward.Position = UDim2.new(0.918, 0,0.158, 0)
			reward.Text = "+5,000"
			reward.Visible = true
			--wait(0.8)
			reward:TweenPosition(UDim2.new(0.064, 0,0.471, 0),0,0,1)

			nowprogc.Value = nowprogc.Value - importantthing
			RS.WklejMiValue:FireServer(nowprogc,nowprogc.Value)
			--wait(0.6)


			RS.DajMiHajs:FireServer(achivefolder.CashLvl)

			for i=0,25 do
				task.wait(0.05)
				reward.TextTransparency += 0.1
			end



			lastchange = plr.leaderstats.Cash.Value

			reward.Visible = false
			reward.TextStrokeTransparency = 0

			wesWstaw(frame.Achive1,"Collect 500,000 Money. Reward 7,500.",500000)

		elseif achivefolder.CashLvl.Value + 1 == 6 then
			RS.WklejMiValue:FireServer(achivefolder.CashLvl,achivefolder.CashLvl.Value+1)
			reward.Position = UDim2.new(0.918, 0,0.158, 0)
			reward.Text = "+7,500"
			reward.Visible = true
			--wait(0.8)
			reward:TweenPosition(UDim2.new(0.064, 0,0.471, 0),0,0,1)

			nowprogc.Value = nowprogc.Value - importantthing
			RS.WklejMiValue:FireServer(nowprogc,nowprogc.Value)
			--wait(0.6)


			RS.DajMiHajs:FireServer(achivefolder.CashLvl)

			for i=0,25 do
				task.wait(0.05)
				reward.TextTransparency += 0.1
			end

			lastchange = plr.leaderstats.Cash.Value

			reward.Visible = false
			reward.TextStrokeTransparency = 0
			wesWstaw(frame.Achive1,"Collect 1,000,000 Money. Reward 10,000.",1000000)
		else
			RS.WklejMiValue:FireServer(achivefolder.CashLvl,achivefolder.CashLvl.Value + 1)

			cashEvent:Disconnect()
			Achive1Event:Disconnect()

			reward.Position = UDim2.new(0.918, 0,0.158, 0)
			reward.Text = "+10,000"
			reward.Visible = true
			--wait(0.8)
			reward:TweenPosition(UDim2.new(0.064, 0,0.471, 0),0,0,1)
			--wait(0.6)
			nowprogc.Value = nowprogc.Value - importantthing

			RS.WklejMiValue:FireServer(nowprogc,nowprogc.Value)

			RS.DajMiHajs:FireServer(achivefolder.CashLvl)

			for i=0,25 do
				task.wait(0.05)
				reward.TextTransparency += 0.1
			end


			lastchange = plr.leaderstats.Cash.Value

			reward.Visible = false
			reward.TextStrokeTransparency = 0
			
			wesWstaw(frame.Achive1,"You collect 1,000,000 Money! Congrats!",-1)
		end
		reward:Destroy()
		canAddCash = true	
	end
end)

Achive2Event = frame.Achive2.Collect.MouseButton1Click:Connect(function()

	if ratachivebool == true then
		ratachivebool = false
		canAddCash = false
		
		frame.Achive2.Collect.AutoButtonColor = false
		frame.Achive2.Collect.BackgroundTransparency = 0.75
		frame.Achive2.Collect.TextTransparency = 0.75
		frame.Achive2.Collect.TextStrokeTransparency = 0.75
		
		local reward = rewardCopy:Clone()
		reward.Parent = rewardCopy.Parent 

		local importantthing = frame.Achive2:GetAttribute("Progress")
		AudioPlayer.playAudio("CashUp")
		if achivefolder.RatLvl.Value + 1 == 1 then


			RS.WklejMiValue:FireServer(achivefolder.RatLvl,achivefolder.RatLvl.Value+1)

			reward.Position = UDim2.new(0.918, 0,0.22, 0)
			reward.TextTransparency = 0
			reward.Text = "+1,000"
			reward.Visible = true

			reward:TweenPosition(UDim2.new(0.064, 0,0.471, 0),0,0,1)

			RS.DajMiHajs:FireServer(achivefolder.RatLvl)
			for i=0,25 do
				wait(0.05)
				reward.TextTransparency += 0.1
			end			
			wesWstaw(frame.Achive2,"Get Rating of 2.0. Reward 2,000 of Money.",2.0)
		elseif achivefolder.RatLvl.Value + 1 == 2 then

			RS.WklejMiValue:FireServer(achivefolder.RatLvl,achivefolder.RatLvl.Value+1)

			reward.Position = UDim2.new(0.918, 0,0.22, 0)
			reward.TextTransparency = 0
			reward.Text = "+2,000"
			reward.Visible = true

			reward:TweenPosition(UDim2.new(0.064, 0,0.471, 0),0,0,1)

			RS.DajMiHajs:FireServer(achivefolder.RatLvl)
			for i=0,25 do
				wait(0.05)
				reward.TextTransparency += 0.1
			end
			wesWstaw(frame.Achive2,"Get Rating of 3.0. Reward 3,000 of Money.",3.0)
		elseif achivefolder.RatLvl.Value + 1 == 3 then

			RS.WklejMiValue:FireServer(achivefolder.RatLvl,achivefolder.RatLvl.Value+1)

			reward.Position = UDim2.new(0.918, 0,0.22, 0)
			reward.TextTransparency = 0
			reward.Text = "+3,000"
			reward.Visible = true

			reward:TweenPosition(UDim2.new(0.064, 0,0.471, 0),0,0,1)

			RS.DajMiHajs:FireServer(achivefolder.RatLvl)
			for i=0,25 do
				wait(0.05)
				reward.TextTransparency += 0.1
			end
			wesWstaw(frame.Achive2,"Get Rating of 4.0. Reward 4,000 of Money.",4.0)
		elseif achivefolder.RatLvl.Value + 1 == 4 then

			RS.WklejMiValue:FireServer(achivefolder.RatLvl,achivefolder.RatLvl.Value+1)

			reward.Position = UDim2.new(0.918, 0,0.22, 0)
			reward.TextTransparency = 0
			reward.Text = "+4,000"
			reward.Visible = true

			reward:TweenPosition(UDim2.new(0.064, 0,0.471, 0),0,0,1)

			RS.DajMiHajs:FireServer(achivefolder.RatLvl)
			for i=0,25 do
				wait(0.05)
				reward.TextTransparency += 0.1
			end
			wesWstaw(frame.Achive2,"Get Rating of 5.0. Reward 5,000 of Money.",5.0)
		else


			RS.WklejMiValue:FireServer(achivefolder.RatLvl,achivefolder.RatLvl.Value+1)
			
			ratingEvent:Disconnect()
			Achive2Event:Disconnect()

			reward.Position = UDim2.new(0.918, 0,0.22, 0)
			reward.TextTransparency = 0
			reward.Text = "+5,000"
			reward.Visible = true

			reward:TweenPosition(UDim2.new(0.064, 0,0.471, 0),0,0,1)

			RS.DajMiHajs:FireServer(achivefolder.RatLvl)
			for i=0,25 do
				wait(0.05)
				reward.TextTransparency += 0.1
			end			
			wesWstaw(frame.Achive2,"You achived rating of 5,0. Congrats!.",-1)
		end
		reward:Destroy()
		wait()
		canAddCash = true
	end
end)

Achive3Event = frame.Achive3.Collect.MouseButton1Click:Connect(function()
	if expachivebool == true and not expDone then
		expachivebool = false
		canAddCash = false
		
		frame.Achive3.Collect.AutoButtonColor = false
		frame.Achive3.Collect.BackgroundTransparency = 0.75
		frame.Achive3.Collect.TextTransparency = 0.75
		frame.Achive3.Collect.TextStrokeTransparency = 0.75
		
		local importantthing = frame.Achive3:GetAttribute("Progress")
		AudioPlayer.playAudio("CashUp")
		
		local reward = rewardCopy:Clone()
		reward.Parent = rewardCopy.Parent 
		--local newvalue = plr.hidden.IleR.Value + plr.hidden.IleC.Value + plr.hidden.IleL.Value
		--nowproge.Value = newvalue
		reward.Position = UDim2.new(0.918, 0,0.22, 0)
		reward.TextTransparency = 0
		reward.Text = "+1,000"
		reward.Visible = true
		
		reward:TweenPosition(UDim2.new(0.064, 0,0.471, 0),0,0,1)
		
		RS.DajMiHajs:FireServer(achivefolder.ExLvl)
		for i=0,25 do
			wait(0.05)
			reward.TextTransparency += 0.1
		end
		
		if achivefolder.ExLvl.Value + 1 == 8 then
			expDone = true
			wesWstaw(frame.Achive3,"You fully expanded your plot. Congrats!.",-1)	
		else
			wesWstaw(frame.Achive3,"Get next plot expansion",achivefolder.ExLvl.Value + 2)
		end

		RS.WklejMiValue:FireServer(achivefolder.ExLvl,achivefolder.ExLvl.Value + 1)
		
		wait()
		reward:Destroy()
		canAddCash = true
	end
end)

game.ReplicatedStorage.Events.RESETGUI.OnClientEvent:Connect(function()
	frame:TweenPosition(UDim2.new(1.109, 0,0.102, 0),0,0,0.5)
	if mainbutton then
		if mainbutton:FindFirstChild('TextLabel') then
			mainbutton.TextLabel.Text = "Achievments"
		end
	end
	wait(0.5)
	deleteToggle = false
	info.Visible = false
end)

function setEvents()
	task.wait(0.05)
	pcall(function()
		cashEvent:Disconnect()
		ratingEvent:Disconnect()
	end)

	cashEvent = plr:WaitForChild('leaderstats'):WaitForChild('Cash').Changed:Connect(CashChanged)
	ratingEvent = plr.leaderstats:WaitForChild('Rating').Changed:Connect(RatingChanged)
end



game.ReplicatedStorage.Events.AchivsEvents.ExpansionAdded.OnClientEvent:Connect(ExpandChanged)