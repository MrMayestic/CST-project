local frame = script.Parent.Parent.Parent.Parent.WBListFrame
local button = script.Parent

local close = script.Parent.Parent.Parent.Parent.WBListclose

local plr = game.Players.LocalPlayer

local wlistf = frame.Whitlelist
local owlistf = frame.OnWhiteList

local RS = game.ReplicatedStorage

local blistf = frame.Blacklist
local oblistf = frame.OnBlackList

local zwykla = {}
local Wlist = {}
local Blist = {}
local AudioPlayer = require(game.ReplicatedStorage.Modules:WaitForChild("AudioModule"))

local settingsFrame = script.Parent.Parent.Parent

local buttonActivate = script.Parent.Parent.KFPSTester

local getPlot = game.ReplicatedStorage.Remotes.requestPlot
local plot = getPlot:InvokeServer()
local RS = game.ReplicatedStorage

buttonActivate.MouseButton1Click:Connect(function()
	RS.Tester:FireServer(Wlist)
end)

button.MouseButton1Click:Connect(function()
	AudioPlayer.playAudio("Click")
	if not plr:GetAttribute("DoesTutorial") then
		settingsFrame.Visible = false
		frame.Visible = true
		close.Visible = true
	end
end)

close.MouseButton1Click:Connect(function()
	AudioPlayer.playAudio("Click")
	frame.Visible = false
	close.Visible = false
	settingsFrame.Visible = true
end)

function wykasuj(name,lista)
	for y,u in pairs(lista) do
		if u == name then
			lista[y] = nil
		end
	end
end

function WyszyscZListy(ktore,plr)

	for i,n in pairs(ktore:GetChildren()) do

		if n:GetAttribute("PlrName") == plr then
			n:SetAttribute("PlrName","")
			n.Text = ""
			n.Visible = false
		end

	end

end

function ZwrotID(id)

	for i,n in pairs(game.Players:GetChildren()) do
		if n.UserId == id then
			return n
		end
	end

end



for i, v in pairs(wlistf:GetChildren()) do
	v.MouseButton1Click:Connect(function()
		AudioPlayer.playAudio("Click")
		for c=1,7 do
			if Wlist[c] == nil then
				Wlist[c] = v:GetAttribute("PlrID")
				wykasuj(v:GetAttribute("PlrID"),zwykla)

				v.Visible = false

				owlistf:FindFirstChild("PlrB"..c).Visible = true
				owlistf:FindFirstChild("PlrB"..c):SetAttribute("PlrName",v:GetAttribute("PlrName"))
				owlistf:FindFirstChild("PlrB"..c):SetAttribute("PlrID",v:GetAttribute("PlrID"))
				owlistf:FindFirstChild("PlrB"..c).Text=v:GetAttribute("PlrName")
				WyszyscZListy(blistf,v:GetAttribute("PlrName"))
				v:SetAttribute("PlrName","")
				v:SetAttribute("PlrID",0)
				break
			end
		end
	end)
end




for i, v in pairs(owlistf:GetChildren()) do
	v.MouseButton1Click:Connect(function()
		AudioPlayer.playAudio("Click")
		for c=1,7 do 
			if zwykla[c] == nil then
				wykasuj(v:GetAttribute("PlrID"),Wlist)

				zwykla[c] = v:GetAttribute("PlrID")
				v.Visible = false

				wlistf:FindFirstChild("PlrB"..c).Visible = true
				wlistf:FindFirstChild("PlrB"..c):SetAttribute("PlrName",v:GetAttribute("PlrName"))
				wlistf:FindFirstChild("PlrB"..c):SetAttribute("PlrID",v:GetAttribute("PlrID"))
				wlistf:FindFirstChild("PlrB"..c).Text=v:GetAttribute("PlrName")

				blistf:FindFirstChild("PlrB"..c).Visible = true
				blistf:FindFirstChild("PlrB"..c):SetAttribute("PlrName",v:GetAttribute("PlrName"))
				blistf:FindFirstChild("PlrB"..c):SetAttribute("PlrID",v:GetAttribute("PlrID"))
				blistf:FindFirstChild("PlrB"..c).Text=v:GetAttribute("PlrName")
				v:SetAttribute("PlrName","")
				v:SetAttribute("PlrID",0)

				break
			end
		end
	end)
