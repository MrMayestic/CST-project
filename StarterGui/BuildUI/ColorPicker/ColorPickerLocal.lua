-- dispeller 2020
-- Color picker example

local Player = game.Players.LocalPlayer
local UserInputService = game:GetService('UserInputService')
local MainFrame = script.Parent.ColorPickerFrame
local ColorShower = MainFrame.ColorShower
local PickerArea = MainFrame.ColorPickerArea
local Picker = PickerArea.Picker
local Gradient = PickerArea:FindFirstChildOfClass('UIGradient')
local endFrame = script.Parent.Parent.Parent:WaitForChild("PaintFrame")
local colButton = script.Parent.Parent.Parent:WaitForChild("PaintFrame").FirstColor
local selecting = false
local paintRE = game.ReplicatedStorage.Events.SettingsFolder.PaintPlotRE
local eventColor = game.ReplicatedStorage.Events.ColorOBJ
local object
local getPlot = game.ReplicatedStorage.Remotes.requestPlot
local plot = getPlot:InvokeServer()
local isPickingOn = false
-- upon the user selecting
local xPos

local function findColor(toggle,ile,ile2,sectoggle)
	game.ReplicatedStorage.Remotes.CPTopB:Invoke(toggle,ile)
	beginSelection(toggle,ile2,true)
	return true
end

