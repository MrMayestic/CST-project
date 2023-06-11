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
local interpolation = true -- Toggles interpolation (smoothing)
local moveByGrid = true -- Toggles grid system
local collisions = true -- Toggles collisions
local buildModePlacement = true -- Toggles "build mode" placement
local displayGridTexture = true -- Toggles the grid texture to be shown when placing
local smartDisplay = false -- Toggles smart display for the grid. If true, it will rescale the grid texture to match your gridsize
local enableFloors = true-- Toggles if the raise and lower keys will be enabled
local transparentModel = true -- Toggles if the model itself will be transparent
local instantActivation = true -- Toggles if the model will appear at the mouse position immediately when activating placement
local includeSelectionBox = true -- Toggles if a selection box will be shown while placing
local gridFadeIn = true -- If you want the grid to fade in when activating placement
local gridFadeOut = false -- If you want the grid to fade out when ending placement
-- Color3
local collisionColor = Color3.fromRGB(255, 75, 75) -- Color of the hitbox when colliding
local hitboxColor = Color3.fromRGB(75, 255, 75) -- Color of the hitbox while not colliding
local selectionColor = Color3.fromRGB(0, 255, 0) -- Color of the selectionBox lines (includeSelectionBox much be set to "true")
local selectionCollisionColor = Color3.fromRGB(255, 0, 0) -- Color of the selectionBox lines when colliding (includeSelectionBox much be set to "true")

-- Integers
local maxHeight = 20 -- Max height you can place objects (in studs)
local floorStep = 5 -- The step (in studs) that the object will be raised or lowered
local rotationStep = 90 -- Rotation step
-- Numbers/Floats
local hitboxTransparency = 1 -- Hitbox transparency when placing
local transparencyDelta = 0 -- Transparency of the model itself (transparentModel must equal true)
local lerpSpeed = 0.2 -- speed of interpolation. 0 = no interpolation, 0.9 = major interpolation
local placementCooldown = 0.15-- How quickly the user can place down objects (in seconds)
local maxRange = 80 -- Max range for the model (in studs)
local lineThickness = 0.05 -- How thick the line of the selection box is (includeSelectionBox much be set to "true")
local lineTransparency = 0.5 -- How transparent the line of the selection box is (includeSelectionBox must be set to "true")


-- Other
local gridTexture = "rbxassetid://2415319308"

-- DO NOT EDIT PAST THIS POINT UNLESS YOU KNOW WHAT YOUR DOING.
local can = true
local lockToggle = false

local placement = {}

placement.__index = placement

-- Essentials
local runService = game:GetService("RunService")
local contextActionService = game:GetService("ContextActionService")

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local mouse = player:GetMouse()	
local oldHit
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
local GRID_UNIT
local itemLocation
local rotateKey
local terminateKey
local raiseKey
local lowerKey

-- Activation variables
local plot
local object

-- bools
local canActivate = true
local currentRot = false
local canPlace
local isColliding
local stackable
local smartRot
local range

-- values used for calculations
local speed = 1
local preSpeed = 1

local posX
local posY
local posZ
local rot
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
local check = true
-- other
local placedObjects
local loc
local primary
local selection
local lastPlacement = {}
local humanoid = character:WaitForChild("Humanoid")

-- Sets the current state depending on input of function
local function setCurrentState(state)
	currentState = clamp(state, 1, 5)
	lastState = currentState
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
	return (primary.Position - character.PrimaryPart.Position).Magnitude
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
			if not collisionPoints[i]:IsDescendantOf(object) and not collisionPoints[i]:IsDescendantOf(character) then
				setCurrentState(3)

				break
			end
		end

		collisionPoint:Disconnect()

		return collided
	end
end

local function raiseFloor(actionName, inputState, inputObj)
	if currentState ~= 4 and inputState == Enum.UserInputState.Begin then
		if enableFloors and not stackable then
			posY = posY + floor(abs(floorStep))
		end
	end
end

local function lowerFloor(actionName, inputState, inputObj)
	if currentState ~= 4 and inputState == Enum.UserInputState.Begin then
		if enableFloors and not stackable then
			posY = posY - floor(abs(floorStep))
		end
	end
end

-- handles the grid texture
local function displayGrid()
	if displayGridTexture then
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

						wait()
					end
				end
			end)
		else
			gridTex.Transparency = 0
		end

		gridTex.Parent = plot
		for i,n in pairs(plot:GetChildren()) do
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

							wait()
						end
					end
				end)
			else
				gridTex.Transparency = 0
			end

			gridTex.Parent = n
		end
	end
end

