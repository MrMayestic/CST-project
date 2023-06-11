local model = script.Parent
local towar = model.Towar


towar.IleArtykul.Changed:Connect(function()	
	model.Guiile.ile.Text = towar.IleArtykul.Value
end)
towar.KtoryArtykul.Changed:Connect(function()
	local co = towar.KtoryArtykul.Value
	if co == "telewizory" then
		model.GuiCo.Co.Text = "TVs"
	elseif co == "konsole" then
		model.GuiCo.Co.Text = "Consoles"
	elseif co == "komputery" then
		model.GuiCo.Co.Text = "Computers"
	elseif co == "monitory" then
		model.GuiCo.Co.Text = "Monitors"
	else
		model.GuiCo.Co.Text = ""
	end
end)