local rp = game:GetService("ReplicatedStorage")
local ss = game:GetService("ServerStorage")
local uis = game:GetService("UserInputService")

local Remotes = script.Parent.Remotes

local EntityHandler = require(ss.Handlers.Entity)
local fxHandler = require(ss.Handlers.FX)
local classHandler = require(ss.Handlers.Class)
local statusHandler = require(ss.Handlers.StatusEffects)

local config = require(script.Parent.Config)

local server_skill = {}
server_skill.__index = server_skill

local base = require(rp.Classes._class.Skills._skill.Server)
setmetatable(server_skill, base)

function server_skill.new(plr: Player)
    local self = setmetatable(base.new(plr), server_skill)

    self.Config = config.new()

    self.Janitor:Add(Remotes.Use.OnServerEvent:Connect(function(plrFired: Player, target: Model)
        if plrFired ~= self.Player then
            plrFired:Kick("nuh uh")
            return
        end

        local entity = EntityHandler:GetEntity(target)

        if entity == nil then
            return
        end

        fxHandler:FXAllExcept(plrFired, "Hit", {Model = target, Color = Color3.fromRGB(255, 255, 255)})
        fxHandler:FXAllExcept(plrFired, "PlaySound", {Sound = rp.Assets.Sounds.hitmarker, Position = target:GetPivot().Position})
        fxHandler:FXAllExcept(plrFired, "DamageIndicator", {Position = target:GetPivot().Position, Damage = self.Config.Damage})

        print("Hit!")

        statusHandler:Apply(entity, "Burn", {Duration = 3})

        entity:TakeDamage(self.Config.Damage)

    end))

    return self
end

return server_skill