-- Rounds any number to the nearest integer (credit iGottic)
local function round(number)
	local decimal_placement = 1 

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
	---------USTALENIE DZIA£EK W OSI X
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

	if not toggle then
		for i,n in pairs(tejbulX) do

			if x>= n.Position.X - n.Size.X/2 then--and z<= n.Position.Z + n.Size.Z/2 and z>= n.Position.Z - n.Size.Z/2 then
				ktory = n
			end
		end
		if ktory == nil then
			ktory = tejbulX[1]
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
					if z>= n.Position.Z - n.Size.Z/2 then
						ktory = n
					end
				else
					if z<= n.Position.Z + n.Size.Z/2 then
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
					if z>= n.Position.Z - n.Size.Z/2 then
						ktory = n
					end
				else
					if z<= n.Position.Z + n.Size.Z/2 then
						ktory = n
					end
				end
			end
		else
			for i=1,ileC do
				table.insert(tejbulZ,i+1,ktory.Parent:FindFirstChild("PlotC"..i))
			end
			for i,n in pairs(tejbulZ) do
				if check then
					if z>= n.Position.Z - n.Size.Z/2 then
						ktory = n
					end
				else
					if z<= n.Position.Z + n.Size.Z/2 then
						ktory = n
					end
				end
			end
		end

		return ktory
	end
end

---------FUNKCJE ZWRACAJ¥CE WARTOŒCI DO BOUNDS()


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
				zwroc = zwroc/2
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
				zwroc = zwroc/2
			end
		end

	else
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
				zwroc = zwroc/2
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
				zwroc = zwroc/2
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
		local meineX = returnX(KtoryPlt)--(plot.Position.X + plot.PlotL1.Position.X) / 2
		LOWER_X_BOUND = meineX - (meinsizex*0.5) 
		UPPER_X_BOUND = meineX + (meinsizex*0.5) - primary.Size.X
		local meinsizez = returnSizeZ(KtoryPlt)
		local meineZ = returnZ(KtoryPlt)
		LOWER_Z_BOUND = meineZ - (meinsizez*0.5)	
		UPPER_Z_BOUND = meineZ + (meinsizez*0.5) - primary.Size.Z
	else
		local KtoryPlt = onWhich(posX,posZ,false)


		local meinsizex = returnSizeX(KtoryPlt)
		local meineX = returnX(KtoryPlt)--(plot.Position.X + plot.PlotL1.Position.X) / 2
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

local mouseHit = mouse.Hit

-- Calculates the position of the object
local function calculateItemLocation()
	if can then
		mouseHit = mouse.Hit
	else
		if mouse.Hit ~= oldHit then
			can = true
		end
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
		if x % GRID_UNIT < GRID_UNIT*1 then
			posX = round(x*1 - (x % GRID_UNIT))
		else
			posX = round(x*1 + (GRID_UNIT - (x % GRID_UNIT)))	

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
	posY = clamp(posY, initialY, maxHeight + initialY)

	bounds()
end

local function rotate(actionName, inputState, inputObj)
	can = false
	oldHit = mouse.Hit
	
	if currentState ~= 4 and inputState == Enum.UserInputState.Begin or inputState == "SuperJojko5000" then
		if smartRot then
			rot = rot + rotationStep
			if rot >= 360 then
				rot = 0
			end
		end
		currentRot = not currentRot
	end
end


function lockUnlock(aN,iS)
	if iS == Enum.UserInputState.Begin then
		if lockToggle then
			can = false
			oldHit = mouse.Hit
			game.Workspace.Camera.CameraType = Enum.CameraType.Scriptable
			lockToggle = false
			contextActionService:SetTitle("LockUnlock", "Lock")
			wait(0.1)
		else
			can = false
			oldHit = mouse.Hit
			--game.Workspace.Camera.CameraType = Enum.CameraType.Fixed
			lockToggle = true
			contextActionService:SetTitle("LockUnlock", "Unlock")
			wait(0.1)
		end
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

		if getRange() > maxRange then
			setCurrentState(5)

			range = true
		else
			range = false
		end
		if object then
			object:SetPrimaryPartCFrame(primary.CFrame:Lerp(cframe(posX, posY, posZ)*cframe(cx, 0, cz)*anglesXYZ(0, rot*pi/180, 0), speed))
		end	
	end
end



local function unbindInputs()
	contextActionService:UnbindAction("Rotate")
	contextActionService:UnbindAction("Raise")
	contextActionService:UnbindAction("Lower")
end
function TERMINATE_PLACEMENTwithback()
	if object then
		if selection then
			selection:Destroy()
			selection = nil
		end

		stackable = nil
		canPlace = nil
		smartRot = nil
		object:Destroy()
		object = nil

		setCurrentState(4)

		-- removes grid texture from plot
		if displayGridTexture then
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
					end
				end
			end
		end

		canActivate = true
		game.ReplicatedStorage.Events.BackParent:FireServer(plot)
		unbindInputs()
		mouse.TargetFilter = nil

		return
	end