end

for i, v in pairs(blistf:GetChildren()) do
	v.MouseButton1Click:Connect(function()
		AudioPlayer.playAudio("Click")
		for c=1,7 do
			if Blist[c] == nil then
				RS.Events.BLIST:FireServer(v:GetAttribute("PlrID"),true)
				
				Blist[c] = v:GetAttribute("PlrID")
				wykasuj(v:GetAttribute("PlrID"),zwykla)
				v.Visible = false

				oblistf:FindFirstChild("PlrB"..c).Visible = true
				oblistf:FindFirstChild("PlrB"..c):SetAttribute("PlrName",v:GetAttribute("PlrName"))
				oblistf:FindFirstChild("PlrB"..c):SetAttribute("PlrID",v:GetAttribute("PlrID"))
				oblistf:FindFirstChild("PlrB"..c).Text=v:GetAttribute("PlrName")
				WyszyscZListy(wlistf,v:GetAttribute("PlrName"))
				v:SetAttribute("PlrName","")
				v:SetAttribute("PlrID",0)
				
				RS.Tester:FireServer(Wlist)
				break
			end
		end
	end)
end

for i, v in pairs(oblistf:GetChildren()) do
	v.MouseButton1Click:Connect(function()
		AudioPlayer.playAudio("Click")
		for c=1,7 do 
			if zwykla[c] == nil then
				wykasuj(v:GetAttribute("PlrID"),Blist)

				zwykla[c] = v:GetAttribute("PlrID")
				v.Visible = false

				blistf:FindFirstChild("PlrB"..c).Visible = true
				blistf:FindFirstChild("PlrB"..c):SetAttribute("PlrName",v:GetAttribute("PlrName"))
				blistf:FindFirstChild("PlrB"..c):SetAttribute("PlrID",v:GetAttribute("PlrID"))
				blistf:FindFirstChild("PlrB"..c).Text=v:GetAttribute("PlrName")


				wlistf:FindFirstChild("PlrB"..c).Visible = true
				wlistf:FindFirstChild("PlrB"..c):SetAttribute("PlrName",v:GetAttribute("PlrName"))
				wlistf:FindFirstChild("PlrB"..c):SetAttribute("PlrID",v:GetAttribute("PlrID"))
				wlistf:FindFirstChild("PlrB"..c).Text=v:GetAttribute("PlrName")


				v:SetAttribute("PlrName","")
				v:SetAttribute("PlrID",0)

				RS.Events.BLIST:FireServer(wlistf:FindFirstChild("PlrB"..c):GetAttribute("PlrID"),false)
				
				break
			end
		end
	end)
end

RS.Events.WBListActivate.OnClientEvent:Connect(function()
	wait()
	for i,n in pairs(game.Players:GetChildren()) do
		if n.Name ~= plr.Name then
			local typek = wlistf:FindFirstChild("PlrB"..i)
			typek.Text = n.Name
			typek:SetAttribute("PlrName",n.Name)
			typek:SetAttribute("PlrID",n.UserId)
			zwykla[i] = n.UserId

			typek.Visible = true
			local debilek = blistf:FindFirstChild("PlrB"..i)
			debilek.Text = n.Name
			debilek:SetAttribute("PlrName",n.Name)
			debilek:SetAttribute("PlrID",n.UserId)
			zwykla[i] = n.UserId
			debilek.Visible = true
		end

	end

end)

function Zwroc()

	return Wlist
end

function BlistLocal(plot,toggle)
	pcall(function() 
		if toggle then
			game.ReplicatedStorage.BlockUnions:FindFirstChild("BU"..string.sub(plot.Name,#plot.Name,#plot.Name)).Parent = plot.BlockParts
		else
			plot.BlockParts:GetChildren()[1].Parent = game.ReplicatedStorage.BlockUnions
		end
	end)
end

RS.Events.BLISTClient.OnClientEvent:Connect(BlistLocal)

game.ReplicatedStorage.Remotes.KickTable.OnClientInvoke = Zwroc

game.ReplicatedStorage.Events.RESETGUI.OnClientEvent:Connect(function()
	frame.Visible = false
	close.Visible = false
	settingsFrame.Visible = true
end)

game.ReplicatedStorage.BlockUnions:WaitForChild("BU8")