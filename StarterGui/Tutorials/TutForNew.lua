local gui = script.Parent
local BuildUI = gui.Parent:WaitForChild("BuildUI")
local arrow = gui.Arrow
local startframe = gui.TutorialFrame
local plr = game.Players.LocalPlayer
local ktorytut = 1
local mudzin = false
local lable = gui.InfoFrame.Label
local nextarrow = gui.InfoArrow
local nextbutton = gui.NextButton
local toogle = true
local isOn = false

local mainTutorialSteps = {
	[1] = {
		["arrowPos"] = UDim2.new(0.128, 0,0.074, 0),
		["rotation"] = -90,
		["labelText"] = 'First you have to buy and place furniture, let'.."'"..'s place a Display Table and try to place some products on it and earn on it! Now click on the "Build" button to open the shop!',
		["somethingEvent"] = BuildUI.BuildSystemsAndInfo.Shop.MouseButton1Click,
		["func"] = function()
			ktorytut +=1
			obsluga()
		end,
	},
	[2] = {
		["IneedHigherLabel"] = true,
		["arrowPos"] = UDim2.new(0.051, 0,0.902, 0),
		["rotation"] = 0,
		["labelText"] = 'Ok, now select Display Table as the furniture to place.',
		["somethingEvent"] = BuildUI.ShopFrame.ForProductsFrame.DisplayTable.MouseButton1Click,
		["func"] = function()
			ktorytut +=1
			obsluga()
		end,
		["individualFunc"] = function()
			BuildUI.ShopFrame.WallsFrame.Visible = false
			BuildUI.ShopFrame.ForProductsFrame.Visible = true
		end,
	},
	[3] = {
		["labelText"] = 'Now you must place this furniture. If you are on computer, click the "F" button. If you are on mobile device press the "Place" button. Other options are (on mobile buttons are on screen): "R" rotate, "U" up, "L" down, "X" cancel. (One note: lines on the edges of the furniture are only collision info and it only tells you if furnitue is on the verge of another furniture or is is colliding.) Make sure you enough space for customers.',
		["somethingEvent"] = game.ReplicatedStorage.Events.JestEKlkiniete.OnClientEvent,
		["func"] = function()
			ktorytut +=1
			obsluga()
		end,
	},
	[4] = {
		["arrowPos"] = UDim2.new(0.313, 0,0.083, 0),
		["rotation"] = -90,
		["labelText"] = 'Congratulations! You have placed the furniture! Now close the Shop and let'.."'"..'s make some money from it! Click on the "Magazine" button, if you want to buy some products.',
		["somethingEvent"] = BuildUI.BuildSystemsAndInfo.MagazineButton.MouseButton1Click,
		["func"] = function()
			ktorytut +=1
			obsluga()
		end,
	},
	[5] = {
		["arrowPos"] = UDim2.new(0.542, 0,0.394, 0),
		["rotation"] = 180,
		["labelText"] = 'Ok, so now choose how many products (we will pick some phones) you want to buy. Just click on the "+" until the number above "+" is e.g. 6.',
		["somethingEvent"] = BuildUI.AddTowarFrame.telefony.Ile.Changed,
		["func"] = function(NewValue)
			if NewValue >= 6 then
				ktorytut +=1
				obsluga()
			end
		end,
	},
	[6] = {
		["arrowPos"] = UDim2.new(0.638, 0,0.142, 0),
		["rotation"] = 180,
		["labelText"] = 'Ok! Now click the "BUY" button to purchse and send products to your magazine.',
		["somethingEvent"] = BuildUI.InfoFrame.SetButton.MouseButton1Click,
		["func"] = function()
			game.ReplicatedStorage.Events.TowarEvents.Close:FireServer()
			ktorytut +=1
			obsluga()
		end,
	},
	[7] = {
		["arrowPos"] = UDim2.new(0.173, 0,0.076, 0),
		["rotation"] = -90,
		["labelText"] = 'Right! Now turn on Manage System to add some products to the placed furniture.',
		["somethingEvent"] = BuildUI.BuildSystemsAndInfo.Manage.MouseButton1Click,
		["func"] = function()
			ktorytut +=1
			obsluga()
		end,
	},
	[8] = {
		["arrowPos"] = UDim2.new(0.308, 0,0.067, 0),
		["rotation"] = 180,
		["labelText"] = 'Now click on your placed furniture.',
		["somethingEvent"] = game.ReplicatedStorage.Events.JestManageKlikniete.OnClientEvent,
		["func"] = function()
			ktorytut +=1
			local model = gui.Model.Value
			local tutgui = model.TutorialGui
			tutgui.Enabled = false
			obsluga()

		end,
		["individualFunc"] = function()
			local model = gui.Model.Value
			local tutgui = model.TutorialGui
			tutgui.Enabled = true
		end,
	},
	[9] = {
		["arrowPos"] = UDim2.new(0.554, 0,0.423, 0),
		["rotation"] = 180,
		["labelText"] = 'You will now see a frame with products for this furniture. Click on "Phones" to set phones as products for this furniture.',
		["somethingEvent"] = BuildUI.DisplayTableFrame.telefony.MouseButton1Click,
		["func"] = function()
			ktorytut +=1
			game.ReplicatedStorage.Events.MagazynEvents.Close:FireServer()
			game.ReplicatedStorage.Events.ManageClose:FireServer()
			obsluga()
		end,
	},
	[10] = {
		["IneedHigherLabel"] = true,
		["arrowPos"] = UDim2.new(0.122, 0,0.903, 0),
		["rotation"] = 180,
		["labelText"] = 'Now select Cash Register as the furniture to place.',
		["somethingEvent"] = BuildUI.ShopFrame.CashRegistersFrame.CashReg.MouseButton1Click,
		["func"] = function()
			ktorytut +=1
			obsluga()
		end,
		["individualFunc"] = function()
			BuildUI.ShopFrame.Visible = true
			BuildUI.ShopFrame.ForProductsFrame.Visible = false
			BuildUI.ShopFrame.WallsFrame.Visible = false
			BuildUI.ShopFrame.CashRegistersFrame.Visible = true
		end,
	},
	[11] = {
		["labelText"] = 'Now place this furniture. If you are using PC/Desktop, simply type "F" on your keyboard. If you are on mobile, press the "Place" button on your screen. Make sure the customer has enough space.',
		["somethingEvent"] = game.ReplicatedStorage.Events.JestEKlkiniete.OnClientEvent,
		["func"] = function()
			ktorytut +=1
			obsluga()
		end,
	},
	[12] = {
		["arrowPos"] = UDim2.new(0.71, 0,0.08, 0),
		["rotation"] = -90,
		["labelText"] = 'You will need to hire a cashier to make sure everything is ready for sale. Click here to continue.',
		["somethingEvent"] = BuildUI.BuildSystemsAndInfo.HRButton.MouseButton1Click,
		["func"] = function()
			ktorytut +=1
			obsluga()
		end,
	},
	[13] = {
		["arrowPos"] = UDim2.new(0.456, 0,0.53, 0),
		["rotation"] = 180,
		["labelText"] = 'Click here to hire a new cashier.',
		["somethingEvent"] = BuildUI.ManageHR.Cashiers.PLUS.MouseButton1Click,
		["func"] = function()
			ktorytut +=1
			obsluga()
		end,
	},
	[14] = {
		["arrowPos"] = UDim2.new(0.723, 0,0.212, 0),
		["rotation"] = 180,
		["labelText"] = 'Now close this frame.',
		["somethingEvent"] = BuildUI.ManageHR.Close.MouseButton1Click,
		["func"] = function()
			game.ReplicatedStorage.Events.RESETGUI:FireServer()
			BuildUI.ResetMenu.Visible = true
			BuildUI.Parent.Samouczek.TutorialStart.Visible = true
			ktorytut +=1
			obsluga()
		end,
	},
	[15] = {
		["arrowPos"] = UDim2.new(0.266, 0,0.076, 0),
		["rotation"] = -90,
		["labelText"] = 'Great! Now open the shop for customers to earn money. Click on the "Open" button to open your shop.',
		["somethingEvent"] = BuildUI.BuildSystemsAndInfo.OpenClose.MouseButton1Click,
		["somethingEvent2"] = game.ReplicatedStorage.Events.OpenCloseNow.OnClientEvent,
		["func"] = function()
			ktorytut +=1
			obsluga()
		end,
	},
	[16] = {
		["labelText"] = 'Now your shop is opened. Customers will enter the shop, walk over to our display table, pick up some phones, walk over to the till, pay for those phones and then leave the shop. Click "Next" if you want to continue.',
	},
	[17] = {
		["labelText"] = 'I will now explain the other buttons you will see on your GUI. Click on the "Next" button to continue.',
	},
	[18] = {
		["arrowPos"] = UDim2.new(0.219, 0,0.084, 0),
		["rotation"] = -90,
		["labelText"] = 'Here you can enable "banners", which are labels that fly over furnitures, such as the Display Table, showing the current number of products on that furniture.',
	},
	[19] = {
		["arrowPos"] = UDim2.new(0.605, 0,0.073, 0),
		["rotation"] = -90,
		["labelText"] = 'Here you will find shops for plot expansions and magazines.',
	},
	[20] = {
		["arrowPos"] = UDim2.new(0.666, 0,0.081, 0),
		["rotation"] = -90,
		["labelText"] = 'Here is a "Settings" button.',
	},
	[21] = {
		["arrowPos"] = UDim2.new(0.758, 0,0.079, 0),
		["rotation"] = -90,
		["labelText"] = 'Here are the leaderstats, which show the statistics of the players.',
	},
	[22] = {
		["arrowPos"] = UDim2.new(0.8, 0,0.078, 0),
		["rotation"] = -90,
		["labelText"] = 'Here you can find achivements.',
	},
	[23] = {
		["arrowPos"] = UDim2.new(0.847, 0,0.078, 0),
		["rotation"] = -90,
		["labelText"] = 'Here is Robux Shop where you can buy short-time boosts or cash.',
	},
	[24] = {
		["arrowPos"] = UDim2.new(0.834, 0,0.655, 0),
		["rotation"] = 0,
		["labelText"] = 'This button allows you to manually save your progress (the game has an auto-save feature, but if you want to make sure your data is saved, you can use it). Do not use it too often.',
	},
	[25] = {
		["arrowPos"] = UDim2.new(0.846, 0,0.705, 0),
		["rotation"] = 0,
		["labelText"] = 'This is a reset menu that allows you to reset some systems/GUIs if there is a bug.',
	},
	[26] = {
		["arrowPos"] = UDim2.new(0.852, 0,0.743, 0),
		["rotation"] = 0,
		["labelText"] = 'Here you will find all the documentation about this game, tutorials, info and more. Here you will find everything you need to understand this game, so please read it.',
	},
	[27] = {
		["arrowPos"] = UDim2.new(1.852, 0,0.743, 0),
		["rotation"] = 0,
		["labelText"] = 'Now some important information. Customers will rate your shop. Make sure the prices are good, you have everything they need, and your shop isn'.."'"..'t empty. You can see their opinions in the labels above their heads.',
	},
	[28] = {
		["arrowPos"] = UDim2.new(0.666, 0,0.081, 0),
		["rotation"] = -90,
		["labelText"] = 'Now, click the "Settings" button.',
		["somethingEvent"] = BuildUI.SettingsBut.MouseButton1Click,
		["func"] = function()
			ktorytut +=1
			obsluga()
		end,
	},
	[29] = {
		["arrowPos"] = UDim2.new(0.546, 0,0.142, 0),
		["rotation"] = 0,
		["labelText"] = 'This frame allows you to set the name for your shop, set materials for your plot, upgrade parking and billboards, kick players (not on the whitelist) off your plot, use the white/black list and reload the current slot. Click Next to continue.',
	},
	[30] = {
		["arrowPos"] = UDim2.new(0.657, 0,0.14, 0),
		["rotation"] = 0,
		["labelText"] = 'This frame allows you to adjust the volume level. Click Next to continue.',
	},
	[31] = {
		["arrowPos"] = UDim2.new(0.768, 0,0.14, 0),
		["rotation"] = 0,
		["labelText"] = 'This frame allows you to send feedback, set BINDS and ROTATE furniture if it is not rotated properly.',
	},
	[32] = {
		["arrowPos"] = UDim2.new(1.852, 0,0.743, 0),
		["rotation"] = 0,
		["labelText"] = 'Well, that is all for this tutorial. Have fun playing this game!',

	},
}


