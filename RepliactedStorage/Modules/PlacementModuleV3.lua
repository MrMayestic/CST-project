--[[

Written by zblox164. Initial release (V1.0) on 2020-05-22

Change log:

2020-05-22 V1.0 - Details:
	- The module has been released.
2020-05-24 V1.1 - Details:
	- Fixed bugs
	- Improved snapping
	- Added Placement cooldowns
2020-05-26 V1.11 Details:
	- Fixed bugs
2020-06-15 V1.11
	- Released YouTube tutorial
2020-07-07 V1.12 - Details:
	- Fixed bugs
2020-07-15 V1.13 - Details;
	- Optimized math (now uses x * 0.5 instead of x / 2)
	- Code is more readable as a result of comments
	- Added a maxRange variable which controls how far the model can be placed from the character
2020-07-28 V1.14 - Details:
	- Added better round function
	- Improved input (now uses ContextActionService instead of UserInputService)
2020-07-30 V1.15 - Details:
	- Fixed a problem where keybinds were set automaticly and not by the user
2020-08-01 V1.16 - Details:
	- Fixed issue where exploters could leave the plot
	- Minor improvements to code readability
2020-08-02 V1.17 - Details:
	- Improved accuracy when moving models
	- Minor improvements and bug fixes
2020-10-03 V1.18 - Details:
	- Improved timing when starting placement; models will instantly be at the mouse position when activating placement
	- Fixed major bugs: Terminate function should no longer error. Activate function should no longer produce errors
	- Typo fixes
	- Minor improvements and fixes
2020-10-04 V1.19 - Details:
	- Added new setting, "instantActivation". See the description of it below
	- Added new selection box feature. You can now toggle a selection box around your model when placing
	- Added gridFadeIn and gridFadeOut toggles. See the description of it below
	- Minor improvements and fixes
	- Typo fixes
2020-10-06 V1.20 - Details
	- Urgent and critical bug fixed
	- Added collision color support for selection boxes
	- Fixed issue with the module not resetting target filter
	- Added thumbnail
	
For API and FAQ go to the extras script.

]]--

-- SETTINGS

-- Bools

local remote
local interpolation = true -- Toggles interpolation (smoothing)
local moveByGrid = true -- Toggles grid system
local collisions = true -- Toggles collisions
local buildModePlacement = true -- Toggles "build mode" placement
local displayGridTexture = true -- Toggles the grid texture to be shown when placing
local smartDisplay = true -- Toggles smart display for the grid. If true, it will rescale the grid texture to match your gridsize
local enableFloors = true -- Toggles if the raise and lower keys will be enabled
local transparentModel = true -- Toggles if the model itself will be transparent
local instantActivation = true -- Toggles if the model will appear at the mouse position immediately when activating placement
local includeSelectionBox = true -- Toggles if a selection box will be shown while placing
local gridFadeIn = true -- If you want the grid to fade in when activating placement
local gridFadeOut = true -- If you want the grid to fade out when ending placement
-- Color3
local oldHit
local uisEnded
local errormodule = require(game.ReplicatedStorage.Modules.ErrorModule)
local collisionColor = Color3.fromRGB(255, 75, 75) -- Color of the hitbox when colliding
local hitboxColor = Color3.fromRGB(75, 255, 75) -- Color of the hitbox while not colliding
local selectionColor = Color3.fromRGB(0, 255, 0) -- Color of the selectionBox lines (includeSelectionBox much be set to "true")
local selectionCollisionColor = Color3.fromRGB(255, 0, 0) -- Color of the selectionBox lines when colliding (includeSelectionBox much be set to "true")
-- Integers
local maxHeight = 15 -- Max height you can place objects (in studs)
local floorStep = 5 -- The step (in studs) that the object will be raised or lowered
local rotationStep = 90 -- Rotation step
-- Numbers/Floats
local hitboxTransparency = 1 -- Hitbox transparency when placing
local transparencyDelta = 0 -- Transparency of the model itself (transparentModel must equal true)
local lerpSpeed = 0.2 -- speed of interpolation. 0 = no interpolation, 0.9 = major interpolation
local placementCooldown = 0.25 -- How quickly the user can place down objects (in seconds)
local maxRange = 100 -- Max range for the model (in studs)
local lineThickness = 0.05 -- How thick the line of the selection box is (includeSelectionBox much be set to "true")
local lineTransparency = 0.5 -- How transparent the line of the selection box is (includeSelectionBox must be set to "true")
local check = true
-- Other
local gridTexture = "rbxassetid://2415319308"

-- DO NOT EDIT PAST THIS POINT UNLESS YOU KNOW WHAT YOUR DOING.
local can = true
local lockToggle = false

local camera = workspace.CurrentCamera
local worldPoint
local vector, onScreen

local placement = {}

local moveToggleGlobal
local copyToggleGlobal
local gridKeyGlobal

placement.__index = placement

-- Essentials
local runService = game:GetService("RunService")
local contextActionService = game:GetService("ContextActionService")
local UIS = game:GetService("UserInputService")

local player = game.Players.LocalPlayer
local changeGrid = player.PlayerGui.BuildUI.ChangeGrid
local changeHideness = player.PlayerGui.BuildUI.ChangeHideness
local changeDayNight = player.PlayerGui.BuildUI.ChangeDayNight
local dayNightToggle = false

local character = player.Character or player.CharacterAdded:Wait()
local mouse = player:GetMouse()	
local moveModelButton

-- math/cframe functions
local clamp = math.clamp
local floor = math.floor
local ceil = math.ceil
local abs = math.abs
local min = math.min
local pi = math.pi

local cframe = CFrame.new
local anglesXYZ = CFrame.fromEulerAnglesXYZ

-- states
local states = {
	"movement",
	"placing",
	"colliding",
	"in-active",
	"out-of-range"
}

local currentState = 4
local lastState = 4

-- Constructor variables
local HIDE_UNIT = "ceil"
local GRID_UNIT = 1
local itemLocation
local rotateKey
local terminateKey
local raiseKey
local lowerKey
local placeKey

-- Activation variables
local plot
local object

local BuildUI = player.PlayerGui:WaitForChild("BuildUI")

moveModelButton = BuildUI:WaitForChild("MoveModelMobile")

-- bools
local canActivate = true
local currentRot = false
local canPlace
local isColliding
local stackable
local smartRot
local range

-- values used for calculations
local speed = 0.1
local preSpeed = 0.1

local posX
local posY
local posZ
local rot = 0
local objRot
local x, z
local cx, cz

local LOWER_X_BOUND
local UPPER_X_BOUND

local LOWER_Z_BOUND
local UPPER_Z_BOUND

local initialY

-- collision variables
local collisionPoints
local collisionPoint
local collided

-- other
local placedObjects
local loc
local primary
local selection
local lastPlacement = {}
local humanoid = character:WaitForChild("Humanoid")

local mouseHit = mouse.Hit
local radX,radY = workspace.CurrentCamera.CFrame:ToOrientation()
local s,c = math.sin(radY)*-1,math.cos(radY)*-1
-- Sets the current state depending on input of function
local function setCurrentState(state)
	currentState = clamp(state, 1, 5)
	lastState = currentState
