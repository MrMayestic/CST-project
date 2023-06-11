-- Made by Stonetr03, Parts (Most) of code copied from dispeller

local function UpdateOtherBar()
	local Player = game.Players.LocalPlayer
	local UserInputService = game:GetService('UserInputService')
	local MainFrame = script.Parent.Parent.Parent.Bottom.ColorPickerFrame
	local ColorShower = MainFrame.ColorShower
	local PickerArea = MainFrame.ColorPickerArea
	local Picker = PickerArea.Picker
	local Gradient = PickerArea:FindFirstChildOfClass('UIGradient')

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
	local minXPos = PickerArea.AbsolutePosition.X

	-- right cord of ColorPickerArea in pixels
	local maxXPos = minXPos+PickerArea.AbsoluteSize.X

	-- width of ColorPickerArea in pixels
	local xPixelSize = maxXPos-minXPos
	local SliderPos = PickerArea.Picker.AbsolutePosition.X
	local xPos = (SliderPos-minXPos)/xPixelSize
	-- set the ColorShower frame color
	ColorShower.BackgroundColor3 = getColor(xPos,ColorKeyPoints)
	local ManualInputColor = ColorShower.BackgroundColor3
	script.Parent.Parent.Parent.RGBInput.R.TextBox.Text = string.split(tostring(ManualInputColor.R * 255),".")[1]
	script.Parent.Parent.Parent.RGBInput.G.TextBox.Text = string.split(tostring(ManualInputColor.G * 255),".")[1]
	script.Parent.Parent.Parent.RGBInput.B.TextBox.Text = string.split(tostring(ManualInputColor.B * 255),".")[1]
end

return UpdateOtherBar
