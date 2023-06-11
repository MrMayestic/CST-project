local players = game:GetService("Players")
local DSS = game:GetService("DataStoreService")

local AchiveStore = DSS:GetDataStore("AchiveStoreV1")
local OthersStore = DSS:GetDataStore("OtherStoreV1")
local valuesrule

local Events = game.ReplicatedStorage.Events

local plotManager = require(game.ServerScriptService.ServerModules.PlotManager)
local errormodule = require(game.ReplicatedStorage.Modules.ErrorModule)
local LSmodule = require(game.ReplicatedStorage.Modules.LeaderstatsModule)

local dataTable = {}
local backupTable = {}
local bindTable = {}
local bindFrame
local removingPlayers = {}

local function Save(plr,toggle)
	if plr then
		if not plr:GetAttribute("CanSave") then
			return
		end
	else
		return
	end
	
	local plot = plotManager.returnPlot(workspace.Plots, plr)
	
	local slPI
	local playerData = dataTable[plr.userId]

	pcall(function()
		slPI = plr.PlayerGui.BuildUI.SaveLoadPI
		slPI.Text = "Preparing to save player data..."
	end)
	
	local key = "uid_" .. plr.userId
	local slot
	
	if playerData.slot then
		slot = playerData.slot
	end
	
	local DataStore = DSS:GetDataStore("SaveCashV"..slot)

	local save = {}
	local saveAchive = {}
	local fixedData = {}

	local backupSave = {}
	local backupSaveAchive = {}
	local backupFixedData = {}

	local successSave,erro = pcall(function()
		save = {
			["Cash"] = playerData.Cash;
			["telefony"] = playerData.telefony;
			["aparaty"] = playerData.aparaty;
			["tablety"] = playerData.tablety;

			["telewizory"] = playerData.telewizory;
			["konsole"] = playerData.konsole;
			["komputery"] = playerData.komputery;
			["monitory"] = playerData.monitory;

			["klawiatury"] = playerData.klawiatury;
			["myszki"] = playerData.myszki;
			["glosniki"] = playerData.glosniki;
			["sluchawki"] = playerData.sluchawki;
			---------------------------------------------------------------
			["ctelefony"] = playerData.ctelefony;
			["caparaty"] = playerData.caparaty;
			["ctablety"] = playerData.ctablety;

			["ctelewizory"] = playerData.ctelewizory;
			["ckonsole"] = playerData.ckonsole;
			["ckomputery"] = playerData.ckomputery;
			["cmonitory"] = playerData.cmonitory;

			["cklawiatury"] = playerData.cklawiatury;
			["cmyszki"] = playerData.cmyszki;
			["cglosniki"] = playerData.cglosniki;
			["csluchawki"] = playerData.csluchawki;

			["MaxCapacity"] = playerData.MaxCapacity;
			["nameshop"] = playerData.nameshop;
			["plotmaterial"] = playerData.plotmaterial;
			["colorR"] = playerData.colorR;
			["colorG"] = playerData.colorG;
			["colorB"] = playerData.colorB;
			
			["plotTop"] = playerData.plotTop;
			["plotBottom"] = playerData.plotBottom;
			
			["parking"] = playerData.parking;
			["sign"] = playerData.sign;

			["IleL"] = playerData.IleL;
			["IleC"] = playerData.IleC;
			["IleR"] = playerData.IleR;	

			["ratingnow"] = playerData.ratingnow;
			["rating"] = playerData.rating;

			["ktoryplot"] = playerData.ktoryplot;	

			["storagemenValue"] = playerData.storagemenValue;
			["cashiersValue"] = playerData.cashiersValue;
		}
		saveAchive = {
			["czytutorialdone"] = playerData.czytutorialdone;
			["CashLvl"] = playerData.CashLvl;
			["RatLvl"] = playerData.RatLvl;
			["ExLvl"] = playerData.ExLvl;
			["CashProg"] = playerData.CashProg;
			["RatProg"] = playerData.RatProg;
			["ExProg"] = playerData.ExProg
		}
		fixedData = {
			["grid"] = playerData.grid;
			["volume"] = playerData.volume;

			["MainStep"] = playerData.MainStep;
			["CashStep"] = playerData.CashStep;

			["boostPerc"] = playerData.boostPerc;
			["boostTimeLeft"] = playerData.boostTimeLeft;
			
			["localAnims"] = playerData.localAnims;
		}
		
		for i,n in pairs(playerData) do
			if string.match(i,"Custom") then
				fixedData[i] = n
			end
		end

		for i,n in pairs(bindTable) do
			fixedData[tostring(i)] = n
		end

	end)


	if not successSave then
		task.wait()
		print("Trying from backupTable")
		playerData = backupTable[plr.userId]
	end

	local successSaveBackup,errBack = pcall(function()
		if playerData then
			backupSave = {
				["Cash"] = playerData.Cash;
				["telefony"] = playerData.telefony;
				["aparaty"] = playerData.aparaty;
				["tablety"] = playerData.tablety;

				["telewizory"] = playerData.telewizory;
				["konsole"] = playerData.konsole;
				["komputery"] = playerData.komputery;
				["monitory"] = playerData.monitory;

				["klawiatury"] = playerData.klawiatury;
				["myszki"] = playerData.myszki;
				["glosniki"] = playerData.glosniki;
				["sluchawki"] = playerData.sluchawki;
				---------------------------------------------------------------
				["ctelefony"] = playerData.ctelefony;
				["caparaty"] = playerData.caparaty;
				["ctablety"] = playerData.ctablety;

				["ctelewizory"] = playerData.ctelewizory;
				["ckonsole"] = playerData.ckonsole;
				["ckomputery"] = playerData.ckomputery;
				["cmonitory"] = playerData.cmonitory;

				["cklawiatury"] = playerData.cklawiatury;
				["cmyszki"] = playerData.cmyszki;
				["cglosniki"] = playerData.cglosniki;
				["csluchawki"] = playerData.csluchawki;

				["MaxCapacity"] = playerData.MaxCapacity;
				["nameshop"] = playerData.nameshop;
				["plotmaterial"] = playerData.plotmaterial;
				["colorR"] = playerData.colorR;
				["colorG"] = playerData.colorG;
				["colorB"] = playerData.colorB;
				
				["plotTop"] = playerData.plotTop;
				["plotBottom"] = playerData.plotBottom;
				--	["ColorName"] = plr.SetFolder.ColorName.Value;
				["parking"] = playerData.parking;
				["sign"] = playerData.sign;

				["IleL"] = playerData.IleL;
				["IleC"] = playerData.IleC;
				["IleR"] = playerData.IleR;	

				["ratingnow"] = playerData.ratingnow;
				["rating"] = playerData.rating;

				["ktoryplot"] = playerData.ktoryplot;	

				["storagemenValue"] = playerData.storagemenValue;
				["cashiersValue"] = playerData.cashiersValue;
			}
			backupSaveAchive = {
				["czytutorialdone"] = playerData.czytutorialdone;
				["CashLvl"] = playerData.CashLvl;
				["RatLvl"] = playerData.RatLvl;
				["ExLvl"] = playerData.ExLvl;
				["CashProg"] = playerData.CashProg;
				["RatProg"] = playerData.RatProg;
				["ExProg"] = playerData.ExProg
			}
			backupFixedData = {
				["grid"] = playerData.grid;
				["volume"] = playerData.volume;

				["MainStep"] = playerData.MainStep;
				["CashStep"] = playerData.CashStep;

				["boostPerc"] = playerData.boostPerc;
				["boostTimeLeft"] = playerData.boostTimeLeft;
				
				["localAnims"] = playerData.localAnims;
			}
			for i,n in pairs(bindTable) do
				backupFixedData[tostring(i)] = n
			end
		end
	end)


	local succes, err
	local succes2, err2 
	local succes3, err3 
	local tries,tries2,tries3 = 0,0,0

	pcall(function()
		slPI.Text = "Trying to save player data..."
	end)

	repeat
		succes, err = pcall(function()
			DataStore:SetAsync(tostring(key), save)
			wait()
		end)

		tries += 1
		if not succes then
			task.wait(1.5)
		end
	until succes or tries == 4

	repeat
		succes2, err2 = pcall(function()
			AchiveStore:SetAsync(tostring(key), saveAchive)
			wait()
		end)

		tries2 += 1	
		if not succes2 then
			task.wait(1.5)
		end
	until succes2 or tries2 == 4

	repeat
		succes3, err3 = pcall(function()
			OthersStore:SetAsync(tostring(key), fixedData)
			wait()
		end)

		tries3 += 1
		if not succes3 then
			task.wait(1.5)
		end
	until succes3 or tries3 == 4

	print("po próBach zapisu; ", succes,succes2,succes3)

	if not succes then

		repeat
			succes, err = pcall(function()
				DataStore:SetAsync(tostring(key), backupSave)
				wait()
			end)

			tries += 1
			if not succes then
				task.wait(1.5)
			end
		until succes or tries == 4

		if not succes then
			errormodule.errorfuncGo(plr,"Failed to over-write standard data: "..tostring(err))
			return
		end
	end

	if not succes2 then
		repeat
			succes2, err2 = pcall(function()
				AchiveStore:SetAsync(tostring(key), backupSaveAchive)
				wait()
			end)

			tries2 += 1	
			if not succes2 then
				task.wait(1.5)
			end
		until succes2 or tries2 == 4

		if not succes2 then
			errormodule.errorfuncGo(plr,"Failed to over-write achivment's data: "..tostring(err))
			return
		end
	end

	if not succes3 then
		repeat
			succes3, err3 = pcall(function()
				OthersStore:SetAsync(tostring(key), fixedData)
				wait()
			end)

			tries3 += 1
			if not succes3 then
				task.wait(1.5)
			end
		until succes3 or tries3 == 4

		if not succes3 then
			errormodule.errorfuncGo(plr,"Failed to over-write other data: "..tostring(err))
			return
		end

	end

	if toggle then
		Events.RESETGUI:FireClient(plr)
		slotNames(plr)
		Events.SlotEvents.playerDataSaved:Fire(plr,plot)
		DataStore = nil
	end
