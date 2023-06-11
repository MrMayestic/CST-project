-- Stonetr03

local CurrentColor = Color3.fromRGB(255,0,0)

local function ApplyColors()
	CurrentColor = Color3.fromRGB(script.Parent.R.TextBox.Text,script.Parent.G.TextBox.Text,script.Parent.B.TextBox.Text)
	
	script.Parent.Parent.Bottom.ColorPickerFrame.ColorShower.BackgroundColor3 = CurrentColor
	script.Parent.Parent.Top.ColorPickerFrame.ColorShower.BackgroundColor3 = CurrentColor
	
end

script.Parent.R.TextBox.FocusLost:Connect(function()
	if typeof(tonumber(script.Parent.R.TextBox.Text)) == "number" then
		-- = Color3.fromRGB(tonumber(script.Parent.R.TextBox.Text),string.split(tostring(CurrentColor.G * 255),".")[1],string.split(tostring(CurrentColor.B * 255),".")[1])
		ApplyColors()
	else
		script.Parent.R.TextBox.Text = string.split(tostring(CurrentColor),",")[1] * 255
	end
end)
script.Parent.G.TextBox.FocusLost:Connect(function()
	if typeof(tonumber(script.Parent.G.TextBox.Text)) == "number" then
		--CurrentColor = Color3.fromRGB(string.split(tostring(CurrentColor.R * 255),".")[1],tonumber(script.Parent.G.TextBox.Text),string.split(tostring(CurrentColor.B * 255),".")[1])
		ApplyColors()
	else
		script.Parent.G.TextBox.Text = string.split(tostring(CurrentColor),",")[2] * 255
	end
end)
script.Parent.B.TextBox.FocusLost:Connect(function()
	if typeof(tonumber(script.Parent.B.TextBox.Text)) == "number" then
		--CurrentColor = Color3.fromRGB(string.split(tostring(CurrentColor.R * 255),".")[1],string.split(tostring(CurrentColor.G * 255),".")[1],tonumber(script.Parent.B.TextBox.Text))
		ApplyColors()
	else
		script.Parent.B.TextBox.Text = string.split(tostring(CurrentColor),",")[3] * 255
	end
end)
script.Parent.Parent.Bottom.ColorPickerFrame.ColorShower:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
	CurrentColor = script.Parent.Parent.Bottom.ColorPickerFrame.ColorShower.BackgroundColor3
end)

