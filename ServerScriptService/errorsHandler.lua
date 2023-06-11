--[[
	Created by MrSprinkleToes
	1/28/2019
--]]

--[[
	Set to your webhook link! Your webhook link should like something like "https://discordapp.com/api/webhooks/1234567890/winSUInwsNUSifwn-WIOWNFGOWQiom-sSW"
   	After you have your webhook link, change the very beginning from "https://discordapp.com/" to "https://discord.osyr.is/". This is required for it to work!
   	In the end, it should look something like "https://discord.osyr.is/api/webhooks/1234567890/winSUInwsNUSifwn-WIOWNFGOWQiom-sSW
--]]
local logService = game:GetService("LogService")
local scriptContext = game:GetService("ScriptContext")

errorwebhook = "https://media.guilded.gg/webhooks/6f5ba032-a284-4bcf-a7a5-bc42e9986008/LNZxKA1Z4qcGeM0kIQwuq2kGyYIMceOs4soMeEEYC0asS0MwoeIK6C2S6Gg4EOSYweGSywc0saAYKa4A4mqiiG"
-- TO FIND OUT HOW TO OBTAIN YOUR WEBHOOK LINK, FOLLOW THIS GIF: https://gyazo.com/bedca458b3bb5bd0eeb0f707432db868

local removingPlayers = {}

-- SETTINGS --
local throttleAmount = 0 -- How long to wait between each time a player sends feedback. Set to 0 for default time. (10 seconds)

-- MAIN CODE -- (Do not edit!)
game:GetService("Players").PlayerAdded:Connect(function(v)
	local waiting = game:GetService("ReplicatedStorage").waiting:Clone()
	waiting.Name = "waitingError"
	waiting.Parent = v
end)

local http = game:GetService("HttpService")

local function sendError(plr,err,uis)
	if plr.waitingError.Value == false then
		local dt = DateTime.now()
		local Data = {
			["content"] = "**CLIENT**\n*Username:* `"..plr.Name.."`".."\n*ID:* `"..plr.userId.."`\n*Error:* `"..err.."`\n\n*Time:* `"..dt:FormatUniversalTime("LTS", "zh-cn").."`\n* ServerID:* `"..game.JobId.."`\n*GameVer:* `"..game.PlaceVersion.."`* PlaceVersion:* `"..game.PlaceVersion.."`\n* Touch Enabled:* `"..tostring(uis).."`\n *isRemoving:"..tostring(removingPlayers[plr]).."\n\n_"
		}
		Data = http:JSONEncode(Data)
		http:PostAsync(errorwebhook, Data)
		plr.waitingError.Value = true
		if throttleAmount == 0 then
			wait(3)
		else
			wait(throttleAmount)
		end
		plr.waitingError.Value = false
	end
end

--game:GetService("ReplicatedStorage").sendErrorB.Event:Connect(sendError)
game:GetService("ReplicatedStorage").sendError.OnServerEvent:Connect(sendError)

local function onError(message, trace, script)
	local dt = DateTime.now()
	local Data = {
		["content"] = "**SERVER**\n*Script:* `"..script:GetFullName().."`".."\n*Reason:* `"..message.."`\n*Trace:* `"..trace.."`\n*Time:* `"..dt:FormatUniversalTime("LTS", "zh-cn").."`\n *ServerID:* `"..game.JobId.."`\n*GameVer:* `"..game.PlaceVersion.."`* PlaceVersion:* `"..game.PlaceVersion.."`\n\n_"
	}
	Data = http:JSONEncode(Data)
	http:PostAsync(errorwebhook, Data)
	if throttleAmount == 0 then
		wait(3)
	else
		wait(throttleAmount)
	end
end

scriptContext.Error:Connect(onError)

game.Players.PlayerRemoving:Connect(function(plr)
	table.insert(removingPlayers,plr)
	task.wait(5)
	table.remove(removingPlayers,table.find(removingPlayers,plr))
end)