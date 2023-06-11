local frame = script.Parent
local set = frame.SetButton
local war = frame.Wartosci
local onoff = frame.Wartosci.OnOffVal
local AudioPlayer = require(game.ReplicatedStorage.Modules:WaitForChild("AudioModule"))


onoff.MouseButton1Click:Connect(function()
	AudioPlayer.playAudio("Click")
	if onoff:GetAttribute("KtoryTryb") == 0 then	
		onoff:SetAttribute("KtoryTryb",1)
		onoff.Text = "ON"
	elseif onoff:GetAttribute("KtoryTryb") == 1 then
		onoff:SetAttribute("KtoryTryb",2)
		onoff.Text = "ON AT NIGHT"
	elseif onoff:GetAttribute("KtoryTryb") == 2 then
		onoff:SetAttribute("KtoryTryb",0)
		onoff.Text = "OFF"
	end
end)

set.MouseButton1Click:Connect(function()
	AudioPlayer.playAudio("Click")
	local model = frame.Object.Value
	local light = model.LightPart.Light
	local angle = if tonumber(war.AngleVal.Text) then tonumber(war.AngleVal.Text) else 0
	local bright = if tonumber(war.BrightnessVal.Text) then tonumber(war.BrightnessVal.Text) else 0
	local range = if tonumber(war.RangeVal.Text) then tonumber(war.RangeVal.Text) else 0

	if angle > 120 then
		war.AngleVal.Text = 120
	elseif angle < 0 then
		war.AngleVal.Text = 0
	end

	if bright > 10 then
		war.BrightnessVal.Text = 10
	elseif bright < 0 then
		war.BrightnessVal.Text = 0
	end

	if range > 70 then
		war.RangeVal.Text = 70
	elseif range < 0 then
		war.RangeVal.Text = 0
	end
	
	war.AngleVal.Text  = math.floor(tonumber(war.AngleVal.Text))
	war.RangeVal.Text = math.floor(tonumber(war.RangeVal.Text))
	war.BrightnessVal.Text = math.round(tonumber(war.BrightnessVal.Text)*100)/100
	game.ReplicatedStorage.Events.LightManage:FireServer(light,war.AngleVal.Text,war.BrightnessVal.Text,onoff:GetAttribute("KtoryTryb"),war.RangeVal.Text)

end)