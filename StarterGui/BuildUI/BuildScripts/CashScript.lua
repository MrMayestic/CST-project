local plr = game.Players.LocalPlayer
local FormatNumber = require(game.ReplicatedStorage.Modules.FormatNumber)
local formatter = FormatNumber.NumberFormatter.with()

local TweenService = game:GetService("TweenService")

local goal = {}

--goal.Value = 10000--however much money you want

local TweenInfo = TweenInfo.new(0.6)

local tween --= TweenService:Create(lastValue, TweenInfo, goal)

local function zmiana(newVal)
	goal.Value = newVal
	tween = TweenService:Create(script.Parent.CashValue, TweenInfo, goal)
	tween:Play()
end

function zmieniacz()
	script.Parent.CashValue.Value = plr.leaderstats.Cash.Value
	script.Parent.Cash.Text = formatter:Format(plr.leaderstats.Cash.Value)

	plr.leaderstats.Cash.Changed:Connect(zmiana)
	while task.wait(0.012) do
		script.Parent.Cash.Text = formatter:Format(script.Parent.CashValue.Value)
	end
end

game.ReplicatedStorage.Events.CashLabel.OnClientEvent:Connect(zmieniacz)