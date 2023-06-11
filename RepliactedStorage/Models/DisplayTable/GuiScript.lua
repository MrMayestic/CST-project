local model = script.Parent
local towar = model.Towar


towar.IleArtykul.Changed:Connect(function()	
	model.Guiile.ile.Text = towar.IleArtykul.Value
end)
towar.KtoryArtykul.Changed:Connect(function()
	local co = towar.KtoryArtykul.Value
	if co == "telefony" then
		model.GuiCo.Co.Text = "Phones"
	elseif co == "aparaty" then
		model.GuiCo.Co.Text = "Cameras"
	elseif co == "tablety" then
		model.GuiCo.Co.Text = "Tablets"
	else
		model.GuiCo.Co.Text = ""
	end
end)