end

local PlotsStd = {"Plot1","Plot2","Plot3","Plot4"}
local PlotsRoz = {"Plot5","Plot6","Plot7","Plot8"}

function ReturnPlot(plotS)

	for i,n in pairs(PlotsStd) do
		if n == plotS then
			return "std"
		end
	end
	for i,n in pairs(PlotsRoz) do
		if n == plotS then
			return "roz"
		end
	end
end



-- Changes the color of the hitbox depending on the current state
local function editHitboxColor()
	if primary and object then
		if currentState >= 3 then
			--primary.Color = collisionColor
			selection.Color3 = selectionCollisionColor
		else

			--primary.Color = hitboxColor
			selection.Color3 = selectionColor
		end
	end
end

-- Checks to see if the model is in range of the maxRange
local function getRange()
	return ((primary.Position - character.PrimaryPart.Position).Magnitude) - 150
end

-- Checks for collisions on the hitbox (credit EgoMoose)
local function checkHitbox()
	if object and collisions then
		if range then
			setCurrentState(5)
		else
			setCurrentState(1)
		end

		collisionPoint = object.PrimaryPart.Touched:Connect(function() end)
		collisionPoints = object.PrimaryPart:GetTouchingParts()

		-- Checks if there is collision on any object that is not a child of the object and is not a child of the player
		for i = 1, #collisionPoints do
			if not collisionPoints[i]:IsDescendantOf(object) and not collisionPoints[i]:IsDescendantOf(character) and not string.match(collisionPoints[i].Name,"index") and collisionPoints[i].Name ~= "SoundPart" and not collisionPoints[i].Parent:GetAttribute("beingMoved") and not collisionPoints[i].Parent.Parent:GetAttribute("beingMoved") and collisionPoints[i].Name ~= "BuildPlot" then
				setCurrentState(3)
				break
			end
		end

		collisionPoint:Disconnect()

		return collided
	end
end

local function raiseFloor(actionName, inputState, inputObj,value)
	if currentState ~= 4 and inputState == Enum.UserInputState.Begin then
		if enableFloors and not stackable then
			if not value then
				posY = posY + floor(abs(floorStep))
				posY = clamp(posY, initialY, maxHeight + initialY)
				--if object.Name == "Light" then
				--	plot.Parent.BuildPlot.Position = Vector3.new(plot.Parent.BuildPlot.Position.X,posY - (primary.Size.Y * 0.5) - floorStep,plot.Parent.BuildPlot.Position.Z)
				--else
				--	plot.Parent.BuildPlot.Position = Vector3.new(plot.Parent.BuildPlot.Position.X,posY - (primary.Size.Y* 0.5),plot.Parent.BuildPlot.Position.Z)
				--end
			end
		end
	end
	--can = true
end

local function lowerFloor(actionName, inputState, inputObj)
	if currentState ~= 4 and inputState == Enum.UserInputState.Begin  then
		if enableFloors and not stackable then
			posY = posY - floor(abs(floorStep))
			posY = clamp(posY, initialY, maxHeight + initialY)
			--if object.Name == "Light" then
			--	plot.Parent.BuildPlot.Position = Vector3.new(plot.Parent.BuildPlot.Position.X,posY - (primary.Size.Y* 0.5) - floorStep,plot.Parent.BuildPlot.Position.Z)
			--else
			--	plot.Parent.BuildPlot.Position = Vector3.new(plot.Parent.BuildPlot.Position.X,posY - (primary.Size.Y* 0.5),plot.Parent.BuildPlot.Position.Z)
			--end
		end
	end
end

-- handles the grid texture
local function displayGrid()
	if displayGridTexture then

		for i=1,5 do
			local indexV = Instance.new("Part")
			indexV.Name = "indexV"
			indexV.Material = Enum.Material.Neon
			indexV.BrickColor = BrickColor.new("Lily white")
			indexV.Size = Vector3.new(0.15,0.1,plot.Size.Z)
			if i == 1 then
				indexV.Position = plot.Position + Vector3.new(0,0.485,0)
			elseif i == 2 then
				indexV.Position = plot.Position + Vector3.new(plot.Size.X* 0.5,0.485,0)
			elseif i == 3 then
				indexV.Position = plot.Position + Vector3.new((plot.Size.X* 0.5)*-1,0.485,0)
			elseif i == 4 then
				indexV.Position = plot.Position + Vector3.new(plot.Size.X* 0.25,0.485,0)
			elseif i == 5 then
				indexV.Position = plot.Position + Vector3.new((plot.Size.X* 0.25)*-1,0.485,0)
			end
			indexV.Anchored = true
			indexV.CanCollide = false
			indexV.Parent = plot
		end
		for i=1,5 do
			local indexH = Instance.new("Part")
			indexH.Name = "indexH"
			indexH.Material = Enum.Material.Neon
			indexH.BrickColor = BrickColor.new("Lily white")
			indexH.Size = Vector3.new(plot.Size.X,0.1,0.15)
			if i == 1 then
				indexH.Position = plot.Position + Vector3.new(0,0.485,0)
			elseif i == 2 then
				indexH.Position = plot.Position + Vector3.new(0,0.485,plot.Size.X* 0.5)
			elseif i == 3 then
				indexH.Position = plot.Position + Vector3.new(0,0.485,(plot.Size.X* 0.5)*-1)
			elseif i == 4 then
				indexH.Position = plot.Position + Vector3.new(0,0.485,plot.Size.X* 0.25)
			elseif i == 5 then
				indexH.Position = plot.Position + Vector3.new(0,0.485,(plot.Size.X* 0.25)*-1)
			end
			indexH.Anchored = true
			indexH.CanCollide = false
			indexH.Parent = plot
		end

		local gridTex = Instance.new("Texture")

		gridTex.Name = "GridTexture"
		gridTex.Texture = gridTexture
		gridTex.Face = Enum.NormalId.Top
		gridTex.Transparency = 1

		gridTex.StudsPerTileU = 2
		gridTex.StudsPerTileV = 2

		if smartDisplay then
			gridTex.StudsPerTileU = GRID_UNIT
			gridTex.StudsPerTileV = GRID_UNIT	
		end

		if gridFadeIn then
			spawn(function()
				for i = 1, 0, -0.1 do
					if currentState ~= 4 then
						gridTex.Transparency = i
					end
				end
			end)
		else
			gridTex.Transparency = 0
		end

		gridTex.Parent = plot
		wait()
		for i,n in pairs(plot:GetChildren()) do
			if not string.match(n.Name,"index") and n.Name ~= "GridTexture" then
				for i=1,5 do
					local indexV = Instance.new("Part")
					indexV.Name = "indexV"
					indexV.Material = Enum.Material.Neon
					indexV.BrickColor = BrickColor.new("Lily white")
					indexV.Size = Vector3.new(0.15,0.1,n.Size.Z)
					if i == 1 then
						indexV.Position = n.Position + Vector3.new(0,0.485,0)
					elseif i == 2 then
						indexV.Position = n.Position + Vector3.new(n.Size.X* 0.5,0.485,0)
					elseif i == 3 then
						indexV.Position = n.Position + Vector3.new((n.Size.X* 0.5)*-1,0.485,0)
					elseif i == 4 then
						indexV.Position = n.Position + Vector3.new(n.Size.X* 0.25,0.485,0)
					elseif i == 5 then
						indexV.Position = n.Position + Vector3.new((n.Size.X* 0.25)*-1,0.485,0)
					end
					indexV.Anchored = true
					indexV.CanCollide = false
					indexV.Parent = n
				end
				for i=1,5 do
					local indexH = Instance.new("Part")
					indexH.Name = "indexH"
					indexH.Material = Enum.Material.Neon
					indexH.BrickColor = BrickColor.new("Lily white")
					indexH.Size = Vector3.new(n.Size.X,0.1,0.15)
					if i == 1 then
						indexH.Position = n.Position + Vector3.new(0,0.485,0)
					elseif i == 2 then
						indexH.Position = n.Position + Vector3.new(0,0.485,n.Size.X* 0.5)
					elseif i == 3 then
						indexH.Position = n.Position + Vector3.new(0,0.485,(n.Size.X* 0.5)*-1)
					elseif i == 4 then
						indexH.Position = n.Position + Vector3.new(0,0.485,n.Size.X* 0.25)
					elseif i == 5 then
						indexH.Position = n.Position + Vector3.new(0,0.485,(n.Size.X* 0.25)*-1)
					end
					indexH.Anchored = true
					indexH.CanCollide = false
					indexH.Parent = n
				end

				local gridTex2 = Instance.new("Texture")

				gridTex2.Name = "GridTexture"
				gridTex2.Texture = gridTexture
				gridTex2.Face = Enum.NormalId.Top
				gridTex2.Transparency = 1

				gridTex2.StudsPerTileU = 2
				gridTex2.StudsPerTileV = 2

				if smartDisplay then
					gridTex2.StudsPerTileU = GRID_UNIT
					gridTex2.StudsPerTileV = GRID_UNIT	
				end

				if gridFadeIn then
					spawn(function()
						for i = 1, 0, -0.1 do
							if currentState ~= 4 then
								gridTex2.Transparency = i
							end
						end
					end)
				else
					gridTex2.Transparency = 0
				end

				gridTex2.Parent = n
			end
		end
	end
