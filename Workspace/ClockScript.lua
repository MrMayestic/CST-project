local clock = game.Workspace.Clock

local function lightsOn()
	for i,n in pairs(game.Workspace.Lamps:GetChildren()) do
		for j,m in pairs(n:GetChildren()) do
			if m.Name == "Light" then
				m.SpotLight.Enabled = true
				m.Transparency = 0
			end
		end
	end
end

local function lightsOff()
	for i,n in pairs(game.Workspace.Lamps:GetChildren()) do
		for j,m in pairs(n:GetChildren()) do
			if m.Name == "Light" then
				m.SpotLight.Enabled = false
				m.Transparency = 0.55
				m.SpotLight.Brightness = 1
			end
		end
	end
end

lightsOff()

while task.wait(0.029) do
	if clock.Value + 0.001 > 24 then
		clock.Value = 0
	end
	clock.Value += 0.001
	if clock.Value >= 17.5 and clock.Value <= 17.55 then
		lightsOn()
		for i,n in pairs(game.Workspace.Plots:GetChildren()) do
			for j,m in pairs(n.PlacedObjects:GetChildren()) do
				if string.match(m.Name,"Light") then
					if m.LightPart.Light:GetAttribute("KtoryTryb")==2 then
						m.LightPart.BrickColor = BrickColor.new(1,1,1)
						m.LightPart.Light.Enabled = true
					end
				elseif string.match(m.Name,"Sign") then
					if m.Paintable2.LightPart.Light:GetAttribute("KtoryTryb") == 2 then
						m.Paintable2.LightPart.Light.Enabled = true
						m.Paintable2.LightPart.BrickColor =  BrickColor.new(1,1,1)
					end
				end
			end	
		end
	end
	if clock.Value >= 6.5 and clock.Value <= 6.55 then
		lightsOff()
		for i,n in pairs(game.Workspace.Plots:GetChildren()) do
			for j,m in pairs(n.PlacedObjects:GetChildren()) do
				if string.match(m.Name,"Light") then
					if m.LightPart.Light:GetAttribute("KtoryTryb")==2 then
						m.LightPart.Light.Enabled = false
						m.LightPart.BrickColor = BrickColor.new(0.5,0.5,0.5)
					end
				elseif string.match(m.Name,"Sign") then
					if m.Paintable2.LightPart.Light:GetAttribute("KtoryTryb") == 2 then
						m.Paintable2.LightPart.Light.Enabled = false
						m.Paintable2.LightPart.BrickColor = BrickColor.new(0.5,0.5,0.5)
					end
				end
			end
		end
	end
	local stringNow = tostring(clock.Value)
	local hourMin = string.split(stringNow,".")

	local currentTime
	local minVal = tonumber("0."..hourMin[2])
	local minute = math.floor(minVal*60)
	currentTime = string.format("%02d:%02d", tonumber(hourMin[1]), minute)
	for i,n in pairs(game.Players:GetChildren()) do
		if n.PlayerGui:FindFirstChild('BuildUI') then
			if n.PlayerGui:FindFirstChild('BuildUI'):FindFirstChild('Clock') then
				n.PlayerGui.BuildUI.Clock.clock.Text = currentTime
			end
		end
	end
end