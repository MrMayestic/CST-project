local frame = script.Parent.Parent.RotateLR
local slider = script.Parent

local runService = game:GetService('RunService')
local UIS = game:GetService('UserInputService')

local plr = game.Players.LocalPlayer
local mouse = plr:GetMouse()

local camera = workspace.CurrentCamera

local boundaries = {}

local defaultSliderPos = slider.Position

local sterringToggle

local viewX
local sliderX,sliderY

local sizeDiffX,sizeDiffY

local leftBound,rightBound,upBound,downBound

local canDo = true

local myObj = nil

function calcBounds()
	viewX = camera.ViewportSize.X

	sliderX = frame.Position.X.Scale

	sizeDiffX = frame.Size.X.Scale

	leftBound = sliderX - (slider.Size.X.Scale/2)
	rightBound = sliderX + (sizeDiffX) - (slider.Size.X.Scale/2)

end

local currentXScale,currentYScale

local left,right,up,down

function sliderPosCalc()
	currentXScale = (myObj.Position.X/viewX)-(slider.Size.X.Scale/2)

	if currentXScale < leftBound then
		currentXScale = leftBound
	end
	if currentXScale > rightBound then
		currentXScale = rightBound
	end

	slider.Position = UDim2.new(currentXScale,0,slider.Position.Y.Scale,0)

end

UIS.InputEnded:Connect(function(inputObj)
	if (inputObj.UserInputType == Enum.UserInputType.MouseButton1 or inputObj.UserInputType == Enum.UserInputType.Touch) and inputObj == myObj then
		runService:UnbindFromRenderStep('sliderLRCalculating')
		wait()
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
		runService:BindToRenderStep('sliderLRCalculating',0.25,sliderPosCalc)
		table.insert(_G.SliderInputs,inputObj)
	end
end)