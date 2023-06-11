local npcsModule = {}
local tasksQueue = {}

local currentObjects = {
	["value"] = 0;
	['NPCs'] = {};
}

function updateQueues(who,obj,isMinus,isReset,test)
	if isMinus then
		for i,n in pairs(currentObjects.NPCs) do
			n.Queue -= 1
		end
	end

	task.wait(0.1)

	for i,n in pairs(currentObjects.NPCs) do
		if n.whoIsIt:FindFirstChild("NPCMainScript") then
			local succ,err = pcall(function()
				n.whoIsIt.NPCMainScript.updateSpot:Invoke(currentObjects.NPCs[n.whoIsIt].Queue,isReset)
			end)

			if not succ then
				warn(err)
			end
		else
			currentObjects.NPCs[n.whoIsIt] = nil
		end
	end

	return true
end

function spotMinus1(who,obj,test)
	currentObjects.NPCs[who] = nil
	currentObjects.value -= 1
	if currentObjects.value < 0 then
		currentObjects.value = 0
	end
	obj.SpotValues.Spot.Value = currentObjects.value
	updateQueues(who,obj,true,false,test)
	return true
end

function handleNPCArrived(who,obj)
	for i,n in pairs(currentObjects.NPCs) do
		if n.whoIsIt == who then
			warn("return")
			return false
		end
	end

	currentObjects.NPCs[who] = {
		['Queue'] = currentObjects.value;
		['whoIsIt'] = who;
	}

	currentObjects.value += 1
	obj.SpotValues.Spot.Value = currentObjects.value
	updateQueues(who,obj)
	return true
end


function resetQueues(who,obj)
	currentObjects.NPCs[who].Queue = 0

	local counter = 1

	for i,n in pairs(currentObjects.NPCs) do
		if n.whoIsIt ~= who then
			n.Queue = counter
			counter += 1
		end
	end

	currentObjects.value = counter
	obj.SpotValues.Spot.Value = currentObjects.value
	updateQueues(who,obj,false,true)
	return true
end


function npcsModule.resetQueues(who,obj)
	if who and obj then
		table.insert(tasksQueue,{
			['who'] = who;
			['obj'] = obj;
			['func'] = resetQueues;
		})
	end
end

function npcsModule.imArrived(who,obj)
	if who and obj then
		table.insert(tasksQueue,{
			['who'] = who;
			['obj'] = obj;
			['func'] = handleNPCArrived;
		})
	end
end


function taskHandler()
	if tasksQueue[1] then
		local myTask = tasksQueue[1]

		local succ,err = pcall(function()
			myTask.func(myTask.who,myTask.obj,myTask.test)
		end)

		if not succ then
			warn("err",err,myTask.who,myTask.obj)
		end

		table.remove(tasksQueue,1)
	end
end

function npcsModule.spotMinus1(who,obj,test)
	if who and obj then
		table.insert(tasksQueue,{
			['who'] = who;
			['obj'] = obj;
			['func'] = spotMinus1;
			['test'] = test;
		})
	end
end

function doTasks()
	while task.wait(0.3) do
		taskHandler()
	end
end

function npcsModule.makeEvent()
	script.Start.Event:Connect(function()
		doTasks()
	end)
end

return npcsModule