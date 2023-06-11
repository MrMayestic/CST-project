--[[
	Created by MrSprinkleToes
	1/28/2019
--]]

--[[
	Set to your webhook link! Your webhook link should like something like "https://discordapp.com/api/webhooks/1234567890/winSUInwsNUSifwn-WIOWNFGOWQiom-sSW"
   	After you have your webhook link, change the very beginning from "https://discordapp.com/" to "https://discord.osyr.is/". This is required for it to work!
   	In the end, it should look something like "https://discord.osyr.is/api/webhooks/1234567890/winSUInwsNUSifwn-WIOWNFGOWQiom-sSW
--]]
webhook = "https://media.guilded.gg/webhooks/c7b1152f-dc97-4766-96c5-6fba46cc5fca/twPJZjUjQcm2QeEcgOokmU8koA2c2asiI88sKAIwWgECaGwcQIU0mYKUkUkCAkSkICGOkSik2UuawUwccSOoKA"
-- TO FIND OUT HOW TO OBTAIN YOUR WEBHOOK LINK, FOLLOW THIS GIF: https://gyazo.com/bedca458b3bb5bd0eeb0f707432db868

-- SETTINGS --
local throttleAmount = 0 -- How long to wait between each time a player sends feedback. Set to 0 for default time. (10 seconds)


-- MAIN CODE -- (Do not edit!)
game:GetService("Players").PlayerAdded:Connect(function(v)
	local waiting = game:GetService("ReplicatedStorage").waiting:Clone()
	waiting.Parent = v
end)

if webhook == "" then
	error("Webhook isn't set! Make sure to set your webhook and follow all instructions in the README.")
end

local http = game:GetService("HttpService")

game:GetService("ReplicatedStorage").sendReport.OnServerEvent:Connect(function(Player, fb)
	if Player.waiting.Value == false then
		local filteredFb = game:GetService("TextService"):FilterStringAsync(fb,Player.UserId)
		local result = filteredFb:GetNonChatStringForUserAsync(Player.UserId)
		local Data = {
			["content"] = "**Feedback received!**\n\n*Username:* `"..Player.Name.."`".."\n*ID:* `"..Player.userId.."`\n *Feedback:* \n`"..result.."`"
		}
		Data = http:JSONEncode(Data)
		http:PostAsync(webhook, Data)
		Player.waiting.Value = true
		if throttleAmount == 0 then
			wait(10)
		else
			wait(throttleAmount)
		end
		Player.waiting.Value = false
	end
end)
