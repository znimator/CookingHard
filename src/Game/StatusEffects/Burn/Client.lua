local rp = game:GetService("ReplicatedStorage")

local EntityHandler = require(rp.Handlers.Entity)

local burn_effect_client = {}
burn_effect_client.__index = burn_effect_client

local base = require(rp.StatusEffects._effect.Client)
setmetatable(burn_effect_client, base)

local default_config = {
    Damage = 1;
}

function burn_effect_client.new(target, cfg: {[any]: any}?)
    cfg = setmetatable(cfg or {}, {__index = default_config})

    local self = setmetatable(base.new(target, cfg), burn_effect_client)

    self.Damage = cfg.Damage

    return self
end

return burn_effect_client