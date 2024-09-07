local rp = game:GetService("ReplicatedStorage")

local base_config = require(rp.Classes._class.Skills._skill.Config)

local skill_config = {}
skill_config.__index = skill_config

setmetatable(skill_config, base_config)

function skill_config.new()
    local self = setmetatable(base_config.new(), skill_config)

    self.Damage = 10

    return self
end

return skill_config