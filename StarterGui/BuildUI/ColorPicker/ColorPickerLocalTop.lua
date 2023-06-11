-- dispeller 2020
-- Color picker example

local Player = game.Players.LocalPlayer
local UserInputService = game:GetService('UserInputService')
local MainFrame = script.Parent.ColorPickerFrame
local ColorShower = MainFrame.ColorShower
local PickerArea = MainFrame.ColorPickerArea
local Picker = PickerArea.Picker
local Gradient = PickerArea:FindFirstChildOfClass('UIGradient')
local selecting = false
local endFrame = script.Parent.Parent.Parent:WaitForChild("PaintFrame")
local colButton = script.Parent.Parent.Parent:WaitForChild("PaintFrame").FirstColor
local UpdateOtherBar = require(script.UpdateOtherBar)
local paintRE = game.ReplicatedStorage.Events.SettingsFolder.PaintPlotRE
local object
local getPlot = game.ReplicatedStorage.Remotes.requestPlot
local plot = getPlot:InvokeServer()
local xPos
local isPickingOn = false
-- load the getColor function
getColor = require(script.GetOnGradientSlider)
local eventColor = game.ReplicatedStorage.Events.ColorOBJ
-- upon the user selecting
function beginSelection(toggle,ile,sectoggle)
	selecting = true
	local ColorKeyPoints = Gradient.Color.Keypoints
	local OtherColorKeyPoints = script.Parent.Parent.Bottom.ColorPickerFrame.ColorPickerArea:FindFirstChild("UIGradent")
	repeat wait()

		-- left cord of ColorPickerArea in pixels
		local minXPos = PickerArea.AbsolutePosition.X

		-- right cord of ColorPickerArea in pixels
		local maxXPos = minXPos+PickerArea.AbsoluteSize.X

		-- width of ColorPickerArea in pixels
		local xPixelSize = maxXPos-minXPos
		local mouseX
		-- raw Mouse X pixel position

		mouseX = UserInputService:GetMouseLocation().X


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
		local Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,255)),
			ColorSequenceKeypoint.new(0.5,getColor(xPos,ColorKeyPoints)),
			ColorSequenceKeypoint.new(1,Color3.fromRGB(0,0,0))
		}
		script.Parent.Parent.Bottom.ColorPickerFrame.ColorPickerArea.UIGradent.Color = Color
		
		if (not toggle and not sectoggle) or (toggle and sectoggle) then

			if endFrame and endFrame.Name == "PaintFrame" then
				colButton:SetAttribute("Top",xPos)
				colButton:SetAttribute("Bottom",script.Parent.Parent.Bottom.ColorPickerFrame.ColorPickerArea.Picker.Position.X.Scale)
				colButton.BackgroundColor3 = script.Parent.Parent.Bottom.ColorPickerFrame.ColorShower.BackgroundColor3
				
				if Player and object then
					for i, v in pairs(object.Parent:FindFirstChild("Paintable1"):GetChildren()) do
						if v.Parent.Parent.Parent.Parent == plot then
							v.Color =  colButton.Parent.FirstColor.BackgroundColor3
						else
							warn("Don't try to paint other player models")
						end
					end
					for i, v in pairs(object.Parent:FindFirstChild("Paintable2"):GetChildren()) do
						if v.Parent.Parent.Parent.Parent == plot then
							v.Color =  colButton.Parent.SecColor.BackgroundColor3
						else
							warn("Don't try to paint other player models")
						end
					end
				end

			elseif endFrame and endFrame.Name == "PaintPlotFrame" then
				script.Parent.Parent.Parent.SettingsFrame.Shop.ColorButton.BackgroundColor3 = 				script.Parent.Parent.Bottom.ColorPickerFrame.ColorShower.BackgroundColor3
				endFrame.ColorColor.BackgroundColor3 = script.Parent.Parent.Bottom.ColorPickerFrame.ColorShower.BackgroundColor3
				if not toggle then
					plot.Plot.Color = script.Parent.Parent.Bottom.ColorPickerFrame.ColorShower.BackgroundColor3
					for i,n in pairs(plot.Plot:GetChildren()) do
						if n.ClassName == "Part" then
							n.Color = script.Parent.Parent.Bottom.ColorPickerFrame.ColorShower.BackgroundColor3
						end
					end
				end
			end
		end

		if endFrame and endFrame.Name == "PaintPlotFrame" then
			endFrame.ColorColor:SetAttribute("Bottom",script.Parent.Parent.Bottom.ColorPickerFrame.ColorPickerArea.Picker.Position.X.Scale)
			endFrame.ColorColor:SetAttribute("Top",xPos)
		end
		UpdateOtherBar()
		if toggle then
			endSelection(toggle)
			return true
		end
	until not selecting
end

-- upon the user ending selection
function endSelection(toggle)
	wait()
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

game.ReplicatedStorage.Remotes.CPTopB.OnInvoke = beginSelection

game.ReplicatedStorage.Events.ColorPickerEvents.PickB.Event:Connect(function(frame)
	endFrame = frame
end)

game.ReplicatedStorage.Events.ColorPickerEvents.ChangeFSCB.Event:Connect(function(button)
	colButton = button
end)

game.ReplicatedStorage.Events.ColorPickerEvents.SendObjB.Event:Connect(function(obj,pickToggle)
	isPickingOn = pickToggle
	if pickToggle then
		object = nil
	else
		object = obj
	end
	isPickingOn = false
end)