end



-- Rounds any number to the nearest integer (credit iGottic)
local function round(number)
	local decimal_placement = 4

	return (number % (1/decimal_placement) > 1/decimal_placement*0.5) and ceil(number*decimal_placement)/decimal_placement or floor(number*decimal_placement)/decimal_placement
end

-- Calculates the Y position to be ontop of the plot (all objects) and any object (when stacking)
local function calculateYPos(tp, ts, o)
	return (tp + ts*0.5) + o*0.5
end

local ileL
local ileC
local ileR

local function onWhich(x,z,toggle)
	local ktory
	local tejbulX
	--x = x+5
	---------USTALENIE DZIAŁEK W OSI X
	if ileR > 0 and ileL==0 then
		if check then
			tejbulX = {plot.PlotR1,plot}
		else
			tejbulX = {plot,plot.PlotR1}
		end
	elseif ileL > 0 and ileR == 0 then
		if check then
			tejbulX = {plot,plot.PlotL1}
		else
			tejbulX = {plot.PlotL1,plot}
		end
	elseif ileR> 0 and ileL>0 then
		if check then
			tejbulX = {plot.PlotR1,plot,plot.PlotL1}
		else
			tejbulX = {plot.PlotL1,plot,plot.PlotR1}
		end
	else
		tejbulX = {plot}
	end

	local primaryPos = primary.Position.X


	if not toggle then
		for i,n in pairs(tejbulX) do
			if primaryPos >= n.Position.X - n.Size.X * 0.5 then
				ktory = n
			end
		end

		if ktory == nil then
			ktory = plot
		end
		------USTALENIE OSI Y

		local name = ktory.Name
		local tejbulZ = {}
		if string.match(name,"PlotR") then
			for i=1,ileR do
				table.insert(tejbulZ,i,ktory.Parent:FindFirstChild("PlotR"..i))
			end
			for i,n in pairs(tejbulZ) do
				if check then
					if z >= n.Position.Z - n.Size.Z * 0.5 then--and z<= n.Position.Z + n.Size.Z/2 and z>= n.Position.Z - n.Size.Z/2 then
						ktory = n
					end
				else
					if z <= n.Position.Z + n.Size.Z * 0.5 then--and z<= n.Position.Z + n.Size.Z/2 and z>= n.Position.Z - n.Size.Z/2 then
						ktory = n
					end
				end
			end

		elseif string.match(name,"PlotL") then
			for i=1,ileL do
				table.insert(tejbulZ,i,ktory.Parent:FindFirstChild("PlotL"..i))
			end
			for i,n in pairs(tejbulZ) do
				if check then
					if z >= n.Position.Z - n.Size.Z * 0.5 then--and z<= n.Position.Z + n.Size.Z/2 and z>= n.Position.Z - n.Size.Z/2 then
						ktory = n
					end
				else
					if z <= n.Position.Z + n.Size.Z * 0.5 then--and z<= n.Position.Z + n.Size.Z/2 and z>= n.Position.Z - n.Size.Z/2 then
						ktory = n
					end
				end
			end
		else
			--tejbulZ = {plot,plot.PlotC2}
			for i=1,ileC do
				if ktory:FindFirstChild("PlotC"..i) then
					table.insert(tejbulZ,i+1,ktory:FindFirstChild("PlotC"..i))
				else
					table.insert(tejbulZ,i+1,ktory.Parent:FindFirstChild("PlotC"..i))
				end
			end
			for i,n in pairs(tejbulZ) do
				if check then
					if z >= n.Position.Z - n.Size.Z * 0.5 then--and z<= n.Position.Z + n.Size.Z/2 and z>= n.Position.Z - n.Size.Z/2 then
						ktory = n
					end
				else
					if z <= n.Position.Z + n.Size.Z * 0.5 then--and z<= n.Position.Z + n.Size.Z/2 and z>= n.Position.Z - n.Size.Z/2 then
						ktory = n
					end
				end
			end
		end

		return ktory
	end
end

---------FUNKCJE ZWRACAJĄCE WARTOŚCI DO BOUNDS()


