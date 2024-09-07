local rp = game:GetService("ReplicatedStorage")

local signal = require(rp.Packages.goodsignal)
local janitor = require(rp.Packages.janitor)
local config = require(script.Parent.Parent.Config)

local client_entity = {}
client_entity.__index = client_entity
local base = require(rp.Entities.Humanoid.Client)
setmetatable(client_entity, base)

function client_entity.new(model: Model)
    local self = setmetatable(base.new(model), client_entity)

    self.Config = config.new()

    self.Name = self.Config.Name

    return self
end

return client_entity