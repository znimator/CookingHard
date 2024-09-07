local rp = game:GetService("ReplicatedStorage")
local ss = game:GetService("ServerStorage")

local janitor = require(rp.Packages.janitor)

local EntityHandler = require(ss.Handlers.Entity)

local _server_effect = {}
_server_effect.__index = _server_effect

local default_config = {
    Duration = 1;
}

export type ServerEffect = {
    Name: string,
    
    Config: {[any]: any},
    Target: EntityHandler.Entity,
    LastUpdate: number,
    Janitor: janitor.Janitor,
    Blacklist: {string},

    Apply: (self: ServerEffect) -> (),
    Update: (self: ServerEffect, deltaTime: number) -> (),
    Destroy: (self: ServerEffect) -> (),
}

function _server_effect.new(entity: EntityHandler.Entity, config: {[any]: any}?)
    local self = setmetatable({}, _server_effect)

    self.Name = script.Parent.Name

    self.Config = setmetatable(config or {}, default_config)

    self.Target = entity
    self.LastUpdate = os.clock()

    self.Janitor = janitor.new()

    self.Blacklist = {}

    return self
end

function _server_effect:Apply()
    
end

function _server_effect:Update(deltaTime)
    
end

function _server_effect:Destroy()
    self.Janitor:Destroy()
end

return _server_effect