end
local function bindInputs()
	contextActionService:BindAction("Rotate", rotate, false, rotateKey)
	contextActionService:BindAction("Raise", raiseFloor, false, raiseKey)
	contextActionService:BindAction("Lower", lowerFloor, false, lowerKey)

end

function placement:canzmien()


	can = false
end

function placement:TERMINATE_PLACEMENTm()
	if object then
		if selection then
			selection:Destroy()
			selection = nil
		end

		stackable = nil
		canPlace = nil
		smartRot = nil
		object:Destroy()
		object = nil

		setCurrentState(4)

		-- removes grid texture from plot
		if displayGridTexture then
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
					end
				end
			end
		end

		canActivate = true
		--game.ReplicatedStorage.Events.BackParent:FireServer(plot)
		unbindInputs()
		mouse.TargetFilter = nil

		return
	end
end



function TERMINATE_PLACEMENT(backToggle)

	if object then
		if selection then
			selection:Destroy()
			selection = nil
		end


		stackable = nil
		canPlace = nil
		smartRot = nil
		object:Destroy()
		object = nil


		setCurrentState(4)

		-- removes grid texture from plot
		if displayGridTexture then
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
					end
				end
			end
		end

		canActivate = true
		if backToggle then
			game.ReplicatedStorage.Events.BackParent:FireServer(plot)
		end
		unbindInputs()

		mouse.TargetFilter = nil

		return
	end
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
		warn("The object that the model is moving on is not scaled correctly. Consider changing it.")
	end

	if GRID_UNIT > min(plot.Size.X, plot.Size.Z) then 
		error("Grid size is larger than the plot size. To fix this, try lowering the grid size.")
	end
end

-- Constructor function
function placement.new(g, objs, r, t, u, l,e)
	local data = {}
	local metaData = setmetatable(data, placement)

	-- Sets variables needed
	GRID_UNIT = abs(tonumber(g))

	itemLocation = objs
	rotateKey = r
	terminateKey = t
	raiseKey = u
	lowerKey = l

	data.gridsize = GRID_UNIT
	data.items = objs
	data.rotate = rotateKey
	data.cancel = terminateKey
	data.raise = raiseKey
	data.lower = lowerKey

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
function placement:terminate(toggle)
	TERMINATE_PLACEMENT(toggle)
end

function placement:terminateback()
	TERMINATE_PLACEMENT(true)
end

-- Requests to place down the object
function placement:requestPlacement(func)
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
					func:InvokeServer(object.Name, placedObjects, loc, cf, collisions, plot)

					setCurrentState(1)
					TERMINATE_PLACEMENT()
				end
			else
				cf = getFinalCFrame()

				checkHitbox()
				setCurrentState(2)

				if currentState == 2 then
					-- Same as above (line 509)
					if func:InvokeServer(object.Name, placedObjects, loc, cf, collisions, plot) then
						--object.Parent = placedObjects
						TERMINATE_PLACEMENT()
					end
				end
			end
		end
	end
end




-- Activates placement
function placement:activate(id, pobj, plt, stk, r, e)
	TERMINATE_PLACEMENT()	
	-- Sets necessary variables for placement 
	plot = plt

	object = itemLocation:FindFirstChild(tostring(id)):Clone()

	placedObjects = pobj
	loc = itemLocation
	can = true
	approveActivation()

	-- Sets properties of the model (CanCollide, Transparency)
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

	stackable = false
	smartRot = r

	-- Allows stackable objects depending on stk variable given by the user
	if not stk then
		mouse.TargetFilter = placedObjects
	else
		mouse.TargetFilter = object
	end
	check = true
	if tonumber(string.sub(plot.Parent.Name,5,5)) > 4 then
		check = false
	end
	ileR = player.hidden.IleR.Value
	ileC = player.hidden.IleC.Value
	ileL = player.hidden.IleL.Value
	-- Toggles buildmode placement (infinite placement) depending on if set true by the user
	if buildModePlacement then
		canActivate = true
	else
		canActivate = false
	end

	-- Gets the initial y pos and gives it to posY
	initialY = calculateYPos(plt.Position.Y, plt.Size.Y, object.PrimaryPart.Size.Y)
	posY = initialY

	speed = 0
	rot = 0
	currentRot = true

	translateObj()
	displayGrid()
	editHitboxColor()
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
		setCurrentState(1)
		object.Parent = pobj

		wait()

		speed = preSpeed
	else
		TERMINATE_PLACEMENT()

		warn("Your trying to activate placement too fast! Please slow down")
	end
end

runService:BindToRenderStep("Input", Enum.RenderPriority.Input.Value, translateObj)

return placement