nextbutton.MouseButton1Click:Connect(function()
	toogle = false
	ktorytut +=1
	obsluga()
end)

function obsluga()
	if isOn then
		mudzin = false
		arrow.Visible = false
		if ktorytut <= 16 or ktorytut == 28 then
			if mainTutorialSteps[ktorytut-1] then
				if mainTutorialSteps[ktorytut-1].event then
					mainTutorialSteps[ktorytut-1].event:Disconnect()
				end
				if mainTutorialSteps[ktorytut-1].event2 then
					mainTutorialSteps[ktorytut-1].event2:Disconnect()
				end
			end

			local nowStep = mainTutorialSteps[ktorytut]

			if ktorytut == 16 or ktorytut == 29 then
				nextbutton.Visible = true
			end

			if ktorytut == 28 then
				nextbutton.Visible = false
			end

			if nowStep.individualFunc then
				nowStep.individualFunc()
			end
			toogle = true
			startframe.Visible = false
			lable.Text = nowStep.labelText
			lable.Parent.Visible = true
			if nowStep.IneedHigherLabel then
				lable.Parent:TweenPosition(UDim2.new(0.205, 0,0.723, 0),nil,6,0.85)
			else
				lable.Parent:TweenPosition(UDim2.new(0.205, 0,0.853, 0),nil,6,0.85)
			end
			wait(0.3)
			wait()
			if nowStep.somethingEvent then
				nowStep["event"] = nowStep.somethingEvent:Connect(nowStep.func)
			end
			if nowStep.somethingEvent2 then
				nowStep["event2"] = nowStep.somethingEvent2:Connect(nowStep.func)
			end

			mudzin = true
			if ktorytut == 8 then
				local model = gui.Model.Value
				local tutgui = model.TutorialGui
				przesuwanie(tutgui.Image.Position,tutgui.Image)
			else
				if nowStep.arrowPos then
					arrow.Rotation = nowStep.rotation
					przesuwanie(nowStep.arrowPos)
				end
			end
		elseif ktorytut == 33 then
			ended()
		else
			if mainTutorialSteps[ktorytut-1] then
				if mainTutorialSteps[ktorytut-1].event then
					mainTutorialSteps[ktorytut-1].event:Disconnect()
				end
				if mainTutorialSteps[ktorytut-1].event2 then
					mainTutorialSteps[ktorytut-1].event2:Disconnect()
				end
			end
			if ktorytut == 29 then
				nextbutton.Visible = true
			end
			local nowStep = mainTutorialSteps[ktorytut]
			toogle = true
			lable.Text = nowStep.labelText
			lable.Parent.Visible = true
			if nowStep.IneedHigherLabel then
				lable.Parent:TweenPosition(UDim2.new(0.205, 0,0.723, 0),nil,6,0.85)
			else
				lable.Parent:TweenPosition(UDim2.new(0.205, 0,0.853, 0),nil,6,0.85)
			end
			mudzin = true
			if nowStep.arrowPos then
				arrow.Rotation = nowStep.rotation
				przesuwanie(nowStep.arrowPos)
			end
		end
	end
