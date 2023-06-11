local plr = game.Players.LocalPlayer

local viewX = workspace.Camera.ViewportSize.X
local viewY = workspace.Camera.ViewportSize.Y


local newSize = viewY * 0.001
local gui = script.Parent
--local waiter = gui:WaitForChild("BuildFrame"):WaitForChild("Move")
local waiter = gui:WaitForChild('SliderUD'):WaitForChild("UICorner")
local waiter2 = plr:WaitForChild('leaderstats'):WaitForChild("Cash")
--wait(1)
local Yperc = viewX/viewY
wait()
function changeChildrenProp(object)
	if object.ClassName == "UIStroke" then
		object.Thickness = newSize * object.Thickness
		wait()
	end
	if object.ClassName == "ImageLabel" then
		if object.Parent.Name == "RobuxPrice" and object.Parent.Parent.Parent.Parent.Name ~= "ExpandPlotFrame" then
			local sizeY = object.Size.Y.Scale
			local multi = object.Parent.Size.Y.Scale / object.Parent.Size.X.Scale
			local sizeX = sizeY/multi
			if object.Parent.Parent.Name == "ExpandMagazinFrame" then
				sizeX = sizeY*multi
			end
			object.Size = UDim2.new(sizeX,0,sizeY,0)
		end
	end 
end

local function handleSizes(sendObj)
	changeChildrenProp(sendObj)
	if #sendObj:GetChildren() > 0 then
		for i,n in pairs(sendObj:GetChildren()) do
			handleSizes(n)
		end
	end
end

for i,n in pairs(gui:GetChildren()) do
	handleSizes(n)
end