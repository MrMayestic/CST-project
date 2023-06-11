local dialogModule = {}

local plr

local entryDialogs = {
	["Dialog1"] = {
		["Startup"] = "Good morning, what can I buy for my son's birthday?";
		["Products"] = {"telefony","tablety","konsole","komputery","klawiatury","myszki","sluchawki"};
		["atLeastOne"] = true;
		["Options"] = {
			["Option1"] = {
				["DialogText"] = "Best choice in this days is a new _ I think.";
				["Response"] = "Okay, thanks for help!";
				["Value"] = 1;
			};
			["Option2"] = {
				["DialogText"] = "So you came to My shop and don't know what to buy?!.";
				["Response"] = "Oh, what a rude answer!";
				["Value"] = -2;
			};
			["Option3"] = {
				["DialogText"] = "Well... I don't know what will be the best.";
				["Response"] = "So... it wasn't really helpful.";
				["Value"] = 0;
			};
			["Reject"] = {
				["DialogText"] = "I don't think we have anything like that, sorry.";
				["ResponseGood"] = "Eh, maybe next time.";
				["ResponseBad"] = "You are electronic shop without electronic?!";
			}
		}
	},
	["Dialog2"] = {
		["Products"] = {"telefony"};
		["atLeastOne"] = false;
		["Startup"] = "Good morning, I need a new phone, do you have any?";
		["Options"] = {
			["Option1"] = {
				["DialogText"] = "Yes, we have brand new models right there.";
				["Response"] = "Thanks mister!";
				["Value"] = 1;
			};
			["Option2"] = {
				["DialogText"] = "For you i think we don't have old enough models.";
				["Response"] = "You are so rude! I won't buy here anything.";
				["Value"] = -2;
			};
			["Option3"] = {
				["DialogText"] = "We may have i think.";
				["Response"] = "I hope that you have.";
				["Value"] = 0;
			};
			["Reject"] = {
				["DialogText"] = "We don't have phones yet.";
				["ResponseGood"] = "Ok, so i will look for something else.";
				["ResponseBad"] = "Eh, why I had to come to shop that don't have product I want.";
			}
		}
	},
	["Dialog3"] = {
		["Products"] = {"telewizory"};
		["atLeastOne"] = false;
		["Startup"] = "Good day, I need a new TV. Can you offer me something?";
		["Options"] = {
			["Option1"] = {
				["DialogText"] = "Yes, we have brand the newest TV here.";
				["Response"] = "Thanks mister!";
				["Value"] = 1;
			};
			["Option2"] = {
				["DialogText"] = "You should go for do some sport, not watch TV.";
				["Response"] = "You are not better!";
				["Value"] = -2;
			};
			["Option3"] = {
				["DialogText"] = "Um... something is here I guess.";
				["Response"] = "I hope that you have.";
				["Value"] = 0;
			};
			["Reject"] = {
				["DialogText"] = "We don't have TVs yet.";
				["ResponseGood"] = "Ok, so i will check for that later.";
				["ResponseBad"] = "Oh, I was really hoping that you have something like that.";
			}
		}
	},
	["Dialog4"] = {
		["Startup"] = "Hello, do you have any special offers?";
		["Products"] = "any";
		["atLeastOne"] = false;
		["Options"] = {
			["Option1"] = {
				["DialogText"] = "Yes, for example right there you can see.";
				["Response"] = "Thank! I will consider of buying it.";
				["Value"] = 1;
			};
			["Option2"] = {
				["DialogText"] = "So you came to My shop and don't know what to buy?!.";
				["Response"] = "Oh, what a rude answer!";
				["Value"] = -2;
			};
			["Option3"] = {
				["DialogText"] = "Um... ask casier.";
				["Response"] = "Right...";
				["Value"] = 0;
			};
		}
	},
	["Dialog5"] = {
		["Products"] = {"aparaty"};
		["atLeastOne"] = false;
		["Startup"] = "Hello, I wanted a new camera to take some photos soon. Do you have any?";
		["Options"] = {
			["Option1"] = {
				["DialogText"] = "Yes, we have great cameras here.";
				["Response"] = "Thank you!";
				["Value"] = 1;
			};
			["Option2"] = {
				["DialogText"] = "You can't take any good picture. Get out.";
				["Response"] = "You will get what you deserve for!";
				["Value"] = -2;
			};
			["Option3"] = {
				["DialogText"] = "Um... something is here I guess.";
				["Response"] = "I hope that you have.";
				["Value"] = 0;
			};
			["Reject"] = {
				["DialogText"] = "We don't have yet.";
				["ResponseGood"] = "Eh, I'm so unlucky.";
				["ResponseBad"] = "Ah, you can't have some primary products?!.";
			}
		}
	},
	["Dialog6"] = {
		["Products"] = {"komputery"};
		["atLeastOne"] = false;
		["Startup"] = "Good morning. I need a new computer to my work.";
		["Options"] = {
			["Option1"] = {
				["DialogText"] = "Right, there we have some good computers.";
				["Response"] = "Alright!";
				["Value"] = 1;
			};
			["Option2"] = {
				["DialogText"] = "Haha to browse internet right?";
				["Response"] = "You better shut or I will report you.";
				["Value"] = -2;
			};
			["Option3"] = {
				["DialogText"] = "Go ask cashier, I don't know.";
				["Response"] = "Intresting.";
				["Value"] = 0;
			};
			["Reject"] = {
				["DialogText"] = "We don't have full sets yet.";
				["ResponseGood"] = "I understand.";
				["ResponseBad"] = "And this is computer store?.";
			}
		}
	},
	["Dialog7"] = {
		["Products"] = {"sluchawki,myszki,glosniki,klawiatury"};
		["atLeastOne"] = false;
		["Startup"] = "I'm upgrading my computer station.";
		["Options"] = {
			["Option1"] = {
				["DialogText"] = "Alright, we have some products for You.";
				["Response"] = "Thanks!";
				["Value"] = 1;
			};
			["Option2"] = {
				["DialogText"] = "You are too poor for that.";
				["Response"] = "I wish you aren't.";
				["Value"] = -2;
			};
			["Option3"] = {
				["DialogText"] = "Ok.";
				["Response"] = "Ok?";
				["Value"] = 0;
			};
			["Reject"] = {
				["DialogText"] = "We don't have yet.";
				["ResponseGood"] = "Eh, okay.";
				["ResponseBad"] = "You are bad then.";
			}
		}
	},
	["Dialog8"] = {
		["Products"] = {"monitory"};
		["atLeastOne"] = false;
		["Startup"] = "I'm looking for really solid monitor.";
		["Options"] = {
			["Option1"] = {
				["DialogText"] = "Yes, there are some really solid monitors.";
				["Response"] = "Okay!";
				["Value"] = 1;
			};
			["Option2"] = {
				["DialogText"] = "You need better glasses not monitor.";
				["Response"] = "And you need some personal culture.";
				["Value"] = -2;
			};
			["Option3"] = {
				["DialogText"] = "TV is not the same?.";
				["Response"] = "Really?";
				["Value"] = 0;
			};
			["Reject"] = {
				["DialogText"] = "We don't have yet.";
				["ResponseGood"] = "Uh, maybe next time.";
				["ResponseBad"] = "I'm not happy hearing this.";
			}
		}
	},
	["Dialog9"] = {
		["Products"] = {"any"};
		["atLeastOne"] = false;
		["Startup"] = "Hello, do you have anything intresting today?";
		["Options"] = {
			["Option1"] = {
				["DialogText"] = "Yes, we have this!";
				["Response"] = "Thanks!";
				["Value"] = 1;
			};
			["Option2"] = {
				["DialogText"] = "Get lost.";
				["Response"] = "Oh... that is your true side...";
				["Value"] = -2;
			};
			["Option3"] = {
				["DialogText"] = "Um... maybe... yes...";
				["Response"] = "Yhm.";
				["Value"] = 0;
			};
		}
	},
	["Dialog10"] = {
		["Products"] = {"konsole"};
		["atLeastOne"] = false;
		["Startup"] = "Hello, is there anything i can play on?";
		["Options"] = {
			["Option1"] = {
				["DialogText"] = "Yes, there are consoles.";
				["Response"] = "Thank you!";
				["Value"] = 1;
			};
			["Option2"] = {
				["DialogText"] = "You better read a book.";
				["Response"] = "And you learn how to treat customers.";
				["Value"] = -2;
			};
			["Option3"] = {
				["DialogText"] = "Ym...";
				["Response"] = "Ym...?";
				["Value"] = 0;
			};
			["Reject"] = {
				["DialogText"] = "We don't have anything like that, sorry.";
				["ResponseGood"] = "Ah, such a shame.";
				["ResponseBad"] = "I thought that this shop is a joke.";
			}
		}
	},
	["Dialog11"] = {
		["Products"] = {"myszki"};
		["atLeastOne"] = false;
		["Startup"] = "I need a new mouse, do you have any?";
		["Options"] = {
			["Option1"] = {
				["DialogText"] = "Yes, we have. Go over there.";
				["Response"] = "Alright, thanks.";
				["Value"] = 1;
			};
			["Option2"] = {
				["DialogText"] = "You destroyed the previous one?";
				["Response"] = "...";
				["Value"] = -2;
			};
			["Option3"] = {
				["DialogText"] = "Ask storeman...";
				["Response"] = "?";
				["Value"] = 0;
			};
			["Reject"] = {
				["DialogText"] = "We do not have mouses at the moment, sorry.";
				["ResponseGood"] = "Maybe next time.";
				["ResponseBad"] = "I thought so.";
			}
		}
	},
}

