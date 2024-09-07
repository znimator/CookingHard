local rp = game:GetService("ReplicatedStorage")
local ss = game:GetService("ServerStorage")

local EntityHandler = require(ss.Handlers.Entity)

local DamageHandler = {}

function DamageHandler:Damage(entity: EntityHandler.Entity, damage: number, attacker: EntityHandler.Entity)
    entity:TakeDamage(damage)
end

return DamageHandler