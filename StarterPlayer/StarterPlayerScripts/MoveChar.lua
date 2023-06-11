local player = game.Players.LocalPlayer
local UIS = game:GetService('UserInputService')

local function MoveChar(Char, X, Z)
	Char:SetPrimaryPartCFrame(CFrame.new(X, 8, Z))
end

player.CharacterAdded:Connect(function(char)
	local waiter = player:WaitForChild("leaderstats"):WaitForChild("Cash")
	local waiter2 = game.Workspace:WaitForChild("Plots"):WaitForChild("Plot8"):WaitForChild("Plot")
	
	task.wait(0.1)
	
	for i, plt in pairs(workspace.Plots:GetChildren()) do
		if plt then
			if plt.wazne.Owner.Value == player.Name then 
				task.wait(0.65)
				MoveChar(char, plt.Spawn.CFrame.X, plt.Spawn.CFrame.Z)
				if UIS.TouchEnabled then
					player.PlayerGui:FindFirstChild("TouchGui"):WaitForChild('TouchControlFrame'):WaitForChild('JumpButton').Position = UDim2.new(0, workspace.Camera.ViewportSize.X * 0.8, 0, workspace.Camera.ViewportSize.Y * 0.648)
					local viewX = workspace.Camera.ViewportSize.X
					local viewY = workspace.Camera.ViewportSize.Y

					local Yperc = workspace.Camera.ViewportSize.X/workspace.Camera.ViewportSize.Y

					local sizeX = ((workspace.Camera.ViewportSize.X * 60)/1080)/workspace.Camera.ViewportSize.X
					local sizeY = sizeX * Yperc
					player.PlayerGui:FindFirstChild("TouchGui").TouchControlFrame.JumpButton.Size = UDim2.new(sizeX, 0, sizeY, 0)
				end
				break
			end
		end
	end
end)