local entryNumber = 11
--local inNumber = 3

local waiterAnswers = {"Agh, why I must wait so long for answer!","When should I come to get answer?","Ah... that customer service..."}
local events = {}
local dialogWait = false
local returnValue
local returnProduct

--{{-----------------------------}}--

local DialogGui

local function resetGUI()
	DialogGui.Frame.Choice1.Visible = false
	DialogGui.Frame.Choice2.Visible = false
	DialogGui.Frame.Choice3.Visible = false
end

local function exitDialog()
	resetGUI()
end

local function ratingInfo(good)
	local object = plr.PlayerGui.BuildUI.RatingInfoDial 

	if good == true then
		object.Text = "Rating Raises"
		object.TextColor3 = Color3.new(0, 0.666667, 0)
		object:TweenPosition(UDim2.new(0, 0,0.138, 0),nil,nil,0.9)
		wait(3.2)
		object:TweenPosition(UDim2.new(-0.11, 0,0.138, 0),nil,nil,0.9)
	elseif good == false then
		object.Text = "Rating Lowers"
		object:TweenPosition(UDim2.new(0, 0,0.138, 0))
		object.TextColor3 = Color3.new(0.784314, 0, 0)
		object:TweenPosition(UDim2.new(0, 0,0.138, 0),nil,nil,0.9)
		wait(3.2)
		object:TweenPosition(UDim2.new(-0.11, 0,0.138, 0),nil,nil,0.9)
	end
