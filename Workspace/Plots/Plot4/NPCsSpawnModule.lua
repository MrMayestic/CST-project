local spawnModule = {}

local npc = game.ReplicatedStorage:WaitForChild('HumansRS'):WaitForChild('Customer')

local tasksQueue = {}

function handleSpawn(plotName)
	local plot = game.Workspace.Plots[plotName]
	
	local plr = game.Players:FindFirstChild(plot.wazne.Owner.Value)
	
	if not plr then
		return
	end
	
	local miejsce = nil

	local success,err = pcall(function()
		if plot.wazne.Otwarte.Value == true then
			task.wait(0.5)
			local howManyPeople = 1

			local divider = 41.2 --41.2

			local clockValue = game.Workspace.Clock.Value

			if clockValue > 12 and clockValue < 16.2 then
				divider = 29.3
			elseif clockValue >= 16.2 and clockValue < 20 then
				divider = 22.7
			elseif clockValue >= 21 and clockValue < 23 then
				divider = 45
			elseif clockValue >= 23 or clockValue < 1 then
				divider = 60
			elseif clockValue >= 1 and clockValue < 3 then
				divider = 100
			elseif clockValue >= 3 and clockValue < 5.5 then
				divider = 60
			elseif clockValue >= 5.5 and clockValue < 7 then
				divider = 45
			elseif clockValue >= 7 and clockValue < 8.5 then
				divider = 35.2
			end

			local rat = plr.leaderstats.Rating.Value

			local linearMinus = ((5 - rat) * 6)/100

			divider = divider - (divider * linearMinus) 

			local ilerazy = math.floor((rat * 100) / divider)

			if ilerazy <= 0 then
				ilerazy = 2
			elseif ilerazy == 1 then
				ilerazy += 1
			end

			if #plot.Humans:GetChildren() < ilerazy then
				howManyPeople = ilerazy - #plot.Humans:GetChildren() 
				howManyPeople += 1
			end	

			if howManyPeople > 0 then
				for i=1,howManyPeople do
					if math.random(1,100) > 27 then
						if plot.wazne.Otwarte.Value == false or (ilerazy - #plot.Humans:GetChildren()) <= 0 then
							continue
						end
						local car = game.ReplicatedStorage.Car:Clone()
						local npcClone = npc:Clone()
						local parking = plot.ParkingBase
						local czeker = 0

						miejsce = nil

						for i,n in pairs(parking.Miejsca:GetChildren()) do
							if n.Zajete.Value == false then
								miejsce = n
							end
						end

						npcClone:MoveTo(plot.Spawnery.Spawner.Position + Vector3.new(0,2,0))

						task.wait(0.15)

						npcClone.Parent = plot.Humans

						for i,j in pairs(npcClone:GetChildren()) do
							if j.ClassName == "Part" or j.ClassName == "MeshPart" then
								if j.Name == "HumanoidRootPart" or j.Name == "Head" or string.match(j.Name,"Torso") or string.match(j.Name,"Leg") or string.match(j.Name,"Arm") then
									j:SetNetworkOwner(nil)
								else
									j:SetNetworkOwner(plr)
								end
							end
						end

						if miejsce then
							miejsce.Zajete.Value = true
							npcClone:SetAttribute("KtoreMiejsce", miejsce.Name)
							local addOrient = 0

							if math.random(1,2) == 2 then
								addOrient = 180
							end
							car:SetPrimaryPartCFrame(CFrame.new(miejsce.Position+Vector3.new(0,3.9,0))*CFrame.Angles(0,math.rad(miejsce.Orientation.Y+addOrient),0))

							local r = math.random(1,255)
							local g = math.random(1,255)
							local b = math.random(1,255)

							for i,n in pairs(car.ChangeThis:GetChildren()) do
								n.Color = Color3.fromRGB(r,g,b)
							end

							car.Parent = plot.Cars
							npcClone.WichPark.Value = car
							npcClone:MoveTo(car.Starter.Position + Vector3.new(0,2.35,0))
						else
							local plotCos = math.cos(math.rad(plot.Plot.Orientation.Y))
							local addToTempPos1
							local tempPos
							addToTempPos1 = Vector3.new(math.random(0,5) * math.random(-1,1),1.5,math.random(-5,0) * plotCos)
							tempPos = plot.Spawnery.Spawner.Position + addToTempPos1
							npcClone:MoveTo(tempPos)
						end
						task.wait(math.random(9,19)/10)
					else
						if i == howManyPeople then
							task.wait(5.5)
							if #plot.Humans:GetChildren() == 0 then
								task.wait(math.random(1,6))
								handleSpawn(plotName)
							end
						end
					end
				end
			end
		end
	end)
	return true
end

function spawnModule.makeTask(who)
	if who then
		table.insert(tasksQueue,{
			["plot"] = who.Parent.Parent,
		})
		return true
	end
end

function taskHandler()
	if tasksQueue[1] then
		local plot = tasksQueue[1].plot

		if not plot:GetAttribute("shopStarting") then
			handleSpawn(plot.Name)
		end

		table.remove(tasksQueue,1)
	end
end

function doTasks()
	while task.wait(0.5) do
		taskHandler()
	end
end

function spawnModule.makeEvent()
	script.Start.Event:Connect(function()
		doTasks()
	end)
end

return spawnModule