local function returnX(mPlt)
	local zwroc = mPlt.Position.X
	local name = mPlt.Name
	if string.match(name,"PlotR") then
		if ileC >= tonumber(string.sub(name,6,6)) then
			local plotex = mPlt.Parent
			zwroc += plotex.Position.X
			if ileL >= ileR then
				local plotex = mPlt.Parent:FindFirstChild("PlotL"..string.sub(name,6,6))
				zwroc += plotex.Position.X
				zwroc = zwroc/3
			else
				zwroc = zwroc * 0.5
			end
		end
	elseif string.match(name,"PlotL") then
		if ileC >= tonumber(string.sub(name,6,6)) then
			local plotex = mPlt.Parent
			zwroc += plotex.Position.X
			if ileR >= ileL then
				local plotex = mPlt.Parent:FindFirstChild("PlotR"..string.sub(name,6,6))
				zwroc += plotex.Position.X
				zwroc = zwroc/3
			else
				zwroc = zwroc * 0.5
			end
		end

	else --if string.match(name,"PlotC") then
		if string.match(name,"PlotC") then
			if ileL >= tonumber(string.sub(name,6,6)) then
				local plotex = mPlt.Parent:FindFirstChild("PlotL"..string.sub(name,6,6))
				zwroc += plotex.Position.X
			end
			if ileR >= tonumber(string.sub(name,6,6)) then
				local plotex = mPlt.Parent:FindFirstChild("PlotR"..string.sub(name,6,6))
				zwroc += plotex.Position.X
			end
			if ileR >= tonumber(string.sub(name,6,6)) and ileL >= tonumber(string.sub(name,6,6)) then
				zwroc = zwroc/3
			elseif ileL < tonumber(string.sub(name,6,6)) and ileR < tonumber(string.sub(name,6,6)) then
				wait()
			else
				zwroc = zwroc * 0.5
			end
		else
			if ileL >= 1 then
				local plotex = mPlt:FindFirstChild("PlotL"..1)
				zwroc += plotex.Position.X
			end
			if ileR >= 1 then
				local plotex = mPlt:FindFirstChild("PlotR"..1)
				zwroc += plotex.Position.X
			end
			if ileR >= 1 and ileL >= 1 then
				zwroc = zwroc/3
			elseif ileL==ileR and ileL==0 then
				wait()
			else
				zwroc = zwroc * 0.5
			end
		end

	end

	return zwroc
end

local function returnZ(mPlt)
	local zwrocZ = 0
	local name = mPlt.Name

	if string.match(name,"PlotR") then
		for i=1,ileR do

			zwrocZ += mPlt.Parent:FindFirstChild("PlotR"..i).Position.Z
		end
		zwrocZ = zwrocZ/ileR
	elseif string.match(name,"PlotL") then
		for i=1,ileL do
			zwrocZ += mPlt.Parent:FindFirstChild("PlotL"..i).Position.Z
		end
		zwrocZ = zwrocZ/ileL
	elseif not string.match(name,"PlotR") and not string.match(name,"PlotL") and not string.match(name,"PlotC") then
		for i=1,ileC do
			if i==1 then
				zwrocZ += mPlt.Position.Z
			else
				zwrocZ += mPlt:FindFirstChild("PlotC"..i).Position.Z
			end
		end
		zwrocZ = zwrocZ/ileC
	else
		for i=1,ileC do
			if ileC == 1 and i==ileC or i==1 then
				zwrocZ += mPlt.Parent.Position.Z
			else
				local check = mPlt.Parent:FindFirstChild("PlotC"..i)
				if check then
					zwrocZ += check.Position.Z
				end
			end
		end
		zwrocZ = zwrocZ/ileC
	end
	return zwrocZ
end

local function returnSizeZ(mPlt)
	local zwrocSZ = 0
	local name = mPlt.Name
	if string.match(name,"PlotR") then
		for i=1,ileR do
			zwrocSZ += mPlt.Parent:FindFirstChild("PlotR"..i).Size.Z
		end
	elseif string.match(name,"PlotL") then
		for i=1,ileL do
			zwrocSZ += mPlt.Parent:FindFirstChild("PlotL"..i).Size.Z
		end
	elseif not string.match(name,"PlotR") and not string.match(name,"PlotL") and not string.match(name,"PlotC") then
		for i=1,ileC do
			if i == 1 then
				zwrocSZ += mPlt.Size.Z
			else
				zwrocSZ += mPlt:FindFirstChild("PlotC"..i).Size.Z
			end
		end
	else
		for i=1,ileC do
			if ileC == 1 and i==ileC or i==1 then
				zwrocSZ += mPlt.Parent.Size.Z
			else
				local check = mPlt.Parent:FindFirstChild("PlotC"..i)
				if check then
					zwrocSZ += check.Size.Z
				end
			end
		end
	end
	return zwrocSZ
end

local function returnSizeX(mPlt)
	local zwrocS = mPlt.Size.X
	local name = mPlt.Name
	if string.match(name,"PlotR") then
		if ileC >= tonumber(string.sub(name,6,6)) then
			local plotex = mPlt.Parent
			zwrocS += plotex.Size.X
			if ileL >= ileR then
				local plotex = mPlt.Parent:FindFirstChild("PlotL"..string.sub(name,6,6))
				zwrocS += plotex.Size.X
			end
		end
	elseif string.match(name,"PlotL") then
		if ileC >= tonumber(string.sub(name,6,6)) then
			local plotex = mPlt.Parent
			zwrocS += plotex.Size.X
			if ileR >= ileL then
				local plotex = mPlt.Parent:FindFirstChild("PlotR"..string.sub(name,6,6))
				zwrocS += plotex.Size.X
			end
		end
	elseif not string.match(name,"PlotR") and not string.match(name,"PlotL") and not string.match(name,"PlotC") then

		if ileL > 0 then
			local plotex = mPlt:FindFirstChild("PlotL1")
			zwrocS += plotex.Size.X
		end
		if ileR > 0 then
			local plotex = mPlt:FindFirstChild("PlotR1")
			zwrocS += plotex.Size.X
		end
	else
		if ileL >= tonumber(string.sub(name,6,6))  then
			local plotex = mPlt.Parent:FindFirstChild("PlotL"..tonumber(string.sub(name,6,6)))
			zwrocS += plotex.Size.X
		end
		if ileR >= tonumber(string.sub(name,6,6))  then
			local plotex = mPlt.Parent:FindFirstChild("PlotR"..tonumber(string.sub(name,6,6)) )
			zwrocS += plotex.Size.X
		end
	end
	return zwrocS
end

-- Clamps the x and z positions so they cannot leave the plot
local function bounds()

	if currentRot then

		local KtoryPlt = onWhich(posX,posZ,false)

		local meinsizex = returnSizeX(KtoryPlt)
		local meineX = returnX(KtoryPlt)

		LOWER_X_BOUND = meineX - (meinsizex*0.5) 
		UPPER_X_BOUND = meineX + (meinsizex*0.5) - primary.Size.X

		local meinsizez = returnSizeZ(KtoryPlt)
		local meineZ = returnZ(KtoryPlt)

		LOWER_Z_BOUND = meineZ - (meinsizez*0.5)	
		UPPER_Z_BOUND = meineZ + (meinsizez*0.5) - primary.Size.Z
	else
		local KtoryPlt = onWhich(posX,posZ,false)


		local meinsizex = returnSizeX(KtoryPlt)
		local meineX = returnX(KtoryPlt)

		LOWER_X_BOUND = meineX - (meinsizex*0.5) 
		UPPER_X_BOUND = meineX + (meinsizex*0.5) - primary.Size.Z

		local meinsizez = returnSizeZ(KtoryPlt)
		local meineZ = returnZ(KtoryPlt)

		LOWER_Z_BOUND = meineZ - (meinsizez*0.5)	
		UPPER_Z_BOUND = meineZ + (meinsizez*0.5) - primary.Size.X
	end

	posX = clamp(posX, LOWER_X_BOUND, UPPER_X_BOUND)

	posZ = clamp(posZ, LOWER_Z_BOUND, UPPER_Z_BOUND)
