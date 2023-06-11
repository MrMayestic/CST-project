local PathFindingService = game:GetService("PathfindingService")
local PhysicsService = game:GetService("PhysicsService")

local NPCMove = "NPCMove"
local NPC = "NPC"

PhysicsService:RegisterCollisionGroup(NPCMove)
PhysicsService:RegisterCollisionGroup(NPC)

local storemanModule

local storemanAttrib

local towarmodule = require(game.ReplicatedStorage.Modules.TowarModule)
local errormodule = require(game.ReplicatedStorage.Modules.ErrorModule)

local human = script.Parent:WaitForChild("Humanoid")
local destination-- = game.Workspace.Plots.Plot1.PlacedObjects:WaitForChild("DisplayTable").find.Position

local RS = game.ReplicatedStorage

local pathParams = {
	AgentRadius = 2.25,
	AgentHeight = 5,
	AgentCanJump = false,
	WaypointSpacing = 50,
	--Costs = {
	--	Grass = 3,
	--	SmoothPlastic = 5
	--}
}

local path = PathFindingService:CreatePath(pathParams)

local waypoints
local nextWaypointIndex = 0
local reachedConnection
local blockedConnection

local plr

local plotCos

local counter = 0

local currentObj

local playAnim = game.ReplicatedStorage.Events.AnimationEvents.playAnim
local stopAnim = game.ReplicatedStorage.Events.AnimationEvents.stopAnim
local initiateAnims = game.ReplicatedStorage.Events.AnimationEvents.initateAnims
local destroyAnims = game.ReplicatedStorage.Events.AnimationEvents.destroyAnims

