local model = script.Parent
local towar = model.Towar


towar.IleArtykul.Changed:Connect(function()	
	model.Guiile.ile.Text = towar.IleArtykul.Value
end)
towar.KtoryArtykul.Changed:Connect(function()
	local co = towar.KtoryArtykul.Value
	
	if co == "klawiatury" then
		model.GuiCo.Co.Text = "Keyboards"
	elseif co == "myszki" then
		model.GuiCo.Co.Text = "Mouses"
	elseif co == "glosniki" then
		model.GuiCo.Co.Text = "Speakers"
	elseif co == "sluchawki" then
		model.GuiCo.Co.Text = "Headphones"
	else
		model.GuiCo.Co.Text = ""
	end
end)