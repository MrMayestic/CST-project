local aparaty = script.Parent.aparaty
local tablety = script.Parent.tablety
local telefony = script.Parent.telefony
local konsole = script.Parent.konsole
local telewizory = script.Parent.telewizory
local komputery = script.Parent.komputery
local monitory = script.Parent.monitory
local klawiatury = script.Parent.klawiatury
local myszki = script.Parent.myszki
local glosniki = script.Parent.glosniki
local sluchawki = script.Parent.sluchawki

local infoframe = script.Parent.Parent.InfoFrame
local plr = game.Players.LocalPlayer
local magazinbutton = script.Parent.Parent.BuildSystemsAndInfo.MagazineButton
local close = infoframe.XButton
local cost = infoframe.AllCost
local allinfo = infoframe.Allinfo
local allsecondinfo = script.Parent.Parent.InfoAutoBuyFrame.Allinfo
local CostValue = script.Parent.CostValue.Value
local HowMany = script.Parent.HowMany
local magazynframe = script.Parent.Parent.BuildSystemsAndInfo.Midyl.Frame.MagazynFrame
local Ilecapacity = magazynframe.NowCapacity.Text
local capacity = 0
local nowcapacity = 0
local ileinfo = infoframe.Ileinfo
local zliczvalue = false
local distabframe = script.Parent.Parent.DisplayTableFrame
local shlefframe = script.Parent.Parent.ShelfFrame
local smallshlefframe = script.Parent.Parent.SmallShelfFrame

local getPlot = game.ReplicatedStorage.Remotes.requestPlot
local plot = getPlot:InvokeServer()
local AudioPlayer = require(game.ReplicatedStorage.Modules:WaitForChild("AudioModule"))

local mainStepframe = script.Parent.MainStep
local cashStepframe = script.Parent.CashStep

local mainStep
local cashStep

function ping()
	local t = tick()
	local cos = game.ReplicatedStorage.PingTest.RemoteFunction:InvokeServer()
	local ping = ((tick() - t) / 2)
	return ping
end

---MAIN STEP FRAME

mainStepframe.PLUS.MouseButton1Click:Connect(function()
	mainStep += 1
	if mainStep > 10 then
		mainStep = 10
	end
	mainStepframe.IleStep.Text = mainStep
	mainStepframe:SetAttribute("Step",mainStep)
	game.ReplicatedStorage.Events.TowarEvents.SetStep:FireServer(mainStepframe,mainStep)
end)

mainStepframe.MINUS.MouseButton1Click:Connect(function()
	mainStep -= 1
	if mainStep < 1 then
		mainStep = 1
	end
	mainStepframe.IleStep.Text = mainStep
	mainStepframe:SetAttribute("Step",mainStep)
	game.ReplicatedStorage.Events.TowarEvents.SetStep:FireServer(mainStepframe,mainStep)
end)



---CASH STEP FRAME

cashStepframe.PLUS.MouseButton1Click:Connect(function()
	cashStep += 1
	if cashStep > 10 then
		cashStep = 10
	end
	cashStepframe.IleStep.Text = cashStep
	cashStepframe:SetAttribute("Step",cashStep)
	game.ReplicatedStorage.Events.TowarEvents.SetStep:FireServer(cashStepframe,cashStep)
end)
cashStepframe.MINUS.MouseButton1Click:Connect(function()
	cashStep -= 1
	if cashStep < 1 then
		cashStep = 1
	end
	cashStepframe.IleStep.Text = cashStep
	cashStepframe:SetAttribute("Step",cashStep)
	game.ReplicatedStorage.Events.TowarEvents.SetStep:FireServer(cashStepframe,cashStep)
end)

game.ReplicatedStorage.Events.TowarEvents.LoadStep.OnClientEvent:Connect(function()
	mainStep = mainStepframe:GetAttribute("Step")
	cashStep = cashStepframe:GetAttribute("Step")
end)