end

local function Load(plr,slot)
	bindFrame = plr.PlayerGui.BuildUI:WaitForChild('BindFrame')
	local slPI

	pcall(function()
		slPI = plr.PlayerGui.BuildUI.SaveLoadPI
		slPI.Text = "Getting player data..."
	end)

	DataStore = DSS:GetDataStore("SaveCashV"..slot)

	plr:SetAttribute("Slot",slot)

	pcall(function()
		slPI.Text = "Loading player data..."
	end)

	wait()

	local folder = Instance.new('Folder',plr)
	folder.Name = 'hidden'

	local towarfolder = Instance.new("Folder")
	towarfolder.Name = "TowarFolder"
	towarfolder.Parent = plr

	local telefony = Instance.new("IntValue")
	telefony.Name = "telefony"
	telefony.Parent = towarfolder

	local aparaty = Instance.new("IntValue")
	aparaty.Name = "aparaty"
	aparaty.Parent = towarfolder

	local tablety = Instance.new("IntValue")
	tablety.Name = "tablety"
	tablety.Parent = towarfolder

	local telewizory = Instance.new("IntValue")
	telewizory.Name = "telewizory"
	telewizory.Parent = towarfolder

	local konsole = Instance.new("IntValue")
	konsole.Name = "konsole"
	konsole.Parent = towarfolder

	local komputery = Instance.new("IntValue")
	komputery.Name = "komputery"
	komputery.Parent = towarfolder

	local monitory = Instance.new("IntValue")
	monitory.Name = "monitory"
	monitory.Parent = towarfolder

	local klawiatury = Instance.new("IntValue")
	klawiatury.Name = "klawiatury"
	klawiatury.Parent = towarfolder

	local myszki = Instance.new("IntValue")
	myszki.Name = "myszki"
	myszki.Parent = towarfolder

	local glosniki = Instance.new("IntValue")
	glosniki.Name = "glosniki"
	glosniki.Parent = towarfolder

	local sluchawki = Instance.new("IntValue")
	sluchawki.Name = "sluchawki"
	sluchawki.Parent = towarfolder

	-----------------------------------------------------

	local CenaFolder = Instance.new("Folder")
	CenaFolder.Name = "CenaFolder"
	CenaFolder.Parent = plr

	local ctelefony = Instance.new("IntValue")
	ctelefony.Name = "telefony"
	ctelefony.Parent = CenaFolder
	ctelefony.Value = 115

	local caparaty = Instance.new("IntValue")
	caparaty.Name = "aparaty"
	caparaty.Parent = CenaFolder
	caparaty.Value = 285

	local ctablety = Instance.new("IntValue")
	ctablety.Name = "tablety"
	ctablety.Parent = CenaFolder
	ctablety.Value = 170

	local ctelewizory = Instance.new("IntValue")
	ctelewizory.Name = "telewizory"
	ctelewizory.Parent = CenaFolder
	ctelewizory.Value = 1725

	local ckonsole = Instance.new("IntValue")
	ckonsole.Name = "konsole"
	ckonsole.Parent = CenaFolder
	ckonsole.Value = 800

	local ckomputery = Instance.new("IntValue")
	ckomputery.Name = "komputery"
	ckomputery.Parent = CenaFolder
	ckomputery.Value = 1140

	local cmonitory = Instance.new("IntValue")
	cmonitory.Name = "monitory"
	cmonitory.Parent = CenaFolder
	cmonitory.Value = 685

	local cklawiatury = Instance.new("IntValue")
	cklawiatury.Name = "klawiatury"
	cklawiatury.Parent = CenaFolder
	cklawiatury.Value = 85

	local cmyszki = Instance.new("IntValue")
	cmyszki.Name = "myszki"
	cmyszki.Parent = CenaFolder
	cmyszki.Value = 35

	local cglosniki = Instance.new("IntValue")
	cglosniki.Name = "glosniki"
	cglosniki.Parent = CenaFolder
	cglosniki.Value = 175

	local csluchawki = Instance.new("IntValue")
	csluchawki.Name = "sluchawki"
	csluchawki.Parent = CenaFolder
	csluchawki.Value = 105

	local setfolder = Instance.new("Folder")
	setfolder.Name = "SetFolder"
	setfolder.Parent = plr
	
	local plotTop = Instance.new("NumberValue")
	plotTop.Name = "plotTop"
	plotTop.Parent = setfolder
	plotTop.Value = 1
	
	local plotBottom = Instance.new("NumberValue")
	plotBottom.Name = "plotBottom"
	plotBottom.Parent = setfolder
	plotBottom.Value = 0.178

	local grid = Instance.new("IntValue")
	grid.Name = "whatgrid"
	grid.Parent = setfolder
	grid.Value = 1

	local parking = Instance.new("IntValue")
	parking.Name = "parking"
	parking.Parent = setfolder
	parking.Value= 0

	local sign = Instance.new("IntValue")
	sign.Name = "sign"
	sign.Parent = setfolder
	sign.Value= 0

	local volume = Instance.new("IntValue")
	volume.Name = "VolumeLvl"
	volume.Parent = setfolder
	volume.Value= 50

	local nameshope = Instance.new("StringValue")
	nameshope.Name = "NameShop"
	nameshope.Parent = setfolder
	nameshope.Value = ""

	local plotmaterial = Instance.new("StringValue")
	plotmaterial.Name = "PlotMaterial"
	plotmaterial.Parent = setfolder
	plotmaterial.Value = "Plastic"

	local plotcolorr = Instance.new("IntValue",setfolder)
	plotcolorr.Name = "PlotColorR"
	plotcolorr.Value = 64706

	local plotcolorg = Instance.new("IntValue",setfolder)
	plotcolorg.Name = "PlotColorG"
	plotcolorg.Value = 63529

	local plotcolorb = Instance.new("IntValue",setfolder)
	plotcolorb.Name = "PlotColorB"
	plotcolorb.Value = 64706
	--[[local colorname = Instance.new("StringValue")
	colorname.Name = "ColorName"
	colorname.Parent = setfolder
	colorname.Value = "Medium stone grey"]]
	
	local localAnims = Instance.new("BoolValue",setfolder)
	localAnims.Name = "localAnims"
	localAnims.Value = false

	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = plr

	local rating = Instance.new("Folder")
	rating.Name = "rating"
	rating.Parent = plr

	--wait()

	local RatingNow = Instance.new('IntValue',rating)
	RatingNow.Name = 'RatingNow'
	RatingNow.Value = 0

	local RatingMax = Instance.new('IntValue',rating)
	RatingMax.Name = 'RatingMax'
	RatingMax.Value = 50

	local IleL = Instance.new('IntValue',folder)
	IleL.Name = 'IleL'

	local IleR = Instance.new('IntValue',folder)
	IleR.Name = 'IleR'

	local IleC = Instance.new('IntValue',folder)
	IleC.Name = 'IleC'

	IleL.Value = 0
	IleR.Value = 0
	IleC.Value = 1

	local towarvalue = Instance.new('IntValue', folder)
	towarvalue.Name = "TowarValue"

	local zapasowytowar = Instance.new('IntValue', folder)
	zapasowytowar.Name = "ZapasowyTowar"

	local Rating = Instance.new('NumberValue',leaderstats)
	Rating.Name = 'Rating'
	Rating.Value = 0

	local currency = Instance.new("IntValue", leaderstats)

	currency.Name = "Cash"
	currency.Value = 15000
	currency.Parent=leaderstats

	local CzyTutorialDone = Instance.new("BoolValue",plr)
	CzyTutorialDone.Name = "CzyTutorialDone"
	CzyTutorialDone.Value = false

	local specialfolder = Instance.new("Folder",plr)
	specialfolder.Name = "ValueFolder"

	local CanYou = Instance.new("BoolValue",specialfolder)
	CanYou.Name = "CanYou"
	CanYou.Value = true

	local MaxValue = Instance.new("IntValue",specialfolder)
	MaxValue.Name = "MaxCapacity"

	local KtoryPlot = Instance.new("StringValue",specialfolder)
	KtoryPlot.Name = "KtoryPlot"
	KtoryPlot.Value = ""

	local AchiveFolder = Instance.new("Folder",plr)
	AchiveFolder.Name = "AchiveFolder"


	local CashLvl = Instance.new("IntValue",AchiveFolder)
	CashLvl.Name = "CashLvl"
	CashLvl.Value = 0	

	local RatLvl = Instance.new("IntValue",AchiveFolder)
	RatLvl.Name = "RatLvl"
	RatLvl.Value = 0	

	local ExLvl = Instance.new("IntValue",AchiveFolder)
	ExLvl.Name = "ExLvl"
	ExLvl.Value = 0	

	local ProgressFolder = Instance.new("Folder",plr)
	ProgressFolder.Name = "ProgressFolder"

	local CashProgress = Instance.new("IntValue",ProgressFolder)
	CashProgress.Name = "CashProgress"
	CashProgress.Value = 0	

	local RatProgress = Instance.new("NumberValue",ProgressFolder)
	RatProgress.Name = "RatProgress"
	RatProgress.Value = 0	

	local ExProgress = Instance.new("NumberValue",ProgressFolder)
	ExProgress.Name = "ExProgress"
	ExProgress.Value = 0	

	local RBFolder = Instance.new('Folder',plr)
	RBFolder.Name = "RBFolder"

	local boostPerc = Instance.new('IntValue',RBFolder)
	boostPerc.Name = "boostPerc"
	boostPerc.Value = 0

	local boostTime = Instance.new('NumberValue',RBFolder)
	boostTime.Name = "boostTimeLeft"
	boostTime.Value = 0

	--HR--

	local HRFolder = Instance.new('Folder',plr)
	HRFolder.Name = "HRFolder"

	local storagemenValue = Instance.new('IntValue',HRFolder)
	storagemenValue.Name = "storagemenValue"
	storagemenValue.Value = 0

	local cashiersValue = Instance.new('IntValue',HRFolder)
	cashiersValue.Name = "cashiersValue"
	cashiersValue.Value = 0

	local key = "uid_" .. plr.userId

	local savedData
	local succes, err = pcall(function()
		savedData = DataStore:GetAsync(key)
		return savedData
	end)

	if not succes then
		errormodule.errorfuncGo(plr,"Failed to read data: "..tostring(err))
		return
	end

	local savedAchive
	local succeses, erro = pcall(function()
		savedAchive = AchiveStore:GetAsync(key)
		return savedAchive
	end)

	local fixedData
	local succeseses, erroo = pcall(function()
		fixedData = OthersStore:GetAsync(key)
		return fixedData
	end)

	if not succeses then
		errormodule.errorfuncGo(plr,"Failed to read data: "..tostring(erro))
		return
	end
	if not succeseses then
		errormodule.errorfuncGo(plr,"Failed to read data: "..tostring(erroo))
		return
	end

	task.wait()

	if savedData then
		if savedData.Cash then
			currency.Value = savedData.Cash
		end
		
		if savedData.telefony then
			telefony.Value = savedData.telefony
		end
		
		if savedData.aparaty then
			aparaty.Value = savedData.aparaty
		end
		
		if savedData.tablety then
			tablety.Value = savedData.tablety
		end	
		
		if savedData.telewizory then
			telewizory.Value = savedData.telewizory
		end
		
		if savedData.konsole then
			konsole.Value = savedData.konsole
		end
		
		if savedData.komputery then
			komputery.Value = savedData.komputery
		end
		
		if savedData.monitory then
			monitory.Value = savedData.monitory
		end
		
		if savedData.klawiatury then
			klawiatury.Value = savedData.klawiatury
		end
		
		if savedData.myszki then
			myszki.Value = savedData.myszki
		end
		
		if savedData.glosniki then
			glosniki.Value = savedData.glosniki
		end
		
		if savedData.sluchawki then
			sluchawki.Value = savedData.sluchawki
		end
		-----------------------------------------------------------------
		if savedData.ctelefony then
			ctelefony.Value = savedData.ctelefony
		end
		
		if savedData.caparaty then
			caparaty.Value = savedData.caparaty
		end
		
		if savedData.ctablety then
			ctablety.Value = savedData.ctablety
		end

		if savedData.ctelewizory then
			ctelewizory.Value = savedData.ctelewizory
		end
		
		if savedData.ckonsole then
			ckonsole.Value = savedData.ckonsole
		end
		
		if savedData.ckomputery then
			ckomputery.Value = savedData.ckomputery
		end
		
		if savedData.cmonitory then
			cmonitory.Value = savedData.cmonitory
		end
		
		if savedData.cklawiatury then
			cklawiatury.Value = savedData.cklawiatury
		end
		
		if savedData.cmyszki then
			cmyszki.Value = savedData.cmyszki
		end
		
		if savedData.cglosniki then
			cglosniki.Value = savedData.cglosniki
		end
		
		if savedData.csluchawki then
			csluchawki.Value = savedData.csluchawki
		end

		if savedData.MaxCapacity then
			MaxValue.Value = savedData.MaxCapacity
		end
		
		if savedData.grid then
			grid.Value = savedData.grid
		end
		
		if savedData.plotmaterial then
			plotmaterial.Value = savedData.plotmaterial
		end
		
		if savedData.colorR and savedData.colorG and savedData.colorB then-- and savedData.ColorName then
			plotcolorr.Value = savedData.colorR
			plotcolorg.Value = savedData.colorG
			plotcolorb.Value = savedData.colorB
			--	colorname.Value = savedData.ColorName
		end	
		
		if savedData.plotTop and savedData.plotBottom then
			plotTop.Value = savedData.plotTop
			plotBottom.Value = savedData.plotBottom
		end
		
		if savedData.nameshop then
			nameshope.Value = savedData.nameshop		
		end
		if savedData.parking then
			parking.Value = savedData.parking		
		end
		if savedData.IleL then
			IleL.Value = savedData.IleL	
		end
		if savedData.IleR then
			IleR.Value = savedData.IleR	
		end
		if savedData.IleC then
			IleC.Value = savedData.IleC	
		end

		if savedData.sign then
			sign.Value = savedData.sign		
		end
		if savedData.ratingnow then
			RatingNow.Value = savedData.ratingnow		
		end
		if savedData.rating then
			Rating.Value = savedData.rating
			--Rating.Value = 0		
		end
		if savedData.ktoryplot then
			KtoryPlot.Value = savedData.ktoryplot		
		end

		if savedData.storagemenValue then
			storagemenValue.Value = savedData.storagemenValue		
		end
		if savedData.cashiersValue then
			cashiersValue.Value = savedData.cashiersValue		
		end
	else
		if CzyTutorialDone.Value == false then
			wait(0.2)
			Events:WaitForChild("TutorialStatus"):FireClient(plr)
			CzyTutorialDone.Value = true
		end

		--Save(plr)	
	end
	
	task.wait()

	------------------

	if savedAchive then
		if savedAchive.czytutorialdone then
			CzyTutorialDone.Value = savedAchive.czytutorialdone
		end
		if savedAchive.CashLvl then
			CashLvl.Value = savedAchive.CashLvl
			if plr.Name == "SuperPPVip" then
				CashLvl.Value = 0
			end
		end
		if savedAchive.RatLvl then
			RatLvl.Value = savedAchive.RatLvl
			--RatLvl.Value = 0
		end
		if savedAchive.ExLvl then
			ExLvl.Value = savedAchive.ExLvl
			--ExLvl.Value = 0
		end
		if savedAchive.CashProg then
			CashProgress.Value = savedAchive.CashProg
			if plr.Name == "SuperPPVip" then
				CashProgress.Value = 0
			end
		end
		if savedAchive.RatProg then
			RatProgress.Value = savedAchive.RatProg
			--RatProgress.Value = 0
		end
		if savedAchive.ExProg then
			ExProgress.Value = savedAchive.ExProg
			--ExProgress.Value = 0
		end
	end

	local customs = plr.PlayerGui.BuildUI.PaintFrame.Customs
	local customs2 = plr.PlayerGui.BuildUI.PaintPlotFrame.Customs
	
	task.wait()

	
	if fixedData then

		if fixedData.MainStep and fixedData.CashStep then
			plr.PlayerGui:WaitForChild("BuildUI"):WaitForChild("AddTowarFrame"):WaitForChild("MainStep"):SetAttribute("Step",fixedData.MainStep)
			plr.PlayerGui.BuildUI.AddTowarFrame.MainStep.IleStep.Text = fixedData.MainStep
			plr.PlayerGui:WaitForChild("BuildUI"):WaitForChild("AddTowarFrame"):WaitForChild("CashStep"):SetAttribute("Step",fixedData.CashStep)
			plr.PlayerGui.BuildUI.AddTowarFrame.CashStep.IleStep.Text = fixedData.CashStep
		end

		--RBFolder section
		if fixedData.boostPerc then
			boostPerc.Value = fixedData.boostPerc
		end
		if fixedData.boostTimeLeft then
			boostTime.Value = fixedData.boostTimeLeft
		end

		--

		if fixedData.volume then
			volume.Value = fixedData.volume
		end
		
		if fixedData.localAnims then
			localAnims.Value = fixedData.localAnims
		end

		local off,on = UDim2.new(-0.176, 0,-0.212, 0),UDim2.new(0.559, 0,-0.212, 0)

		for i,n in pairs(fixedData) do
			local bind = bindFrame:FindFirstChild(tostring(i))

			if bind then
				if bind.Name == "SwitchCTRL" then
					if n then
						bind.Switch:TweenPosition(on,nil,nil,0.3)
						bind.BackgroundColor3 = Color3.new(0, 0.666667, 0)
						bind:SetAttribute('isOn',true)
						bind.Parent.LOWERCAMERA.Transparency = 0.6
						bind.Parent.LOWERCAMERA.Button.Transparency = 0.6
						bind.Parent.LOWERCAMERA:SetAttribute('activated',false)
						bind.Parent.RAISECAMERA.Transparency = 0.6
						bind.Parent.RAISECAMERA.Button.Transparency = 0.6
						bind.Parent.RAISECAMERA:SetAttribute('activated',false)
					elseif not n then
						bind.Switch:TweenPosition(off,nil,nil,0.3)
						bind.BackgroundColor3 = Color3.new(0.92549, 0, 0)
						bind:SetAttribute('isOn',false)
						bind.Parent.LOWERCAMERA.Transparency = 0
						bind.Parent.LOWERCAMERA.Button.Transparency = 0
						bind.Parent.LOWERCAMERA:SetAttribute('activated',true)
						bind.Parent.RAISECAMERA.Transparency = 0
						bind.Parent.RAISECAMERA.Button.Transparency = 0
						bind.Parent.RAISECAMERA:SetAttribute('activated',true)
					end
				elseif bind.Name == "SwitchSHIFT" then
					if n then
						bind.Switch:TweenPosition(on,nil,nil,0.3)
						bind.BackgroundColor3 = Color3.new(0, 0.666667, 0)
						bind:SetAttribute('isOn',true)
						bind.Parent.ROTATEDOWN.Transparency = 0.6
						bind.Parent.ROTATEDOWN.Button.Transparency = 0.6
						bind.Parent.ROTATEDOWN:SetAttribute('activated',false)
						bind.Parent.ROTATEUP.Transparency = 0.6
						bind.Parent.ROTATEUP.Button.Transparency = 0.6
						bind.Parent.ROTATEUP:SetAttribute('activated',false)
					elseif not n then
						bind.Switch:TweenPosition(off,nil,nil,0.3)
						bind.BackgroundColor3 = Color3.new(0.92549, 0, 0)
						bind:SetAttribute('isOn',false)
						bind.Parent.ROTATEDOWN.Transparency = 0
						bind.Parent.ROTATEDOWN.Button.Transparency = 0
						bind.Parent.ROTATEDOWN:SetAttribute('activated',true)
						bind.Parent.ROTATEUP.Transparency = 0
						bind.Parent.ROTATEUP.Button.Transparency = 0
						bind.Parent.ROTATEUP:SetAttribute('activated',true)
					end
				else
					bind:SetAttribute('Bind',n)
					bind.Button.Text = n
				end
			end
		end
		for i,n in pairs(fixedData) do
			if string.match(i,"Custom") then
				local values
				local jorbabka
				jorbabka, err = pcall(function()
					values = n:split("_")
				end) 
				if values[1] and values[2] then
					customs:FindFirstChild(i):SetAttribute("Top",values[1])
					customs:FindFirstChild(i):SetAttribute("Bottom",values[2])
					customs2:FindFirstChild(i):SetAttribute("Top",values[1])
					customs2:FindFirstChild(i):SetAttribute("Bottom",values[2])
				else
					customs:FindFirstChild(i):SetAttribute("Top",0)
					customs:FindFirstChild(i):SetAttribute("Bottom",0)
					customs2:FindFirstChild(i):SetAttribute("Top",0)
					customs2:FindFirstChild(i):SetAttribute("Bottom",0)
				end
			end
		end
	end

	if CzyTutorialDone.Value == false then
		wait(0.05)
		Events:WaitForChild("TutorialStatus"):FireClient(plr)
		CzyTutorialDone.Value = true
	end

	plr:SetAttribute("DoesTutorial",false)
	plr:SetAttribute("isBind",false)
	plr:SetAttribute("counterAbort",false)

	pcall(function()
		slPI.Text = "Player data loaded"
		wait(0.25)
		slPI.Text = "Starting game systems"
	end)

	task.wait(0.15)
	Events.ExpansionEvents.ODPALEXPANSION:FireClient(plr,false,slot)
	task.wait()
	Events.MagazynEvents.WczytajMaxCap:FireClient(plr, MaxValue.Value)
	task.wait()
	Events.MagazynEvents.WczytajMaxCap2:FireClient(plr, MaxValue.Value)
	task.wait()
	Events.MagazynEvents.ExpandMagazinData:FireClient(plr, MaxValue.Value)
	task.wait()
	Events.MagazynEvents.WczytajTowar:FireClient(plr, towarvalue.Value)
	task.wait()
	Events.MagazynEvents.WczytajCeny:FireClient(plr)
	task.wait()
	Events.VALUEvents.ReadValue:FireClient(plr)
	task.wait()
	Events.TowarEvents.Zlicz:FireClient(plr)
	task.wait()
	Events.TowarEvents.LoadStep:FireClient(plr)
	task.wait()
	Events.CashLabel:FireClient(plr)
	task.wait()
	Events.SettingsFolder.UstawSuwak:FireClient(plr)
	task.wait()
	Events.SettingsFolder.ParkingWczytaj:FireClient(plr)
	task.wait()
	Events.SettingsFolder.SignWczytaj:FireClient(plr)
	task.wait()
	Events.WBListActivate:FireAllClients()
	task.wait()
	Events.AchivsEvents.DobraWczytaj:FireClient(plr)
	task.wait()
	Events.ColorPickerEvents.SetCustoms:FireClient(plr)
	task.wait()
	Events.RBEvents.resumeCounter:Fire(plr)
	task.wait()
	game.ReplicatedStorage.Clock:FireClient(plr)
	task.wait()
	Events.Other.makeDailyReward:FireClient(plr)
	task.wait()
	game.ReplicatedStorage.Events.Other.setRatingEvent:FireClient(plr)
	task.wait()
	game.ReplicatedStorage.Events.AnimationEvents.setAnimSettings:FireClient(plr)
	task.wait()
	game.ReplicatedStorage.Events.MagazynEvents.activateMagazineInfo:FireClient(plr)
	plr:SetAttribute("CanSave",true)
	
	game.ReplicatedStorage.Events.BadgesEvents.awardBadge:Fire(plr,2144496194)
	
	return savedData