end


-- Calculates the position of the object
local function calculateItemLocation(setNewToggle)
	if (can or not UIS.TouchEnabled or setNewToggle) and object then
		mouseHit = mouse.Hit
		camera = workspace.CurrentCamera

		local h1 = camera.CFrame.Position.Y - plot.Position.Y
		local h2 = posY - (primary.Size.Y * 0.5)
		
		if h1 > h2 then
			local similarIndex = h1/h2

			local pos1 = Vector3.new(camera.CFrame.Position.X,1,camera.CFrame.Position.Z)
			local pos2 = Vector3.new(mouseHit.X,1,mouseHit.Z)

			local distance = (pos1 - pos2).Magnitude
			local substractedDist = distance/similarIndex

			local x,y,z = CFrame.lookAt(pos1,pos2):ToOrientation()
			local yRot = math.rad((y/math.pi) * 180)


			local sinus = math.sin(yRot)*-1
			local cosinus = math.cos(yRot)*-1

			mouseHit = mouseHit.Position - Vector3.new(substractedDist * sinus,0,substractedDist * cosinus)
		end

		if setNewToggle then
			camera = workspace.CurrentCamera

			radX,radY = camera.CFrame:ToOrientation()

			s = math.sin(radY)*-1
			c = math.cos(radY)*-1

			mouseHit = CFrame.new(Vector3.new(camera.CFrame.Position.X,primary.Position.Y,camera.CFrame.Position.Z) + Vector3.new(15*s,0,15*c)).Position
		end

		if currentRot then
			x, z = mouseHit.X - primary.Size.X*0.5, mouseHit.Z - primary.Size.Z*0.5

			cx = primary.Size.X*0.5
			cz = primary.Size.Z*0.5

		else
			x, z = mouseHit.X - primary.Size.Z*0.5, mouseHit.Z - primary.Size.X*0.5

			cx = primary.Size.Z*0.5
			cz = primary.Size.X*0.5

		end

		if moveByGrid then
			-- Snaps models to grid
			if x % GRID_UNIT < GRID_UNIT then
				posX = round(x - (x % GRID_UNIT))
			else
				posX = round(x + (GRID_UNIT - (x % GRID_UNIT)))	

			end

			if z % GRID_UNIT < GRID_UNIT*1 then
				posZ = round(z - (z % GRID_UNIT))
			else
				posZ = round(z + (GRID_UNIT - (z % GRID_UNIT)))
			end
		else
			posX = x
			posZ = z
		end

		-- Changes posY depending on mouse target
		if stackable and mouse.Target then

			posY = calculateYPos(mouse.Target.Position.Y, mouse.Target.Size.Y, primary.Size.Y)

		end

		-- Clamps posY to a max height above the plot position

		if setNewToggle then
			if object then
				object:SetPrimaryPartCFrame(primary.CFrame:Lerp(cframe(posX, posY, posZ)*cframe(cx, 0, cz)*anglesXYZ(0, rot*pi/180, 0), speed))
			end	
		end

		bounds()
	end
end

local function rotate(actionName, inputState, inputObj)
	if currentState ~= 4 and inputState == Enum.UserInputState.Begin  then
		if smartRot then
			rot = rot + rotationStep
			if rot >= 360 then
				rot = 0
			end
		end

		-- Toggles currentRot
		currentRot = not currentRot
	end
end

--[[
	Used for sending a final CFrame to the server when using interpolation.
	When interpolating the position is changing. This is the position the object will
	end up after the lerp is finished.
]]
local function getFinalCFrame()
	return cframe(posX, posY, posZ)*cframe(cx, 0, cz)*anglesXYZ(0, rot*pi/180, 0)

end
-- Sets the position of the object
local function translateObj()

	if currentState ~= 4 then

		calculateItemLocation()

		checkHitbox()
		editHitboxColor()

		range = false
		if object then
			object:SetPrimaryPartCFrame(primary.CFrame:Lerp(cframe(posX, posY, posZ)*cframe(cx, 0, cz)*anglesXYZ(0, rot*pi/180, 0), speed))
		end	

	end

end

function termination(toggle)
	contextActionService:UnbindAction("changeGrid")
	--game.ReplicatedStorage.Events.KoniecPlacmenta:Fire()
	if remote ~= nil then
		remote.cancel:Invoke()
	end
	resetGridaIWysokosci()
	TERMINATE_PLACEMENT(toggle)
end

function terminationButton(toggle)
	pcall(function()
		if HIDE_UNIT == "ceil" then
			for i,n in pairs(plot.Parent.PlacedObjects:GetChildren()) do
				if string.match(n.Name,"Celling") and n.Name ~= "InfoSignOnCelling" then
					n.Paintable1.Celling.Transparency = 0
				end
			end
		elseif HIDE_UNIT == "wall" then
			for i,n in pairs(plot.Parent.PlacedObjects:GetChildren()) do
				if string.match(n.Name,"Wall") then
					if string.match(n.Name,"Window") then
						for j,m in pairs(n.Paintable2:GetChildren()) do
							m.Transparency = 0.45
						end
					else
						for j,m in pairs(n.Paintable2:GetChildren()) do
							m.Transparency = 0
						end
					end
					for j,m in pairs(n.Paintable1:GetChildren()) do
						m.Transparency = 0
					end
				end
			end
		elseif HIDE_UNIT == "all"then
			for i,n in pairs(plot.Parent.PlacedObjects:GetChildren()) do
				if string.match(n.Name,"Wall") then
					if string.match(n.Name,"Window") then
						for j,m in pairs(n.Paintable2:GetChildren()) do
							m.Transparency = 0.45
						end
					else
						for j,m in pairs(n.Paintable2:GetChildren()) do
							m.Transparency = 0
						end
					end
					for j,m in pairs(n.Paintable1:GetChildren()) do
						m.Transparency = 0
					end
				end
				if string.match(n.Name,"Celling") and n.Name ~= "InfoSignOnCelling" then
					n.Paintable1.Celling.Transparency = 0
				end
			end
		end
	end)
	game.ReplicatedStorage.ClockOn:Fire()

	if remote ~= nil then
		remote.cancel:Invoke()
	end

	--pcall(function() 
	--	plot.Parent.BuildPlot:Destroy()
	--end)

	resetGridaIWysokosci()
	TERMINATE_PLACEMENT(toggle)
end

function placement:shutdown(toggle,newplot)
	if not plot then
		plot = newplot.Plot
	end
	terminationButton(toggle)
end

local function moveButtonForModel()
	if object then
		vector, onScreen = camera:WorldToViewportPoint(object.PrimaryPart.Position - Vector3.new(0,primary.Size.Y/2))
		moveModelButton.Position = UDim2.new(0,vector.X,0,vector.Y)
	end

end

--BIND AND UNBINDS--


local function unbindInputs()
	contextActionService:UnbindAction("Rotate")
	contextActionService:UnbindAction("Raise")
	contextActionService:UnbindAction("Lower")
	contextActionService:UnbindAction("Terminate")
end

