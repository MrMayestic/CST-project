local cameraModule = {}

local plr = game.Players.LocalPlayer
local character = game.Workspace:WaitForChild(plr.Name)

local BuildUI = plr.PlayerGui:WaitForChild("BuildUI")
local sprintButton = BuildUI:WaitForChild("MoveModelMobile")

local frame = plr.PlayerGui.BuildUI:WaitForChild('CameraSterringSlider')
local slider = plr.PlayerGui.BuildUI:WaitForChild('Slider')

local sliderLR = plr.PlayerGui.BuildUI:WaitForChild('SliderLR')
local sliderUD = plr.PlayerGui.BuildUI:WaitForChild('SliderUD')

local frameSizeX,frameSizeY

local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local getPlot = game.ReplicatedStorage.Remotes.requestPlot
local plot

local bind

local camera = workspace.CurrentCamera
local cameraOffset = Vector3.new(2, 2, 8)

local CAS = game:GetService("ContextActionService")
local UIS = game:GetService("UserInputService")
local runService = game:GetService("RunService")

local plotType

local bindFrame = plr.PlayerGui.BuildUI:WaitForChild('BindFrame')

local errormodule = require(game.ReplicatedStorage.Modules.ErrorModule)

local currentButton = {}

_G.BuildInputs = {}

local isSystemOn = true

local currentMobileButton = nil

local currentCameraRot,currentTilt

local maxBack,maxFront,maxLeft,maxRight

--MOBILE VARs

local defaultSliderPos = slider.Position
local defaultSliderPosLR = sliderLR.Position
local defaultSliderPosUD = sliderUD.Position

local sliderInputBEGIN
local sliderInputEND
------------

local binds = {
	["ROTATELEFT"] = 1,
	["ROTATERIGHT"] = 2,
	["LOWERCAMERA"] = 3,
	["RAISECAMERA"] = 4,
	["ROTATEDOWN"] = 5,
	["ROTATEUP"] = 6,
}

--function that converts attribute of bind value to the KeyCode

function convert(input)
	if input == "1" then
		return Enum.KeyCode["One"]
	elseif input == "2" then
		return Enum.KeyCode["Two"]
	elseif input == "3" then
		return Enum.KeyCode["Three"]
	elseif input == "4" then
		return Enum.KeyCode["Four"]
	elseif input == "5" then
		return Enum.KeyCode["Five"]
	elseif input == "6" then
		return Enum.KeyCode["Six"]
	elseif input == "7" then
		return Enum.KeyCode["Seven"]
	elseif input == "8" then
		return Enum.KeyCode["Eight"]
	elseif input == "9" then
		return Enum.KeyCode["Nine"]
	elseif input == "0" then
		return Enum.KeyCode["Zero"]
	end
	return Enum.KeyCode[input]
end

--Function that update binds for camera system, like rotation of camera

local function updateBinds()
	for i,n in pairs(binds) do
		if bindFrame:FindFirstChild(tostring(i)):GetAttribute('Bind') ~= "" and bindFrame:FindFirstChild(tostring(i)):GetAttribute('Bind') ~= " " and 					bindFrame:FindFirstChild(tostring(i)):GetAttribute('Bind') ~= nil then
			binds[tostring(i)] = convert(bindFrame:FindFirstChild(tostring(i)):GetAttribute('Bind'))
		else
			binds[tostring(i)] = " "
		end
	end
end

--Function that calculates Fractions for each sides, based on cos and sin

local function returnFraction()
	-----Calculates the fractions to allow diagonally moves; Used in moveCamera()
	local x,z,x1,z1
	if currentButton then
		x1,z1 = math.cos(math.rad(currentCameraRot+90)),math.sin(math.rad(currentCameraRot+90))
		x,z = math.cos(math.rad(currentCameraRot)),math.sin(math.rad(currentCameraRot))
	else
		x1,z1 = math.cos(math.rad(currentCameraRot+90)),math.sin(math.rad(currentCameraRot+90))
		x,z = math.cos(math.rad(currentCameraRot)),math.sin(math.rad(currentCameraRot))
	end

	return z*-1,x*-1,z1*-1,x1*-1
end

-------------------------

