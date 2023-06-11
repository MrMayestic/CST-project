local CDSmodule = {}

local partToCopy = game.ReplicatedStorage.CDS

function CDSmodule.checkCollision(pos)
	task.wait()
	local partCDS = partToCopy:Clone()
	partCDS.Parent = game.Workspace
	partCDS.Position =	Vector3.new(pos.X,3.5,pos.Y)
	for i,n in pairs(partCDS:GetTouchingParts()) do
		if n then 
			partCDS:Destroy()
			return true
		end
	end
	partCDS:Destroy()
	return false
end

return CDSmodule