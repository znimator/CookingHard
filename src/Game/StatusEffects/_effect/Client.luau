local rp = game:GetService("ReplicatedStorage")
local ss = game:GetService("ServerStorage")

local plr = game.Players.LocalPlayer

local janitor = require(rp.Packages.janitor)

local EntityHandler = require(rp.Handlers.Entity)

local _client_effect = {}
_client_effect.__index = _client_effect

local default_config = {
    Duration = 1;
}

export type ClientEffect = {
    Config: {[any]: any};

    Name: string;
    IsPlayer: boolean;
    Target: EntityHandler.Entity;
    LastUpdate: number;
    ApplyTimestamp: number?;
    Janitor: janitor.Janitor;
    Blacklist: {string};

    Apply: (self: ClientEffect) -> ();
    Update: (self: ClientEffect, deltaTime: number) -> ();
    Destroy: (self: ClientEffect) -> ();
}

function _client_effect.new(entity: EntityHandler.Entity, config: {[any]: any}?) : ClientEffect
    local self = setmetatable({}, _client_effect)

    self.Config = setmetatable(config or {}, {__index = default_config})

    self.Name = script.Parent.Name

    print(plr)

    self.IsPlayer = entity.Model == plr.Character

    self.Target = entity
    self.LastUpdate = os.clock()
    self.ApplyTimestamp = nil;

    self.Janitor = janitor.new()

    self.Blacklist = {}

    return self
end

function _client_effect:Apply()
    
end

function _client_effect:Update(deltaTime)
    
end

function _client_effect:Destroy()
    self.Janitor:Destroy()
end

return _client_effect