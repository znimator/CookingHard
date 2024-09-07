local rp = game:GetService("ReplicatedStorage")

local signal = require(rp.Packages.goodsignal)
local janitor = require(rp.Packages.janitor)

local client_entity = {}
client_entity.__index = client_entity

export type ClientEntity = {

    Model: Model,
    Name: string,

    Janitor: janitor.Janitor,

    Events: {
        OnDeath: signal.Signal,
        OnDestroy: signal.Signal,
        OnDamage: signal.Signal,
    },
    Properties: {
        Health: number,
        MaxHealth: number,
        IsDead: boolean,
        IFrames: number,
    },

    Destory: (self: ClientEntity) -> (),
}

function client_entity.new(model: Model) : ClientEntity
    local self = setmetatable({}, client_entity)

    self.Model = model

    self.Name = script.Parent.Name

    self.Janitor = janitor.new()

    self.Properties = {}
    setmetatable(self.Properties, {
        __index = function(_, key)
            return model:GetAttribute(key)
        end,
        __newindex = function(_, key, value)
            model:SetAttribute(key, value)
        end
    })
    
    self.Properties.Health = 100;
    self.Properties.MaxHealth = 100;
    self.Properties.IsDead = false;
    self.Properties.IFrames = 0;

    self.Events = {}

    self.Events.OnDeath = signal.new()
    self.Events.OnDestroy = signal.new()
    self.Events.OnDamage = signal.new()

    return self
end

function client_entity:Destroy()
    self.Events.OnDestroy:Fire()

    for _, v in self.Events do
        v:DisconnectAll()
    end

    self.Janitor:Destroy()
end

return client_entity