local rp = game:GetService("ReplicatedStorage")
local ss = game:GetService("ServerStorage")

local ClassHandler = {}

local Remotes = rp.Handlers.Class.Remotes

local EntityHandler = require(ss.Handlers.Entity)

local base_class = require(rp.Classes._class.Server)

export type Class = base_class.ServerClass

function ClassHandler:GetClass(plr: Player) : Class
    return self.PlayerClasses[plr]
end

function ClassHandler:Load(plr: Player, name: string, skin: string?)
    if self._classes[name] == nil then
        warn("Unknown class: " .. name)
        return
    end
    
    if self.PlayerClasses[plr] ~= nil then
        self:Unload(plr)
    end

    local class = self._classes[name].new(plr, skin or "Default")
    
    self.PlayerClasses[plr] = class

    class:Load()

    Remotes.Change:FireClient(plr, name, skin)
    EntityHandler:Register(plr.Character, name)

    return class
end

function ClassHandler:Unload(plr: Player)
    if self.PlayerClasses[plr] == nil then
        return
    end

    self.PlayerClasses[plr]:Destroy()
    self.PlayerClasses[plr] = nil
end

function ClassHandler:Init()
    self._classes = {}
    self.PlayerClasses = {}

    for _, v in rp.Classes:GetChildren() do
        self._classes[v.Name] = require(v)
    end

    game.Players.PlayerRemoving:Connect(function(player)
        self:Unload(player)
    end)
end

return ClassHandler