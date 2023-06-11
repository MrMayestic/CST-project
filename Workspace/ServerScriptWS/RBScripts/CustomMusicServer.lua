local RS = game.ReplicatedStorage
local plotManager = require(game.ServerScriptService.ServerModules.PlotManager)

local MarketplaceService = game:GetService("MarketplaceService")

local errormodule = require(game.ReplicatedStorage.Modules.ErrorModule)

local players = game:GetService("Players")

local customMusicPassID = 172117812

local function setMusic(plr,id)	
	local hasPass = false

	local success, message = pcall(function()
		hasPass = MarketplaceService:UserOwnsGamePassAsync(plr.UserId, customMusicPassID)
	end)

	if not hasPass then
		return
	end

	local plot = plotManager.returnPlot(workspace.Plots, plr)

	local succ,err = pcall(function() 
		game:GetService("MarketplaceService"):GetProductInfo(id)
	end)

	if succ then
		task.wait(0.15)

		plot:SetAttribute("musicId",id)

		task.wait(0.1)
		pcall(function() 
			for i,n in pairs(plot.SoundPart:GetTouchingParts()) do
				if n.Parent.Name ~= "Customer" and n.Parent.Name ~= "Storeman" and n.Parent.Name ~= "Cashier" then
					local humanoid = n.Parent:FindFirstChild("Humanoid")

					if humanoid and id ~= "" and id ~= nil then
						local char = n.Parent
						local target = players:GetPlayerFromCharacter(char)
						task.wait()
						game.ReplicatedStorage.SoundEvent:FireClient(target,true,plot)
					end
				end
			end
		end)
	else
		errormodule.errorfuncGo(plr,"Error while loading music: "..err)
	end
end

RS.Events.RBEvents.playMusic.OnServerEvent:Connect(setMusic)

task.wait(2)

for i,n in pairs(game.Workspace.Plots:GetChildren()) do
	n.SoundPart.Touched:Connect(function(part)
		task.wait(0.1)
		pcall(function()
			if part.Parent then
				if part.Parent.Name ~= "Customer" and part.Parent.Name ~= "Storeman" and part.Parent.Name ~= "Cashier" then
					local humanoid = part.Parent:FindFirstChild("Humanoid")

					if humanoid and n:GetAttribute("musicId") ~= "" and n:GetAttribute("musicId") ~= nil then
						local char = part.Parent
						local target = players:GetPlayerFromCharacter(char)
						if target then
							game.ReplicatedStorage.SoundEvent:FireClient(target,true,n)
						end
					end
				end
			end
		end)
	end)

	n.SoundPart.TouchEnded:Connect(function(part)
		task.wait(0.1)
		pcall(function() 
			if part.Parent then
				if part.Parent.Name ~= "Customer" and part.Parent.Name ~= "Storeman" and part.Parent.Name ~= "Cashier" then
					local humanoid = part.Parent:FindFirstChild("Humanoid")

					if humanoid then
						local char = part.Parent
						local target = players:GetPlayerFromCharacter(char)
						if target then
							game.ReplicatedStorage.SoundEvent:FireClient(target,false,n)
						end
					end
				end
			end
		end)
	end)
end