function maxcap(maxvalues)
	local maxvalue = plr.ValueFolder.MaxCapacity.Value
	if maxvalue == 0 or maxvalue == nil then
		magazynframe.MaxCapacity.MaxValue.Value = 50
	elseif maxvalue == 1 then
		magazynframe.MaxCapacity.MaxValue.Value = 75
	elseif maxvalue == 2 then
		magazynframe.MaxCapacity.MaxValue.Value = 100
	elseif maxvalue == 3 then
		magazynframe.MaxCapacity.MaxValue.Value = 150
	elseif maxvalue == 4 then
		magazynframe.MaxCapacity.MaxValue.Value = 250
	elseif maxvalue == 5 then
		magazynframe.MaxCapacity.MaxValue.Value = 500
	end
	zliczvalue = true
end


function dodaj(ktory)
	local wartosc = plr.TowarFolder[ktory.Name].Value
	script.Parent[ktory.Name].IleTerazJest.Text = wartosc
end

local function minus(cos, costtowaru)
	AudioPlayer.playAudio("Click")
	if not plr:GetAttribute("DoesTutorial") or cos==telefony then

		if cos.Ile.Value - mainStepframe:GetAttribute("Step") >= 0 or plr.TowarFolder:FindFirstChild(cos.Name).Value == 0 then

			local was = cos.Ile.Value
			cos.Ile.Value -= mainStepframe:GetAttribute("Step")
			if cos.Ile.Value < 0 then
				cos.Ile.Value = 0
				if was > 0 then
					nowcapacity -= was
					--cos.Ile.Value -= was
					ileinfo.Text = nowcapacity
					cos.Cost.Text = cos.Ile.Value
					HowMany.Value -= was
					CostValue -= costtowaru * was
					cost.Text = CostValue
				end
			else
				nowcapacity -= mainStepframe:GetAttribute("Step")
				ileinfo.Text = nowcapacity
				cos.Cost.Text = cos.Ile.Value
				CostValue -= costtowaru * mainStepframe:GetAttribute("Step") 
				cost.Text = CostValue
				HowMany.Value -= mainStepframe:GetAttribute("Step")
			end
		else
			if plr.TowarFolder:FindFirstChild(cos.Name).Value - (math.abs(cos.Ile.Value - mainStepframe:GetAttribute("Step"))) >= 0 then
				cos.Ile.Value -= mainStepframe:GetAttribute("Step")
				nowcapacity -= mainStepframe:GetAttribute("Step")
				ileinfo.Text = nowcapacity
				cos.Cost.Text = cos.Ile.Value
				if cos.Ile.Value < 0 then
					CostValue -= (costtowaru * mainStepframe:GetAttribute("Step"))/2
				else
					CostValue -= costtowaru * mainStepframe:GetAttribute("Step")
				end
				cost.Text = CostValue
				HowMany.Value -= mainStepframe:GetAttribute("Step")
			elseif plr.TowarFolder:FindFirstChild(cos.Name).Value - (math.abs(cos.Ile.Value)) > 0 then
				local diff = math.abs(0 - plr.TowarFolder:FindFirstChild(cos.Name).Value - cos.Ile.Value )
				cos.Ile.Value -= diff
				nowcapacity -= diff
				ileinfo.Text = nowcapacity
				cos.Cost.Text = cos.Ile.Value
				CostValue -= (costtowaru * diff )/2
				cost.Text = CostValue
				HowMany.Value -= diff
			end
		end
	end
end

