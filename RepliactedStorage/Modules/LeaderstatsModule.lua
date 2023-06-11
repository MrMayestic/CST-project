local lsmodule = {}

local ratings = game.ReplicatedStorage.LSRatings

local LSTable = {}

local muzin = false

local RS = game.ReplicatedStorage

local mudzinek = true

function ZmianaAwaryjna(ktore)

	local rat2 = ratings:FindFirstChild("Rat"..ktore+1)

	if rat2:GetAttribute("Zajete") == false then

		rat2.Value = ratings:GetAttribute("SpecRatingVal")
		rat2:SetAttribute("PlrName",ratings:GetAttribute("PlrSpecName"))
		rat2:SetAttribute("Zajete",true)

		LSTable[ktore+1] = rat2:GetAttribute("PlrName")

	else

		ratings:SetAttribute("PlrSpecName",rat2:GetAttribute("PlrName"))
		ratings:SetAttribute("SpecRatingVal",rat2.Value)

		rat2.Value = ratings:GetAttribute("SpecRatingVal")
		rat2:SetAttribute("PlrName",ratings:GetAttribute("PlrSpecName"))
		rat2:SetAttribute("Zajete",true)

		LSTable[ktore+1] = rat2:GetAttribute("PlrName")

		ZmianaAwaryjna(ktore+1)

	end

end

function ZmianaDwoch(ktore,plr)

	local rat1 = ratings:FindFirstChild("Rat"..ktore)
	local rat2 = ratings:FindFirstChild("Rat"..ktore+1)

	if rat2:GetAttribute("Zajete") == false then

		rat2.Value = rat1.Value
		rat2:SetAttribute("PlrName",rat1:GetAttribute("PlrName"))
		rat2:SetAttribute("Zajete",true)
		LSTable[ktore+1] = rat2:GetAttribute("PlrName")
		LSTable[ktore] = plr.Name
		rat1:SetAttribute("Zajete", true)
		rat1:SetAttribute("PlrName",plr.Name)
		rat1.Value = plr.leaderstats.Rating.Value
	else

		ratings:SetAttribute("PlrSpecName",rat2:GetAttribute("PlrName"))
		ratings:SetAttribute("SpecRatingVal",rat2.Value)

		rat2.Value = rat1.Value
		rat2:SetAttribute("PlrName",rat1:GetAttribute("PlrName"))
		rat2:SetAttribute("Zajete",true)

		LSTable[ktore+1] = rat2:GetAttribute("PlrName")

		LSTable[ktore] = plr.Name
		rat1:SetAttribute("Zajete", true)
		rat1:SetAttribute("PlrName",plr.Name)
		rat1.Value = plr.leaderstats.Rating.Value

		ZmianaAwaryjna(ktore+1)

	end

end


function Zmiana(plr,yhm,jak)
	if plr:FindFirstChild('leaderstats') then
		for i,m in pairs(game.Players:GetChildren()) do
			task.wait()
			if m:FindFirstChild('leaderstats') then
				task.wait()
				local rat = m:WaitForChild('leaderstats'):WaitForChild('Rating').Value

				local ktory = 1
				for i,n in pairs(ratings:GetChildren()) do
					if muzin==true then
						if n.Value < plr.leaderstats.Rating.Value then
							if n:GetAttribute("Zajete") == false then
								LSTable[ktory] = plr.Name
								n:SetAttribute("Zajete", true)
								n:SetAttribute("PlrName",plr.Name)
								n.Value = plr.leaderstats.Rating.Value
								muzin = false
								break
							else
								ZmianaDwoch(ktory,plr)

								muzin = false
								break
							end
						elseif plr:FindFirstChild('leaderstats') and n.Value == plr:FindFirstChild('leaderstats'):FindFirstChild('Rating').Value then

							if n:GetAttribute("Zajete") == false  then
								LSTable[ktory] = plr.Name
								n:SetAttribute("Zajete", true)
								n:SetAttribute("PlrName",plr.Name)
								n.Value = plr.leaderstats.Rating.Value
								muzin = false
								break
							else

								ktory+=1
							end

						else
							ktory+=1
						end
					end

				end
			end
		end
	end
end

function Reset()

	for i,n in pairs(ratings:GetChildren()) do
		wait()
		n:SetAttribute("PlrName","")
		n:SetAttribute("SpecPlrName","")
		n:SetAttribute("SpecRatingValue",0)	
		n:SetAttribute("Zajete",false)	
		n.Value = 0
		LSTable[i] = nil
	end

end

function lsmodule.SetLS()
	if mudzinek == true then
		mudzinek = false
		Reset()
		task.wait()
		for i,y in pairs(game.Players:GetChildren()) do
			muzin = true
			Zmiana(y)
		end
		game.ReplicatedStorage.AllInfo:FireAllClients(LSTable)
		task.wait()
		mudzinek = true
	else
		task.wait(1)
		lsmodule.SetLS()
	end
end

function lsmodule.SynchroLS(plr)
	wait()
	return LSTable
end

function lsmodule.Reset()

	Reset()

end


return lsmodule