local function bindInputs()
	contextActionService:BindAction("PlaceMobile", DoPlacement, false, placeKey)
	contextActionService:BindAction("Rotate", rotate, false, rotateKey)
	contextActionService:BindAction("Lower", lowerFloor, false, lowerKey)
	contextActionService:BindAction("Raise", raiseFloor, false, raiseKey)
	contextActionService:BindAction("Terminate", terminationButton, false, terminateKey)

	if UIS.TouchEnabled then

		local myInputObj = nil

		moveModelButton.Visible = true

		runService:BindToRenderStep("moveModel",0.5,moveButtonForModel)

		moveModelButton.InputBegan:Connect(function(inputObject)
			if (inputObject == myInputObj or not myInputObj) and not table.find(_G.SliderInputs,inputObject) then
				myInputObj = inputObject
				table.insert(_G.SliderInputs,inputObject)
				can = true
			end
		end)

		uisEnded = UIS.InputEnded:Connect(function(inputObject)
			if inputObject == myInputObj then
				can = false
				table.remove(_G.SliderInputs,table.find(_G.SliderInputs,inputObject))
				myInputObj = nil
			end
		end)

		local viewX = workspace.Camera.ViewportSize.X
		local viewY = workspace.Camera.ViewportSize.Y

		local Yperc = workspace.Camera.ViewportSize.X/workspace.Camera.ViewportSize.Y

		local sizeX = ((workspace.Camera.ViewportSize.X * 52)/1080)/workspace.Camera.ViewportSize.X
		local sizeY = sizeX * Yperc

		local placeButton = BuildUI.MobileButton:Clone()
		placeButton.Size = UDim2.new(sizeX,0,sizeY,0)
		placeButton.Position = UDim2.new(0.03, 0,0.35, 0)
		placeButton.MouseButton1Click:Connect(function() DoPlacement(false,"special") end)
		placeButton.Text = "Place"
		placeButton.Parent = BuildUI.MobileBuildButtons
		placeButton.Visible = true

		local rotateButton = BuildUI.MobileButton:Clone()
		rotateButton.Size = UDim2.new(sizeX,0,sizeY,0)
		rotateButton.Position = UDim2.new(0.03, 0,0.25, 0)
		rotateButton.MouseButton1Click:Connect(function() rotate("",Enum.UserInputState.Begin) end)
		rotateButton.Text = "Rotate"
		rotateButton.Parent = BuildUI.MobileBuildButtons
		rotateButton.Visible = true

		local deleteButton = BuildUI.MobileButton:Clone()
		deleteButton.Size = UDim2.new(sizeX,0,sizeY,0)
		deleteButton.Position = UDim2.new(0.03, 0,0.15, 0)
		deleteButton.MouseButton1Click:Connect(terminationButton)
		deleteButton.Text = "Terminate"
		deleteButton.Parent = BuildUI.MobileBuildButtons
		deleteButton.Visible = true

		local raiseButton = BuildUI.MobileButton:Clone()
		raiseButton.Size = UDim2.new(sizeX,0,sizeY,0)
		raiseButton.Position = UDim2.new(0.92, 0,0.25, 0)
		raiseButton.MouseButton1Click:Connect((function() raiseFloor("",Enum.UserInputState.Begin) end))
		raiseButton.Text = "Raise"
		raiseButton.Parent = BuildUI.MobileBuildButtons
		raiseButton.Visible = true

		local lowerButton = BuildUI.MobileButton:Clone()
		lowerButton.Size = UDim2.new(sizeX,0,sizeY,0)
		lowerButton.Position = UDim2.new(0.92, 0,0.35, 0)
		lowerButton.MouseButton1Click:Connect((function() lowerFloor("",Enum.UserInputState.Begin) end))
		lowerButton.Text = "Lower"
		lowerButton.Parent = BuildUI.MobileBuildButtons
		lowerButton.Visible = true

	end
end

--Change can status and set old if it is necessery

function placement:changeCanStatus(canStatus,old)

	can = canStatus

	if old then
		oldHit = old
	end

end

function resetGridaIWysokosci()
	if displayGridTexture then
		if plot then
			for i, v in next, plot:GetChildren() do
				if v then
					if v.Name == "GridTexture" and v:IsA("Texture") then
						if gridFadeOut then
							for i = v.Transparency, 1, 0.1 do
							end
							v:Destroy()
						else
							v:Destroy()
						end	
					end
					if string.match(v.Name,"index") then
						v:Destroy()
					end
				end
			end
			for i, v in next, plot:GetChildren() do
				for u,n in pairs(v:GetChildren()) do
					if n then
						if n.Name == "GridTexture" and n:IsA("Texture") then
							if gridFadeOut then
								for i = n.Transparency, 1, 0.1 do
								end
								n:Destroy()
							else
								n:Destroy()
							end	
						end
						if string.match(n.Name,"index") then
							n:Destroy()
						end
					end
				end
			end
		end
	end
end

function TERMINATE_PLACEMENT(backToggle,copyToggle)
	if selection then
		selection:Destroy()
		selection = nil
	end

	stackable = nil
	canPlace = nil
	smartRot = nil

	if not copyToggle and object then
		object:Destroy()
		object = nil
	end

	setCurrentState(4)

	unbindInputs()
	canActivate = true

	local BuildUI = player.PlayerGui.BuildUI

	BuildUI.MobileBuildButtons:ClearAllChildren()

	if UIS.TouchEnabled then
		moveModelButton.Visible = false
		runService:UnbindFromRenderStep("moveModel")
		pcall(function() uisEnded:Disconnect() end)
	end
	mouse.TargetFilter = nil
end

-- Makes sure that you cannot place objects too fast.
local function coolDown(plr, cd)
	if lastPlacement[plr.UserId] == nil then
		lastPlacement[plr.UserId] = os.time()

		return true
	else
		if os.time() - lastPlacement[plr.UserId] >= cd then
			lastPlacement[plr.UserId] = os.time()

			return true
		else
			return false
		end
	end
end

-- Verifys that the plane which the object is going to be placed upon is the correct size
local function verifyPlane()	
	if plot.Size.X%GRID_UNIT == 0 and plot.Size.Z%GRID_UNIT == 0 then
		return true
	else
		return false
	end
end

-- Checks if there are any problems with the users setup
local function approveActivation()
	if not verifyPlane() then
		errormodule.errorfuncGo(player,"The object that the model is moving on is not scaled correctly. Consider changing it.")
	end

	if GRID_UNIT > min(plot.Size.X, plot.Size.Z) then 
		errormodule.errorfuncGo(player,"Grid size is larger than the plot size. To fix this, try lowering the grid size.")
	end
end

function changeGridFunc(aN,iS)
	if iS == Enum.UserInputState.Begin or iS == nil then
		wait()
	else
		return
	end

	if GRID_UNIT == 0.25 then
		GRID_UNIT = 0.5
	elseif GRID_UNIT == 0.5 then
		GRID_UNIT = 1
	elseif GRID_UNIT == 1 then
		GRID_UNIT = 2
	elseif GRID_UNIT == 2 then
		GRID_UNIT = 0.25
	end

	changeGrid.Text = GRID_UNIT

	pcall(function() 
		if smartDisplay then
			plot.GridTexture.StudsPerTileU = GRID_UNIT
			plot.GridTexture.StudsPerTileV = GRID_UNIT
			for i,n in pairs(plot:GetChildren()) do
				n.GridTexture.StudsPerTileU = GRID_UNIT
				n.GridTexture.StudsPerTileV = GRID_UNIT
			end
		end
	end)
