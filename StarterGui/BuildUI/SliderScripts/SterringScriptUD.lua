local frame = script.Parent.Parent.RotateUD
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
	viewX,viewY = camera.ViewportSize.X,camera.ViewportSize.Y

	sliderX = frame.Position.X.Scale
	sliderY = frame.Position.Y.Scale

	sizeDiffX = frame.Size.X.Scale
	sizeDiffY = frame.Size.Y.Scale

	upBound = sliderY - (slider.Size.Y.Scale/2)
	downBound = sliderY + (sizeDiffY) - (slider.Size.Y.Scale/2)

end

local currentXScale,currentYScale

local left,right,up,down

function sliderPosCalc()

	currentXScale = (myObj.Position.X/viewX)-(slider.Size.X.Scale/2)
	currentYScale = (myObj.Position.Y/viewY)+(slider.Size.Y.Scale/2)

	if currentYScale < upBound then
		currentYScale = upBound
	end
	if currentYScale > downBound then
		currentYScale = downBound
	end

	slider.Position = UDim2.new(slider.Position.X.Scale,0,currentYScale,0)

end

UIS.InputEnded:Connect(function(inputObj)
	if (inputObj.UserInputType == Enum.UserInputType.MouseButton1 or inputObj.UserInputType == Enum.UserInputType.Touch) and inputObj == myObj then
		runService:UnbindFromRenderStep('sliderUDCalculating')
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
		runService:BindToRenderStep('sliderUDCalculating',0.25,sliderPosCalc)
		table.insert(_G.SliderInputs,inputObj)
	end
end)