local BColors = {3, 5, 12, 18, 108, 128, 138, 224, 224, 226, 226}
local SColors = {22}
local PColors = {26}
local BColor = BrickColor.new(BColors[math.random(1, #BColors)])
local SColor = BrickColor.new(SColors[math.random(1, #SColors)])
local PColor = BrickColor.new(PColors[math.random(1, #PColors)])

script.Parent.Head.BrickColor = BColor
script.Parent.LeftUpperArm.BrickColor = BColor
script.Parent.LeftUpperLeg.BrickColor = PColor
script.Parent.RightUpperArm.BrickColor = BColor
script.Parent.RightUpperLeg.BrickColor = PColor
script.Parent.UpperTorso.BrickColor = SColor

function CCfM() --change collision for move
	pcall(function()
		for i,n in pairs(script.Parent:GetChildren()) do
			if n.ClassName == "MeshPart" or n.ClassName == "Part" then
				n.CollisionGroup = NPCMove
			end
		end
	end)
	task.wait(0.1)
end

local function setAnim(model,animID)
	local Animation = Instance.new("Animation")
	Animation.AnimationId = animID

	if model:FindFirstChild("Humanoid") then
		return model.Humanoid:LoadAnimation(Animation)
	else
		return model.AnimationController:LoadAnimation(Animation)
	end
end

--[[ ANIMS LENGTHS normal(after adjust)
	fillingDT - 12.933 (9.949)
	fillingS - 11.3 (8.7)	
]]


local function rotateMe(findOrient)
	stopAnim:FireAllClients(script.Parent)
	
	task.wait(0.1)

	local npcOrient = script.Parent.PrimaryPart.Orientation.Y
	local rotDiff = 0
	local multiOrient = findOrient/ math.abs(findOrient)	
	local multiNPC = npcOrient/ math.abs(npcOrient)
	local isRotOtherSide = false

	if findOrient == 90 then
		if npcOrient * findOrient < 0 then
			isRotOtherSide = true
			if npcOrient < 0 and npcOrient >= -90 then
				rotDiff -= math.abs(npcOrient)
				rotDiff -= math.abs(findOrient)
				rotDiff *= -1
			elseif npcOrient < 0 and npcOrient < -90 then
				rotDiff -= 180 - math.abs(npcOrient)
				rotDiff -= math.abs(findOrient)
			else
				rotDiff -= math.abs(npcOrient)
				rotDiff -= math.abs(findOrient)
			end
		end
	elseif findOrient == -90 then
		if npcOrient * findOrient < 0 then
			isRotOtherSide = true
			if npcOrient > 0 and npcOrient <= 90 then
				rotDiff += math.abs(npcOrient)
				rotDiff += math.abs(findOrient)
				rotDiff *= -1
			elseif npcOrient > 0 and npcOrient > -90 then
				rotDiff += 180 - math.abs(npcOrient)
				rotDiff += math.abs(findOrient)
			else
				rotDiff -= math.abs(npcOrient)
				rotDiff -= math.abs(findOrient)
			end
		end
	elseif findOrient == 0 then
		if npcOrient < 90 and npcOrient > -90 then
			isRotOtherSide = true
			rotDiff = math.abs(findOrient) - npcOrient
		end
	elseif math.abs(findOrient) == 180 then
		if npcOrient < 90 and npcOrient > 0 then
			isRotOtherSide = true
			rotDiff = (math.abs(findOrient) - math.abs(npcOrient))
		elseif npcOrient > -90 and npcOrient < 0 then
			isRotOtherSide = true
			rotDiff = (math.abs(findOrient) - math.abs(npcOrient))
			rotDiff *= -1
		end
	end

	if not isRotOtherSide then
		rotDiff = (math.abs(findOrient) - math.abs(npcOrient)) * multiNPC
	end

	local rotStep = rotDiff / 15
	local waiter = (math.abs(rotDiff)/7500) * 4
	
	pcall(function() 
		for i=1,15 do
			if i%3==0 then
				task.wait(waiter)
			end
			script.Parent.PrimaryPart.Orientation += Vector3.new(0,rotStep,0)
		end
	end)
	task.wait(0.1)
	return true
end


local function GoHuman(destination,a,b)

	local success, errorMessage = pcall(function()
		path:ComputeAsync(script.Parent.PrimaryPart.Position, destination)
	end)


	if success and path.Status == Enum.PathStatus.Success then
		-- Get the path waypoints
		waypoints = path:GetWaypoints()
		local isBlocked = false
		-- Detect if path becomes blocked
		blockedConnection = path.Blocked:Connect(function(blockedWaypointIndex)
			isBlocked = true
			-- Check if the obstacle is further down the path
			if blockedWaypointIndex >= nextWaypointIndex then
				-- Stop detecting path blockage until path is re-computed
				blockedConnection:Disconnect()
				-- Call function to re-compute new path

			end
		end)

		-- Detect when movement to next waypoint is complete
		for i, waypoint in pairs(waypoints) do
			if i == 1 then
				task.wait(0.1)
				playAnim:FireAllClients(script.Parent,"walk",1.23)
			end
			if not isBlocked then
				nextWaypointIndex = i
				human:MoveTo(waypoint.Position)
				human.MoveToFinished:Wait()
			else
				stopAnim:FireAllClients(script.Parent)
				task.wait(0.1)
				local tempZ,tempX = math.cos(math.rad(script.Parent.UpperTorso.Orientation.Y-90)),math.sin(math.rad(script.Parent.UpperTorso.Orientation.Y-90))
				local addToTempPos1
				local addToTempPos2
				local cos = math.random(0,2)
				local tempPos
				local adder = 0

				addToTempPos1 = Vector3.new((math.random(0,2*cos) + (math.random(0,2)*tempZ)),0,(math.random(0,2*cos)+(math.random(0,2)*tempX)))
				addToTempPos2 = Vector3.new((math.random(0,2)*tempX),0,(math.random(0,2)*tempZ))
				tempPos = script.Parent.UpperTorso.Position + addToTempPos1 + addToTempPos2
				adder += 1

				if adder >= 15 then
					adder = 0
					cos = math.random(0,2)
					addToTempPos1 = Vector3.new((math.random(0,4*cos) + (math.random(0,2)*tempZ)),0,(math.random(0,4*cos)+(math.random(0,2)*tempX)))
					addToTempPos2 = Vector3.new((math.random(0,3)*tempX),0,(math.random(0,3)*tempZ))
					tempPos = script.Parent.UpperTorso.Position - addToTempPos1 - addToTempPos2
					cos = math.random(1,3)
					adder += 1
					local pos
					pcall(function() 
						pos = script.Parent.Parent.Parent.ParkingBase.firstFind.Position
					end)
					if pos then
						if not GoHuman(Vector3.new(pos.X,1,pos.Z)) then
							script.Parent.PrimaryPart.Position = Vector3.new(pos.X,script.Parent.PrimaryPart.Position.Y,pos.Z)
						end
					end

				else
					if not GoHuman(Vector3.new(tempPos.X,1,tempPos.Z)) then
						script.Parent.PrimaryPart.Position = Vector3.new(tempPos.X,script.Parent.PrimaryPart.Position.Y,tempPos.Z)
					end
				end

				GoHuman(destination)
				break
			end
		end
		blockedConnection:Disconnect()
		task.wait(0.1)
		playAnim:FireAllClients(script.Parent,"breath",0.4)
	else
		warn("Path not computed!", errorMessage,"Typek"..script.Parent.KtoryToTypek.Value)
	end
	script.Parent:SetAttribute("beingMoved",false)
	return true
end


local function countCapacity(plr)
	local checkvalue = plr.ValueFolder.MaxCapacity.Value
	local ustawcapacity = 0
	for i,numa in ipairs(plr.TowarFolder:GetChildren()) do
		ustawcapacity = ustawcapacity + numa.Value
	end
	if checkvalue == 0 or checkvalue == nil then
		return 50,ustawcapacity
	elseif checkvalue == 1 then
		return 75,ustawcapacity
	elseif checkvalue == 2 then
		return 100,ustawcapacity
	elseif checkvalue == 3 then
		return 150,ustawcapacity
	elseif checkvalue == 4 then
		return 250,ustawcapacity
	elseif checkvalue == 5 then
		return 500,ustawcapacity
	end
end

local function getFrame(plr,name)
	if name == "DisplayTable" then
		return plr.PlayerGui.BuildUI.DisplayTableFrame
	elseif name == "Shelf" then
		return plr.PlayerGui.BuildUI.ShelfFrame
	elseif name == "SmallShelf" then
		return plr.PlayerGui.BuildUI.SmallShelfFrame
	end
end

-------------------------------------------

local function go(obj,storageDT)
	counter = 0
	local myStorage = storageDT[math.random(1,#storageDT)]

	local num = math.random(1,10)

	local firstPos

	if num > 5 then
		firstPos = myStorage.findRight.Position
	else
		firstPos = myStorage.findRight.Position
	end

	GoHuman(Vector3.new(firstPos.X,1,firstPos.Z))

	rotateMe(myStorage.findLeft.Orientation.Y)

	task.wait(1)

	GoHuman(Vector3.new(obj.findForStoreman.Position.X,1,obj.findForStoreman.Position.Z))

	task.wait(0.3)

	rotateMe(obj.findLeft.Orientation.Y)

	task.wait(0.3)

	local tempZ,tempX = math.cos(math.rad(obj.PrimaryPart.Orientation.Y-90)),math.sin(math.rad(obj.PrimaryPart.Orientation.Y-90))
	local addToTempPosPACK

	if math.abs(tempZ) > math.abs(tempX) then
		addToTempPosPACK = Vector3.new(2*tempZ,0,2*tempZ)
	else
		addToTempPosPACK = Vector3.new(2*tempX,0,2*tempX*-1)
	end
	
	local co = obj.Towar.KtoryArtykul.Value
	
	local towarCounter = 0
	
	for i,towar in ipairs(obj.Towar:FindFirstChild(co):GetChildren()) do
		if towar.Transparency == 0 then
			towarCounter += 1
		end
	end

	if plr.TowarFolder:FindFirstChild(co).Value == 0 or towarCounter == 6 then
		stopAnim:FireAllClients(script.Parent)

		task.wait(1)

		obj.beingHandled.Value = false

		local cos,sin = math.cos(math.rad(myStorage.PrimaryPart.Orientation.Y)),math.sin(math.rad(myStorage.PrimaryPart.Orientation.Y))
		local addToTempPos1
		local tempPos

		addToTempPos1 = Vector3.new((math.random(-5,-1) * plotCos * sin) + (math.random(-1,4) * cos),0,(math.random(-5,-1) * plotCos * cos) +(math.random(-1,4) * sin))
		tempPos = myStorage.findWait.Position + addToTempPos1

		tempPos = Vector3.new(tempPos.X,1,tempPos.Z)

		if not GoHuman(tempPos) then
			GoHuman(Vector3.new(myStorage.findWait.Position.X,1,myStorage.findWait.Position.Z))
		end
		return
	end
	
	towarCounter = 0

	local pack = game.ReplicatedStorage.StoremanPack:Clone()
	local pos = script.Parent.Head.Position
	pack.Orientation = script.Parent.PrimaryPart.Orientation
	pack.Position = Vector3.new(pos.X,0.667,pos.Z) + addToTempPosPACK
	task.wait(0.1)
	pack.Parent = script.Parent.Parent.Parent.Packs

	--resetAnims()

	if obj.Name == "DisplayTable" then
		playAnim:FireAllClients(script.Parent,"fdt",1.3)

		task.wait(7.2)

		for i,towar in ipairs(obj.Towar:FindFirstChild(co):GetChildren()) do
			if towar.Transparency == 0 then
				towarCounter += 1
			end
		end

		if towarCounter ~= obj.Towar.IleArtykul.Value then
			local capacity,ilejest = countCapacity(plr)
			towarmodule.erase(plr,obj,getFrame(plr,obj.Name),capacity,ilejest)
			local ile = plr.TowarFolder:FindFirstChild(co).Value
			local toggle 

			if plr.TowarFolder:FindFirstChild(co).Value >= 6 then
				toggle = true
			else	
				toggle = false
			end

			towarmodule.towar(plr, co, obj, toggle, ile)
			game.ReplicatedStorage.Events.TowarEvents.Zlicz:FireClient(plr)
		else
			towarmodule.uzupelnij(plr,co,obj)
		end

		task.wait(4)
	else
		playAnim:FireAllClients(script.Parent,"fs",1.3)

		task.wait(7.2)

		for i,towar in ipairs(obj.Towar:FindFirstChild(co):GetChildren()) do
			if towar.Transparency == 0 then
				towarCounter += 1
			end
		end

		if towarCounter ~= obj.Towar.IleArtykul.Value then
			local capacity,ilejest = countCapacity(plr)
			towarmodule.erase(plr,obj,getFrame(plr,obj.Name),capacity,ilejest)
			local ile = plr.TowarFolder:FindFirstChild(co).Value
			local toggle 

			if plr.TowarFolder:FindFirstChild(co).Value >= 6 then
				toggle = true
			else	
				toggle = false
			end

			towarmodule.towar(plr, co, obj, toggle, ile)
			game.ReplicatedStorage.Events.TowarEvents.Zlicz:FireClient(plr)
		else
			towarmodule.uzupelnij(plr,co,obj)
		end

		task.wait(3)

	end

	stopAnim:FireAllClients(script.Parent)

	pack:Destroy()

	task.wait(0.5)

	obj.beingHandled.Value = false

	local cos,sin = math.cos(math.rad(myStorage.PrimaryPart.Orientation.Y)),math.sin(math.rad(myStorage.PrimaryPart.Orientation.Y))
	local addToTempPos1
	local tempPos

	addToTempPos1 = Vector3.new((math.random(-5,-1) * plotCos * sin) + (math.random(-1,4) * cos),0,(math.random(-5,-1) * plotCos * cos) +(math.random(-1,4) * sin))
	tempPos = myStorage.findWait.Position + addToTempPos1

	tempPos = Vector3.new(tempPos.X,1,tempPos.Z)

	if not GoHuman(tempPos) then
		GoHuman(Vector3.new(myStorage.findWait.Position.X,1,myStorage.findWait.Position.Z))
	end

	return true
end


--{{----------------------------------MAIN------------------------------------------------}}


local function StoremanMainFunc()
	plotCos = math.cos(math.rad(script.Parent.Parent.Parent.Plot.Orientation.Y))

	playAnim:FireAllClients(script.Parent,"breath",0.4)

	plr = game.Players:FindFirstChild(script.Parent.Parent.Parent.wazne.Owner.Value)

	for i,j in pairs(human.Parent:GetChildren()) do
		if j.ClassName == "Part" or j.ClassName == "MeshPart" then
			j:SetNetworkOwner(plr)
		end
	end

	task.wait(0.15)

	for i,n in pairs(Enum.HumanoidStateType:GetEnumItems()) do
		if n ~= Enum.HumanoidStateType.None and n ~= Enum.HumanoidStateType.FallingDown and n ~= Enum.HumanoidStateType.GettingUp and n ~= Enum.HumanoidStateType.Running then
			human:SetStateEnabled(n,false)
		end
	end

	local plot = script.Parent.Parent.Parent

	local items = script.Parent.Parent.Parent.PlacedObjects:GetChildren()

	local storageDT = {}

	for i,n in pairs(plot.PlacedObjects:GetChildren()) do
		if n.Name == "Storage" then
			table.insert(storageDT,n)
		end
	end

	if #storageDT == 0 then
		errormodule.errorfuncGo(plr,"You don't have anything to store staff.")
		return false
	end

	local parking = script.Parent.Parent.Parent.ParkingBase

	local toggle = true

	local event = script.Parent.sendWork.Event:Connect(function(obj)
		pcall(function() 
			if obj then
				obj.beingHandled.Value = true
				currentObj = obj
				go(obj,storageDT)
			end
		end)
		toggle = true
	end)

	while true do
		task.wait(math.random(5,20)/10)
		if counter >= 3 and toggle then
			break
		end
		if toggle then
			toggle = false
			storemanModule.makeTask(script.Parent,plot,currentObj)
		end
		if #plot.Humans:GetChildren() == 0 then
			counter += 1
		end
	end

	destroyAnims:FireAllClients(script.Parent)

	task.wait(0.3)

	pcall(function() 
		script.Parent:Destroy()
	end)
end

--Main handler of starting the whole script

script.Parent.Changed:Connect(function(what)

	storemanModule= require(script.Parent.Parent.Parent.StoremanWorkModule)
	storemanAttrib = script.Parent.Parent.Parent.StoremanWorkModule

	if what == "Parent" then
		task.wait(0.5)
		CCfM()
		--initiateAnims:FireAllClients(script.Parent)
		task.wait(0.5)
		StoremanMainFunc()
	end
end)