end

--Function to compare model product and dialog product

local function checkProductOnModel(dialog,check)
	for i,n in pairs(dialog.Products) do
		if n == check then
			return true
		end
	end

	return false
end

--Function that checks if player's plot has avaible products that are included in dialog

local function checkDialogProduct(dialog,npcChar,atLeastOne)
	local check
	local availStaff = {}
	local placedObjs = npcChar.Parent.Parent.PlacedObjects:GetChildren()
	if dialog.Products == "any" then
		return true
	else
		for i,n in pairs(placedObjs) do
			task.wait()
			if n.Name == "DisplayTable" or n.Name == "Shelf" or n.Name == "SmallShelf" then
				check = n.Towar.KtoryArtykul.Value
				if checkProductOnModel(dialog,check) then
					if n.Towar.IleArtykul.Value > 0 then
						if atLeastOne then
							table.insert(availStaff,check)
						else
							return true
						end
					end
				end
			end
		end
		if atLeastOne and #availStaff > 0 then
			return true,availStaff
		end
	end

	return false
end

local function translateProduct(co)
	if co == "telefony" then
		return "phone"
	elseif co == "aparaty" then
		return  "camera"
	elseif co == "tablety" then
		return  "tablet"
	elseif co == "telewizory" then
		return "TV"
	elseif co == "konsole" then
		return  "console"
	elseif co == "komputery" then
		return  "computer"
	elseif co == "monitory" then
		return  "monitor"	
	elseif co == "klawiatury" then
		return "keyboard"
	elseif co == "myszki" then
		return  "mouse"
	elseif co == "glosniki" then
		return  "speakers"
	elseif co == "sluchawki" then
		return  "headphones"
	end
end

--Abort dialog when waiter count to (_)

local function abortDialog(npcChar)
	if #events > 0 then
		for i,n in pairs(events) do
			n:Disconnect()
		end
	end
	npcChar.Head.Gui.Enabled = false
	DialogGui.Enabled = false
	resetGUI()
	return true
end

--Function to make Dialog: create options and adds events, handles reject

