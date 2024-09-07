local rp = game:GetService("ReplicatedStorage")

local EntityHandler = require(rp.Handlers.Entity)

local burn_effect_server = {}
burn_effect_server.__index = burn_effect_server

local base = require(rp.StatusEffects._effect.Client)
setmetatable(burn_effect_server, base)

local default_config = {
    Damage = 1;
}

function burn_effect_server.new(target, cfg: {[any]: any}?)
    cfg = setmetatable(cfg or {}, {__index = default_config})

    local self = setmetatable(base.new(target, cfg), burn_effect_server)

    self.Damage = cfg.Damage

    return self
end

return burn_effect_server