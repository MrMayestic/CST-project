local hideModule = {}

local slotObjs = {"CashFrame","MagazynFrame","BuildSystemsAndInfo","Clock","RatingInfo","BoostInfo","CustomerInfo"}

local function checkSlot(obj)
	for i,n in ipairs(slotObjs) do
		if obj == n then
			return true
		end
	end
	return false
end

local NOTUseSlot = {"ChangeGrid","Mobile","close","Close","STOP","Slider","ChangeHideness","ChangeDayNight"}

local function checkNotUsesSlot(text)
	local returnVal = true
	for i,n in pairs(NOTUseSlot) do
		if string.match(text,n) then
			returnVal = false
		end
	end
	return returnVal
end

-------------------------------------------------

local objs = {"CashFrame","MagazynFrame"}

local function check(obj)
	for i,n in ipairs(objs) do
		if obj == n then
			return true
		end
	end
	return false
end

local NOTUse = {"ChangeGrid","Mobile","close","Close","STOP","Slider","ManageHR","ChangeHideness","ChangeDayNight","OpenMIButton"}

local function checkNotUses(text)
	local returnVal = true
	for i,n in pairs(NOTUse) do
		if string.match(text,n) then
			returnVal = false
		end
	end
	return returnVal
end

--Standard functions

function hideModule.visibleOff(notThis)
	local plr = game.Players.LocalPlayer
	pcall(function() 
		for i,n in pairs(plr.PlayerGui.BuildUI:GetChildren()) do
			if n.ClassName == "TextButton" and checkNotUses(n.Name) and n.Name ~= notThis.Name or check(n.Name)  then-- and not n == script.Parent then
				n.Visible = false
			end
			plr.PlayerGui.Samouczek.TutorialStart.Visible = false
		end
	end)
end

function hideModule.visibleOn()
	local plr = game.Players.LocalPlayer
	pcall(function() 
		for i,n in pairs(plr.PlayerGui.BuildUI:GetChildren()) do
			if n.ClassName == "TextButton" and checkNotUses(n.Name) or check(n.Name)  then--and not n == script.Parent then
				n.Visible = true
			end
			plr.PlayerGui.Samouczek.TutorialStart.Visible = true
		end
	end)
end

--For slot purposes

function hideModule.visibleOffSlot()
	local plr = game.Players.LocalPlayer

	for i,n in pairs(plr.PlayerGui.BuildUI:GetChildren()) do
		if n.ClassName == "TextButton" and checkNotUsesSlot(n.Name) or checkSlot(n.Name)  then-- and not n == script.Parent then
			n.Visible = false
		end
		plr.PlayerGui:WaitForChild('Samouczek'):WaitForChild('TutorialStart').Visible = false
	end
end

function hideModule.visibleOnSlot()
	local plr = game.Players.LocalPlayer

	for i,n in pairs(plr.PlayerGui.BuildUI:GetChildren()) do
		if n.ClassName == "TextButton" and checkNotUsesSlot(n.Name) or checkSlot(n.Name)  then--and not n == script.Parent then
			n.Visible = true
		end
		plr.PlayerGui:WaitForChild('Samouczek'):WaitForChild('TutorialStart').Visible = true
	end
end

return hideModule
