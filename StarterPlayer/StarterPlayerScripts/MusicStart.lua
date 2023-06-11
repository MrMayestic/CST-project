local SoundService = game:GetService("SoundService")

-- Number of other songs required to play before the same song can play again
local MININUM_SONGS_REQUIRED_BETWEEN_REPEATS = 3
local DEFAULT_VOLUME = 0.5

local random = Random.new()
local recentlyPlayedSoundObjects = {}
local plr = game.Players.LocalPlayer
--local soundDown = plr.PlayerGui:WaitForChild("BuildUI").SettingsFrame.TextButton
local waiter = plr:WaitForChild("SetFolder"):WaitForChild("VolumeLvl")
local slider = plr.PlayerGui:WaitForChild("BuildUI").SettingsFrame.MusicFrame.Slider
local textB = slider.TextControl
local frame = textB.Parent
local max = frame.Max
local fire = max.Fire
local bar = max.Bar
local setfolder = plr:WaitForChild("SetFolder")
local VolumeLvl = setfolder:WaitForChild("VolumeLvl")
wait(1.1)

-- Array of song asset IDs to play randomly
local songs = {
	--"rbxassetid://5030035250",
	"1846258277",
	"1842242249",
	"1846631912",
	"1837879082",
	"1845764240",
	"1837905067",
	"9044565954",
	"1844316119",

}


-- Create and store sound objects to use in-game
local soundObjects = {}
for _, songID in ipairs(songs) do
	local soundObject = Instance.new("Sound")
	soundObject.SoundId = "rbxassetid://"..songID
	soundObject.Volume = setfolder.VolumeLvl.Value/100
	soundObject.Parent = SoundService
	table.insert(soundObjects, soundObject)
	local 	as = Vector2.new(max.AbsoluteSize.X, max.AbsoluteSize.Y)
	fire.Changed:Connect(function()

		if fire.Value == true then

			local maxSize = as.X
			local size = bar.Size.X.Offset
			local num = (size / maxSize)
			local num100 = 100 * (size / maxSize)
			
			if num100>99.5 then
				num100 = 100
			end

			local ile = 0.01 * num100
			if SoundService.CustomMusic.SoundId == "" or SoundService.CustomMusic.SoundId == nil then
				soundObject.Volume = ile
			end
			textB.Text = math.floor(num100)
			game.ReplicatedStorage.Events.SettingsFolder.SetVolume:FireServer(math.floor(num100))
		end

	end)

	textB.FocusLost:Connect(function()
		
		if typeof(tonumber(textB.Text)) == "number" then

			local num = tonumber(textB.Text)

			if num >= 0 and num <= 100 then

				bar.Size = UDim2.new(0, ((num / 100) * as.X), 1, 0)

			else

				textB.Text = "Min 0, max 100"

			end

		else

			textB.Text = "Not valid"

		end

	end)


end

-- Check and warn for any predictable randomization issues given the minimum songs between repeat
if MININUM_SONGS_REQUIRED_BETWEEN_REPEATS >= #soundObjects then
	warn("MININUM_SONGS_REQUIRED_BETWEEN_REPEATS is too high and cannot be respected")
elseif MININUM_SONGS_REQUIRED_BETWEEN_REPEATS == #soundObjects - 1 then
	warn("MININUM_SONGS_REQUIRED_BETWEEN_REPEATS is high enough that only one music sequence is possible (no randomization will occur)")
end

local function shuffleInPlace(array)
	for index1 = #array, 2, -1 do
		local index2 = random:NextInteger(1, index1)
		array[index1], array[index2] = array[index2], array[index1]
	end
end

while true do
	-- Randomly shuffle the given array in place (modifies the original array)
	shuffleInPlace(soundObjects)

	-- Enforce minimum song count required between repeated songs
	for recentlyPlayedIndex = 1, #recentlyPlayedSoundObjects do
		local recentlyPlayedSound = recentlyPlayedSoundObjects[recentlyPlayedIndex]

		for futureSongIndex = 1, #recentlyPlayedSoundObjects do
			local futureSoundObject = soundObjects[futureSongIndex]

			if recentlyPlayedSound == futureSoundObject then
				local numIndexesToMoveForward = math.max(MININUM_SONGS_REQUIRED_BETWEEN_REPEATS - futureSongIndex - recentlyPlayedIndex + 2, 0)

				if numIndexesToMoveForward > 0 then
					table.remove(soundObjects, futureSongIndex)
					table.insert(soundObjects, math.min(#soundObjects + 1, futureSongIndex + numIndexesToMoveForward), futureSoundObject)
				end
			end
		end
	end

	-- Play all songs in the newly shuffled and constrained song array
	for currentSongIndex = 1, #soundObjects do
		local currentSongObject = soundObjects[currentSongIndex]

		-- Play song
		currentSongObject:Play()

		currentSongObject.Ended:Wait()
	end

	-- Update the recently played sound objects array with the most recently played songs
	recentlyPlayedSoundObjects = {}
	for i = #soundObjects, #soundObjects - MININUM_SONGS_REQUIRED_BETWEEN_REPEATS + 1, -1 do
		table.insert(recentlyPlayedSoundObjects, soundObjects[i])
	end
end



