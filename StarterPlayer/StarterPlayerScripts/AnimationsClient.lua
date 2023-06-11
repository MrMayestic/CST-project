local RS = game:WaitForChild("ReplicatedStorage")

local walkID = "http://www.roblox.com/asset/?id=10126574945"
local breathID = "http://www.roblox.com/asset/?id=10201386176"

local plr = game.Players.LocalPlayer

--Customer

local takingDPID = "http://www.roblox.com/asset/?id=12290251282"
local takingSID = "http://www.roblox.com/asset/?id=12290947281"

local cashRegT1PayID = "http://www.roblox.com/asset/?id=12328444807"

--Storeman

local fillingDT_ID = "http://www.roblox.com/asset/?id=12326593556"
local fillingS_ID = "http://www.roblox.com/asset/?id=12325856910"

local function setAnim(model,animID,name)
	local Animation = Instance.new("Animation")
	Animation.AnimationId = animID
	Animation.Name = name
	Animation.Parent = model.Humanoid

	if model:FindFirstChild("Humanoid") then
		return model.Humanoid:LoadAnimation(Animation)
	else
		return model.AnimationController:LoadAnimation(Animation)
	end
end

local function createAnimsCustomer(npc)
	setAnim(npc,walkID,"walk")
	setAnim(npc,breathID,"breath")
	setAnim(npc,takingDPID,"tdt")
	setAnim(npc,takingSID,"ts")
	setAnim(npc,cashRegT1PayID,"crp")
end

local function createAnimsStoreman(npc)
	setAnim(npc,walkID,"walk")
	setAnim(npc,breathID,"breath")
	setAnim(npc,fillingDT_ID,"fdt")
	setAnim(npc,fillingS_ID,"fs")
end


RS:WaitForChild("Events"):WaitForChild("AnimationEvents"):WaitForChild("playAnim").OnClientEvent:Connect(function(npc,anim,adjust)
	pcall(function()
		if not plr:FindFirstChild("SetFolder") then
			return
		end
		
		if plr.SetFolder.localAnims.Value then
			if npc.Parent.Parent.wazne.Owner.Value ~= plr.Name then
				return
			end
		end
		
		for i,v in pairs(npc.Humanoid:GetPlayingAnimationTracks()) do
			v:Stop()
		end
		
		if not npc.Humanoid:FindFirstChild("AnimatorLocal") then
			local animator = Instance.new("Animator")
			animator.Parent = npc.Humanoid
			animator.Name = "AnimatorLocal"

			if npc.Name == "Customer" then
				createAnimsCustomer(npc)
			else
				createAnimsStoreman(npc)
			end
			
			if anim ~= "breath" then
				return
			end
		end
		
		task.wait()
		
		local animation = npc.Humanoid:LoadAnimation(npc.Humanoid[anim])
		animation:Play()
		
		if adjust then
			animation:AdjustSpeed(adjust)
		end
	end)
end)

RS:WaitForChild("Events"):WaitForChild("AnimationEvents"):WaitForChild("stopAnim").OnClientEvent:Connect(function(npc)
	pcall(function() 
		if not plr:FindFirstChild("SetFolder") then
			return
		end
		
		if plr.SetFolder.localAnims.Value then
			if npc.Parent.Parent.wazne.Owner.Value ~= plr.Name then
				return
			end
		end
		
		if not npc.Humanoid:FindFirstChild("AnimatorLocal") then
			local animator = Instance.new("Animator")
			animator.Parent = npc.Humanoid
			animator.Name = "AnimatorLocal"

			if npc.Name == "Customer" then
				createAnimsCustomer(npc)
			else
				createAnimsStoreman(npc)
			end
			
			return false
		end
		
		for i,v in pairs(npc.Humanoid:GetPlayingAnimationTracks()) do
			v:Stop()
		end
	end)
end)


RS:WaitForChild("Events"):WaitForChild("AnimationEvents"):WaitForChild("initateAnims").OnClientEvent:Connect(function(npc)
	pcall(function() 
		if not plr:FindFirstChild("SetFolder") then
			return
		end
		
		if plr.SetFolder.localAnims.Value then
			if npc.Parent.Parent.wazne.Owner.Value ~= plr.Name then
				return
			end
		end
		
		local animator = Instance.new("Animator")
		animator.Parent = npc.Humanoid
		animator.Name = "AnimatorLocal"

		if npc.Name == "Customer" then
			createAnimsCustomer(npc)
		else
			createAnimsStoreman(npc)
		end
	end)
end)

RS:WaitForChild("Events"):WaitForChild("AnimationEvents"):WaitForChild("destroyAnims").OnClientEvent:Connect(function(npc)
	pcall(function() 
		for i,v in pairs(npc.Humanoid:GetPlayingAnimationTracks()) do
			v:Destroy()
		end
	end)
end)