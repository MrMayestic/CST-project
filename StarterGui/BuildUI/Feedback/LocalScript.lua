local AudioPlayer = require(game.ReplicatedStorage.Modules:WaitForChild("AudioModule"))
script.Parent.MouseButton1Click:Connect(function()
 			AudioPlayer.playAudio("Click")
	script.Disabled = true
	script.Parent.Parent.Parent:TweenPosition(UDim2.new(.5,0,1.35,0),"Out","Quad",1)
	wait(1)
	script.Parent.Parent.Parent.Parent.SettingsFrame.Other.openfb:TweenPosition(UDim2.new(.498,0,0.18,0),"Out","Quad",.2)
	script.Parent.Parent.Parent.Parent.SettingsFrame.Visible = true
	wait(.2)
	script.Disabled = false
end)