local remote = game.ReplicatedStorage.PingTest.RemoteFunction
local remote2 = game.ReplicatedStorage.PingTest.Function

remote.OnServerInvoke = function() 
	return true
end

remote2.OnInvoke = function()
	return true
end