local function plus(cos,costtowaru)
	AudioPlayer.playAudio("Click")
	if not plr:GetAttribute("DoesTutorial") or cos==telefony then

		nowcapacity += mainStepframe:GetAttribute("Step")

		if nowcapacity > capacity then
			local num = capacity - HowMany.Value
			nowcapacity = capacity
			if num > 0 then
				ileinfo.Text = nowcapacity
				cos.Ile.Value += num
				cos.Cost.Text = cos.Ile.Value
				CostValue += costtowaru * num
				cost.Text = CostValue
				HowMany.Value += num
			end
		else
			ileinfo.Text = nowcapacity
			cos.Ile.Value += mainStepframe:GetAttribute("Step")
			cos.Cost.Text = cos.Ile.Value
			CostValue += costtowaru * mainStepframe:GetAttribute("Step")
			cost.Text = CostValue
			HowMany.Value += mainStepframe:GetAttribute("Step")
		end

		if plr:GetAttribute("DoesTutorial") then
			if telefony.Ile.Value == 6 then
				game.ReplicatedStorage.Events.Jest6Telefonow:FireServer()
			end
		end
	end
end


magazinbutton.MouseButton1Click:Connect(function()
	if not plr:FindFirstChild("leaderstats") then
		return
	end

	AudioPlayer.playAudio("Click")
	script.Parent:TweenPosition(UDim2.new(0.35, 0, 0.237, 0),0,0,0.35) 
	infoframe:TweenPosition(UDim2.new(0.35, 0,0.138, 0),0,0,0.35)
	magazinbutton.Visible = false
	magazinbutton.Active = false
end)

function quit(isReset)
	if not plr:FindFirstChild("leaderstats") then
		return
	end
	AudioPlayer.playAudio("Click")
	if not isReset then
		script.Parent:TweenPosition(UDim2.new(0.35, 0, 1.347, 0),0,0,0.35) 
		infoframe:TweenPosition(UDim2.new(0.35, 0,1.238, 0),0,0,0.35)
		script.Parent.CanvasPosition = Vector2.new(0,0)
		magazinbutton.Visible = true
		magazinbutton.Active = true
		task.wait(0.1)
	end
	for i,towar in ipairs(plr.TowarFolder:GetChildren()) do
		task.wait()
		local obiekt = script.Parent[towar.Name]
		obiekt.Ile.Value = 0
		obiekt.Cost.Text = obiekt.Ile.Value
	end
	CostValue = 0
	cost.Text = CostValue
	HowMany.Value=0
	nowcapacity = 0
	ileinfo.Text = nowcapacity
end

close.MouseButton1Click:Connect(quit)

script.Parent.RESET.MouseButton1Click:Connect(function() 
	quit(true) 
end)

game.ReplicatedStorage.Events.TowarEvents.Close.OnClientEvent:Connect(quit)

---------------------------------
aparaty.PLUS.MouseButton1Click:Connect(function()
	plus(aparaty,250)
end)
aparaty.MINUS.MouseButton1Click:Connect(function()
	minus(aparaty,250)
end)
-----------------------------------
tablety.PLUS.MouseButton1Click:Connect(function()
	plus(tablety,150)
end)
tablety.MINUS.MouseButton1Click:Connect(function()
	minus(tablety,150)
end)
----------------------------------
telefony.PLUS.MouseButton1Click:Connect(function()
	plus(telefony,100)
end)
telefony.MINUS.MouseButton1Click:Connect(function()
	minus(telefony,100)
end)
----------------------------------
telewizory.PLUS.MouseButton1Click:Connect(function()
	plus(telewizory,1500)
end)
telewizory.MINUS.MouseButton1Click:Connect(function()
	minus(telewizory,1500)
end)
----------------------------------
konsole.PLUS.MouseButton1Click:Connect(function()
	plus(konsole,700)
end)
konsole.MINUS.MouseButton1Click:Connect(function()
	minus(konsole,700)
end)
----------------------------------
komputery.PLUS.MouseButton1Click:Connect(function()
	plus(komputery,1000)
end)
komputery.MINUS.MouseButton1Click:Connect(function()
	minus(komputery,1000)
end)
-----------------------------------
monitory.PLUS.MouseButton1Click:Connect(function()
	plus(monitory,600)
end)
monitory.MINUS.MouseButton1Click:Connect(function()
	minus(monitory,600)
end)
-----------------------------------
klawiatury.PLUS.MouseButton1Click:Connect(function()
	plus(klawiatury,70)
end)
klawiatury.MINUS.MouseButton1Click:Connect(function()
	minus(klawiatury,70)
end)
-----------------------------------
myszki.PLUS.MouseButton1Click:Connect(function()
	plus(myszki,30)
end)
myszki.MINUS.MouseButton1Click:Connect(function()
	minus(myszki,30)
end)
-----------------------------------
glosniki.PLUS.MouseButton1Click:Connect(function()
	plus(glosniki,150)
end)
glosniki.MINUS.MouseButton1Click:Connect(function()
	minus(glosniki,150)
end)
-----------------------------------
sluchawki.PLUS.MouseButton1Click:Connect(function()
	plus(sluchawki,90)
end)
sluchawki.MINUS.MouseButton1Click:Connect(function()
	minus(sluchawki,90)
end)
-----------------------------------


