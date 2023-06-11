local PathFindingService = game:GetService("PathfindingService")
local PhysicsService = game:GetService("PhysicsService")

local NPCMove = "NPCMove"
local NPC = "NPC"

PhysicsService:RegisterCollisionGroup(NPCMove)
PhysicsService:RegisterCollisionGroup(NPC)

local npcsModule
local spawnModule
local attrib
local spawnAttrib

local playAnim = game.ReplicatedStorage.Events.AnimationEvents.playAnim
local stopAnim = game.ReplicatedStorage.Events.AnimationEvents.stopAnim
local initiateAnims = game.ReplicatedStorage.Events.AnimationEvents.initateAnims
local destroyAnims = game.ReplicatedStorage.Events.AnimationEvents.destroyAnims

local towarmodule = require(game.ReplicatedStorage.Modules.TowarModule)
local errormodule = require(game.ReplicatedStorage.Modules.ErrorModule)
local SPMoudule = require(game.ReplicatedStorage.Modules.SearchPosModule)

local human = script.Parent:WaitForChild("Humanoid")
local destination

local showOpinion = game.ReplicatedStorage.Events.NPCEvents.showOpinion

local plotCos

local wasDestroyed = false

local pathParams = {
	AgentRadius = 2.25,
	AgentHeight = 5,
	AgentCanJump = false,
	WaypointSpacing = 50,
	Costs = {
		Grass = 3.5,
		SmoothPlastic = 5
	}
}

local ilosc = 0
local path = PathFindingService:CreatePath(pathParams)

local waypoints
local nextWaypointIndex = 0
local blockedConnection

local blockedEvent

local arrivedToggle = false

local li
local zarobas = 0
local plr

local cashreg = nil
local miejsce = nil

local isOpinionGiven = false
local cenaNabywcza = 0
local cenaWSklepie = 0

local ileDodac = 0

local goHumanEndToggle = false

local HighPriceTexts = {"Prices are very high!","I will think next time before buying something for this price!","Prices are ridiculus!","Someone doesn't care about good opinion, cash is more important."}

local SUPERHighPrices = {"I won't buy there anything in the future with prices high like that!","Manager is super money-grubber! I hate that!","This shop is joke with these prices.","Are you crazy about those prices?!"}

local okPriceTexts = {"Prices are good I think.","Prices are normal.","Most of shops have prices like this.","Nothing special about prices.","It's an ok price, not too cheap but not too expensive either.","The prices are fair, they're ok.","I can afford it, the price is ok."}

local superPricesText = {"These prices are best!","It's so cheap here!","I love these prices!","It's a super good deal, I'm definitely buying it.","The prices are super competitive, I can't find a better deal."}

local interiorDesignBad = {"This shop's interior is... empty.","Only cash registers and furnitures for products.","I would add something to that interior.","The interior design is empty, it lacks personality.","The space feels empty, it needs more decor.","There's no character in the design, it feels empty."}

local interiorOk = {"Interior is preety good.","This interior design is ok.","The interior design is ok, it's not too bad but not too great either.","The design is alright, it's not amazing but it's functional.","It's an ok interior design, it's not my style but I can appreciate it."}

local interiorDesingGood = {"I like this interior!","Interior design is really cool in my opinion.","I like shops with interiors like this.","I love the interior design, it's stylish and functional.","The design is excellent, it's creative and unique.","It's a good interior design, it's beautiful and makes the space feel inviting."}

local eqBad = {"I can't buy much here.","I hope that new products will be avaiable in nearest future.","I can't buy everything I want from here.","The shop has a limited selection, there are only a few products to choose from.","There isn't much variety, the shop has a small amount of products.","The product selection is limited, there's not much to choose from in the shop."}

local eqGood = {"I can buy anything here!","One of the best equipped shops in the area!","It is really cool that I can buy all I want here.","The shop has a huge selection, there are so many products to choose from.","It's a big shop, there are a lot of products to buy.","The shop has an extensive range of products, there's so much to choose from."}

local opinionGui = script.Parent.Head.Opinion

local BColors = {3, 5, 12, 18, 108, 128, 138, 224, 224, 226, 226}
local SColors = {145, 146, 147, 148, 149, 150, 168, 176, 178, 179, 200}
local PColors = {190, 191, 193, 1024, 1025, 1026, 1027, 1028, 1029, 1030}
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

--[[ ANIMS LENGTHS normal(after adjust)
	Paying - 6.8 (4.47)
	TakingDP - 8.067 (4.89)
	TakingS - 7.767 (4.7)	
]]

function NieZajete()
	local places = script.Parent.Parent.Parent.ParkingBase.Miejsca
	if places:FindFirstChild(script.Parent:GetAttribute("KtoreMiejsce")) then
		places[script.Parent:GetAttribute("KtoreMiejsce")].Zajete.Value = false
	end
end