--Function that checks boundaries based on defines at starting the system

local function checkBoundaries(position)
	if plotType == "std" then
		if position.X > maxLeft or position.X < maxRight or position.Z < maxBack or position.Z > maxFront then
			return false
		end
	else if plotType == "exd" then
			if position.X < maxLeft or position.X > maxRight or position.Z < maxFront or position.Z > maxBack then
				return false
			end
		end
	end
	return true
end

local updownworking = false

--Function that calculates Vector and adds it to camera position and handles rotations and all camera move
local function moveCameraMOBILE(what)
	if not isSystemOn then
		return
	end

	local V1Frac,V3Frac,U1Frac,U3Frac = returnFraction()

	wait()

	local addVector = Vector3.new(0,0,0)

	local XPerc = ((slider.Position.X.Scale + slider.Size.X.Scale/2) - frame.Position.X.Scale)/frame.Size.X.Scale
	local YPerc = ((slider.Position.Y.Scale + slider.Size.Y.Scale/2) - frame.Position.Y.Scale)/frame.Size.Y.Scale

	if YPerc < 0.47 then
		addVector += Vector3.new(0.5*V1Frac*(1-YPerc),0,0.5*V3Frac*(1-YPerc))
	elseif YPerc > 0.53 then
		addVector -= Vector3.new(0.5*V1Frac*YPerc,0,0.5*V3Frac*YPerc)
	end
	if XPerc < 0.42 then
		addVector += Vector3.new(0.5*U1Frac*(1-XPerc),0,0.5*U3Frac*(1-XPerc))
	elseif XPerc > 0.58  then
		addVector -= Vector3.new(0.5*U1Frac*XPerc,0,0.5*U3Frac*XPerc)	
	end

	local cameraRotAdd = 0
	local LRPerc = ((sliderLR.Position.X.Scale + sliderLR.Size.X.Scale/2) - BuildUI.RotateLR.Position.X.Scale)/BuildUI.RotateLR.Size.X.Scale

	if LRPerc < 0.47 then
		cameraRotAdd += (1 * (1-LRPerc))*2 - 1	
	elseif LRPerc > 0.53  then
		cameraRotAdd -= (1 * LRPerc)*2 - 1
	end

	local tiltToAdd = 0
	currentCameraRot += cameraRotAdd

	local UDPerc = ((sliderUD.Position.Y.Scale + sliderUD.Size.Y.Scale/2) - (BuildUI.RotateUD.Position.Y.Scale))/BuildUI.RotateUD.Size.Y.Scale

	if UDPerc < 0.43 then
		tiltToAdd -= (1 * (1-UDPerc))*2 - 1
	elseif UDPerc > 0.53  then
		tiltToAdd += (1 * UDPerc)*2-1
	end

	currentTilt += tiltToAdd

	if currentMobileButton then
		if currentMobileButton.Name == "Up" then
			if (camera.CFrame.Position+Vector3.new(0,0.25,0)).Y < 50 then
				addVector += Vector3.new(0,0.25,0)
			end
		elseif currentMobileButton.Name == "Down" then
			if (camera.CFrame.Position-Vector3.new(0,0.25,0)).Y > 5 then
				addVector -= Vector3.new(0,0.25,0)
			end
		end
	end

	local cameraPos = CFrame.new(camera.CFrame.Position+addVector)*CFrame.Angles(0,math.rad(currentCameraRot),0)
	cameraPos = cameraPos*CFrame.Angles(math.rad(currentTilt)*-1,0,0)
	if checkBoundaries(cameraPos.Position) then
		camera.CFrame = cameraPos
	end

end