end

local function Reset(plr,slot)
	DataStore = DSS:GetDataStore("SaveCashV"..slot)

	local savedData
	local key = "uid_" .. plr.userId
	local succes, err = pcall(function()
		savedData = DataStore:GetAsync(key)
		return savedData
	end)
	local null = {}
	local succes, err = pcall(function()
		DataStore:SetAsync(tostring(key), null)
	end)
end



function slotNames(plr,db)
	plr:SetAttribute("CanSave",false)
	for i=1,4 do
		local key = "uid_" .. plr.userId
		local data = DSS:GetDataStore("SaveCashV"..i)
		local savedData
		local succes, err = pcall(function()
			savedData = data:GetAsync(key)
			return savedData
		end)

		if not succes then
			errormodule.errorfuncGo(plr,"Failed to GetAsync.")
		end

		local success, err
		success, err = pcall(function()
			local name = savedData.nameshop
		end)
		if not success then
			Events.SlotEvents.NazwaSlota:FireClient(plr," ",i)
		else
			local name = savedData.nameshop
			Events.SlotEvents.NazwaSlota:FireClient(plr,name,i)
		end
	end
end

Events.SlotEvents.ResetModel.OnServerEvent:Connect(Reset)
Events.SlotEvents.startLoading.OnServerEvent:Connect(Load)

