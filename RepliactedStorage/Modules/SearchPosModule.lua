local SPmodule = {}

--local plot

local CDS = require(script.Parent.CDSModule)

local function isPlotEXT(plot)
	local num = tonumber(string.sub(plot.Name,5,5))
	if num > 4 then
		return true
	else
		return false
	end
end

local function checkX(i,curCheckPos,poses)
	local check = CDS.checkCollision(curCheckPos)
	if not check then
		poses["Pos"..i] = {["pos"] = curCheckPos} 
		return true,poses
	end
	return false,poses
end

local function checkY(howToCalc)

end

local function getModelPoses(orient,pos,plot)
	local plotType = isPlotEXT(plot)
	local startPos
	local X
	local Z
	local isZMain
	local isBest
	if orient.Y == 0 or math.abs(orient.Y) == 180 then
		if not plotType then
			if pos.Z < plot.Plot.Position.Z then
				X = (plot.Plot.Position.X - (plot.Plot.Size.X/2)) + 2
				Z = pos.Z + 6
				isBest = true
			else
				X = (plot.Plot.Position.X - (plot.Plot.Size.X/2)) + 2
				Z = pos.Z - 6
				isBest = false
			end
		else
			if pos.Z > plot.Plot.Position.Z then
				X = (plot.Plot.Position.X - (plot.Plot.Size.X/2)) + 2
				Z = pos.Z - 6 
				isBest = true
			else
				X = (plot.Plot.Position.X - (plot.Plot.Size.X/2)) + 2
				Z = pos.Z + 6 
				isBest = false
			end
		end
		isZMain = true
	end
	startPos = Vector3.new(X,1,Z)
	return startPos,isZMain,isBest
end

local function getFinalPos(plot)
	local howManyModels = 0
	local startPoses = {}
	for i,n in pairs(plot.PlacedObjects:GetChildren()) do
		if n.Name == "EntryDoors" then
			local pos = n.PrimaryPart.Position
			local orient = n.PrimaryPart.Orientation
			local Pos,isZMain,isBest = getModelPoses(orient,pos,plot)
			startPoses[i] = {
				['pos'] = Pos;
				['isZMain'] = isZMain;	
				['isBest'] = isBest;
			}
			howManyModels += 1
		end
	end

	local startPos

	local findBest = false
	local whereBest
	local isZMain

	for i,n in pairs(startPoses) do
		if n.isBest == true then
			findBest = true
			whereBest = i
			isZMain = n.isZMain
		end
	end
	if findBest then
		startPos = startPoses[whereBest].pos
	else
		if howManyModels > 0 then
			local succ,err = pcall(function()
				local rand = math.random(1,howManyModels)
				startPos = startPoses[rand].pos
				isZMain = startPoses[rand].isZMain
			end)
			if not succ then
				return false
			end
		else
			startPos = plot.ParkingBase.firstFind.Position
		end
	end
	local curCheckPos = startPos

	local step = math.random(2,4)
	local counter = 1
	local poses = {}
	local check
	if isZMain then
		while curCheckPos.X < plot.Plot.Position.X + (plot.Plot.Size.X/2)  do
			check,poses = checkX(counter,curCheckPos,poses)
			if check then
				counter += 1
			end
			curCheckPos += Vector3.new(step,0,0)
		end
	end

	--if places == nil then

	--end
	local randPos = math.random(1,counter)
	local finalPos
	wait()
	pcall(function()
		finalPos = poses["Pos"..randPos].pos
	end)

	wait()
	return finalPos
end

function startCalc(plot)
	local finalPos = getFinalPos(plot)

	return finalPos
end

function SPmodule.calc(plot)
	--plot = curPlot

	return startCalc(plot)
end

return SPmodule