local function giveOpinion()

	if not plr or not plr:FindFirstChild("leaderstats") or wasDestroyed then
		return false
	end
	
	local specialNum = 56
	
	local nowRat = plr.rating.RatingNow.Value
	
	if nowRat < 70 then
		specialNum -= math.floor((70 - nowRat) / 1.53)
	end

	if math.random(1,100) > specialNum then

		pcall(function() 
			attrib.addWaiter:Fire(2.5)
		end)

		local highMulit = tonumber("1."..tostring(math.random(181,210)))

		local okCena = math.floor(cenaNabywcza * highMulit)
		local superPrice = math.floor(cenaNabywcza * 1.10)
		local tooHighPrice = math.floor(cenaNabywcza * 1.25)
		local priceStatus
		local interiorDesign
		local equOfShop

		local forOpinion = {}

		if cenaWSklepie <= okCena and cenaWSklepie > superPrice then
			local priceNum = 4
			
			if nowRat < 10 then
				priceNum = 0
			elseif nowRat < 25 then
				priceNum = 1
			elseif nowRat < 50 then
				priceNum = 2
			elseif nowRat < 75 then
				priceNum = 3
			end
			
			if math.random(1,10) > priceNum then
				ileDodac += 1
			end
			table.insert(forOpinion,"okPrice")
		end

		if cenaWSklepie >= okCena and cenaWSklepie < tooHighPrice then
			if math.random(1,10) > 2 then
				ileDodac -= 2
				table.insert(forOpinion,"highPrice")
			end
		elseif cenaWSklepie >= tooHighPrice then
			if math.random(1,10) > 1 then
				ileDodac -= 3
				table.insert(forOpinion,"superHighPrice")
			end
		end

		if cenaWSklepie <= superPrice then
			if math.random(1,10) > 4 then
				ileDodac += 1
			end
			table.insert(forOpinion,"superPrice")
		end

		local ilePrzedmiotow = 0
		local howManyPlots = plr.hidden.IleC.Value + plr.hidden.IleL.Value + plr.hidden.IleR.Value
		local articles = {}

		for i,n in pairs(script.Parent.Parent.Parent.PlacedObjects:GetChildren()) do
			if n.Name == "InfoSignOnCelling" or n.Name == "InfoSignOnWall" or n.Name == "LittleTree" or n.Name == "Bush" or n.Name == "BigPillar" or n.Name == "Pillar" then
				ilePrzedmiotow += 1
			end
			if n.Name == "DisplayTable" or string.match(n.Name,"Shelf") then
				if n.Towar.KtoryArtykul.Value then
					if not table.find(articles,n.Towar.KtoryArtykul.Value) then
						table.insert(articles,n.Towar.KtoryArtykul.Value)
					end
				end
			end
		end

		task.wait(0.1)

		if ilePrzedmiotow >= howManyPlots * 5 then
			if math.random(1,10) > 3 then
				ileDodac += 1
			end
			table.insert(forOpinion,"goodInterior")
		elseif #articles > 8 then
			if math.random(1,10) > 3 then
				ileDodac += 1
			end
			table.insert(forOpinion,"goodEq")
		elseif ilePrzedmiotow >= howManyPlots * 2 and #articles > 3 then
			table.insert(forOpinion,"eqIsOk")
			table.insert(forOpinion,"interiorIsOk")
			if math.random(1,10) > 3 then
				ileDodac += 1
			end
		elseif ilePrzedmiotow == 0 then
			table.insert(forOpinion,"interiorIsBad")
			if howManyPlots > 1 then
				ileDodac -= 1
			end
		end

		local randOpinion = forOpinion[math.random(1,#forOpinion)]

		if randOpinion == "okPrice" then
			showOpinion:FireClient(plr,script.Parent,okPriceTexts[math.random(1,#okPriceTexts)],Enum.FrameStyle.ChatBlue)
		elseif randOpinion == "highPrice" then
			showOpinion:FireClient(plr,script.Parent,HighPriceTexts[math.random(1,#HighPriceTexts)],Enum.FrameStyle.ChatRed)
		elseif randOpinion == "superHighPrice" then
			showOpinion:FireClient(plr,script.Parent,SUPERHighPrices[math.random(1,#SUPERHighPrices)],Enum.FrameStyle.ChatRed)
		elseif randOpinion == "superPrice" then
			showOpinion:FireClient(plr,script.Parent,superPricesText[math.random(1,#superPricesText)],Enum.FrameStyle.ChatGreen)
		elseif randOpinion == "goodInterior" then
			showOpinion:FireClient(plr,script.Parent,interiorDesingGood[math.random(1,#interiorDesingGood)],Enum.FrameStyle.ChatGreen)
		elseif randOpinion == "goodEq" then
			showOpinion:FireClient(plr,script.Parent,eqGood[math.random(1,#eqGood)],Enum.FrameStyle.ChatGreen)
		elseif randOpinion == "eqIsOk" then
			showOpinion:FireClient(plr,script.Parent,eqGood[math.random(1,#eqGood)],Enum.FrameStyle.ChatBlue)
		elseif randOpinion == "interiorIsOk" then
			showOpinion:FireClient(plr,script.Parent,interiorOk[math.random(1,#interiorOk)],Enum.FrameStyle.ChatBlue)
		elseif randOpinion == "interiorIsBad" then
			showOpinion:FireClient(plr,script.Parent,interiorDesignBad[math.random(1,#interiorDesignBad)],Enum.FrameStyle.ChatRed)
		end
		
		local zeroRand = 6
		
		if nowRat < 13 then
			if math.random(1,7) > 4 then
				ileDodac += 1
			end
		end
		
		if nowRat < 10 then
			zeroRand = 9
		elseif nowRat < 25 then
			zeroRand = 8
		elseif nowRat < 50 then
			zeroRand = 7
		end

		if ileDodac > 0 and math.random(1,10) > zeroRand then
			ileDodac = 0
		end

		isOpinionGiven = true
		task.wait(1.8)
	end
end

local function checkForDialogAlready()
	if wasDestroyed then
		return true
	end
	for i,n in pairs(script.Parent.Parent:GetChildren()) do
		if n:GetAttribute("isDialog") then
			return true
		end
	end
	return false
end


local function dialogFunc(state)
	if not checkForDialogAlready() then
		local retrunValue,products
		script.Parent:SetAttribute('isDialog',true)

		local counterToggle = false
		local counter = 0

		local event = game.ReplicatedStorage.Events.NPCEvents.dialogRes.OnServerEvent:Connect(function(player,rV,ps)
			if player == plr then
				retrunValue,products = rV,ps
				counterToggle = true
			end
		end)

		game.ReplicatedStorage.Events.NPCEvents.dialogReq:FireClient(plr,state,script.Parent)

		repeat
			counter += task.wait(1)
		until counterToggle or counter >= 28

		pcall(function()
			event:Disconnect()
		end)

		if counter >= 28 then
			return false
		end

		return retrunValue,products
	end
end


function iodnowa(cos)
	if wasDestroyed then
		return
	end

	local carsucc, carerr = pcall(function()
		if script.Parent.WichPark.Value then
			script.Parent.WichPark.Value:Destroy()
		end
	end)

	if not carsucc then
		warn(carerr)
	end

	destroyAnims:FireAllClients(script.Parent)

	if ileDodac ~= 0 and plr then
		if plr.rating.RatingMax.Value > (plr.rating.RatingNow.Value + ileDodac) and (plr.rating.RatingNow.Value + ileDodac) >= 0  then
			plr.rating.RatingNow.Value  += ileDodac
			ileDodac = 0
		elseif (plr.rating.RatingNow.Value + ileDodac) < 0 then
			plr.rating.RatingNow.Value = 0
		else
			plr.rating.RatingNow.Value = plr.rating.RatingMax.Value
		end
	end

	if zarobas and zarobas > 0 then
		local multiplier = 1 + (plr.RBFolder.boostPerc.Value/100)
		zarobas = math.round(zarobas * multiplier)
		plr.leaderstats.Cash.Value += zarobas
		zarobas = 0
	end

	NieZajete()

	task.wait(1)

	spawnModule.makeTask(script.Parent)

	local succ,err = pcall(function() 
		script.Parent:Destroy()
	end)

	if not succ then
		warn("Error while destroying",succ,err)
	else
		wasDestroyed = true
	end
	task.wait(1)
end


function GoHuman(destination,model,findSpot)

	if wasDestroyed then
		return
	end

	stopAnim:FireAllClients(script.Parent)

	while script.Parent:GetAttribute("beingMoved") do
		task.wait(0.2)
	end

	script.Parent:SetAttribute("beingMoved",true)

	local success, errorMessage

	if model == "modelTemp" then
		success, errorMessage = pcall(function()
			path:ComputeAsync(destination,script.Parent.PrimaryPart.Position)
		end)
	else
		success, errorMessage = pcall(function()
			path:ComputeAsync(script.Parent.PrimaryPart.Position,destination)
		end)
	end

	task.wait(0.05)

	local blocked = false

	if success and path.Status == Enum.PathStatus.Success then
		-- Get the path waypoints
		waypoints = path:GetWaypoints()

		if model == "modelTemp" then
			local index = 1
			local orderedWaypoints = {}

			for i=#waypoints,1,-1 do
				orderedWaypoints[index] = waypoints[i]
				index += 1
			end

			waypoints = orderedWaypoints
		end
		-- Detect if path becomes blocked
		blockedConnection = path.Blocked:Connect(function(blockedWaypointIndex)
			-- Check if the obstacle is further down the path
			if blockedWaypointIndex >= nextWaypointIndex and not blocked then
				blocked = true
				-- Stop detecting path blockage until path is re-computed
				playAnim:FireAllClients(script.Parent,"breath",0.4)
				blockedConnection:Disconnect()
			end
		end)

		for i, waypoint in pairs(waypoints) do
			if i == 2 then
				playAnim:FireAllClients(script.Parent,"walk",1.05)
				task.wait(0.1)
			end

			if not script.Parent:GetAttribute("beingMoved") then
				break
			end

			if not blocked then
				nextWaypointIndex = i
				human:MoveTo(waypoint.Position)
				human.MoveToFinished:Wait()
			else
				stopAnim:FireAllClients(script.Parent)
				local tempZ,tempX = math.cos(math.rad(script.Parent.UpperTorso.Orientation.Y-90)),math.sin(math.rad(script.Parent.UpperTorso.Orientation.Y-90))
				local addToTempPos1
				local tempPos
				local adder = 0


				addToTempPos1 = Vector3.new((math.random(0,2) + (math.random(0,2)*tempZ)),0,(math.random(0,2)+(math.random(0,2)*tempX)))
				tempPos = script.Parent.UpperTorso.Position + addToTempPos1

				script.Parent:SetAttribute("beingMoved",false)

				if adder >= 15 then
					adder = 0

					addToTempPos1 = Vector3.new((math.random(0,4) + (math.random(0,2)*tempZ)),0,(math.random(0,4)+(math.random(0,2)*tempX)))
					tempPos = script.Parent.UpperTorso.Position - addToTempPos1

					local pos

					pcall(function() 
						pos = script.Parent.Parent.Parent.ParkingBase.firstFind.Position
					end)

					if pos then
						local success = GoHuman(Vector3.new(tempPos.X,1,tempPos.Z),"from goHuman",findSpot)
						task.wait(0.03)
						if not success then
							pcall(function() 
								script.Parent.PrimaryPart.Position = Vector3.new(pos.X,script.Parent.PrimaryPart.Position.Y,pos.Z)
							end)
						end
					end

				else
					local success = GoHuman(Vector3.new(tempPos.X,1,tempPos.Z),"from goHuman",findSpot)
					task.wait(0.03)
					if not success then
						pcall(function() 
							script.Parent.PrimaryPart.Position = Vector3.new(tempPos.X,script.Parent.PrimaryPart.Position.Y,tempPos.Z)
						end)
					end
				end
				GoHuman(destination,"from goHuman",findSpot)
				break
			end
		end

		blockedConnection:Disconnect()

		playAnim:FireAllClients(script.Parent,"breath",0.4)

	else
		if goHumanEndToggle then
			iodnowa()
			return false
		end

		if not arrivedToggle then
			goHumanEndToggle = true

			local park = script.Parent.WichPark.Value
			script.Parent:SetAttribute("beingMoved",false)
			if park and park:FindFirstChild("Starter") and model ~= "Starter" then
				go(park.Starter, false,nil,true)
			else
				go(script.Parent.Parent.Parent.Spawnery.Spawner, false,nil,true)
			end
		end
		return false
	end

	task.wait(0.05)

	pcall(function() 
		script.Parent:SetAttribute("beingMoved",false)
	end)
	return true
end

--Spot function

local function calculateSpotSite(leftSpot,rightSpot)
	if leftSpot >= 1 and rightSpot >= 1 then
		if leftSpot == rightSpot then
			if math.random(1,2) == 1 then
				return "LeftSpot"
			else
				return "RightSpot"
			end
		elseif leftSpot < rightSpot then
			return "LeftSpot"
		elseif leftSpot > rightSpot then
			return "RightSpot"
		end
	elseif leftSpot == 0 and rightSpot == 0 then
		if math.random(1,2) == 1 then
			return "LeftSpot"
		else
			return "RightSpot"
		end
	elseif leftSpot == 0 and rightSpot >= 1 then
		return "LeftSpot"
	elseif leftSpot >= 1 and rightSpot == 0 then
		return "RightSpot"
	end
	task.wait(0.1)
end


--Rotate Customer function


function rotateMe(model,find,queueToggle)
	stopAnim:FireAllClients(script.Parent)
	
	task.wait(0.1)

	if script.Parent:GetAttribute("beingMoved") then
		return false
	end

	local findOrient = find

	if queueToggle then
		if model.Name == "CashReg" then
			findOrient -= 90
		else
			findOrient += 90
		end
	end

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

-------------------------------------------

function go(model,toggle,pos,isFromGoHuman)
	if wasDestroyed then
		return
	end

	local addToTempPos1
	local addToTempPos2
	local tempPos

	local findSpot
	local spot
	local tak = true

	npcsModule = nil

	destination = nil

	if model then
		local stringToAnalyze

		if model ~= "search" then
			stringToAnalyze = model.Name
		else
			stringToAnalyze = model
		end

		if string.match(stringToAnalyze,"CashReg") then		
			local cos,sin = math.cos(math.rad(model.PrimaryPart.Orientation.Y)),math.sin(math.rad(model.PrimaryPart.Orientation.Y))

			local adder = 0

			addToTempPos1 = Vector3.new((math.random(-4,-1) * plotCos * sin) + (math.random(-3,3) * cos),0,(math.random(-4,-1) * plotCos * cos) +(math.random(-3,3) * sin))
			tempPos = model.find.Position + addToTempPos1

			tempPos = Vector3.new(tempPos.X,1,tempPos.Z)


			if adder >= 45 then		
				GoHuman(Vector3.new(model.find.Position.X,1,model.find.Position.Z),"cashReg adder")
			else
				GoHuman(Vector3.new(tempPos.X,1,tempPos.Z),"cashReg adder")
			end

			npcsModule = require(model.NPCsModule)
			attrib = model.NPCsModule

			task.wait(0.1)

			findSpot = model.find.Name
			spot = findSpot

			local waiterValue = 10

			local currentQueue = nil
			local activateVal = nil
			local endWaiter = false

			local z,x = math.cos(math.rad(model.PrimaryPart.Orientation.Y-90)),math.sin(math.rad(model.PrimaryPart.Orientation.Y-90))

			local calculatePosition

			local opinionG

			local isReset = false

			if wasDestroyed then
				return
			end

			script.updateSpot.OnInvoke = function(queue,isReseted,opinion)
				currentQueue = queue

				if currentQueue < 0 then
					currentQueue = 0
				end

				if isReseted then
					isReset = isReseted
				end

				return true
			end

			local addEvent = attrib.addWaiter.Event:Connect(function(addThis)
				waiterValue += addThis
			end)

			local counter = 0

			task.wait(0.15)

			npcsModule.imArrived(script.Parent,model,findSpot)

			local firstQueue

			arrivedToggle = true


			repeat 
				counter += task.wait(0.1)
				if activateVal ~= currentQueue then

					local tempQueue = currentQueue

					if not firstQueue then
						firstQueue = tempQueue
					end

					waiterValue = 10 --7.95
					counter = 0

					if tempQueue == 0 and activateVal ~= nil then
						task.wait((math.random(5,9)/10))
					elseif tempQueue > 0 and activateVal ~= nil then
						task.wait((math.random(7,12)/10)*tempQueue)
					end

					if model.Name == "CashReg" then
						calculatePosition = model[spot].Position+Vector3.new(3*tempQueue*x*-1,1,3*tempQueue*z*-1)
					else
						calculatePosition = model[spot].Position+Vector3.new(3*tempQueue*x,1,3*tempQueue*z)
					end

					playAnim:FireAllClients(script.Parent,"walk",1.05)
					task.wait(0.1)
					human:MoveTo(calculatePosition)
					human.MoveToFinished:Wait()
					playAnim:FireAllClients(script.Parent,"breath",0.4)
					task.wait(0.5)

					if tempQueue > 0 and activateVal == nil then
						rotateMe(model,model.find.Orientation.Y,true)
					elseif tempQueue == 0 then
						rotateMe(model,model.find.Orientation.Y)
					end

					activateVal = tempQueue
				end
				if isReset then
					isReset = false
					waiterValue += 10
				end
			until activateVal == 0 or counter >= waiterValue

			if counter >= waiterValue then
				print("RESET QUEUES",firstQueue,waiterValue,firstQueue,counter)
				npcsModule.resetQueues(script.Parent,model,findSpot)
				calculatePosition = model[spot].Position
				local dest = Vector3.new(calculatePosition.X,1,calculatePosition.Z)
				GoHuman(dest,"reset")
				rotateMe(model,model.find.Orientation.Y)
			end

			script.updateSpot.OnInvoke = function() return false end
			addEvent:Disconnect()

			playAnim:FireAllClients(script.Parent,"crp",1.52)

			task.wait(2.6)

			if zarobas then
				local multiplier = 1 + (plr.RBFolder.boostPerc.Value/100)
				zarobas = math.round(zarobas * multiplier)
				task.wait(0.1)
				game.ReplicatedStorage.Events.NPCEvents.paymentAnim:FireClient(plr,model,zarobas)
				task.wait(1)
				plr.leaderstats.Cash.Value += zarobas
				zarobas = 0
			end

			task.wait(1)

			if not isOpinionGiven then
				if math.random(1,10) > 2 then
					giveOpinion()
				end
			end

			if not wasDestroyed and arrivedToggle then
				npcsModule.spotMinus1(script.Parent,model)
			end

			arrivedToggle = false		
		elseif model.Name == "firstFind" or model.Name == "secondFind" or model.Name == "rightFind" or model.Name == "leftFind" then

			local cos,sin = math.cos(math.rad(model.Orientation.Y)),math.sin(math.rad(model.Orientation.Y))

			local adder = 0

			addToTempPos1 = Vector3.new((math.random(-4,-1) * plotCos * sin) + (math.random(-3,3) * cos),0,(math.random(-4,-1) * plotCos * cos) +(math.random(-3,3) * sin))
			tempPos = model.Position + addToTempPos1

			tempPos = Vector3.new(tempPos.X,1,tempPos.Z)

			if adder >= 25 then
				destination = model.Position
			else
				destination = tempPos
			end

		elseif model.Name == "Spawner" then		

			local cos,sin = math.cos(math.rad(model.Orientation.Y)),math.sin(math.rad(model.Orientation.Y))

			local adder = 0

			addToTempPos1 = Vector3.new((math.random(-4,-1) * plotCos * sin) + (math.random(-3,3) * cos),0,(math.random(-4,-1) * plotCos * cos) +(math.random(-3,3) * sin))
			tempPos = model.Position + addToTempPos1

			tempPos = Vector3.new(tempPos.X,1,tempPos.Z)

			if adder >= 25 then
				destination = model.Position
			else
				destination = tempPos
			end
		elseif model.Name == "Starter" then
			local cos,sin = math.cos(math.rad(model.Orientation.Y)),math.sin(math.rad(model.Orientation.Y))

			local adder = 0

			addToTempPos1 = Vector3.new((math.random(-4,-1) * plotCos * sin) + (math.random(-3,3) * cos),0,(math.random(-4,-1) * plotCos * cos) +(math.random(-3,3) * sin))
			tempPos = model.Position + addToTempPos1

			tempPos = Vector3.new(tempPos.X,1,tempPos.Z)

			if adder >= 25 then
				destination = model.Position
			else
				destination = tempPos
			end
		elseif model.Name == "Spawn" then
			local cos,sin = math.cos(math.rad(model.Orientation.Y)),math.sin(math.rad(model.Orientation.Y))

			local adder = 0

			addToTempPos1 = Vector3.new((math.random(-4,-1) * plotCos * sin) + (math.random(-3,3) * cos),0,(math.random(-4,-1) * plotCos * cos) +(math.random(-3,3) * sin))
			tempPos = model.Position + addToTempPos1

			tempPos = Vector3.new(tempPos.X,1,tempPos.Z)

			if adder >= 25 then
				destination = model.Position
			else
				destination = tempPos
			end

		elseif model.Name == "DisplayTable" or model.Name == "Shelf" or model.Name == "SmallShelf" then
			attrib = model.NPCsModule
			npcsModule = require(model.NPCsModule)

			task.wait(0.1)

			local cos,sin = math.cos(math.rad(model.PrimaryPart.Orientation.Y)),math.sin(math.rad(model.PrimaryPart.Orientation.Y))

			local site = math.random(1,2)


			addToTempPos1 = Vector3.new((math.random(-4,-1) * plotCos * sin) + (math.random(-3,3) * cos),0,(math.random(-4,-1) * plotCos * cos) +(math.random(-3,3) * sin))

			if site == 1 then
				tempPos = model.findLeft.Position + addToTempPos1
			elseif site == 2 then
				tempPos = model.findRight.Position + addToTempPos1
			end

			tempPos = Vector3.new(tempPos.X,1,tempPos.Z)

			GoHuman(tempPos,"modelTemp")

			findSpot = calculateSpotSite(model.SpotValues.LeftSpot.Value,model.SpotValues.RightSpot.Value)

			local currentQueue = nil
			local activateVal = nil
			local z,x = math.cos(math.rad(model.PrimaryPart.Orientation.Y-90)),math.sin(math.rad(model.PrimaryPart.Orientation.Y-90))
			local calculatePosition 

			if findSpot == "LeftSpot" then
				spot = "findLeft"
			elseif findSpot == "RightSpot" then
				spot = "findRight"
			end

			local waiterValue = 10

			local isReset = false

			if wasDestroyed then
				return
			end

			script.updateSpot.OnInvoke = function(queue,isReseted)
				currentQueue = queue

				if currentQueue < 0 then
					currentQueue = 0
				end

				if isReseted then
					isReset = isReseted
				end

				return true
			end

			local addEvent = attrib.addWaiter.Event:Connect(function(addThis)
				waiterValue += addThis
			end)

			local counter = 0

			task.wait(0.15)

			npcsModule.imArrived(script.Parent,model,findSpot)
			arrivedToggle = true

			repeat 
				counter += task.wait(0.1)
				if activateVal ~= currentQueue then
					local tempQueue = currentQueue

					waiterValue += 11
					counter = 0		

					if tempQueue == 0 and activateVal ~= nil then
						task.wait((math.random(5,8)/10))
					elseif tempQueue > 0 and activateVal ~= nil then
						task.wait((math.random(11,13)/10)*tempQueue)
					end

					calculatePosition = model[spot].Position+Vector3.new(3*tempQueue*z*-1,1,3*tempQueue*x)

					playAnim:FireAllClients(script.Parent,"walk",1.05)
					task.wait(0.1)
					human:MoveTo(calculatePosition)
					human.MoveToFinished:Wait()
					task.wait(0.5)
					playAnim:FireAllClients(script.Parent,"breath",0.4)

					if tempQueue > 0 and activateVal == nil then
						rotateMe(model,model.findLeft.Orientation.Y)
					elseif tempQueue == 0 then
						rotateMe(model,model.findLeft.Orientation.Y)
					end

					activateVal = tempQueue
				end
				if isReset then
					isReset = false
					waiterValue += 11
				end
			until activateVal == 0 or counter >= waiterValue

			if counter >= waiterValue then
				print("RESET QUEUES 2",findSpot,spot)
				npcsModule.resetQueues(script.Parent,model,findSpot)
				local succ,err = pcall(function() 
					calculatePosition = model:FindFirstChild(spot).Position
					local dest = Vector3.new(calculatePosition.X,1,calculatePosition.Z)
					GoHuman(dest,"reset2")
					rotateMe(model,model.findLeft.Orientation.Y)
				end)
				if not succ then
					warn("error with spot",spot,err)
				end
			end

			script.updateSpot.OnInvoke = function() return false end

			stopAnim:FireAllClients(script.Parent)

		else
			if pos then
				destination = pos
			end
		end
	end

	local specialitems = nil

	if toggle then

		local co = model.Towar.KtoryArtykul.Value
		if co == nil then
			if not wasDestroyed then
				npcsModule.spotMinus1(script.Parent,model,findSpot)
			end
			arrivedToggle = false
			return
		end

		local checkspecialitems = model.Towar:FindFirstChild(co)

		if checkspecialitems then
			specialitems = checkspecialitems:GetChildren()
			local towar
			local ilerazy = 0
			local iletowar = 0
			ilosc = math.random(0,10)
			
			if ilosc > 0 then
				iletowar = 1
			else
				task.wait(2)
				if not wasDestroyed then
					npcsModule.spotMinus1(script.Parent,model,findSpot)
				end
				arrivedToggle = false
				return false
			end
			
			if iletowar < 1 then
				task.wait(2)
				if not wasDestroyed then
					npcsModule.spotMinus1(script.Parent,model,findSpot)
				end
				arrivedToggle = false
				return false
			end

			for i=1,iletowar do
				plr = game.Players:FindFirstChild(script.Parent.Parent.Parent.wazne.Owner.Value)

				cenaWSklepie = plr.CenaFolder:FindFirstChild(co).Value

				if co == "telefony" then
					cenaNabywcza += 100
				elseif co == "aparaty" then
					cenaNabywcza +=  250
				elseif co == "tablety" then
					cenaNabywcza += 150	
				elseif co == "telewizory" then
					cenaNabywcza += 1500	
				elseif co == "konsole" then
					cenaNabywcza += 700	
				elseif co == "komputery" then
					cenaNabywcza += 1000
				elseif co == "monitory" then
					cenaNabywcza += 600
				elseif co == "klawiatury" then
					cenaNabywcza += 70
				elseif co == "myszki" then
					cenaNabywcza += 30
				elseif co == "glosniki" then
					cenaNabywcza += 150
				elseif co == "sluchawki" then
					cenaNabywcza += 90
				end

				local okCena = math.floor(cenaNabywcza * 1.20)

				local staffTable = {}

				for i,oneStaff in pairs(specialitems) do
					if oneStaff.Transparency == 0 then
						table.insert(staffTable,oneStaff)
					end
				end

				if #staffTable == 0 then
					ilerazy = 10
				end

				if ilerazy < 5 then
					repeat

						if model.Towar.IleArtykul.Value > 0 and #staffTable > 0 then
							ilerazy += 1
							towar = staffTable[math.random(1,#staffTable)]
						else
							ilerazy = 15
						end
					until towar.Name == "Part" and towar.Transparency == 0 or ilerazy >= 5
				end

				if ilerazy >= 5 then
					task.wait(1)
					if arrivedToggle and not wasDestroyed then
						npcsModule.spotMinus1(script.Parent,model,findSpot)
					end
					arrivedToggle = false
					return false
				end
				towar.Transparency = 0.02
				
				task.wait(0.05)

				if cenaWSklepie > okCena then
					if math.random(1,10) <= 6 then
						if arrivedToggle and not wasDestroyed then
							task.wait(1)
							npcsModule.spotMinus1(script.Parent,model,findSpot)
						end
						towar.Transparency = 0
						arrivedToggle = false
						return false
					end
				end

				local succ,err = pcall(function() 
					if towar.Transparency == 1 then

						specialitems = checkspecialitems:GetChildren()

						table.clear(staffTable)

						for i,oneStaff in pairs(specialitems) do
							if oneStaff.Transparency == 0 then
								table.insert(staffTable,oneStaff)
							end
						end
						if #staffTable == 0 then
							if arrivedToggle and not wasDestroyed then
								task.wait(1)
								npcsModule.spotMinus1(script.Parent,model,findSpot)
							end
							arrivedToggle = false
							isOpinionGiven = true
							return false
						end

						ilerazy = 0

						repeat

							if model.Towar.IleArtykul.Value > 0 and #staffTable > 0 then
								ilerazy += 1
								towar = staffTable[math.random(1,#staffTable)]
							else
								ilerazy = 15
							end
						until towar.Name == "Part" and towar.Transparency == 0 or ilerazy >= 5

						if ilerazy >= 5 then
							task.wait(1)
							if arrivedToggle and not wasDestroyed then
								npcsModule.spotMinus1(script.Parent,model,findSpot)
							end
							arrivedToggle = false
							isOpinionGiven = true
							return false
						end
						towar.Transparency = 0.02
					end
					if model.Name == "DisplayTable" then

						playAnim:FireAllClients(script.Parent,"tdt",1.65)

						task.wait(3.4)
						
						if math.round(towar.Transparency*100) == 2 then
							towar.Transparency = 1
						else
							ilerazy = 0

							if #staffTable == 0 then
								ilerazy = 15
							else
								repeat
									if model.Towar.IleArtykul.Value > 0 and #staffTable > 0 then
										ilerazy += 1
										towar = staffTable[math.random(1,#staffTable)]
									else
										ilerazy = 5
									end
								until towar.Name == "Part" and towar.Transparency == 0 or ilerazy >= 5
							end

							if ilerazy >= 5 then
								task.wait(1)
								if arrivedToggle and not wasDestroyed then
									npcsModule.spotMinus1(script.Parent,model,findSpot)
								end
								arrivedToggle = false
								isOpinionGiven = true
								return false
							end
							towar.Transparency = 1
						end

						model.Towar.IleArtykul.Value -= 1

						if model.Towar.IleArtykul.Value < 0 then
							model.Towar.IleArtykul.Value = 0
						end

						task.wait(2.5)

						stopAnim:FireAllClients(script.Parent)
					else
						playAnim:FireAllClients(script.Parent,"ts",1.65)

						task.wait(3.4)
						
						if math.round(towar.Transparency*100) == 2 then
							towar.Transparency = 1
						else
							ilerazy = 0
							if #staffTable == 0 then
								ilerazy = 15
							else
								repeat
									if model.Towar.IleArtykul.Value > 0 and #staffTable > 0 then
										ilerazy += 1
										towar = staffTable[math.random(1,#staffTable)]
									else
										ilerazy = 15
									end
								until towar.Name == "Part" and towar.Transparency == 0 or ilerazy >= 5
							end

							if ilerazy >= 15 then
								task.wait(1)
								if arrivedToggle and not wasDestroyed then
									npcsModule.spotMinus1(script.Parent,model,findSpot)
								end
								arrivedToggle = false
								isOpinionGiven = true
								return false
							end
							towar.Transparency = 1
						end

						model.Towar.IleArtykul.Value -= 1

						if model.Towar.IleArtykul.Value < 0 then
							model.Towar.IleArtykul.Value = 0
						end

						task.wait(1.85)

					end				
					playAnim:FireAllClients(script.Parent,"breath",0.4)
				end)

				if not succ then
					if math.round(towar.Transparency*100) == 2 then
						towar.Transparency = 0
					end
					warn(err)
					if arrivedToggle and not wasDestroyed then
						npcsModule.spotMinus1(script.Parent,model,findSpot)
					end
					arrivedToggle = false
					isOpinionGiven = true
					return false
				end


				if co then
					zarobas += plr.CenaFolder:FindFirstChild(co).Value
				end

				if not isOpinionGiven then
					if math.random(1,10) > 2 then
						giveOpinion()
					end
				end
			end
		end
	end

	if findSpot and not string.match(model.Name,"CashReg") and not wasDestroyed and arrivedToggle then
		npcsModule.spotMinus1(script.Parent,model,findSpot)
		arrivedToggle = false
	end

	if model.Name ~= "DisplayTable" and model.Name ~= "Shelf" and model.Name ~= "SmallShelf" then
		if destination then
			GoHuman(destination,model.Name)
		end
	end
	if model.Name == "Spawner" or model.Name == "Starter" then
		iodnowa()
	end
	return true
end


local function checkProductOnModel(product,check)
	if product == check then
		return true
	end
	return false
end

--Function that checks if player's plot has avaible products that are included in dialog

local function checkDialogProduct(product)
	local check
	local availStaff = {}
	for i,n in pairs(script.Parent.Parent.Parent.PlacedObjects:GetChildren()) do
		if n.Name == "DisplayTable" or n.Name == "Shelf" or n.Name == "SmallShelf" then
			check = n.Towar.KtoryArtykul.Value
			if checkProductOnModel(product,check) then
				if n.Towar.IleArtykul.Value > 0 then
					table.insert(availStaff,n)
				end
			end
		end
	end
	if #availStaff > 0 then
		return true,availStaff
	end
	return false
end


--{{----------------------------------MAIN------------------------------------------------}}



local function NPCMainFunc()
	plotCos = math.cos(math.rad(script.Parent.Parent.Parent.Plot.Orientation.Y))

	ileDodac = 0

	plr = game.Players:FindFirstChild(script.Parent.Parent.Parent.wazne.Owner.Value)

	for i,n in pairs(Enum.HumanoidStateType:GetEnumItems()) do
		if n ~= Enum.HumanoidStateType.None and n ~= Enum.HumanoidStateType.FallingDown and n ~= Enum.HumanoidStateType.GettingUp and n ~= Enum.HumanoidStateType.Running then
			human:SetStateEnabled(n,false)
		end
	end

	playAnim:FireAllClients(script.Parent,"breath",0.4)

	task.wait(0.15)


	if not plr:FindFirstChild("leaderstats") then
		plr = nil
	end

	local park = nil

	if not plr then
		iodnowa()
		return
	end

	li= math.random(1,2)

	local items = script.Parent.Parent.Parent.PlacedObjects:GetChildren()
	local DTtable = {}
	local CRtable = {}
	local success, err


	if script.Parent.WichPark.Value then
		park = script.Parent.WichPark.Value
	end

	local parkingLvl = script.Parent.Parent.Parent:GetAttribute('Parking')

	local placeVal = script.Parent:GetAttribute('KtoreMiejsce')
	local firstGo = nil

	if placeVal then
		local currentPlace = tonumber(string.sub(placeVal,#placeVal,#placeVal))

		if placeVal == "Where10" then
			currentPlace = 10
		end

		local parkingBase = script.Parent.Parent.Parent.ParkingBase

		if currentPlace then
			if parkingLvl == 0 then
				if currentPlace == 3 or currentPlace == 4 then
					firstGo = parkingBase.secondFind
				end
			end

			if parkingLvl == 1 then
				if currentPlace <= 4 then
					firstGo = parkingBase.leftFind
				elseif currentPlace > 6 then
					firstGo = parkingBase.rightFind
				end
			end
		end

		if firstGo then
			go(firstGo,false)
		end
	end


	if #items == 0 then
		task.wait(0.5)
		errormodule.errorfuncGo(plr,"You don't have any place for products.")
		if plr.rating.RatingNow.Value - 2 > 0 then
			plr.rating.RatingNow.Value  -= 2
		else
			plr.rating.RatingNow.Value = 0
		end

		if park then
			go(park.Starter, false)
		else
			go(script.Parent.Parent.Parent.Spawnery.Spawner, false)
		end

		return
	end


	local helperDT = 1
	local helperCR = 1

	for i,model in ipairs(items) do
		if model.Name == "DisplayTable" and model:FindFirstChild("Towar") and model.Towar.IleArtykul.Value > 0 or model.Name == "Shelf" and model:FindFirstChild("Towar") and model.Towar.IleArtykul.Value > 0 or model.Name == "SmallShelf" and model:FindFirstChild("Towar") and model.Towar.IleArtykul.Value > 0 then
			DTtable[helperDT]=model
			helperDT+=1
		end
	end
	for i,model in ipairs(items) do
		if model.Name == "CashReg" or model.Name == "CashRegType2" then
			CRtable[helperCR] = model
			helperCR+=1
		end
	end

	if #DTtable == 0 then
		wait(0.35)
		errormodule.errorfuncGo(plr,"You don't have any place with products.")
		if plr.rating.RatingNow.Value - 2 > 0 then
			plr.rating.RatingNow.Value  -= 2
		else
			plr.rating.RatingNow.Value = 0
		end

		if park then
			go(park.Starter, false)
		else
			go(script.Parent.Parent.Parent.Spawnery.Spawner, false)
		end

		return
	end

	if #CRtable == 0 then
		wait(0.35)
		errormodule.errorfuncGo(plr,"You don't have any Cash Register.")
		if plr.rating.RatingNow.Value - 3 > 0 then
			plr.rating.RatingNow.Value  -= 3
		else
			plr.rating.RatingNow.Value = 0
		end

		if park then
			go(park.Starter, false)
		else
			go(script.Parent.Parent.Parent.Spawnery.Spawner, false)
		end

		return
	end

	if #script.Parent.Parent.Parent.Kasjerzy:GetChildren() == 0 then
		wait(0.35)
		errormodule.errorfuncGo(plr,"You don't have any Cashiers.")
		if plr.rating.RatingNow.Value - 2 > 0 then
			plr.rating.RatingNow.Value  -= 2
		else
			plr.rating.RatingNow.Value = 0
		end

		if park and park:FindFirstChild("Started") then
			go(park.Starter, false)
		else
			go(script.Parent.Parent.Parent.Spawnery.Spawner, false)
		end

		return
	end

	local model0 = nil

	cashreg=nil

	model0 = DTtable[math.random(1, #DTtable)] 

	if not model0 then
		errormodule.errorfuncGo(plr,"You don't have any place with products.")
		if plr.rating.RatingNow.Value - 3 > 0 then
			plr.rating.RatingNow.Value -= 3
		else
			plr.rating.RatingNow.Value = 0
		end
		if park and park:FindFirstChild("Started") then
			go(park.Starter, false)
		else
			go(script.Parent.Parent.Parent.Spawnery.Spawner, false)
		end

		return
	end

	local spawner

	if script.Parent and script.Parent.Parent and script.Parent.Parent.Parent and script.Parent.Parent.Parent:FindFirstChild("Spawnery") and script.Parent.Parent.Parent:FindFirstChild("Spawnery"):FindFirstChild("Spawner") then
		spawner = script.Parent.Parent.Parent.Spawnery.Spawner
	end

	local retrunValue,product = nil,nil

	if math.random(1,50) <= 10 and not checkForDialogAlready() then
		local destFromSP = SPMoudule.calc(script.Parent.Parent.Parent)
		if destFromSP then
			local pos = Vector3.new(destFromSP.X,0.5,destFromSP.Z)
			go("search",false,pos)
			task.wait(0.15)
			retrunValue,product = dialogFunc("enterance",script.Parent)
			task.wait(0.25)
			if retrunValue then
				if retrunValue < 0 then
					if plr.rating.RatingNow.Value + retrunValue > 0  then
						plr.rating.RatingNow.Value  += retrunValue
					else
						plr.rating.RatingNow.Value = 0
					end
					if park and park:FindFirstChild("Started") then
						go(park.Starter, false)
					else
						go(spawner, false)
					end
					return
				end
			end
		end
	end

	if product then
		if product ~= "any" then
			local checked,models = checkDialogProduct(product)
			if checked then
				model0 = models[math.random(1,#models)]
			end
		end
	end

	for nowStep=0,li do
		task.wait(0.25)
		if nowStep==0 then
			success, err = pcall(function()
				go(model0,true)
			end)

			if not success and not wasDestroyed then
				warn(err,"model")
			end

		elseif nowStep==1 and zarobas == 0 then
			task.wait(0.25)
			if park and park:FindFirstChild("Starter") then
				go(park.Starter, false)
			else
				go(spawner, false)
			end

			break	
		elseif nowStep==1 and zarobas > 0 then
			task.wait(0.25)
			if #script.Parent.Parent.Parent.Kasjerzy:GetChildren() > 0 then
				local succ,err = pcall(function()		
					local spotValLowest = 0
					local random = math.random(1,#CRtable)

					cashreg = CRtable[random]
					spotValLowest = cashreg.SpotValues.Spot.Value	
					table.remove(CRtable,random)

					for num,reg in pairs(CRtable) do
						task.wait()
						if reg.SpotValues.Spot.Value < spotValLowest then
							spotValLowest = reg.SpotValues.Spot.Value
							cashreg = reg
						end

					end

					go(cashreg, false)
				end)

				if not succ and not wasDestroyed then
					warn(err,"cashReg err")
				end

				if not succ and npcsModule and not wasDestroyed and arrivedToggle then
					stopAnim:FireAllClients(script.Parent)
					npcsModule.spotMinus1(script.Parent,cashreg,cashreg.find.Name)
					arrivedToggle = false
				end

				if firstGo then
					go(firstGo,false)
				end

				task.wait(0.25)

				if park and park:FindFirstChild("Starter") then	
					go(park.Starter, false)
				else
					go(spawner, false)
				end

				if plr.rating.RatingMax.Value > (plr.rating.RatingNow.Value + ileDodac)  then
					plr.rating.RatingNow.Value  += ileDodac
					ileDodac = 0
				else
					plr.rating.RatingNow.Value = plr.rating.RatingMax.Value
				end

				break					
			else
				zarobas = 0

				if park and park:FindFirstChild("Starter") then	
					go(park.Starter, false)
				else
					go(spawner, false)
				end

				break
			end
		end

	end
end

--Main handler of starting the whole script

script.Parent.Changed:Connect(function(what)
	spawnModule = require(script.Parent.Parent.Parent.NPCsSpawnModule)
	spawnAttrib = script.Parent.Parent.Parent.NPCsSpawnModule

	if what == "Parent" then
		task.wait(1)
		CCfM()
		task.wait(0.5)
		--initiateAnims:FireAllClients(script.Parent)
		NPCMainFunc()
	end
end)