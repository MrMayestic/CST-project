local plr = game.Players.LocalPlayer
local SoundService = game:GetService("SoundService")

game.ReplicatedStorage.SoundEvent.OnClientEvent:Connect(function(toggle,plot)
	task.wait(0.04)
	
	pcall(function() 
		if not plr:FindFirstChild("SetFolder") then
			return
		end
		if toggle then
			for i,n in pairs(SoundService:GetChildren()) do
				if n.Name == "Sound" then
					n.Volume = 0
				end
			end
			
			if "rbxassetid://"..tostring(plot:GetAttribute("musicId")) ~= SoundService.CustomMusic.SoundId then
				SoundService.CustomMusic.SoundId = "rbxassetid://"..tostring(plot:GetAttribute("musicId"))
				SoundService.CustomMusic.Playing = true
				SoundService.CustomMusic:Play()
				SoundService.CustomMusic.Volume = (plr.SetFolder.VolumeLvl.Value)/100
			end
		else
			for i,n in pairs(SoundService:GetChildren()) do
				if n.Name == "Sound" then
					n.Volume = (plr.SetFolder.VolumeLvl.Value)/100
				end
			end
			
			SoundService.CustomMusic.SoundId = ""
			SoundService.CustomMusic.Playing = false
			SoundService.CustomMusic:Stop()
			SoundService.CustomMusic.Volume = 0
		end
	end)
end)