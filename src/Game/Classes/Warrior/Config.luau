local rp = game:GetService("ReplicatedStorage")

local base_config = require(rp.Classes._class.Config)

local class_config = {}
class_config.__index = class_config

setmetatable(class_config, base_config)

function class_config.new()
    local self = setmetatable(base_config.new(), class_config)

    self.Color = Color3.fromRGB(255, 136, 0)
    self.Name = script.Parent.Name

    return self
end

return class_config