-- INFO you can change --
local speed = 30 -- how fast you want the player to sprint?
local norm_spd = 16 -- what do you want the normal speed to be?
--local ke_y = Enum.KeyCode.LeftShift -- what key do you want it to work with?


------------------------------------------------ Don't edit under here - you may break something -- --
local fovMax = { FieldOfView = 70 + (speed/10) }
local fovMin = { FieldOfView = 70 }
local thing = game.Workspace.CurrentCamera
local tween = game.TweenService:Create(thing, TweenInfo.new(0.4, Enum.EasingStyle.Sine), fovMax)
local tween2 = game.TweenService:Create(thing, TweenInfo.new(0.4, Enum.EasingStyle.Sine), fovMin)
--local UIS = game:GetService("UserInputService")
wait(1)

local LocalPlayer = game:GetService"Players".LocalPlayer

local waiter = LocalPlayer:WaitForChild("PlayerGui")

function mobsprint(name,state)

	if state == Enum.UserInputState.Begin then
		local char = LocalPlayer.Character
		if char then
			if char.Humanoid.WalkSpeed < 70 then
				char.Humanoid.WalkSpeed = 36
				tween:Play()
			else
				char.Humanoid.WalkSpeed = 86
				tween:Play()
			end
		end
	else
		local char = LocalPlayer.Character
		if char and char.Humanoid.WalkSpeed < 70 then
			char.Humanoid.WalkSpeed = 20
			tween2:Play()
		else
			char.Humanoid.WalkSpeed = 70
			tween2:Play()
		end
	end
	--return Enum.ContextActionResult.Pass
end

wait(1.5)

local ContextActionService = game:GetService"ContextActionService"
local UIS = game:GetService("UserInputService")

ContextActionService:BindAction("Sprint",mobsprint,true, Enum.KeyCode.LeftShift)
if UIS.TouchEnabled then
	ContextActionService:SetPosition("Sprint",UDim2.new(1, workspace.Camera.ViewportSize.X * -0.129, 0, workspace.Camera.ViewportSize.Y * 0.05))
	ContextActionService:SetTitle("Sprint","Sprint")
	local sprintbutton = ContextActionService:GetButton("Sprint")
	sprintbutton.Name = "Sprint"
	sprintbutton.ActionTitle.TextScaled = true
end