local function moveCameraPC(step)
	if isSystemOn then
		--[[
		Layout for calculations
		
		MoveForward/Backword: V1,V3
		MoveLeft/MoveRight: V3,V1*-1
		]]
		local V1Frac,V3Frac,U1Frac,U3Frac = returnFraction() 
		wait()
		local addVector = Vector3.new(0,0,0)

		if currentButton  then
			if table.find(currentButton,Enum.KeyCode.W) then
				addVector += Vector3.new(0.5*V1Frac,0,0.5*V3Frac)
			end
			if table.find(currentButton,Enum.KeyCode.S) then
				addVector -= Vector3.new(0.5*V1Frac,0,0.5*V3Frac)
			end
			if table.find(currentButton,Enum.KeyCode.A) then
				addVector += Vector3.new(0.5*U1Frac,0,0.5*U3Frac)
			end
			if table.find(currentButton,Enum.KeyCode.D)  then
				addVector -= Vector3.new(0.5*U1Frac,0,0.5*U3Frac)
			end

			if table.find(currentButton,binds.ROTATERIGHT) then
				if table.find(currentButton,Enum.KeyCode.LeftControl) and table.find(currentButton,Enum.KeyCode.LeftShift) then
					currentCameraRot -= 1
					if currentCameraRot > 360 then
						currentCameraRot = 0
					end
					if currentCameraRot < 0 then
						currentCameraRot = 360
					end
				elseif table.find(currentButton,Enum.KeyCode.LeftControl) then
					if (camera.CFrame.Position+Vector3.new(0,0.25,0)).Y < 50 then
						addVector += Vector3.new(0,0.25,0)
					end
				elseif table.find(currentButton,Enum.KeyCode.LeftShift) then
					currentTilt -= 0.5
					if currentTilt > 360 then
						currentTilt = 0
					end
					if currentTilt < 0 then
						currentTilt = 360
					end
				else
					currentCameraRot -= 1
					if currentCameraRot > 360 then
						currentCameraRot = 0
					end
					if currentCameraRot < 0 then
						currentCameraRot = 360
					end
				end
			end

			if table.find(currentButton,binds.ROTATELEFT) then
				if table.find(currentButton,Enum.KeyCode.LeftControl) and table.find(currentButton,Enum.KeyCode.LeftShift) then
					currentCameraRot += 1
					if currentCameraRot > 360 then
						currentCameraRot = 0
					end
					if currentCameraRot < 0 then
						currentCameraRot = 360
					end
				elseif table.find(currentButton,Enum.KeyCode.LeftControl) then
					if (camera.CFrame.Position-Vector3.new(0,0.25,0)).Y > 5 then
						addVector -= Vector3.new(0,0.25,0)
					end
				elseif table.find(currentButton,Enum.KeyCode.LeftShift) then

					currentTilt += 0.5
					if currentTilt > 360 then
						currentTilt = 0
					end
					if currentTilt < 0 then
						currentTilt = 360
					end
				else
					currentCameraRot += 1
					if currentCameraRot > 360 then
						currentCameraRot = 0
					end
					if currentCameraRot < 0 then
						currentCameraRot = 360
					end
				end
			end
			local cameraPos = CFrame.new(camera.CFrame.Position+addVector)*CFrame.Angles(0,math.rad(currentCameraRot),0)
			cameraPos = cameraPos*CFrame.Angles(math.rad(currentTilt)*-1,0,0)
			if checkBoundaries(cameraPos.Position) then
				camera.CFrame = cameraPos
			end
		end
	end
end

--To stop the system

local function cameraSystemStop(toggle)
	isSystemOn = false
	if not toggle then
		camera.CameraType = Enum.CameraType.Custom
	end
	wait()
	table.clear(currentButton)
	CAS:UnbindAction("playerInputW")
	CAS:UnbindAction("playerInputA")
	CAS:UnbindAction("playerInputS")
	CAS:UnbindAction("playerInputD")
	CAS:UnbindAction("playerInputLEFT")
	CAS:UnbindAction("playerInputRIGHT")

	CAS:UnbindAction("playerInputCTRL")
	CAS:UnbindAction("playerInputSHIFT")

	CAS:UnbindAction("playerInputLOWERCAM")
	CAS:UnbindAction("playerInputRAISECAM")
	CAS:UnbindAction("playerInputROTUP")
	CAS:UnbindAction("playerInputROTDOWN")

	CAS:UnbindAction("playerMobile")

	runService:UnbindFromRenderStep("moveCamera")

	if UIS.TouchEnabled then
		BuildUI.MobileCameraButtons:ClearAllChildren()

		plr.PlayerGui:FindFirstChild("ContextActionGui").ContextButtonFrame.Sprint.Visible = true
		plr.PlayerGui:FindFirstChild("TouchGui").TouchControlFrame.JumpButton.Visible = true

		CAS:UnbindAction("goUp")
		CAS:UnbindAction("goDown")

		pcall(function()
			sliderInputBEGIN:Disconnect()
			sliderInputEND:Disconnect()
		end)
	end
	humanoid.AutoRotate = true
