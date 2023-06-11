local errormodule = require(game.ReplicatedStorage.Modules.ErrorModule)
local plotManager = require(game.ServerScriptService.ServerModules.PlotManager)

local function naKtorym(x,z,toggle,plot,ileL,ileC,ileR,check)
	local ktory
	local tejbulX
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
			if x>= n.Position.X - n.Size.X/2 then
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
				table.insert(tejbulZ,i,ktory.Parent["PlotR"..i])
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
				table.insert(tejbulZ,i,ktory.Parent["PlotL"..i])
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


local function returnX(mPlt,ileL,ileC,ileR)
	local zwroc = mPlt.Position.X
	local name = mPlt.Name
	if string.match(name,"PlotR") then
		if ileC >= tonumber(string.sub(name,6,6)) then
			local plotex = mPlt.Parent
			zwroc += plotex.Position.X
			if ileL >= ileR then
				local plotex = mPlt.Parent["PlotL"..string.sub(name,6,6)]
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
				local plotex = mPlt.Parent["PlotR"..string.sub(name,6,6)]
				zwroc += plotex.Position.X
				zwroc = zwroc/3
			else
				zwroc = zwroc/2
			end
		end

	else
		if ileL >= ileC then
			local plotex = mPlt.Parent:FindFirstChild("PlotL"..tostring(ileC))
			if not plotex then
				plotex = mPlt["PlotL"..tostring(ileC)]
			end
			zwroc += plotex.Position.X
			if ileR >= ileC then
				local plotex = mPlt.Parent:FindFirstChild("PlotR"..tostring(ileC))
				if not plotex then
					plotex = mPlt["PlotL"..tostring(ileC)]
				end
				zwroc += plotex.Position.X
				zwroc = zwroc/3
			else
				zwroc = zwroc/2
			end
		end
	end

	return zwroc
end

local function returnZ(mPlt,ileL,ileC,ileR)
	local zwrocZ = 0
	local name = mPlt.Name

	if string.match(name,"PlotR") then
		for i=1,ileR do
			zwrocZ += mPlt.Parent["PlotR"..i].Position.Z
		end
		zwrocZ = zwrocZ/ileR
	elseif string.match(name,"PlotL") then
		for i=1,ileL do
			zwrocZ += mPlt.Parent["PlotL"..i].Position.Z
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
				local check = mPlt.Parent:FindFirstcChild("PlotC"..i)
				if check then
					zwrocZ += check.Position.Z
				end
			end
		end
		zwrocZ = zwrocZ/ileC
	end
	return zwrocZ
end

local function returnSizeZ(mPlt,ileL,ileC,ileR)
	local zwrocSZ = 0
	local name = mPlt.Name
	if string.match(name,"PlotR") then
		for i=1,ileR do
			zwrocSZ += mPlt.Parent["PlotR"..i].Size.Z
		end
	elseif string.match(name,"PlotL") then
		for i=1,ileL do
			zwrocSZ += mPlt.Parent["PlotL"..i].Size.Z
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

local function returnSizeX(mPlt,ileL,ileC,ileR)
	local zwrocS = mPlt.Size.X
	local name = mPlt.Name
	if string.match(name,"PlotR") then
		if ileC >= tonumber(string.sub(name,6,6)) then
			local plotex = mPlt.Parent
			zwrocS += plotex.Size.X
			if ileL >= ileR then
				local plotex = mPlt.Parent["PlotL"..string.sub(name,6,6)]
				zwrocS += plotex.Size.X
			end
		end
	elseif string.match(name,"PlotL") then
		if ileC >= tonumber(string.sub(name,6,6)) then
			local plotex = mPlt.Parent
			zwrocS += plotex.Size.X
			if ileR >= ileL then
				local plotex = mPlt.Parent["PlotR"..string.sub(name,6,6)]
				zwrocS += plotex.Size.X
			end
		end
	elseif not string.match(name,"PlotR") and not string.match(name,"PlotL") and not string.match(name,"PlotC") then
		if ileL > 0 then
			local plotex = mPlt.PlotL1
			zwrocS += plotex.Size.X
		end
		if ileR > 0 then
			local plotex = mPlt.PlotR1
			zwrocS += plotex.Size.X
		end
	else
		if ileL >= ileC then
			local plotex = mPlt.Parent["PlotL"..ileC]
			zwrocS += plotex.Size.X
		end
		if ileR >= ileC then
			local plotex = mPlt.Parent["PlotR"..ileC]
			zwrocS += plotex.Size.X
		end
	end
	return zwrocS
end


