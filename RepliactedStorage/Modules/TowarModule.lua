local towarmodule = {}

local Towarodpal = game.ReplicatedStorage.Remotes.TowarOdpal

local towarevents= game.ReplicatedStorage.Events.TowarEvents
local errormodule = require(game.ReplicatedStorage.Modules.ErrorModule)

function towarmodule.towar(plr, ktore, model, toggle, ile) --zaczyna
	local itemy
	local towarItems = model.Towar[ktore]:GetChildren()
	local cosvalue = model.Towar.KtoryArtykul.Value
	local ilevalue = model.Towar.IleArtykul.Value
	if cosvalue then
		itemy = model.Towar:FindFirstChild(cosvalue)
	else
		itemy = nil
	end

	if itemy then

		towarItems = model.Towar[cosvalue]:GetChildren()
		for i, part in ipairs(towarItems) do
			part.Transparency = 1
		end
		plr.TowarFolder[cosvalue].Value += ilevalue
	end
	model.Towar.KtoryArtykul.Value = ktore
	towarItems = model.Towar[ktore]:GetChildren()
	--towarevents.ServerSet:FireServer(towarItems)
	if toggle then
		
		plr.TowarFolder[ktore].Value -= 6
		
		for i, part in ipairs(towarItems) do
			part.Transparency = 0
		end
		model.Towar.IleArtykul.Value = 6
	else
		plr.TowarFolder[ktore].Value -= ile
		local licznik = 0
		for i, part in ipairs(towarItems) do
			if licznik == ile then
				model.Towar.IleArtykul.Value = ile
				return 
			end
			licznik += 1
			part.Transparency = 0
		end

	end

end

function towarmodule.uzupelnij(plr, ktore, model)
	pcall(function() 
		if plr.TowarFolder[ktore].Value == 0 then

			return
		end
		local ilejest = model.Towar.IleArtykul.Value
		local ileno = 6 - ilejest
		if ileno == 0 or ileno < 0 then
			return
		end
		local uzupelnijItems = model.Towar[ktore]:GetChildren()
		local liczniktu = 0
		for i, part in ipairs(uzupelnijItems) do

			if part.Transparency == 1 then

				liczniktu += 1
				part.Transparency = 0 
				model.Towar.IleArtykul.Value += 1
				plr.TowarFolder[ktore].Value -= 1
				
				if liczniktu == ileno then
					game.ReplicatedStorage.Events.TowarEvents.Zlicz:FireClient(plr)
					return
				end
			end

			if plr.TowarFolder:FindFirstChild(ktore).Value == 0 then
				game.ReplicatedStorage.Events.TowarEvents.Zlicz:FireClient(plr)

				return
			end

		end
		if model.Towar.IleArtykul.Value ~= ilejest and ilejest < 6 and plr.TowarFolder:FindFirstChild(ktore).Value > 0 then
			if plr.TowarFolder:FindFirstChild(ktore).Value >= ileno then
				model.Towar.IleArtykul.Value = 6
				plr.TowarFolder[ktore].Value -= ileno
			else
				model.Towar.IleArtykul.Value += plr.TowarFolder[ktore].Value
				plr.TowarFolder[ktore].Value = 0
			end
		end
		game.ReplicatedStorage.Events.TowarEvents.Zlicz:FireClient(plr)
	end)
end

local function getFrame(plr,name)
	if name == "DisplayTable" then
		return plr.PlayerGui.BuildUI.DisplayTableFrame
	elseif name == "Shelf" then
		return plr.PlayerGui.BuildUI.ShelfFrame
	elseif name == "SmallShelf" then
		return plr.PlayerGui.BuildUI.SmallShelfFrame
	end
end


function towarmodule.erase(plr, model,ktore,capacity,ilejest)
	local frame = getFrame(plr,model.Name)

	local ilevalue = model.Towar.IleArtykul
	
	if capacity - ilejest < ilevalue.Value then
		errormodule.errorfuncGo(plr,"You don't have enough capacity!")
		return 0
	else
		local ktoryartykul = model.Towar.KtoryArtykul	
	
		if ktoryartykul.Value ~= "" and ktoryartykul.Value then
			local ity = model.Towar[ktoryartykul.Value]
			for i,part in ipairs(ity:GetChildren()) do
				part.Transparency = 1
			end
			plr.TowarFolder[ktoryartykul.Value].Value += ilevalue.Value
			ilevalue.Value = 0
			ktoryartykul.Value = ""
			frame.CoInfo.Text = " "

			game.ReplicatedStorage.Events.TowarEvents.Zlicz:FireClient(plr)
		end
	end
end


function towarmodule.wczytaj(plr, model)
	local ile = model.Towar.IleArtykul.Value
	if ile==0 then
		return
	end
	local ktory = model.Towar.KtoryArtykul.Value
	local wczytajtowar = model.Towar[ktory]
	local licznikIle = 0
	if wczytajtowar then
		for i,part in ipairs(wczytajtowar:GetChildren()) do
			part.Transparency = 0
			licznikIle+=1
			if licznikIle == ile then
				return
			end
		end
	end

end

return towarmodule
