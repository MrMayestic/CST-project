local logService = game:GetService("LogService")
local UIS = game:GetService("UserInputService")

logService.MessageOut:Connect(function(message,messageType)
	if messageType == Enum.MessageType.MessageError then
		game.ReplicatedStorage.sendError:FireServer(message,UIS.TouchEnabled)
	end
end)