end

changeGrid.MouseButton1Click:Connect(function()
	changeGridFunc()
end)

changeDayNight.MouseButton1Click:Connect(function()
	if dayNightToggle then
		dayNightToggle = false
		game.ReplicatedStorage.ClockOff:Fire()
		changeDayNight.Text = "Day"
	else
		dayNightToggle = true
		game.ReplicatedStorage.ClockOff:Fire(dayNightToggle)
		changeDayNight.Text = "Night"
	end
end)

changeHideness.MouseButton1Click:Connect(function()
	if HIDE_UNIT == "ceil" then
		HIDE_UNIT = "wall"
		for i,n in pairs(plot.Parent.PlacedObjects:GetChildren()) do
			if string.match(n.Name,"Wall") then
				for j,m in pairs(n.Paintable2:GetChildren()) do
					m.Transparency = 0.45
				end
				for j,m in pairs(n.Paintable1:GetChildren()) do
					m.Transparency = 0.45
				end
			end
			if string.match(n.Name,"Celling") and n.Name ~= "InfoSignOnCelling" then
				n.Paintable1.Celling.Transparency = 0
			end
		end
	elseif HIDE_UNIT == "wall" then
		HIDE_UNIT = "all"
		for i,n in pairs(plot.Parent.PlacedObjects:GetChildren()) do
			if string.match(n.Name,"Wall") then
				for j,m in pairs(n.Paintable2:GetChildren()) do
					m.Transparency = 0.45
				end
				for j,m in pairs(n.Paintable1:GetChildren()) do
					m.Transparency = 0.45
				end
			end
			if string.match(n.Name,"Celling") and n.Name ~= "InfoSignOnCelling" then
				n.Paintable1.Celling.Transparency = 0.45
			end
		end
	elseif HIDE_UNIT == "all"then
		HIDE_UNIT = "_"
		for i,n in pairs(plot.Parent.PlacedObjects:GetChildren()) do
			if string.match(n.Name,"Wall") then
				if string.match(n.Name,"Window") then
					for j,m in pairs(n.Paintable2:GetChildren()) do
						m.Transparency = 0.45
					end
				else
					for j,m in pairs(n.Paintable2:GetChildren()) do
						m.Transparency = 0
					end
				end
				for j,m in pairs(n.Paintable1:GetChildren()) do
					m.Transparency = 0
				end
			end
			if string.match(n.Name,"Celling") and n.Name ~= "InfoSignOnCelling" then
				n.Paintable1.Celling.Transparency = 0
			end
		end
	elseif HIDE_UNIT == "_" then
		HIDE_UNIT = "ceil"
		for i,n in pairs(plot.Parent.PlacedObjects:GetChildren()) do
			if string.match(n.Name,"Celling") and n.Name ~= "InfoSignOnCelling" then
				n.Paintable1.Celling.Transparency = 0.45
			end
			if string.match(n.Name,"Wall") then
				if string.match(n.Name,"Window") then
					for j,m in pairs(n.Paintable2:GetChildren()) do
						m.Transparency = 0.45
					end
				else
					for j,m in pairs(n.Paintable2:GetChildren()) do
						m.Transparency = 0
					end
				end
				for j,m in pairs(n.Paintable1:GetChildren()) do
					m.Transparency = 0
				end
			end
		end
	end
	changeHideness.Text = HIDE_UNIT
end)


-- Constructor function
function placement.new(g, objs, r, t, u, l,e,newplot,remoteFunc)
	local data = {}
	local metaData = setmetatable(data, placement)
	remote = remoteFunc
	-- Sets variables needed
	--GRID_UNIT = abs(tonumber(g))
	itemLocation = objs
	rotateKey = r
	terminateKey = t
	raiseKey = u
	lowerKey = l
	placeKey = e

	data.gridsize = GRID_UNIT/2
	data.items = objs
	data.rotate = rotateKey
	data.cancel = terminateKey
	data.raise = raiseKey
	data.lower = lowerKey
	currentRot = true
	dayNightToggle = false
	changeDayNight.Text = "Day"
	rot = 0
	plot = newplot.Plot

	--local buildPlot = plot:Clone()
	--buildPlot.CanCollide = false
	--buildPlot.Size = Vector3.new(150,plot.Size.Y,150)
	--buildPlot.Position = plot.Position + Vector3.new(0,0,50 * math.cos(math.rad(plot.Orientation.Y)))
	--buildPlot.Transparency = 1
	--buildPlot.Name = "BuildPlot"
	--buildPlot:ClearAllChildren()
	--buildPlot.Parent = plot.Parent

	if ReturnPlot(newplot.Name) == "roz" then
		rot += 180
	end

	return data 
end

-- returns the current state when called
function placement:getCurrentState()
	return states[currentState]
end

-- Pauses the current state
function placement:pauseCurrentState()
	lastState = currentState

	if object then
		currentState = states[4]
	end
end

-- Resumes the current state if paused
function placement:resume()
	if object then
		setCurrentState(lastState)
	end
end

-- Terminates placement


function placement:terminate(toggle,plr)
	TERMINATE_PLACEMENT(toggle)
end

function placement:terminateALL(toggle,plr)
	termination(toggle)
end

function DoPlacement(a,iS)
	if iS == Enum.UserInputState.End or iS == "special" then
		can = false
		oldHit = mouse.Hit
		local func = remote
		if currentState ~= 4 and currentState ~= 5 and object then
			local cf
			calculateItemLocation()

			-- Makes sure you have waited the cooldown period before placing
			if coolDown(player, placementCooldown) then
				-- Buildmode placement is when you can place multiple objects in one session
				if buildModePlacement then
					cf = getFinalCFrame()

					checkHitbox()
					setCurrentState(2)

					-- Sends information to the server, so the object can be placed
					if currentState == 2 then
						if object then
							if not func:InvokeServer(object.Name, placedObjects, loc, cf, collisions) then
								terminationButton(moveToggleGlobal)
								return
							end
						end
						setCurrentState(4)
						--setCurrentState(4)
						if player:GetAttribute("DoesTutorial") then
							game.ReplicatedStorage.Events.JestEKlkiniete:FireServer()
							terminationButton()
							return
						end
						if remote.Name == 'move' then
							terminationButton()
						elseif remote.Name == "copy" then
							if object then
								placement:activate(object,placedObjects,plot,false,true,moveToggleGlobal,gridKeyGlobal,true,copyToggleGlobal,cf)
							end
						else
							if object and object.PrimaryPart then
								placement:activate(object.Name,placedObjects,plot,false,true,moveToggleGlobal,gridKeyGlobal,true,copyToggleGlobal,cf)
							end
						end
					end
				else
					cf = getFinalCFrame()

					checkHitbox()
					setCurrentState(2)

					if currentState == 2 then
						-- Same as above (line 509)
						if func:InvokeServer(object.Name, placedObjects, loc, cf, collisions) then
							TERMINATE_PLACEMENT()
						end
					end
				end
			end
		end
	end