end

function przesuwanie(pos,alternativeObj)
	local tut = ktorytut
	local object = arrow
	if alternativeObj then
		object = alternativeObj
	end
	local how
	if object.Rotation == 0 then
		how = false
	elseif object.Rotation == -90 then
		how = "else"
	elseif object.Rotation == 180 then
		how = true
	end
	--if alternativeObj then
	--	how = "else"
	--end
	if ktorytut == 8 then
		how = "else"
	end

	object.Visible = true
	local elo = true
	while mudzin and tut==ktorytut do
		local position
		if how == true then
			if elo then
				position = pos + UDim2.new(0.04, 0,0, 0)
				object:TweenPosition(position,nil,nil,0.3)
				elo = false
			elseif elo == false then
				position = pos - UDim2.new(0.04, 0,0, 0)
				object:TweenPosition(position,nil,nil,0.3)
				elo = true
			end
		elseif how == false then
			if elo then
				position = pos - UDim2.new(0.04, 0,0, 0)
				object:TweenPosition(position,nil,nil,0.3)
				elo = false
			elseif elo == false then
				position = pos + UDim2.new(0.04, 0,0, 0)

				object:TweenPosition(position,nil,nil,0.3)
				elo = true
			end
		else
			if elo then
				position = pos + UDim2.new(0, 0,0.04, 0)
				object:TweenPosition(position,nil,nil,0.3)
				elo = false
			elseif elo == false then
				position = pos - UDim2.new(0, 0,0.04, 0)
				object:TweenPosition(position,nil,nil,0.3)
				elo = true
			end
		end
		wait(0.5)
		if mudzin == false then
			return
		end
	end
end

function ended()
	toogle = false
	isOn = false
	lable.Parent.Position = UDim2.new(0.205,0,1.1,0)
	game.ReplicatedStorage.Events.RESETGUI:FireServer()
	mudzin = false
	nextbutton.Visible = false
	plr:SetAttribute("DoesTutorial",false)
	gui.Enabled = false
end

gui.InfoFrame.EndButton.MouseButton1Click:Connect(function()
	ended()
end)

startframe.QuitBtn.MouseButton1Click:Connect(function()
	ended()
end)

startframe.StartBtn.MouseButton1Click:Connect(function()
	startframe.Visible = false
	plr:SetAttribute("DoesTutorial",true)
	isOn = true
	local n = gui.Parent.BuildUI.ShopFrame
	obsluga()
end)


game.ReplicatedStorage.Events.TutorialStatus.OnClientEvent:Connect(function()
	startframe.Visible = true
	wait(1.5)
	startframe:TweenPosition(UDim2.new(0.298, 0,0.309, 0))
end)