function beginSelection(toggle,ile,sectoggle)
	selecting = true
	local ColorKeyPoints = Gradient.Color.Keypoints
	local function getColor(percentage, ColorKeyPoints)
		if (percentage < 0) or (percentage>1) then
			--error'getColor percentage out of bounds!'
			warn'getColor got out of bounds percentage (less than 0 or greater than 1'
		end

		local closestToLeft = ColorKeyPoints[1]
		local closestToRight = ColorKeyPoints[#ColorKeyPoints]
		local LocalPercentage = .5
		local color = closestToLeft.Value

		-- This loop can probably be improved by doing something like a Binary search instead
		-- This should work fine though
		for i=1,#ColorKeyPoints-1 do
			if (ColorKeyPoints[i].Time <= percentage) and (ColorKeyPoints[i+1].Time >= percentage) then
				closestToLeft = ColorKeyPoints[i]
				closestToRight = ColorKeyPoints[i+1]
				LocalPercentage = (percentage-closestToLeft.Time)/(closestToRight.Time-closestToLeft.Time)
				color = closestToLeft.Value:lerp(closestToRight.Value,LocalPercentage)
				return color
			end
		end
		warn('Color not found!')
		return color
	end
	repeat wait()
		--local getColor = require(script.GetOnGradientSlider)
		-- left cord of ColorPickerArea in pixels
		local minXPos = PickerArea.AbsolutePosition.X

		-- right cord of ColorPickerArea in pixels
		local maxXPos = minXPos+PickerArea.AbsoluteSize.X

		-- width of ColorPickerArea in pixels
		local xPixelSize = maxXPos-minXPos

		-- raw Mouse X pixel position
		local mouseX = UserInputService:GetMouseLocation().X

		-- constraints
		if mouseX<minXPos then
			mouseX = minXPos
		elseif mouseX>maxXPos then
			mouseX = maxXPos
		end

		-- get percentage mouse is on
		if toggle then
			xPos = ile
		else
			xPos = (mouseX-minXPos)/xPixelSize
		end

		-- move the visual Picker line
		Picker.Position = UDim2.new(xPos,0,0,0)

		-- set the ColorShower frame color
		ColorShower.BackgroundColor3 = getColor(xPos,ColorKeyPoints)
		local ManualInputColor = ColorShower.BackgroundColor3

		script.Parent.Parent.RGBInput.R.TextBox.Text = string.split(tostring(ManualInputColor.R * 255),".")[1]
		script.Parent.Parent.RGBInput.G.TextBox.Text = string.split(tostring(ManualInputColor.G * 255),".")[1]
		script.Parent.Parent.RGBInput.B.TextBox.Text = string.split(tostring(ManualInputColor.B * 255),".")[1]

		if (not toggle and not sectoggle) or toggle then

			if endFrame and endFrame.Name == "PaintFrame" then
				colButton:SetAttribute("Top",script.Parent.Parent.Top.ColorPickerFrame.ColorPickerArea.Picker.Position.X.Scale)
				colButton:SetAttribute("Bottom",xPos)
				colButton.BackgroundColor3 = script.Parent.Parent.Bottom.ColorPickerFrame.ColorShower.BackgroundColor3
				
				if sectoggle or (not toggle and not sectoggle) then	
					if Player and object and object.Parent and script.Parent.Parent.Parent.PaintFrame.Change.Text ~= "Material Only" then
						if colButton.Name == "FirstColor" then
							for i, v in pairs(object.Parent:FindFirstChild("Paintable1"):GetChildren()) do
								if v.Parent.Parent.Parent.Parent == plot then
									v.Color =  colButton.BackgroundColor3
								else
									warn("Don't try to paint other player models")
								end
							end
						else
							for i, v in pairs(object.Parent:FindFirstChild("Paintable2"):GetChildren()) do
								if v.Parent.Parent.Parent.Parent == plot then
									v.Color =  colButton.BackgroundColor3
								else
									warn("Don't try to paint other player models")
								end
							end
						end
					end
				end
				
			elseif endFrame and endFrame.Name == "PaintPlotFrame" then
				script.Parent.Parent.Parent.SettingsFrame.Shop.ColorButton.BackgroundColor3 = script.Parent.Parent.Bottom.ColorPickerFrame.ColorShower.BackgroundColor3
				endFrame.ColorColor.BackgroundColor3 = script.Parent.Parent.Bottom.ColorPickerFrame.ColorShower.BackgroundColor3
				if not toggle then
					plot.Plot.Color = script.Parent.Parent.Bottom.ColorPickerFrame.ColorShower.BackgroundColor3
				end
			end
			
			if toggle and sectoggle then
				script.Parent.Parent.Reset:SetAttribute("Top",script.Parent.Parent.Top.ColorPickerFrame.ColorPickerArea.Picker.Position.X.Scale)
				script.Parent.Parent.Reset:SetAttribute("Bottom",xPos)
			end
		end

		if endFrame and endFrame.Name == "PaintPlotFrame" then
			endFrame.ColorColor:SetAttribute("Bottom",xPos)
			endFrame.ColorColor:SetAttribute("Top",script.Parent.Parent.Top.ColorPickerFrame.ColorPickerArea.Picker.Position.X.Scale)
		end

		if toggle then
			endSelection(toggle)
		end
	until not selecting
end

-- upon the user ending selection
function endSelection(toggle)
	-- this will stop the loop
	selecting = false
	if not toggle then
		if endFrame and endFrame.Name == "PaintFrame" then
			local succ,err
			succ,err = pcall(function()
				local topLc1 = endFrame.FirstColor:GetAttribute("Top")
				local bottomLcl1 = endFrame.FirstColor:GetAttribute("Bottom")
				local topLc2 = endFrame.SecColor:GetAttribute("Top")
				local bottomLc2 = endFrame.SecColor:GetAttribute("Bottom")
				eventColor:FireServer(object, colButton.Parent.FirstColor.BackgroundColor3,colButton.Parent.SecColor.BackgroundColor3,topLc1,bottomLcl1,topLc2,bottomLc2)
			end)
			if not succ then
				warn("jojko")
			end
		elseif endFrame and endFrame.Name == "PaintPlotFrame" then
			local succ,err
			succ,err = pcall(function()
				paintRE:FireServer(script.Parent.Parent.Bottom.ColorPickerFrame.ColorShower.BackgroundColor3,endFrame.ColorColor)
			end)
			if not succ then
				plot.Plot.Color = Color3.new(0.647059, 0.647059, 0.647059)
				for i,n in pairs(plot.Plot:GetChildren()) do
					if n.ClassName == "Part" then
						n.Color = Color3.new(0.647059, 0.647059, 0.647059)
					end
				end
			end
		end
	end
end

-- check input for selection beginning
local function inputBegan(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		beginSelection()
	end
end

PickerArea.InputBegan:Connect(inputBegan)

-- check input for selection ending
local function inputEnded(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		endSelection()
	end
end

PickerArea.InputEnded:Connect(inputEnded)

game.ReplicatedStorage.Events.ColorPickerEvents.PickB.Event:Connect(function(frame)
	endFrame = frame
	--endFrame.ColorColor.BackgroundColor3 = plot.Plot.Color
end)

--SET CURRENT PAINT LAYER (1,2)--

game.ReplicatedStorage.Events.ColorPickerEvents.ChangeFSCB.Event:Connect(function(button)
	colButton = button
end)

game.ReplicatedStorage.Events.ColorPickerEvents.SendObjB.Event:Connect(function(obj,pickToggle)
	local myObj
	if obj then
		if obj.Name == "Primary" then
			myObj = obj.Parent
		else
			myObj = obj
		end
	end
	
	isPickingOn = pickToggle
	
	if pickToggle and obj then
		local lastButton = colButton
		game.ReplicatedStorage.Events.ColorPickerEvents.ChangeFSCB:Fire(script.Parent.Parent.Parent.PaintFrame.FirstColor)
		colButton = script.Parent.Parent.Parent.PaintFrame.FirstColor
		task.wait(0.1)

		findColor(true,myObj.Paintable1:GetAttribute("Top"),myObj.Paintable1:GetAttribute("Bottom"))

		script.Parent.Parent.Parent.PaintFrame.FirstColor.BackgroundColor3 = script.Parent.Parent.Bottom.ColorPickerFrame.ColorShower.BackgroundColor3
		script.Parent.Parent.Parent.PaintFrame.FirstColor:SetAttribute("Top",myObj.Paintable1:GetAttribute("Top"))
		script.Parent.Parent.Parent.PaintFrame.FirstColor:SetAttribute("Bottom",myObj.Paintable1:GetAttribute("Bottom"))

		game.ReplicatedStorage.Events.ColorPickerEvents.ChangeFSCB:Fire(script.Parent.Parent.Parent.PaintFrame.SecColor)
		colButton = script.Parent.Parent.Parent.PaintFrame.SecColor

		task.wait(0.1)

		findColor(true,myObj.Paintable2:GetAttribute("Top"),myObj.Paintable2:GetAttribute("Bottom"))

		task.wait(0.1)

		script.Parent.Parent.Parent.PaintFrame.SecColor.BackgroundColor3 = script.Parent.Parent.Bottom.ColorPickerFrame.ColorShower.BackgroundColor3
		script.Parent.Parent.Parent.PaintFrame.SecColor:SetAttribute("Top",myObj.Paintable2:GetAttribute("Top"))
		script.Parent.Parent.Parent.PaintFrame.SecColor:SetAttribute("Bottom",myObj.Paintable2:GetAttribute("Bottom"))
		game.ReplicatedStorage.Events.ColorPickerEvents.setColorsLocal:Fire(colButton.Parent.FirstColor.BackgroundColor3,colButton.Parent.SecColor.BackgroundColor3)
		
		game.ReplicatedStorage.Events.ColorPickerEvents.ChangeFSCB:Fire(lastButton)
		colButton = lastButton
		task.wait(0.15)
		
		if lastButton.Name == "FirstColor" then
			findColor(true,myObj.Paintable1:GetAttribute("Top"),myObj.Paintable1:GetAttribute("Bottom"))
		elseif lastButton.Name == "SecColor" then
			findColor(true,myObj.Paintable2:GetAttribute("Top"),myObj.Paintable2:GetAttribute("Bottom"))
		end
	end
	if pickToggle then
		object = nil
	else
		object = obj
	end
	isPickingOn = false
end)

game.ReplicatedStorage.Events.ColorPickerEvents.SetBottomB.Event:Connect(beginSelection)
game.ReplicatedStorage.Events.TestPickeraEnd.OnClientEvent:Connect(endSelection)