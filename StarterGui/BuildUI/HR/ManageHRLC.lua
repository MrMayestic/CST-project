local frameHR = script.Parent
local payment = script.Parent.Payment
local cashiers = frameHR.Cashiers
local storemen = frameHR.Storemen
local plr = game.Players.LocalPlayer
local getPlot = game.ReplicatedStorage.Remotes.requestPlot
local plot = getPlot:InvokeServer()
local Events = game.ReplicatedStorage.Events
local Remotes = game.ReplicatedStorage.Remotes
local maxCashiers,maxStoremen = 0,0
local currentCashiers,currentStoremen = 0,0
local HRbutton = frameHR.Parent.BuildSystemsAndInfo.HRButton
local AudioPlayer = require(game.ReplicatedStorage.Modules:WaitForChild("AudioModule"))
local close = frameHR.Close
local count = game.ReplicatedStorage.Remotes.HR.countPOBJ

local function giveSum()
	return currentCashiers + currentStoremen
end

HRbutton.MouseButton1Click:Connect(function()
	if not plr:FindFirstChild("leaderstats") then
		return
	end
	AudioPlayer.playAudio("Click")
	HRbutton.Visible = false
	frameHR:TweenPosition(UDim2.new(0.297, 0,0.278, 0),0,0,0.4)
	wait(0.55)
	close.Visible = true	
end)

close.MouseButton1Click:Connect(function()
	AudioPlayer.playAudio("Click")
	close.Visible = false
	frameHR:TweenPosition(UDim2.new(0.297, 0,1.078, 0),0,0,0.4)
	wait(0.55)
	HRbutton.Visible = true
end)

cashiers.PLUS.MouseButton1Click:Connect(function()
	if currentCashiers + 1 <= maxCashiers and currentCashiers + 1 <= 20 then
		currentCashiers += 1
		task.wait()
		cashiers.Current.Text = currentCashiers
		game.ReplicatedStorage.Events.Other.HRChanged:FireServer()
		payment.Text = tostring(giveSum()*10)
	end
end)

cashiers.MINUS.MouseButton1Click:Connect(function()
	if currentCashiers - 1 >= 0 then
		currentCashiers -= 1
		task.wait()
		cashiers.Current.Text = currentCashiers
		game.ReplicatedStorage.Events.Other.HRChanged:FireServer()
		payment.Text = tostring(giveSum()*10)
	end
end)
----------------
storemen.PLUS.MouseButton1Click:Connect(function()
	if currentStoremen + 1 <= maxStoremen and currentStoremen + 1 <= 30 then
		currentStoremen += 1
		task.wait()
		storemen.Current.Text = currentStoremen
		game.ReplicatedStorage.Events.Other.HRChanged:FireServer()
		payment.Text = tostring(giveSum()*10)
	end
end)

storemen.MINUS.MouseButton1Click:Connect(function()
	if currentStoremen - 1 >= 0 then
		currentStoremen -= 1
		task.wait()
		storemen.Current.Text = currentStoremen
		game.ReplicatedStorage.Events.Other.HRChanged:FireServer()
		payment.Text = tostring(giveSum()*10)
	end
end)

---------------------------------------------------------------------------------------

local addEvent, removeEvent
local plrRemoving = false

Events.Other.setHR.OnClientEvent:Connect(function()
	local storageCounter,CRCounter = 0,0

	for i,n in pairs(plot.PlacedObjects:GetChildren()) do
		if n.Name == "Storage" then
			storageCounter += 1
		end
		if n.Name == "CashReg" or n.Name == "CashRegType2" then
			CRCounter += 1
		end
	end
	
	if CRCounter > 20 then
		CRCounter = 20
	end
	
	if storageCounter > 30 then
		storageCounter = 30
	end

	maxStoremen = storageCounter * 3
	maxCashiers = CRCounter
	storemen.Max.Text = maxStoremen
	cashiers.Max.Text = maxCashiers

	currentStoremen = plr:WaitForChild("HRFolder").storagemenValue.Value
	storemen.Current.Text = currentStoremen

	currentCashiers = plr:WaitForChild("HRFolder").cashiersValue.Value
	cashiers.Current.Text = currentCashiers
	
	payment.Text = tostring(giveSum()*10)
	
	addEvent = plot.PlacedObjects.ChildAdded:Connect(function(obj)
		local countedSM, countedCS = count:InvokeServer()
		
		if countedCS > 20 then
			countedCS = 20
		end

		if countedSM > 30 then
			countedSM = 30
		end


		maxStoremen = countedSM * 3
		maxCashiers = countedCS

		storemen.Max.Text = maxStoremen
		cashiers.Max.Text = maxCashiers
	end)

	removeEvent = plot.PlacedObjects.ChildRemoved:Connect(function(obj)
		task.wait(0.15)
		if plrRemoving then
			return
		end
		local countedSM, countedCS = count:InvokeServer()
		
		if countedCS > 20 then
			countedCS = 20
		end

		if countedSM > 30 then
			countedSM = 30
		end

		maxStoremen = countedSM * 3
		maxCashiers = countedCS

		storemen.Max.Text = maxStoremen
		cashiers.Max.Text = maxCashiers
		if currentStoremen > maxStoremen then
			currentStoremen = maxStoremen
			storemen.Current.Text = currentStoremen
		end
		if currentCashiers > maxCashiers then
			currentCashiers = maxCashiers
			cashiers.Current.Text = currentCashiers
		end
		game.ReplicatedStorage.Events.Other.HRChanged:FireServer()
		payment.Text = tostring(giveSum()*10)
	end)
end)

function returnCurrentValues()
	task.wait()
	Events.Other.HRcurrentsRes:FireServer(currentCashiers,currentStoremen)
end

function unsetHR()
	addEvent:Disconnect()
	removeEvent:Disconnect()
	currentStoremen = 0
	currentCashiers = 0
	cashiers.Current.Text = currentCashiers
	storemen.Current.Text = currentStoremen
	payment.Text = tostring(giveSum()*10)
end

Events.Other.HRcurrentsReq.OnClientEvent:Connect(returnCurrentValues)
Events.Other.unsetHR.Event:Connect(unsetHR)

game.ReplicatedStorage.Events.RESETGUI.OnClientEvent:Connect(function()
	close.Visible = false
	frameHR:TweenPosition(UDim2.new(0.297, 0,1.078, 0),0,0,0.4)
	wait(0.2)
	HRbutton.Visible = true
end)

game.Players.PlayerRemoving:Connect(function(removedPlr)
	if removedPlr == plr then
		plrRemoving = true
		unsetHR()
	end
end)