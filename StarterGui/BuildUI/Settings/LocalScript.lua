local AudioPlayer = require(game.ReplicatedStorage.Modules:WaitForChild("AudioModule"))
script.Parent.MouseButton1Click:Connect(function()
 			AudioPlayer.playAudio("Click")
	script.Disabled = true
	script.Parent:TweenPosition(UDim2.new(.5,0,1.05,0),"Out","Quad",.2)
	wait(.2)
	script.Parent.Parent.Parent.Parent.bg:TweenPosition(UDim2.new(.5,0,.5,0),"Out","Quad",1)
	script.Parent.Parent.Parent.Visible = false
	wait(1)
	script.Disabled = false
end)