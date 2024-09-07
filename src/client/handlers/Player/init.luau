local PlayerHandler = {}

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local Remotes = script.Remotes

function PlayerHandler:RequestData()
    return Remotes.RequestData:InvokeServer()
end

function PlayerHandler:Init()
    
end

return PlayerHandler