end

local function checkRots()
	if math.abs(rot) == math.abs(objRot) and rot == 180 then
		return true
	end
	if rot == 270 and objRot == -90 then
		return true
	end
	if rot == objRot then
		return true
	end
	return false
end

-- Requests to place down the object

-- Activates placement
function placement:activate(id, pobj, plt, stk, r,moveToggle,gridKey,isItNext,copyToggle,cf)
	TERMINATE_PLACEMENT()
	task.wait(0.05)
	-- Sets necessary variables for placement 
	object = nil
	plot = plt
	local item
	if copyToggle then
		if not isItNext then
			item = id:Clone()
			task.wait()
		else
			for i,n in pairs(plot.Parent.PlacedObjects:GetChildren()) do
				if n:GetAttribute("beingCopied") == true then
					item = n:Clone()
					task.wait()
				end
			end
		end
		if not item then
			terminationButton(moveToggle)
			return
		end
		if string.match(item.Name,"Shelf") or item.Name == "DisplayTable" then
			for j,m in pairs(item.Towar:GetChildren()) do 
				if #m:GetChildren() > 0 then
					for k,l in pairs(m:GetChildren()) do
						l.Transparency = 1 -- change towar's transparency to 1 beacuse it is a new model
					end
				end
			end
		end
		object = item
	elseif moveToggle then
		for i,n in pairs(plot.Parent.PlacedObjects:GetChildren()) do
			if n:GetAttribute("beingMoved") == true then
				item = n:Clone()
				task.wait()
				n:SetAttribute("beingMoved",nil)
			end
		end
		object = item
	else
		object = itemLocation:FindFirstChild(tostring(id)):Clone()
		task.wait()
		if not object then
			task.wait(0.3)
			object = itemLocation:FindFirstChild(tostring(id)):Clone()
		end

	end

	changeGrid.Text = GRID_UNIT
	moveToggleGlobal = moveToggle
	copyToggleGlobal = copyToggle
	gridKeyGlobal = gridKey
	contextActionService:BindAction("changeGrid", changeGridFunc, false, gridKey)

	if object then
		objRot = math.floor(object.PrimaryPart.Orientation.Y)
	end

	if HIDE_UNIT == "ceil" then
		for i,n in pairs(plot.Parent.PlacedObjects:GetChildren()) do
			if string.match(n.Name,"Celling") and n.Name ~= "InfoSignOnCelling" then
				n.Paintable1.Celling.Transparency = 0.45
			end
		end
	elseif HIDE_UNIT == "wall" then
		for i,n in pairs(plot.Parent.PlacedObjects:GetChildren()) do
			if string.match(n.Name,"Wall") then
				for j,m in pairs(n.Paintable2:GetChildren()) do
					m.Transparency = 0.45
				end
				for j,m in pairs(n.Paintable1:GetChildren()) do
					m.Transparency = 0.45
				end
			end
		end
	elseif HIDE_UNIT == "all"then
		for i,n in pairs(plot.Parent.PlacedObjects:GetChildren()) do
			if string.match(n.Name,"Wall") then
				for j,m in pairs(n.Paintable2:GetChildren()) do
					m.Transparency = 0.45
				end
				for j,m in pairs(n.Paintable1:GetChildren()) do
					m.Transparency = 0.45
				end
			end
			if string.match(n.Name,"Celling") and n.Name ~= "InfoSignOnCelling" then
				n.Paintable1.Celling.Transparency = 0.45
			end
		end
	end

	changeHideness.Text = HIDE_UNIT
	placedObjects = pobj
	loc = itemLocation
	can = false
	approveActivation()
	-- Sets properties of the model (CanCollide, Transparency)
	if object then
		if object:FindFirstChild("Towar") then 
			object.Guiile.Enabled = false
			object.GuiCo.Enabled = false
		end
		for i, o in next, object:GetDescendants() do
			if o then
				if o:IsA("Part") or o:IsA("UnionOperation") or o:IsA("MeshPart") then
					o.CanCollide = false
					if transparentModel then
						o.Transparency = o.Transparency + transparencyDelta
					end
				end
			end
		end
		if includeSelectionBox then	
			selection = Instance.new("SelectionBox")
			selection.Name = "outline"
			selection.LineThickness = lineThickness
			selection.Color3 = selectionColor
			selection.Transparency = lineTransparency
			selection.Parent = player.PlayerGui
			selection.Adornee = object.PrimaryPart
		end
		object.PrimaryPart.Transparency = hitboxTransparency
	end

	stackable = false
	smartRot = r

	check = true

	if tonumber(string.sub(plot.Parent.Name,5,5)) > 4 then
		check = false
	end

	ileR = player.hidden.IleR.Value
	ileC = player.hidden.IleC.Value
	ileL = player.hidden.IleL.Value
	-- Allows stackable objects depending on stk variable given by the user
	if not stk then
		mouse.TargetFilter = placedObjects
	else
		mouse.TargetFilter = object
	end

	-- Toggles buildmode placement (infinite placement) depending on if set true by the user
	if buildModePlacement then
		canActivate = true
	else
		canActivate = false
	end
	-- Gets the initial y pos and gives it to posY


	if cf then
		posY = cf.Position.Y
		--pcall(function() 		
		--	plot.Parent.BuildPlot.Position = Vector3.new(plot.Parent.BuildPlot.Position.X,posY,plot.Parent.BuildPlot.Position.Z) 
		--end)
	else
		if object then
			if object.Name == "Light" then
				initialY = calculateYPos(plt.Position.Y, 0 , 0)
			else
				initialY = calculateYPos(plt.Position.Y, plt.Size.Y , object.PrimaryPart.Size.Y)
			end
			if moveToggle or copyToggle then
				posY = object.PrimaryPart.Position.Y
			else
				posY = initialY
			end
		end
	end

	speed = 0

	translateObj()
	bindInputs()
	-- Sets up interpolation speed
	speed = 1

	if interpolation then
		preSpeed = clamp(abs(tonumber(1 - lerpSpeed)), 0, 0.9)

		if instantActivation then
			speed = 1
		else
			speed = preSpeed
		end
	end

	-- Parents the object to the location given
	if object then
		primary = object.PrimaryPart

		if string.match(object.Name,"CashReg") then
			for i,n in pairs(object.Queue:GetChildren()) do
				if #n:GetChildren() > 0 then
					for j,m in pairs(n:GetChildren()) do
						m.Transparency = 0.25
					end
				end
			end
		end

		if cf then
			calculateItemLocation()
		else
			calculateItemLocation(true)
		end



		setCurrentState(1)

		if not isItNext then
			displayGrid()
		end

		if not isItNext then
			while not checkRots() do
				rotate("start",Enum.UserInputState.Begin,nil)
			end
		end

		editHitboxColor()

		if not object then
			terminationButton(moveToggle)
			return
		end

		object.Parent = pobj

		wait()
		speed = preSpeed
	else
		terminationButton(moveToggle)
		errormodule.errorfuncGo(player,"Your trying to activate placement too fast! Please slow down.")
	end
end

runService:BindToRenderStep("Input", Enum.RenderPriority.Input.Value, translateObj)

return placement