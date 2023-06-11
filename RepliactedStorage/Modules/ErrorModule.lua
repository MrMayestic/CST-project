local errormodule = {}
local toggle = true
local text = nil
local saveToggle = true
local paymentToggle = true
local productsToggle = true

function errorfunc(plr,errortextIN)
	local errortext = nil
	errortext = plr.PlayerGui.BuildUI.ERROR
	if toggle then
		toggle = false
		text = errortextIN
		errortext.can.Value = false
		errortext.Parent = plr.PlayerGui.BuildUI
		errortext.Text = errortextIN
		--errortext.TextTransparency = 0
		errortext.TextStrokeTransparency = 0.5
		errortext.Position = UDim2.new(0.218, 0,0.52, 0)
		--errortext.Visible = true
		task.wait(2.2)
		errortext:TweenPosition(UDim2.new(0.218, 0,1.062, 0),nil,nil,0.9) 
		task.wait(1.2)
		errortext.Text = " "
		errortext.Position = UDim2.new(0.218, 0,0.52, 0)
		--errortext.can.Value = true
		toggle = true
		text = nil
	else
		task.wait(0.3)
		errorfunc(plr,errortextIN)
	end
end

function errormodule.errorfuncGo(plar ,errortextHERE)
	--print(errortextHERE,text)
	if errortextHERE == text then
		task.wait()
	else
		pcall(function() 
			errorfunc(plar, errortextHERE)
		end)
	end
end

function infoFunc(plr,toggle,text)
	local infotext = plr.PlayerGui.BuildUI.SaveInfo
	
	if text then
		infotext.Text = text
	end

	infotext.Position = UDim2.new(0.118, 0,1.006, 0)
	task.wait(0.05)
	infotext:TweenPosition(UDim2.new(0.118, 0,0.955, 0),nil,nil,0.7)

	infotext.Text = "Saving."
	task.wait(0.75)
	infotext.Text = "Saving.."
	task.wait(0.75)
	infotext.Text = "Saving..."
	task.wait(0.75)
	infotext.Text = "Saving."
	task.wait(0.75)
	infotext.Text = "Saving.."
	task.wait(0.75)
	infotext.Text = "Saving..."

	infotext:TweenPosition(UDim2.new(0.118, 0,1.006, 0),nil,nil,0.6)

	if not text then
		infotext.Text = "Saving."
		task.wait(0.75)
		infotext.Text = "Saving.."
	end
end

function paymentInfo(plr,text)
	local infotext = plr.PlayerGui.BuildUI.PaymentsInfo

	if text then
		infotext.Text = text
	end

	infotext.Position = UDim2.new(0.189, 0,1.006, 0)
	task.wait(0.05)
	infotext:TweenPosition(UDim2.new(0.189, 0,0.955, 0),nil,nil,0.7)
	task.wait(4.2)
	infotext:TweenPosition(UDim2.new(0.189, 0,1.006, 0),nil,nil,0.6)
end

function productsInfo(plr,text)
	local infotext = plr.PlayerGui.BuildUI.ProductBuyInfo

	if text then
		infotext.Text = text
	end

	infotext.Position = UDim2.new(0.258, 0,1.006, 0)
	task.wait(0.05)
	infotext:TweenPosition(UDim2.new(0.258, 0,0.955, 0),nil,nil,0.7)
	task.wait(4.2)
	infotext:TweenPosition(UDim2.new(0.258, 0,1.006, 0),nil,nil,0.6)
end

function errormodule.infoFunc(plar,togyl,text)
	if saveToggle then
		saveToggle = false
		pcall(function() 
			infoFunc(plar,togyl,text)
		end)
		task.wait(0.3)
		saveToggle = true
	end
end

function errormodule.paymentInfo(plar,text)
	if paymentToggle then
		paymentToggle = false
		pcall(function() 
			paymentInfo(plar,text)
		end)
		task.wait(0.3)
		paymentToggle = true
	end
end

function errormodule.productsInfo(plar,text)
	if productsToggle then
		productsToggle = false
		pcall(function() 
			productsInfo(plar,text)
		end)
		task.wait(0.3)
		productsToggle = true
	end
end

return errormodule
