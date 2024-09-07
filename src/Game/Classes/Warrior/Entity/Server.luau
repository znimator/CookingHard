local HapticService = game:GetService("HapticService")
local rp = game:GetService("ReplicatedStorage")

local signal = require(rp.Packages.goodsignal)
local janitor = require(rp.Packages.janitor)

local config = require(script.Parent.Parent.Config)

local server_entity = {}
server_entity.__index = server_entity

local base = require(rp.Classes._class.Entity.Server)
setmetatable(server_entity, base)

function server_entity.new(model: Model)
    local self = setmetatable(base.new(model), server_entity)

    self.Config = config.new()

    local hum = model:WaitForChild("Humanoid") :: Humanoid
    hum.WalkSpeed = self.Config.WalkSpeed

    self.Properties.Health = self.Config.Health
    self.Properties.MaxHealth = self.Config.Health

    return self
end

return server_entity