end

local function playerMobile(actionName, inputState, inputObject)
	if isSystemOn then
		if inputState == Enum.UserInputState.End then
			runService:UnbindFromRenderStep("moveCamera")
		else
			runService:BindToRenderStep("moveCamera",0.3,moveCameraMOBILE)
		end
	end
end


--Function handler for playerInputs

local function playerInput(actionName, inputState, inputObject)
	if isSystemOn then
		if inputState == Enum.UserInputState.Begin then
			if #currentButton == 0 then
				runService:BindToRenderStep("moveCamera",0.3,moveCameraPC)
			end
			table.insert(currentButton,inputObject.KeyCode)
		elseif inputState == Enum.UserInputState.End then
			if table.find(currentButton,inputObject.KeyCode) then
				table.remove(currentButton,table.find(currentButton,inputObject.KeyCode))
			end
			if #currentButton == 0 then
				runService:UnbindFromRenderStep("moveCamera")
			end
		end
	end
end





--Function that starts the system

local function cameraSystemStart()	
	cameraSystemStop(true)
	wait()

	if camera.CameraType ~= Enum.CameraType.Scriptable then
		camera.CameraType = Enum.CameraType.Scriptable
	end

	humanoid.AutoRotate = false

	for i, plt in pairs(workspace.Plots:GetChildren()) do
		task.wait()
		if plt.wazne.Owner.Value == plr.Name then
			plot = plt
		end
	end

	task.wait()

	plot = plot.Plot

	if not plot then
		errormodule.errorfuncGo(plr,"Something went wrong while setting build system camera. Please try again.")
		cameraSystemStop()
		return false
	end

	currentCameraRot = math.abs(plot.Orientation.Y)

	defaultSliderPos = slider.Position

	local cameraPos

	if currentCameraRot == 0 then
		plotType = "std"
		currentCameraRot = 180
		currentTilt = 35
		cameraPos = CFrame.new(plot.Position+Vector3.new(0,14,-45))*CFrame.Angles(math.rad(currentTilt),math.rad(currentCameraRot),0)

		maxBack = plot.Position.Z - 100
		maxFront = plot.Position.Z + 150
		maxLeft = plot.Position.X + 100
		maxRight = plot.Position.X - 100
	else
		plotType = "exd"
		currentCameraRot = 0
		currentTilt = 35
		cameraPos = CFrame.new(plot.Position+Vector3.new(0,14,45))*CFrame.Angles(math.rad(currentTilt*-1),math.rad(currentCameraRot),0)

		maxBack = plot.Position.Z + 100
		maxFront = plot.Position.Z - 150
		maxLeft = plot.Position.X - 100
		maxRight = plot.Position.X + 100
	end
	camera.CFrame = cameraPos

	if UIS.TouchEnabled then
		local BuildUI = plr.PlayerGui.BuildUI

		frameSizeX = frame.Size.X.Scale
		frameSizeY = frame.Size.Y.Scale

		local Yperc = workspace.Camera.ViewportSize.X/workspace.Camera.ViewportSize.Y

		local sizeX = ((workspace.Camera.ViewportSize.X * 44)/1080)/workspace.Camera.ViewportSize.X
		local sizeY = sizeX * Yperc


		local upButton = BuildUI.MobileButton:Clone()
		upButton.Size = UDim2.new(sizeX,0,sizeY,0)
		upButton.Position = UDim2.new(0.83, 0,0.615, 0)
		upButton.Name = "Up"
		upButton.Text = "Up"
		upButton.Parent = BuildUI.MobileCameraButtons
		upButton.Visible = true

		local downButton = BuildUI.MobileButton:Clone()
		downButton.Size = UDim2.new(sizeX,0,sizeY,0)
		downButton.Position = UDim2.new(0.83, 0,0.74, 0)
		downButton.Name = "Down"
		downButton.Text = "Down"
		downButton.Parent = BuildUI.MobileCameraButtons
		downButton.Visible = true

		bind = false

		sliderInputBEGIN = UIS.InputBegan:Connect(function(inputObj)
			if isSystemOn then
				if inputObj.UserInputType == Enum.UserInputType.Touch then
					if not bind then
						runService:BindToRenderStep("moveCamera",0.3,moveCameraMOBILE)
						bind = true
					end
					if not table.find(_G.BuildInputs,inputObj) then
						table.insert(_G.BuildInputs,inputObj)
					end
				end
			end
		end) 
			and upButton.InputBegan:Connect(function(inputObj)
				if isSystemOn then
				if inputObj.UserInputType == Enum.UserInputType.Touch then
					if not table.find(_G.BuildInputs,inputObj) then
						table.insert(_G.BuildInputs,inputObj)
						currentMobileButton = upButton
					end
					if not bind then
						runService:BindToRenderStep("moveCamera",0.3,moveCameraMOBILE)
						bind = true
					end
				end
			end
			end)
			and downButton.InputBegan:Connect(function(inputObj)
				if isSystemOn then
				if inputObj.UserInputType == Enum.UserInputType.Touch then
					if not table.find(_G.BuildInputs,inputObj) then
						table.insert(_G.BuildInputs,inputObj)
						currentMobileButton = downButton
					end
					if not bind then
						runService:BindToRenderStep("moveCamera",0.3,moveCameraMOBILE)
						bind = true
					end
				end
			end
			end)


		sliderInputEND = UIS.InputEnded:Connect(function(inputObj)
			if inputObj.UserInputType == Enum.UserInputType.Touch then
				if #_G.BuildInputs == 1 then
					runService:UnbindFromRenderStep("moveCamera")
					bind = false
					slider.Position = defaultSliderPos
					sliderLR.Position = defaultSliderPosLR
					sliderUD.Position = defaultSliderPosUD
				end

				if currentMobileButton then
					currentMobileButton = nil
				end
				
				table.remove(_G.BuildInputs,table.find(_G.BuildInputs,inputObj))
				
			end
		end)

		plr.PlayerGui.ContextActionGui.ContextButtonFrame.Sprint.Visible = false
		plr.PlayerGui:FindFirstChild("TouchGui").TouchControlFrame.JumpButton.Visible = false
	else
		updateBinds()
		wait()
		CAS:BindAction("playerInputW",playerInput,false,Enum.KeyCode.W)
		CAS:BindAction("playerInputA",playerInput,false,Enum.KeyCode.A)
		CAS:BindAction("playerInputS",playerInput,false,Enum.KeyCode.S)
		CAS:BindAction("playerInputD",playerInput,false,Enum.KeyCode.D)
		CAS:BindAction("playerInputLEFT",playerInput,false,binds.ROTATELEFT)
		CAS:BindAction("playerInputRIGHT",playerInput,false,binds.ROTATERIGHT)

		if bindFrame.SwitchCTRL:GetAttribute('isOn') then
			CAS:BindAction("playerInputCTRL",playerInput,false,Enum.KeyCode.LeftControl)
		else
			if binds.LOWERCAMERA ~= " " then
				CAS:BindAction("playerInputLOWERCAM",playerInput,false,binds.LOWERCAMERA)
			end
			if binds.RAISECAMERA ~= " " then
				CAS:BindAction("playerInputRAISECAM",playerInput,false,binds.RAISECAMERA)
			end
		end
		if bindFrame.SwitchCTRL:GetAttribute('isOn') then
			CAS:BindAction("playerInputSHIFT",playerInput,false,Enum.KeyCode.LeftShift)
		else
			if binds.ROTATEUP ~= " " then
				CAS:BindAction("playerInputROTUP",playerInput,false,binds.ROTATEUP)
			end
			if binds.ROTATEDOWN ~= " " then
				CAS:BindAction("playerInputROTDOWN",playerInput,false,binds.ROTATEDOWN)
			end
		end
	end
	isSystemOn = true
end

function cameraModule:start()
	cameraSystemStart()
end

function cameraModule:stop()
	cameraSystemStop()
end


return cameraModule
