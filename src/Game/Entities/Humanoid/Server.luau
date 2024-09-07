local rp = game:GetService("ReplicatedStorage")
local ss = game:GetService("ServerStorage")

local hurtboxHandler = require(ss.Handlers.Hurtboxes)

local signal = require(rp.Packages.goodsignal)
local janitor = require(rp.Packages.janitor)

local server_entity = {}
server_entity.__index = server_entity
local base = require(rp.Entities._entity.Server)
setmetatable(server_entity, base)

function server_entity.new(model: Model)
    local self = setmetatable(base.new(model), server_entity)

    self.Name = script.Parent.Name

    self.Properties.Health = 100;
    self.Properties.MaxHealth = 100;

    local box = hurtboxHandler:Add(model, {
        CFrame = model.PrimaryPart.CFrame * CFrame.new(0, -0.25, 0),
        Size = Vector3.new(4, 5, 1) * 1.2,
        WeldTo = model.PrimaryPart,
    })

    self.Janitor:Add(box, "Destroy")

    return self
end

return server_entity