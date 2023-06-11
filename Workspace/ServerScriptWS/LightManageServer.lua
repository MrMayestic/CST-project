local RS = game.ReplicatedStorage
local clock = workspace.Clock

function ChangeLight(plr,light,angle,bright,onoff,range)
	if angle then
		light.Angle = angle
		light.Brightness = bright
		light.Range = range
	end

	light:SetAttribute("KtoryTryb",onoff)
	
	if onoff == 0 then
		light.Parent.BrickColor = BrickColor.new(0.5,0.5,0.5)
		light.Enabled = false
	end
	if onoff == 1 then
		light.Parent.BrickColor = BrickColor.new(1,1,1)
		light.Enabled = true
	end
	if onoff == 2 then
		if clock.Value >= 17.5 and clock.Value <= 6.5 then
			light.Parent.BrickColor = BrickColor.new(1,1,1)
			light.Enabled = true
		end
		if clock.Value >= 6.5 and clock.Value <= 17.5 then
			light.Parent.BrickColor = BrickColor.new(0.5,0.5,0.5)
			light.Enabled = false
		end
	end
	task.wait()
end

RS.Events.LightManage.OnServerEvent:Connect(ChangeLight)