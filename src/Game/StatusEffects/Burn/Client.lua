local rp = game:GetService("ReplicatedStorage")

local EntityHandler = require(rp.Handlers.Entity)
local fxHandler = require(rp.Handlers.FX)

local burn_effect_client = {}
burn_effect_client.__index = burn_effect_client

local base = require(rp.StatusEffects._effect.Client)
setmetatable(burn_effect_client, base)

local default_config = {
    Damage = 1;
}

function burn_effect_client.new(target: EntityHandler.Entity, cfg: {[any]: any}?)
    cfg = setmetatable(cfg or {}, {__index = default_config})

    local self = setmetatable(base.new(target, cfg), burn_effect_client)

    return self
end

function burn_effect_client:Apply()
    
end

return burn_effect_client