script.Parent.Parent.InfoFrame.SetButton.MouseButton1Click:Connect(function()
	AudioPlayer.playAudio("Click")
	local ileile = CostValue
	local ilehajsubylo = plr.leaderstats.Cash.Value
	game.ReplicatedStorage.Events.TowarEvents.SetValues:FireServer()
	task.wait(ping()+0.05)
	if ileile <= ilehajsubylo then
		for i,towar in pairs(plr.TowarFolder:GetChildren()) do
			local obiekt = script.Parent:FindFirstChild(towar.Name)
			obiekt.Ile.Value = 0
			obiekt.Cost.Text = obiekt.Ile.Value
			local checkdis = distabframe:FindFirstChild(towar.Name)
			local checkshelf = shlefframe:FindFirstChild(towar.Name)
			local checksmallshelf = smallshlefframe:FindFirstChild(towar.name)
			wait()
			if checkdis then			
				checkdis.Info.Text = towar.Value
			elseif checkshelf then
				checkshelf.Info.Text = towar.Value
			elseif checksmallshelf then
				checksmallshelf.Info.Text = plr.TowarFolder:FindFirstChild(towar.Name).Value
			end
		end
		magazynframe.NowCapacity.Text += nowcapacity
		magazynframe.NowCapacity.NowValue.Value += nowcapacity


		capacity = magazynframe.MaxCapacity.MaxValue.Value - magazynframe.NowCapacity.NowValue.Value

		allinfo.Text = capacity

		nowcapacity =0
		ileinfo.Text = nowcapacity
		CostValue = 0
		cost.Text = CostValue
		HowMany.Value=0
	end
end)

function dajeInfo()
	game.ReplicatedStorage.Events.TowarEvents.towarRes:FireServer({aparaty.Ile.Value,tablety.Ile.Value,telefony.Ile.Value
		,telewizory.Ile.Value,konsole.Ile.Value,komputery.Ile.Value,monitory.Ile.Value,klawiatury.Ile.Value,myszki.Ile.Value,glosniki.Ile.Value,sluchawki.Ile.Value},

	{aparaty,tablety,telefony
		,telewizory,konsole,komputery,monitory,klawiatury,myszki,glosniki,sluchawki})
end

game.ReplicatedStorage.Events.TowarEvents.towarReq.OnClientEvent:Connect(dajeInfo)

