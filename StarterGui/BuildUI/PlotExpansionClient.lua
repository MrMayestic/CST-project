local valueodpal = game.ReplicatedStorage.Events.VALUEvents.VALUEODPAL
local getPlot = game.ReplicatedStorage.Remotes.requestPlot
local frame = script.Parent.ExpandPlotFrame
local plot = getPlot:InvokeServer()

local position
local player = game.Players.LocalPlayer
local MarketplaceService = game:GetService("MarketplaceService")

local left1ExpID = 1163446072
local left2ExpID = 1275701464
local left3ExpID = 1275701630

local right1ExpID = 1163902199
local right2ExpID = 1275697549
local right3ExpID = 1275700497

local middle1ExpID = 1163902200
local middle2ExpID = 1163903525

local arjusiur = script.Parent.ARJUSIURPLOT
local elo = false
local AudioPlayer = require(game.ReplicatedStorage.Modules:WaitForChild("AudioModule"))
wait()
--[[if plot.Name == "Plot1" then
	position = workspace.Plots.Plot1.Plot.Position
elseif plot.Name == "Plot2" then
	position = workspace.Plots.Plot2.Plot.Position
elseif plot.Name == "Plot3" then
	position = workspace.Plots.Plot3.Plot.Position
end]]
--position = plot.Plot.Position

---WYS£ANIE REQUESTA DO SERVERA

function Najwazniejsza(ktore)

	local jaki = ktore:GetAttribute("ile")

	if string.match(ktore.Name,"Left") then

		ktore.Visible = false
		if jaki < 3 then
			ktore.Parent["LeftExpand"..jaki+1].Visible = true
		end

	elseif string.match(ktore.Name,"Right") then
		ktore.Visible = false
		if jaki < 3 then
			ktore.Parent["RightExpand"..jaki+1].Visible = true
		end	
	elseif string.match(ktore.Name,"Front") then
		ktore.Visible = false
		if jaki < 3 then
			ktore.Parent["FrontExpand"..jaki+1].Visible = true
		end	
	end	
end

game.ReplicatedStorage.Events.ExpansionEvents.YepIboughtExp.OnClientEvent:Connect(Najwazniejsza)

function czykupiles(plr,jaki)
	local yes = arjusiur.YES
	local no = arjusiur.NO
	
	arjusiur.Visible = true
	elo = true
	yes.MouseButton1Click:Connect(function()
		arjusiur.Visible = false
		if elo then
			AudioPlayer.playAudio("Click")
			elo = false
			valueodpal:FireServer(jaki)
		end
	end)
	
	no.MouseButton1Click:Connect(function()
		arjusiur.Visible = false
	end)

	wait(0.01)

end

local function nadanie()
	valueodpal:FireServer("jojko")
end

--LEFT SITE

frame.LeftExpand1.RobXButton.MouseButton1Click:Connect(function(plr)
	MarketplaceService:PromptProductPurchase(player, left1ExpID)
end)

frame.LeftExpand2.RobXButton.MouseButton1Click:Connect(function(plr)
	MarketplaceService:PromptProductPurchase(player, left2ExpID)
end)

frame.LeftExpand3.RobXButton.MouseButton1Click:Connect(function(plr)
	MarketplaceService:PromptProductPurchase(player, left3ExpID)
end)

-----------

--RIGHT SITE

frame.RightExpand1.RobXButton.MouseButton1Click:Connect(function(plr)
	MarketplaceService:PromptProductPurchase(player, right1ExpID)
end)

frame.RightExpand2.RobXButton.MouseButton1Click:Connect(function(plr)
	MarketplaceService:PromptProductPurchase(player, right2ExpID)
end)

frame.RightExpand3.RobXButton.MouseButton1Click:Connect(function(plr)
	MarketplaceService:PromptProductPurchase(player, right3ExpID)
end)

-----------

--MIDDLE SITE
frame.FrontExpand2.RobXButton.MouseButton1Click:Connect(function(plr)
	MarketplaceService:PromptProductPurchase(player, middle1ExpID)
end)

frame.FrontExpand3.RobXButton.MouseButton1Click:Connect(function(plr)
	MarketplaceService:PromptProductPurchase(player, middle2ExpID)
end)

