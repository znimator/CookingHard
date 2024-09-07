local rp = game:GetService("ReplicatedStorage")

local signal = require(rp.Packages.goodsignal)
local janitor = require(rp.Packages.janitor)

local client_entity = {}
client_entity.__index = client_entity
local base = require(rp.Entities._entity.Client)
setmetatable(client_entity, base)

function client_entity.new(model: Model)
    local self = setmetatable(base.new(model), client_entity)

    self.Name = script.Parent.Name

    return self
end

return client_entity