game.ReplicatedStorage.Events.TowarEvents.WezMiPodlicz.OnClientEvent:Connect(function()
	for i,towar in ipairs(plr.TowarFolder:GetChildren()) do
		local obiekt = script.Parent:FindFirstChild(towar.Name)
		obiekt.Ile.Value = 0
		obiekt.Cost.Text = obiekt.Ile.Value
		local checkdis = distabframe:FindFirstChild(towar.Name)
		local checkshelf = shlefframe:FindFirstChild(towar.Name)
		local checksmallshelf = smallshlefframe:FindFirstChild(towar.name)
		task.wait()
		if checkdis then			
			checkdis.Info.Text = towar.Value
		elseif checkshelf then
			checkshelf.Info.Text = towar.Value
		elseif checksmallshelf then
			checksmallshelf.Info.Text = plr.TowarFolder:FindFirstChild(towar.Name).Value
		end
		local obiekt = script.Parent:FindFirstChild(towar.Name)
		dodaj(obiekt)
	end
end)

function zlicz()
	task.wait(0.08)
	if zliczvalue then
		magazynframe.MaxCapacity.Text = magazynframe.MaxCapacity.MaxValue.Value
		local ustawcapacity = 0

		for i,numa in ipairs(plr.TowarFolder:GetChildren()) do
			task.wait()
			script.Parent:FindFirstChild(numa.Name).IleTerazJest.Text = numa.Value
			ustawcapacity = ustawcapacity + numa.Value
			local checkdis = distabframe:FindFirstChild(numa.Name)
			local checkshelf = shlefframe:FindFirstChild(numa.Name)
			local checksmallshelf = smallshlefframe:FindFirstChild(numa.name)

			if checkdis then
				checkdis.Info.Text = plr.TowarFolder:FindFirstChild(numa.Name).Value
			elseif checkshelf then
				checkshelf.Info.Text = plr.TowarFolder:FindFirstChild(numa.Name).Value
			elseif checksmallshelf then
				checksmallshelf.Info.Text = plr.TowarFolder:FindFirstChild(numa.Name).Value
			end
		end

		magazynframe.NowCapacity.Text = ustawcapacity
		magazynframe.NowCapacity.NowValue.Value = ustawcapacity
		capacity = magazynframe.MaxCapacity.MaxValue.Value - magazynframe.NowCapacity.NowValue.Value

		local alltext = magazynframe.MaxCapacity.MaxValue.Value - magazynframe.NowCapacity.NowValue.Value

		allinfo.Text = alltext
		allsecondinfo.Text = alltext
	else
		wait(1)
		zlicz()
	end
end

function cenaPlus(co)
	local ilejest = tonumber(co.CostBox.Text)
	local ilemabyc = ilejest + cashStepframe:GetAttribute("Step")
	local maxmin = math.round(tonumber(co.CostModelu.Text)*0.35)

	while tonumber(string.sub(tostring(maxmin),string.len(tostring(maxmin)),string.len(tostring(maxmin)))) ~= 0 do
		maxmin += 1
	end

	if ilemabyc < tonumber(co.CostModelu.Text)-maxmin then
		co.CostBox.Text = tonumber(co.CostModelu.Text)-maxmin
	elseif ilemabyc > tonumber(co.CostModelu.Text)+maxmin then
		co.CostBox.Text = tonumber(co.CostModelu.Text)+maxmin
	else
		co.CostBox.Text = ilemabyc	
	end
	
	co.CostBox:SetAttribute("lastVal",co.CostBox.Text)
	
	game.ReplicatedStorage.Events.MagazynEvents.WczytajCeny:FireServer(co.Name,tonumber(co.CostBox.Text))
end

function cenaMinus(co)
	local ilejest = tonumber(co.CostBox.Text)
	local ilemabyc = ilejest - cashStepframe:GetAttribute("Step")
	local maxmin = math.round(tonumber(co.CostModelu.Text)*0.35)

	while tonumber(string.sub(tostring(maxmin),string.len(tostring(maxmin)),string.len(tostring(maxmin)))) ~= 0 do
		maxmin += 1
	end

	if ilemabyc < tonumber(co.CostModelu.Text)+1 then
		co.CostBox.Text = tonumber(co.CostModelu.Text)+1
	elseif ilemabyc > tonumber(co.CostModelu.Text)+maxmin then
		co.CostBox.Text = tonumber(co.CostModelu.Text)+maxmin
	else
		co.CostBox.Text = ilemabyc	
	end
	
	co.CostBox:SetAttribute("lastVal",co.CostBox.Text)
	
	game.ReplicatedStorage.Events.MagazynEvents.WczytajCeny:FireServer(co.Name,tonumber(co.CostBox.Text))
