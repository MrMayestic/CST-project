local errormodule = require(game.ReplicatedStorage.Modules.ErrorModule)

local breathID = "http://www.roblox.com/asset/?id=10201386176"


local BColors = {3, 5, 12, 18, 108, 128, 138, 224, 224, 226, 226}
local SColors = {22}
local PColors = {26}
local BColor = BrickColor.new(BColors[math.random(1, #BColors)])
local SColor = BrickColor.new(SColors[math.random(1, #SColors)])
local PColor = BrickColor.new(PColors[math.random(1, #PColors)])

local playAnim = game.ReplicatedStorage.Events.AnimationEvents.playAnim
local stopAnim = game.ReplicatedStorage.Events.AnimationEvents.stopAnim
local initiateAnims = game.ReplicatedStorage.Events.AnimationEvents.initateAnims
local destroyAnims = game.ReplicatedStorage.Events.AnimationEvents.destroyAnims


script.Parent.Head.BrickColor = BColor
script.Parent.LeftUpperArm.BrickColor = BColor
script.Parent.LeftUpperLeg.BrickColor = PColor
script.Parent.RightUpperArm.BrickColor = BColor
script.Parent.RightUpperLeg.BrickColor = PColor
script.Parent.UpperTorso.BrickColor = SColor



--local function setAnim(model,animID)
--	local Animation = Instance.new("Animation")
--	Animation.AnimationId = animID

--	if model:FindFirstChild("Humanoid") then
--		return model.Humanoid:LoadAnimation(Animation)
--	else
--		return model.AnimationController:LoadAnimation(Animation)
--	end
--end

--local breath = setAnim(script.Parent,breathID)

script.Parent.Changed:Connect(function(what)
	if what == "Parent" then
		task.wait(0.5)
		local plr = game.Players:FindFirstChild(script.Parent.Parent.Parent.wazne.Owner.Value)
		if plr then
			for i,j in pairs(script.Parent:GetChildren()) do
				if j.ClassName == "Part" or j.ClassName == "MeshPart" then
					j:SetNetworkOwner(plr)
				end
			end
		end
		--initiateAnims:FireAllClients(script.Parent)
		task.wait(0.5)
		--task.wait(math.random(15,25)/10)
		playAnim:FireAllClients(script.Parent,"breath",0.4)
	end
end)