------------------------------------------------------------------------------------------------------------------------------------
frame.LeftExpand1.MouseButton1Click:Connect(function(plr)

	wait()
	czykupiles(plr,frame.LeftExpand1)
end)
------------------------------------------------------------------------------------------------------------------------------------
frame.LeftExpand2.MouseButton1Click:Connect(function(plr)

	wait()
	czykupiles(plr,frame.LeftExpand2)
end)
------------------------------------------------------------------------------------------------------------------------------------
frame.LeftExpand3.MouseButton1Click:Connect(function(plr)

	wait()
	czykupiles(plr,frame.LeftExpand3)
end)
------------------------------------------------------------------------------------------------------------------------------------

frame.RightExpand1.MouseButton1Click:Connect(function(plr)

	wait()
	czykupiles(plr,frame.RightExpand1)
end)

------------------------------------------------------------------------------------------------------------------------------------

frame.RightExpand2.MouseButton1Click:Connect(function(plr)

	wait()
	czykupiles(plr,frame.RightExpand2)
end)

------------------------------------------------------------------------------------------------------------------------------------

frame.RightExpand3.MouseButton1Click:Connect(function(plr)

	wait()
	czykupiles(plr,frame.RightExpand3)
end)

------------------------------------------------------------------------------------------------------------------------------------
frame.FrontExpand2.MouseButton1Click:Connect(function(plr)

	wait()
	czykupiles(plr,frame.FrontExpand2)
end)


------------------------------------------------------------------------------------------------------------------------------------
frame.FrontExpand3.MouseButton1Click:Connect(function(plr)

	wait()
	czykupiles(plr,frame.FrontExpand3)
end)


------------------------------------------------------------------------------------------------------------------------------------
game.ReplicatedStorage.Events.ExpansionEvents.ODPALEXPANSION.OnClientEvent:Connect(function(toggle,slot)
	wait()
	local ileL = player.hidden.IleL.Value
	local ileC = player.hidden.IleC.Value
	local ileR = player.hidden.IleR.Value

	if ileL > 0 and ileL < 3 then
		for i=1,ileL do
			frame["LeftExpand"..i].Visible = false
		end
		frame["LeftExpand"..ileL+1].Visible = true
	elseif ileL < 1 then
		frame.LeftExpand1.Visible = true
	else
		for i=1,3 do
			frame["LeftExpand"..i].Visible = false
		end
	end

	if ileC > 1 and ileC < 3 then
		for i=2,ileC do
			frame["FrontExpand"..i].Visible = false
		end
		frame["FrontExpand"..ileC+1].Visible = true
	elseif ileC < 2 then
		frame.FrontExpand2.Visible = true
	else
		for i=2,3 do
			frame["FrontExpand"..i].Visible = false
		end
	end

	if ileR > 0 and ileR < 3 then
		for i=1,ileR do
			frame["RightExpand"..i].Visible = false
		end
		frame["RightExpand"..ileR+1].Visible = true
	elseif ileR < 1 then
		frame.RightExpand1.Visible = true
	else
		for i=1,3 do
			frame["RightExpand"..i].Visible = false
		end
	end

	nadanie()
	
	if not toggle then
		game.ReplicatedStorage.Events.ExpansionEvents.ServerExt:FireServer("jojko",slot)
	end
end)

--[[local function zakup(receipt)
	local ID = receipt.ProductId
	
	if ID == leftexpandID then
		wait()
		if value == 2 then			
				valueodpal:FireServer(3,0, plot, position)			
		else
			valueodpal:FireServer(1,0, plot, position)	
		end
		end
	if ID == rightexpandID then
		if value == 1 then			
			valueodpal:FireServer(3,0, plot, position)		
		else
			valueodpal:FireServer(2,0, plot, position)	
		end
	end
	if ID == ffexpandID then
		valueodpal:FireServer(4,0, plot, position)
	end
	if ID == sfexpandID then
		valueodpal:FireServer(5,0, plot, position)
	end
	
end


buyevents.BUYExpand.OnClientEvent:Connect(zakup)]]

game.ReplicatedStorage.Events.RESETEXPANSIONGUI.OnClientEvent:Connect(function()
	local frame = script.Parent.ExpandPlotFrame
	for i,n in pairs(frame:GetChildren()) do
		if n.Name ~= "Frame" and n.Name ~= "UICorner" then
			n.Visible = false
		end
	end
	frame.LeftExpand1.Visible = true
	frame.RightExpand1.Visible = true
	frame.FrontExpand2.Visible = true
	plot[plot:GetAttribute('Sign')].Text.SurfaceGui.TextL.Text = " "
end)