players.PlayerRemoving:Connect(function(plr)
	local id = plr.UserId
	table.insert(removingPlayers,plr)
	Save(plr)
	task.wait(4)
	table.remove(removingPlayers,table.find(removingPlayers,plr))
	backupTable[id] = nil
	dataTable[id] = nil
end)

players.PlayerAdded:Connect(slotNames)

Events.SaveHandler.OnServerEvent:Connect(Save)

game:BindToClose(function()
	for i, plr in pairs(players:GetChildren()) do
		Save(plr)
	end
end)

Events.BindEvents.sendBindData.OnServerEvent:Connect(function(plr,data)
	bindTable = data
end)

------------SERVER AUTO DATA READER/SAVER HANDLER-------------
local backupToggle
local myI = 0

while task.wait(0.75) do
	for i,n in pairs(game.Players:GetChildren()) do
		if n:FindFirstChild("leaderstats") and n:FindFirstChild("leaderstats"):FindFirstChild("Cash") and not table.find(removingPlayers,n) then
			local saveData
			local succ,err = pcall(function()
				saveData = {	
					["PlayerName"] = n.Name;
					["Cash"] = n.leaderstats.Cash.Value;
					["telefony"] = n.TowarFolder.telefony.Value;
					["aparaty"] = n.TowarFolder.aparaty.Value;
					["tablety"] = n.TowarFolder.tablety.Value;

					["telewizory"] = n.TowarFolder.telewizory.Value;
					["konsole"] = n.TowarFolder.konsole.Value;
					["komputery"] = n.TowarFolder.komputery.Value;
					["monitory"] = n.TowarFolder.monitory.Value;

					["klawiatury"] = n.TowarFolder.klawiatury.Value;
					["myszki"] = n.TowarFolder.myszki.Value;
					["glosniki"] = n.TowarFolder.glosniki.Value;
					["sluchawki"] = n.TowarFolder.sluchawki.Value;
					---------------------------------------------------------------
					["ctelefony"] = n.CenaFolder.telefony.Value;
					["caparaty"] = n.CenaFolder.aparaty.Value;
					["ctablety"] = n.CenaFolder.tablety.Value;

					["ctelewizory"] = n.CenaFolder.telewizory.Value;
					["ckonsole"] = n.CenaFolder.konsole.Value;
					["ckomputery"] = n.CenaFolder.komputery.Value;
					["cmonitory"] = n.CenaFolder.monitory.Value;

					["cklawiatury"] = n.CenaFolder.klawiatury.Value;
					["cmyszki"] = n.CenaFolder.myszki.Value;
					["cglosniki"] = n.CenaFolder.glosniki.Value;
					["csluchawki"] = n.CenaFolder.sluchawki.Value;

					["MaxCapacity"] = n.ValueFolder.MaxCapacity.Value;
					["nameshop"] = n.SetFolder.NameShop.Value;
					["plotmaterial"] = n.SetFolder.PlotMaterial.Value;
					["colorR"] = n.SetFolder.PlotColorR.Value;
					["colorG"] = n.SetFolder.PlotColorG.Value;
					["colorB"] = n.SetFolder.PlotColorB.Value;
					
					["plotTop"] = n.SetFolder.plotTop.Value;
					["plotBottom"] = n.SetFolder.plotBottom.Value;
					--	["ColorName"] = n.SetFolder.ColorName.Value;
					["parking"] = n.SetFolder.parking.Value;
					["sign"] = n.SetFolder.sign.Value;

					["IleL"] = n.hidden.IleL.Value;
					["IleC"] = n.hidden.IleC.Value;
					["IleR"] = n.hidden.IleR.Value;	

					["ratingnow"] = n.rating.RatingNow.Value;
					["rating"] = n.leaderstats.Rating.Value;

					["ktoryplot"] = n.ValueFolder.KtoryPlot.Value;

					["czytutorialdone"] = n.CzyTutorialDone.Value;
					["CashLvl"] = n.AchiveFolder.CashLvl.Value;
					["RatLvl"] = n.AchiveFolder.RatLvl.Value;
					["ExLvl"] = n.AchiveFolder.ExLvl.Value;
					["CashProg"] = n.ProgressFolder.CashProgress.Value;
					["RatProg"] = n.ProgressFolder.RatProgress.Value;
					["ExProg"] = n.ProgressFolder.ExProgress.Value;

					["grid"] = n.SetFolder.whatgrid.Value;
					["volume"] = n.SetFolder.VolumeLvl.Value;
					["MainStep"] = n.PlayerGui.BuildUI.AddTowarFrame.MainStep:GetAttribute("Step");
					["CashStep"] = n.PlayerGui.BuildUI.AddTowarFrame.CashStep:GetAttribute("Step");

					["boostPerc"] = n.RBFolder.boostPerc.Value;
					["boostTimeLeft"] = n.RBFolder.boostTimeLeft.Value;

					["storagemenValue"] = n.HRFolder.storagemenValue.Value;	
					["cashiersValue"] = n.HRFolder.cashiersValue.Value;
					
					["localAnims"] = n.SetFolder.localAnims.Value;
					["slot"] = n:GetAttribute("Slot");
				}

				for i,n in pairs(bindTable) do
					saveData[tostring(i)] = n
				end

				for i,n in pairs(n.PlayerGui.BuildUI.PaintFrame.Customs:GetChildren()) do
					saveData[n.Name] = n:GetAttribute("Top").."_"..n:GetAttribute("Bottom")
				end
				myI += 1

				if myI == 4 then
					if saveData then
						backupTable[n.UserId] = dataTable
						myI = 0
					end
				end
				dataTable[n.UserId] = saveData
			end)
			if not succ then
				warn("Error occured while trying to cache data:",err)
			end
		end
	end
end