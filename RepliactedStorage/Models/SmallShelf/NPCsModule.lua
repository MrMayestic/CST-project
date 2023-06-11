local npcsModule = {}
local tasksQueue = {}

local currentObjects = {
	['LeftSpot'] = {
		["value"] = 0;
		['NPCs'] = {};
	};
	['RightSpot'] = {
		['value'] = 0;
		['NPCs'] = {};
	};
}

function updateQueues(who,obj,spot,isMinus,isReset)
	if isMinus then
		for i,n in pairs(currentObjects[spot].NPCs) do
			n.Queue -= 1
		end
	end

	task.wait(0.15)

	for i,n in pairs(currentObjects[spot].NPCs) do
		if n.whoIsIt:FindFirstChild("NPCMainScript") then
			local succ,err = pcall(function() 
				n.whoIsIt.NPCMainScript.updateSpot:Invoke(currentObjects[spot].NPCs[n.whoIsIt].Queue,isReset)
			end)

			if not succ then
				warn(err)
			end
		else
			currentObjects[spot].NPCs[n.whoIsIt] = nil
		end
	end

	return true
end

function spotMinus1(who,obj,spot)
	currentObjects[spot].NPCs[who] = nil
	currentObjects[spot].value -= 1
	if currentObjects[spot].value < 0 then
		currentObjects[spot].value = 0
	end
	obj.SpotValues[spot].Value = currentObjects[spot].value
	updateQueues(who,obj,spot,true)
end

function handleNPCArrived(who,obj,spot)
	for i,n in pairs(currentObjects[spot].NPCs) do
		if n.whoIsIt == who then
			warn("return 2")
			return false
		end
	end
	currentObjects[spot].NPCs[who] = {
		['Queue'] = currentObjects[spot].value;
		['whoIsIt'] = who;
	}
	currentObjects[spot].value += 1
	obj.SpotValues[spot].Value = currentObjects[spot].value
	updateQueues(who,obj,spot)
end	


function resetQueues(who,obj,spot)
	currentObjects[spot].NPCs[who].Queue = 0

	local counter = 1

	for i,n in pairs(currentObjects[spot].NPCs) do
		if n.whoIsIt ~= who then
			n.Queue = counter
			counter += 1
		end
	end
	currentObjects[spot].value = counter
	obj.SpotValues[spot].Value = currentObjects[spot].value
	updateQueues(who,obj,spot,false,true)
	return true
end


function npcsModule.resetQueues(who,obj,spot)
	if who and obj and spot then
		table.insert(tasksQueue,{
			['who'] = who;
			['obj'] = obj;
			['spot'] = spot;
			['func'] = resetQueues;
		})
	end
end

function npcsModule.imArrived(who,obj,spot)
	if who and obj and spot then
		table.insert(tasksQueue,{
			['who'] = who;
			['obj'] = obj;
			['spot'] = spot;
			['func'] = handleNPCArrived;
		})
	end
end


function taskHandler()
	if tasksQueue[1] then
		local myTask = tasksQueue[1]

		myTask.func(myTask.who,myTask.obj,myTask.spot)

		table.remove(tasksQueue,1)
	end
end

function npcsModule.spotMinus1(who,obj,spot)
	if who and obj and spot then
		table.insert(tasksQueue,{
			['who'] = who;
			['obj'] = obj;
			['spot'] = spot;
			['func'] = spotMinus1;
		})
	end
end

function doTasks()
	while task.wait(0.5) do
		taskHandler()
	end
end

function npcsModule.makeEvent()
	script.Start.Event:Connect(function()
		doTasks()
	end)
end

return npcsModule