local function checkHitbox(character, object)
	if object then
		local collided = false

		local collisionPoint = object.PrimaryPart.Touched:Connect(function() end)
		local collisionPoints = object.PrimaryPart:GetTouchingParts()

		for i = 1, #collisionPoints do
			if not collisionPoints[i]:IsDescendantOf(object) and not collisionPoints[i]:IsDescendantOf(character) then
				collided = false
				break
			end
		end

		collisionPoint:Disconnect()

		return collided
	end
end

local function checkBoundaries(plot, primary,plr)
	local ileL = plr.hidden.IleL.Value
	local ileC = plr.hidden.IleC.Value
	local ileR = plr.hidden.IleR.Value
	local check = true
	if tonumber(string.sub(plot.Parent.Name,5,5)) > 4 then
		check = false
	end
	local lowerXBound
	local upperXBound

	local lowerZBound
	local upperZBound

	local currentPos = primary.Position
	local KtoryPlt = naKtorym(primary.Position.X,primary.Position.Z,false,plot,ileL,ileC,ileR,check)


	local meinsizex = returnSizeX(KtoryPlt,ileL,ileC,ileR)
	local meineX = returnX(KtoryPlt,ileL,ileC,ileR)
	lowerXBound = meineX - (meinsizex*0.5) 
	upperXBound = meineX + (meinsizex*0.5)
	local meinsizez = returnSizeZ(KtoryPlt,ileL,ileC,ileR)
	local meineZ = returnZ(KtoryPlt,ileL,ileC,ileR)

	lowerZBound = meineZ - (meinsizez*0.5)	
	upperZBound = meineZ + (meinsizez*0.5)

	return currentPos.X > upperXBound or currentPos.X < lowerXBound or currentPos.Z > upperZBound or currentPos.Z < lowerZBound
end

local function ChangeTransparency(item, c)
	for i, o in next, item:GetDescendants() do
		if o then
			if o:IsA("Part") or o:IsA("UnionOperation") or o:IsA("MeshPart") then
				o.Transparency = c
			end
		end
	end
end
--Ignore above

-- Handle user input began differently depending on whether a shift key is pressed



local function place(plr, name, location, prefabs, cframe, c)
	local plot = plotManager.returnPlot(workspace.Plots, plr)

	if plot.wazne.Owner.Value == plr.Name then
		if name == nil then
			return false
		end
		
		local item
		
		for i,n in pairs(plot.PlacedObjects:GetChildren()) do
			if n:GetAttribute("MovedCopy") == true then
				item = n:Clone()
				n:Destroy()
			end
		end
		
		if not item then
			game.ReplicatedStorage.Events.SystemsEvents.shutdownSystems:FireClient(plr)
			errormodule.errorfuncGo(plr,"Error occured while doing this.")
			return
		end
		
		item:SetPrimaryPartCFrame(cframe)
		item:SetAttribute("MovedCopy",nil)
		
		if checkBoundaries(plot.Plot, item.PrimaryPart,plr) then
			return
		end

		item.Parent = location
		
		task.wait()
		
		if item:FindFirstChild("Towar") then
			game.ReplicatedStorage.Events.ModelEvents.showBanner:FireClient(plr,item)
		end

		if c then
			if not checkHitbox(plr.Character, item) then

				item.PrimaryPart.Transparency = 1

				return true
			else
				item:Destroy()

				return false
			end
		else

			item.PrimaryPart.Transparency = 1

			return true
		end
	end
	return false
end

function handleMovedModelProperties(player,toggle)
	local plotex = plotManager.returnPlot(workspace.Plots, player)
	if toggle then
		for i,n in pairs(plotex.PlacedObjects:GetChildren()) do
			if n:GetAttribute("MovedCopy") then
				n:SetAttribute("MovedCopy",nil)
			end
		end
	end
end

game.ReplicatedStorage.Events.MoveParent.OnServerEvent:Connect(function(plr, model)
	if not model then
		game.ReplicatedStorage.Events.SystemsEvents.shutdownSystems:FireClient(plr)
		errormodule.errorfuncGo(plr,"An error occured, furniture is missing.")
		return
	end
	local plot = plotManager.returnPlot(workspace.Plots, plr)

	if plot.wazne.Owner.Value == plr.Name then
		for i,n in pairs(plot.PlacedObjects:GetChildren()) do
			n:SetAttribute("MovedCopy",nil)
		end

		task.wait()

		if model:IsA("Model") and model.PrimaryPart and model.Parent.Parent.wazne.Owner.Value == plr.Name then
			model:SetAttribute("MovedCopy",true)
		end
	end
end)

game.ReplicatedStorage.Events.BackParent.OnServerEvent:Connect(handleMovedModelProperties)

game.ReplicatedStorage.Remotes.move.OnServerInvoke = place