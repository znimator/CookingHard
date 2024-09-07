local rp = game:GetService("ReplicatedStorage")
local ss = game:GetService("ServerStorage")

local hurtboxHandler = require(ss.Handlers.Hurtboxes)

local signal = require(rp.Packages.goodsignal)
local janitor = require(rp.Packages.janitor)

local server_entity = {}
server_entity.__index = server_entity

export type ServerEntity = {
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

    TakeDamage: (self: ServerEntity, dmg: number) -> (),
    Destroy: (self: ServerEntity) -> (),
}

function server_entity.new(model: Model) : ServerEntity
    local self = setmetatable({}, server_entity)

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

function server_entity:TakeDamage(dmg: number)

    if self.Properties.IsDead then
        return
    end

    if self.Properties.IFrames > 0 then
        return
    end

    self.Properties.Health = math.max(0, self.Properties.Health - dmg)

    self.Events.OnDamage:Fire(dmg)

    if self.Properties.Health <= 0 and self.Properties.IsDead == false then
        self.Properties.IsDead = true
        self.Events.OnDeath:Fire()
    end
end

function server_entity:Destroy()
    self.Events.OnDestroy:Fire()

    for _, v in self.Events do
        v:DisconnectAll()
    end

    self.Janitor:Destroy()
end

return server_entity