end

for i,n in pairs(script.Parent:GetChildren()) do
	if n.ClassName == "TextButton" and n.Name ~= "FILLBUTTON" and n.Name ~= "RESET" then
		n.cPLUS.MouseButton1Click:Connect(function()
			cenaPlus(n)
		end)
		n.cMINUS.MouseButton1Click:Connect(function()
			cenaMinus(n)
		end)

		n.CostBox:GetPropertyChangedSignal("Text"):Connect(function()
			n.CostBox.Text = n.CostBox.Text:gsub('%D+', '');
		end)
		n.CostBox.FocusLost:Connect(function(Return)
			local ilejest = tonumber(n.CostBox.Text)

			if ilejest then
				local maxmin = math.round(tonumber(n.CostModelu.Text)*0.35)

				while tonumber(string.sub(tostring(maxmin),string.len(tostring(maxmin)),string.len(tostring(maxmin)))) ~= 0 do
					wait()
					maxmin +=1
				end

				if ilejest < tonumber(n.CostModelu.Text) - maxmin then
					n.CostBox.Text = tonumber(n.CostModelu.Text)-maxmin
				elseif ilejest > tonumber(n.CostModelu.Text)+  maxmin then
					n.CostBox.Text = tonumber(n.CostModelu.Text)+maxmin
				end
				n.CostBox:SetAttribute("lastVal",n.CostBox.Text)
				game.ReplicatedStorage.Events.MagazynEvents.WczytajCeny:FireServer(n.Name,tonumber(n.CostBox.Text))
			else
				n.CostBox.Text = n.CostBox:GetAttribute("lastVal")
				n.CostBox:SetAttribute("lastVal",n.CostBox.Text)
			end
		end)
	end
end

local function wczytajCeny()
	for i,n in pairs(script.Parent:GetChildren()) do
		if n.ClassName == "TextButton" and n.Name ~= "FILLBUTTON" and n.Name ~= "RESET" then
			n.CostBox.Text = tonumber(plr.CenaFolder:FindFirstChild(n.Name).Value)
			n.CostBox:SetAttribute("lastVal",plr.CenaFolder:FindFirstChild(n.Name).Value)
		end
	end
	
end


game.ReplicatedStorage.Events.TowarEvents.Zlicz.OnClientEvent:Connect(zlicz)
game.ReplicatedStorage.Events.MagazynEvents.WczytajMaxCap.OnClientEvent:Connect(maxcap)
game.ReplicatedStorage.Events.MagazynEvents.WczytajCeny.OnClientEvent:Connect(wczytajCeny)


game.ReplicatedStorage.Events.RESETGUI.OnClientEvent:Connect(function()

	script.Parent:TweenPosition(UDim2.new(0.35, 0, 1.347, 0),0,0,0.35) 
	infoframe:TweenPosition(UDim2.new(0.35, 0,1.238, 0),0,0,0.35)
	wait(0.7)
	script.Parent.CanvasPosition = Vector2.new(0,0)
	magazinbutton.Visible = true
	magazinbutton.Active = true
	for i,towar in ipairs(script.Parent:GetChildren()) do
		if towar.ClassName == "TextButton" and towar.Name ~= "FILLBUTTON" and towar.Name ~= "RESET" then
			local obiekt = towar
			obiekt.Ile.Value = 0
			obiekt.Cost.Text = obiekt.Ile.Value
		end
	end
	CostValue = 0
	cost.Text = CostValue
	HowMany.Value=0
	nowcapacity = 0
	ileinfo.Text = nowcapacity

end)