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
local infoframe = script.Parent.Parent.InfoAutoBuyFrame
local plr = game.Players.LocalPlayer
--local magazinbutton = script.Parent.Parent.MagazinButton
local close = infoframe.XButton
local cost = infoframe.AllCost
local allinfo = infoframe.Allinfo
local allsecondinfo = script.Parent.Parent.InfoFrame.Allinfo
local CostValue = script.Parent.CostValue.Value
local HowMany = script.Parent.HowMany
local magazynframe = script.Parent.Parent.BuildSystemsAndInfo.Midyl.Frame.MagazynFrame
local Ilecapacity = magazynframe.NowCapacity.Text
local capacity = 50
local nowcapacity = 0
local ileinfo = infoframe.Ileinfo
local zliczvalue = false
local ileczasu = script.Parent.IleCzasu
local distabframe = script.Parent.Parent.DisplayTableFrame
local shlefframe = script.Parent.Parent.ShelfFrame
local smallshlefframe = script.Parent.Parent.SmallShelfFrame
local errormodule = require(game.ReplicatedStorage.Modules.ErrorModule)
--local fillup = script.Parent.FILLBUTTON
local getPlot = game.ReplicatedStorage.Remotes.requestPlot
local plot = getPlot:InvokeServer()
local autotoggle = "off"
local isWorking = false
local OnOff = infoframe.OnOffAuto
local AudioPlayer = require(game.ReplicatedStorage.Modules:WaitForChild("AudioModule"))

OnOff.MouseButton1Click:Connect(function()
	AudioPlayer.playAudio("Click")
	if autotoggle == "open" then
		autotoggle = "off"
		OnOff.Text = "OFF"
		OnOff.BackgroundColor3 = Color3.fromRGB(255,0,0)
	elseif autotoggle == "off" then
		autotoggle = "on"
		OnOff.Text = "ON"
		OnOff.BackgroundColor3 = Color3.fromRGB(0,170,0)
		autobuy()
	elseif autotoggle == "on" then
		autotoggle = "open"
		OnOff.Text = "WHILE STORE OPENED"
		OnOff.BackgroundColor3 = Color3.fromRGB(255, 190, 39)
	end

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


local function minus(cos, costtowaru)
	cos.Ile.Value -= 1
	if cos.Ile.Value < 0 then
		cos.Ile.Value = 0
	else
		nowcapacity -=1
		ileinfo.Text = nowcapacity
		cos.IleTerazJest.Text = cos.Ile.Value
		CostValue -= costtowaru
		cost.Text = CostValue
		HowMany.Value -= 1

	end
end

local function plus(cos,costtowaru)

	nowcapacity += 1
	ileinfo.Text = nowcapacity
	cos.Ile.Value += 1
	cos.IleTerazJest.Text = cos.Ile.Value
	CostValue += costtowaru
	cost.Text = CostValue
	HowMany.Value += 1
end


close.MouseButton1Click:Connect(function()
	AudioPlayer.playAudio("Click")
	script.Parent:TweenPosition(UDim2.new(0.353, 0, 1.376, 0),0,0,0.35) 
	infoframe:TweenPosition(UDim2.new(0.353, 0,1.289, 0),0,0,0.35)
	script.Parent.CanvasPosition = Vector2.new(0,0)
end)

----------------------------------------
ileczasu.PLUS.MouseButton1Click:Connect(function()
	ileczasu.Ile.Value += 1
	if ileczasu.Ile.Value > 5 then
		ileczasu.Ile.Value -=1
	end
	ileczasu.IleTerazJest.Text = ileczasu.Ile.Value
end)

ileczasu.MINUS.MouseButton1Click:Connect(function()
	AudioPlayer.playAudio("Click")
	ileczasu.Ile.Value -= 1
	if ileczasu.Ile.Value < 1 then
		ileczasu.Ile.Value +=1
	end
	ileczasu.IleTerazJest.Text = ileczasu.Ile.Value
end)
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
----------------------------------
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

function autobuy(toggle)
	if isWorking and not toggle then
		return
	end
	
	isWorking = true
	
	local czas = script.Parent.IleCzasu.Ile.Value * 60
	task.wait(czas)
	
	if autotoggle ~= "off" then
		autoset()
		autobuy(true)
	else
		isWorking = false
		autotoggle = "off"
		OnOff.Text = "OFF"
		OnOff.BackgroundColor3 = Color3.fromRGB(255,0,0)
	end
end

-----------------------------------
function autoset()
	if CostValue > plr.leaderstats.Cash.Value then
		errormodule.errorfuncGo(plr,"(Auto-buy) You don't have enough money to buy these products.")
		return
	end

	if nowcapacity + magazynframe.NowCapacity.NowValue.Value > magazynframe.MaxCapacity.MaxValue.Value then
		errormodule.errorfuncGo(plr,"(Auto-buy) You don't have enough capacity to buy it.")
		return
	end

	if plot.wazne.Otwarte.Value == false and autotoggle == "open" then
		return
	end
	
	game.ReplicatedStorage.Events.TowarEvents.SetValues:FireServer(true)
	wait(0.1)
	magazynframe.NowCapacity.Text += nowcapacity
	magazynframe.NowCapacity.NowValue.Value += nowcapacity
	
	for i,towar in ipairs(plr.TowarFolder:GetChildren()) do
		local checkdis = distabframe:FindFirstChild(towar.Name)
		local checkshelf = shlefframe:FindFirstChild(towar.Name)
		local checksmallshelf = smallshlefframe:FindFirstChild(towar.name)
		
		if checkdis then			
			checkdis.Info.Text = plr.TowarFolder:FindFirstChild(towar.Name).Value
		elseif checkshelf then
			checkshelf.Info.Text = plr.TowarFolder:FindFirstChild(towar.Name).Value
		elseif checksmallshelf then
			checksmallshelf.Info.Text = plr.TowarFolder:FindFirstChild(towar.Name).Value
		end
	end

	capacity = magazynframe.MaxCapacity.MaxValue.Value - magazynframe.NowCapacity.NowValue.Value

	allinfo.Text = capacity	
	allsecondinfo.Text = capacity
end

function dajeInfo()
	game.ReplicatedStorage.Events.TowarEvents.towarRes:FireServer({aparaty.Ile.Value,tablety.Ile.Value,telefony.Ile.Value
		,telewizory.Ile.Value,konsole.Ile.Value,komputery.Ile.Value,monitory.Ile.Value,klawiatury.Ile.Value,myszki.Ile.Value,glosniki.Ile.Value,sluchawki.Ile.Value},

	{aparaty,tablety,telefony
		,telewizory,konsole,komputery,monitory,klawiatury,myszki,glosniki,sluchawki})
end

game.ReplicatedStorage.Events.TowarEvents.towarReqAB.OnClientEvent:Connect(dajeInfo)

game.ReplicatedStorage.Events.MagazynEvents.WczytajMaxCap2.OnClientEvent:Connect(maxcap)

game.ReplicatedStorage.Events.RESETGUI.OnClientEvent:Connect(function()

	script.Parent:TweenPosition(UDim2.new(0.353, 0, 1.376, 0),0,0,0.35) 
	infoframe:TweenPosition(UDim2.new(0.353, 0,1.289, 0),0,0,0.35)
	script.Parent.CanvasPosition = Vector2.new(0,0)

end)