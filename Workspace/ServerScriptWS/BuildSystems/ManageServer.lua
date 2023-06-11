local towarevents = game.ReplicatedStorage.Events.TowarEvents
local towarmodule = require(game.ReplicatedStorage.Modules.TowarModule)

towarevents.UstalServer.OnServerEvent:Connect(function(plr, co, model, toggle)
	local ile = plr.TowarFolder:FindFirstChild(co).Value
	towarmodule.towar(plr, co, model, toggle, ile)
	task.wait()
	game.ReplicatedStorage.Events.TowarEvents.Zlicz:FireClient(plr)
end)

local function countCapacity(plr)
	local checkvalue = plr.ValueFolder.MaxCapacity.Value
	local ustawcapacity = 0
	for i,numa in ipairs(plr.TowarFolder:GetChildren()) do
		ustawcapacity = ustawcapacity + numa.Value
	end
	if checkvalue == 0 or checkvalue == nil then
		return 50,ustawcapacity
	elseif checkvalue == 1 then
		return 75,ustawcapacity
	elseif checkvalue == 2 then
		return 100,ustawcapacity
	elseif checkvalue == 3 then
		return 150,ustawcapacity
	elseif checkvalue == 4 then
		return 250,ustawcapacity
	elseif checkvalue == 5 then
		return 500,ustawcapacity
	end
end

towarevents.Erase.OnServerEvent:Connect(function(plr,model,ktore)
	local capacity,ilejest = countCapacity(plr)
	towarmodule.erase(plr,model,ktore,capacity,ilejest)
end)

towarevents.EkranOn.OnServerEvent:Connect(function(plr,model)
	model.Screen.BrickColor = BrickColor.new("Medium stone grey")
end)

towarevents.EkranOff.OnServerEvent:Connect(function(plr,model)
	model.Screen.BrickColor = BrickColor.new("Really black")
end)

game.ReplicatedStorage.Events.JestManageKlikniete.OnServerEvent:Connect(function(plr)
	game.ReplicatedStorage.Events.JestManageKlikniete:FireClient(plr)
end)

towarevents.Close.OnServerEvent:Connect(function(plr)
	towarevents.Close:FireClient(plr)
end)


game.ReplicatedStorage.Events.ManageClose.OnServerEvent:Connect(function(plr)
	game.ReplicatedStorage.Events.ManageClose:FireClient(plr)
end)
----SIGNTEXT


local TextService = game:GetService("TextService")

local setSignText = game.ReplicatedStorage.Events:WaitForChild("SetSignText")

local checkSignText = game.ReplicatedStorage.Events:WaitForChild("CheckSignText")

local function getTextObject(message, fromPlayerId)
	local textObject
	local success, errorMessage = pcall(function()
		textObject = TextService:FilterStringAsync(message, fromPlayerId)
	end)
	if success then
		return textObject
	elseif errorMessage then
		print("Error generating TextFilterResult:", errorMessage)
	end

	return false
end

local function getFilteredMessage(textObject)
	local filteredMessage
	local success, errorMessage = pcall(function()
		filteredMessage = textObject:GetNonChatStringForBroadcastAsync()
	end)
	if success then
		return filteredMessage
	elseif errorMessage then
		print("Error filtering message:", errorMessage)
	end
	return false
end

-- Fired when client sends a request to write on the sign

setSignText.OnServerEvent:Connect(function(plr,message,obj,bg,text)
	if message ~= "" and message then
		-- Filter the incoming message and send the filtered message
		local messageObject = getTextObject(message, plr.UserId)
		local filteredText = ""
		filteredText = getFilteredMessage(messageObject)
		obj.Parent.Part.SurfaceGui.TextLabel.Text = filteredText
	end

	if bg then
		obj.Parent.Part.SurfaceGui.TextLabel.BackgroundColor3 = bg
	end

	if text then
		obj.Parent.Part.SurfaceGui.TextLabel.TextColor3 = text
	end
end)

checkSignText.OnServerEvent:Connect(function(plr,name)
	if name ~= "" then
		-- Filter the incoming message and send the filtered message
		local messageObject = getTextObject(name, plr.UserId)
		local filteredText = ""
		filteredText = getFilteredMessage(messageObject)
		checkSignText:FireClient(plr,filteredText)
	end
end)