local function makeDialog(dialog,npcChar,isProducts,whichProduct)
	dialogWait = true
	if isProducts then
		local counter = 1
		for i,n in pairs(dialog.Options) do
			if i ~= "Reject" then
				local choiceButton = DialogGui.Frame:FindFirstChild("Choice"..counter)
				local mycounter = counter
				local char = npcChar
				events[counter] = choiceButton.MouseButton1Click:Connect(function()
					if char:FindFirstChild("Head") then
						char.Head.Gui.Frame.NPCDialog.Text = n.Response
					end
					returnValue = n.Value
					dialogWait = false
					DialogGui.Enabled = false
					events[mycounter]:Disconnect()
					if returnValue < 0 then
						ratingInfo(false)
					elseif returnValue > 0 then
						ratingInfo(true)
					end
					wait(3)
					resetGUI()
				end)
				
				local splitedText = string.split(n.DialogText,"_")
				local textToAdd
				
				if splitedText[2] then
					local random = math.random(1,#whichProduct)
					textToAdd = splitedText[1]..translateProduct(whichProduct[random])
					textToAdd = textToAdd..splitedText[2]
					returnProduct = whichProduct[random]
				else
					textToAdd = n.DialogText
					if dialog.Products ~= "any" then
						returnProduct = dialog.Products[1]
					else
						returnProduct = dialog.Products
					end
				end

				choiceButton.Text = textToAdd
				choiceButton.Visible = true
				counter += 1
			end

		end
	else
		local choiceButton = DialogGui.Frame.Choice2
		local n = dialog.Options.Reject
		task.wait(0.05)		
		local RNG = math.random(1,20)
		local isGood = true
		
		if RNG > 15 then
			isGood = false
		end
		
		if isGood then
			local event
			event = choiceButton.MouseButton1Click:Connect(function()
				npcChar.Head.Gui.Frame.NPCDialog.Text = n.ResponseGood
				dialogWait = false
				DialogGui.Enabled = false
				returnValue = 0
				event:Disconnect()
				wait(2.5)
				resetGUI()
			end)
		else
			local event
			event = choiceButton.MouseButton1Click:Connect(function()
				npcChar.Head.Gui.Frame.NPCDialog.Text = n.ResponseBad
				dialogWait = false
				DialogGui.Enabled = false
				returnValue = -1
				event:Disconnect()
				if returnValue < 0 then
					ratingInfo(false)
				end
				wait(2.5)
				resetGUI()
			end)
		end
		choiceButton.Text = n.DialogText
		choiceButton.Visible = true
	end
	npcChar.Head.Gui.Enabled = true
	npcChar.Head.Gui.Frame.NPCDialog.Text = dialog.Startup

	wait(2)

	DialogGui.Enabled = true
	wait()
	local waiter = 0
	repeat
		waiter += wait(0.15)
	until dialogWait == false or math.floor(waiter) == 12

	if math.floor(waiter) == 12 then
		local rand = math.random(1,#waiterAnswers)
		DialogGui.Enabled = false
		npcChar.Head.Gui.Frame.NPCDialog.Text = waiterAnswers[rand]
		wait(4.5)
		abortDialog(npcChar)
		returnValue = -3
		return returnValue
	end

	wait(1.5)
	npcChar.Head.Gui.Enabled = false
	wait()
	return returnValue
end

--Function that activates dialog and makes first wait Event (? above npc)

function activateDialog(state,npcChar)
	returnValue = nil
	dialogWait = true
	local myDialog
	if state == "enterance" then
		local random = math.random(1,entryNumber)
		task.wait(0.05)
		myDialog = entryDialogs["Dialog"..tostring(random)] 
	end

	makeDialog(myDialog,npcChar,checkDialogProduct(myDialog,npcChar,myDialog.atLeastOne))
	
	--npcChar.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer

	return returnValue,returnProduct
end

--To activate module

function dialogModule.activate(state,npcChar,player)
	plr = player
	returnValue = 0
	returnProduct = nil
	DialogGui = plr.PlayerGui:WaitForChild('DialogGui')

	local dialogInst = Instance.new('Dialog')

	dialogInst.GoodbyeChoiceActive = false
	dialogInst.InitialPrompt = "."
	dialogInst.Parent = npcChar.Head

	local activatorToggle = false

	local activateEvent = dialogInst.Changed:Connect(function(a,b)
		if dialogInst.InUse == true then
			dialogInst.Parent = game.Workspace.DialogParent
			activatorToggle = true
		end
	end)

	local waiter = 0
	
	repeat
		waiter += wait(0.1)
	until activatorToggle or math.floor(waiter) == 15


	if math.floor(waiter) == 15 then
		activateEvent:Disconnect()
		dialogInst:Destroy()
		abortDialog(npcChar)
		returnValue = 0
		return returnValue
	end
	--npcChar.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	wait(0.2)
	activateEvent:Disconnect()
	dialogInst:Destroy()
	return activateDialog(state,npcChar)
end

return dialogModule
