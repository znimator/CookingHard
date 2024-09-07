local rp = game:GetService("ReplicatedStorage")

local plr = game.Players.LocalPlayer

local ClassHandler = {}

local Remotes = script.Remotes

local EntityHandler = require(rp.Handlers.Entity)

function ClassHandler:RequestLoad(name: string, skin: string?)
    Remotes.RequestChange:FireServer(name, skin)
end

function ClassHandler:Load(name: string, skin: string?)
    if self._classes[name] == nil then
        warn("Unknown class: " .. name)
        return
    end

    if self.PlayerClass ~= nil then
        print("Unloading old class")
        self:Unload()
    end

    local class = self._classes[name].new(skin or "Default")

    self.PlayerClass = class

    class:Load()

    EntityHandler:Register(plr.Character, name)

    return class
end

function ClassHandler:Unload()
    if self.PlayerClass == nil then
        return
    end

    self.PlayerClass:Destroy()
    self.PlayerClass = nil
end

function ClassHandler:Init()
    self._classes = {}
    self.PlayerClass = nil

    for i,v in rp.Classes:GetChildren() do
        self._classes[v.Name] = require(v)
    end

    Remotes.Change.OnClientEvent:Connect(function(name: string, skin: string?)
        self:Load(name, skin)
    end)
end

return ClassHandler
