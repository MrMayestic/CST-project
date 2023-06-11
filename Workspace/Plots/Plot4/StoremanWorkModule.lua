local spawnModule = {}

local npc = game.ReplicatedStorage:WaitForChild('HumansRS'):WaitForChild('Customer')

local tasksQueue = {}

local ObjData = {
	["0p"] = {},
	["1p"] = {},
	["2p"] = {},
	["3p"] = {},
	["4p"] = {},
	["5p"] = {},
}

local function checkObjs(plot)
	local plr = game.Players:FindFirstChild(plot.wazne.Owner.Value)
	if plr then
		for i,n in pairs(plot.PlacedObjects:GetChildren()) do
			if n:FindFirstChild('Towar') then
				if n.Towar.KtoryArtykul.Value ~= "" and n.Towar.KtoryArtykul.Value ~= nil then
					local howManyStaff = n.Towar.IleArtykul.Value
					if howManyStaff < 6 and plr.TowarFolder:FindFirstChild(n.Towar.KtoryArtykul.Value).Value > 0 and n.beingHandled.Value == false then
						table.insert(ObjData[tostring(howManyStaff).."p"],n)
					end
				end
			end
		end
	end
end

local function checkTable() 
	local succ,err = pcall(function() 
		for i=0,5 do
			local index = tostring(i)
			if #ObjData[index.."p"] > 0 then
				for i,n in pairs(ObjData[index.."p"]) do
					if n.Towar.IleArtykul.Value == 6 then
						ObjData[index.."p"][i] = nil
					end
				end
			end 
		end
	end)
end

local function getObjForWork()
	checkObjs(script.Parent)

	task.wait(0.15)

	local objToReturn

	local succ,err = pcall(function() 
		for i=0,5 do
			local index = tostring(i)
			if #ObjData[index.."p"] > 0 then
				if #ObjData[index.."p"] > 1 then
					local randomNum = math.random(1,#ObjData[index.."p"])
					if ObjData[index.."p"][randomNum] then
						if ObjData[index.."p"][randomNum].beingHandled.Value == false then
							objToReturn = ObjData[index.."p"][randomNum]
							ObjData[index.."p"][randomNum] = nil
						end
					end
				else
					if ObjData[index.."p"][1] then
						if ObjData[index.."p"][1].beingHandled.Value == false then
							objToReturn = ObjData[index.."p"][1]
							ObjData[index.."p"][1] = nil
						end
					end
				end
			end 
		end
	end)

	if not succ then
		warn(err)
	end

	task.wait(0.25)

	checkTable()

	return objToReturn
end

function spawnModule.makeTask(who,plot,obj)
	table.insert(tasksQueue,{
		["plot"] = plot,
		['who'] = who,
	})
	if obj then
		obj.beingHandled.Value = false
	end
	return true
end

function taskHandler()
	if tasksQueue[1] then
		local obj = getObjForWork()

		local who = tasksQueue[1].who

		pcall(function() 
			who.sendWork:Fire(obj)
		end)

		table.remove(tasksQueue,1)
	end
end

function spawnModule.test()
	checkObjs(game.Workspace.Plots.Plot1)
end

function spawnModule.makeEvent()
	script.Start.Event:Connect(function()
		doTasks()
	end)
end

function doTasks()
	while task.wait(0.35) do
		taskHandler()
	end
end

return spawnModule
