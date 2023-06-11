local plotManager = {}

function plotManager.assignPlot(loc, plr)
	for i, plt in pairs(loc:GetChildren()) do
		if plt.wazne.Owner.Value == "" then
			plt.wazne.Owner.Value = plr.Name
			break
		end
	end
end

function plotManager.returnPlot(loc, plr)
	task.wait()
	for i, plt in pairs(loc:GetChildren()) do
		task.wait()
		if plt.wazne.Owner.Value == plr.Name then
			task.wait()
			return plt
		end
	end
	wait(2)
	for i, plt in pairs(loc:GetChildren()) do
		task.wait()
		if plt.wazne.Owner.Value == plr.Name then
			task.wait()
			return plt
		end
	end
	wait(3)
	for i, plt in pairs(loc:GetChildren()) do
		task.wait()
		if plt.wazne.Owner.Value == plr.Name then
			task.wait()
			return plt
		end
	end
	return false
end

return plotManager