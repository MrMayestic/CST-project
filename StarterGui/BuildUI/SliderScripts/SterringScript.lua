local frame = script.Parent.Parent.CameraSterringSlider
local slider = script.Parent

_G.SliderInputs = {}

local runService = game:GetService('RunService')
local UIS = game:GetService('UserInputService')

local plr = game.Players.LocalPlayer
local mouse = plr:GetMouse()

local camera = workspace.CurrentCamera

local boundaries = {}

local defaultSliderPos = slider.Position

local sterringToggle

local viewX,viewY
local sliderX,sliderY

local sizeDiffX,sizeDiffY

local leftBound,rightBound,upBound,downBound

local canDo = true

local myObj = nil

function calcBounds()
	viewX,viewY = camera.ViewportSize.X,camera.ViewportSize.Y

	sliderX = frame.Position.X.Scale
	sliderY = frame.Position.Y.Scale

	sizeDiffX = frame.Size.X.Scale
	sizeDiffY = frame.Size.Y.Scale

	leftBound = sliderX - (slider.Size.X.Scale/2)
	rightBound = sliderX + (sizeDiffX) - (slider.Size.X.Scale/2)

	upBound = sliderY - (slider.Size.Y.Scale/2)
	downBound = sliderY + (sizeDiffY) - (slider.Size.Y.Scale/2)

end

local currentXScale,currentYScale

local left,right,up,down

function sliderPosCalc()
	currentXScale = (myObj.Position.X/viewX)-(slider.Size.X.Scale/2)
	currentYScale = (myObj.Position.Y/viewY)+(slider.Size.Y.Scale/2)

	if currentXScale < leftBound then
		currentXScale = leftBound
	end
	if currentXScale > rightBound then
		currentXScale = rightBound
	end

	if currentYScale < upBound then
		currentYScale = upBound
	end
	if currentYScale > downBound then
		currentYScale = downBound
	end

	slider.Position = UDim2.new(currentXScale,0,currentYScale,0)

end

UIS.InputEnded:Connect(function(inputObj)
	if (inputObj.UserInputType == Enum.UserInputType.MouseButton1 or inputObj.UserInputType == Enum.UserInputType.Touch) and inputObj == myObj then
		runService:UnbindFromRenderStep('sliderCalculating')
		task.wait()
		slider.Position = defaultSliderPos
		myObj = nil
		canDo = true
		table.remove(_G.SliderInputs,table.find(_G.SliderInputs,inputObj))
	end
end)

frame.InputBegan:Connect(function(inputObj)
	if (inputObj == myObj or not myObj) and canDo and not table.find(_G.SliderInputs,inputObj) then
		if not myObj then
			myObj = inputObj
		end
		canDo = false
		calcBounds()
		task.wait()
		runService:BindToRenderStep('sliderCalculating',0.25,sliderPosCalc)
		table.insert(_G.SliderInputs,inputObj)
	end
end)