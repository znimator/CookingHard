local rp = game:GetService("ReplicatedStorage")
local ss = game:GetService("ServerStorage")

local EntityHandler = require(ss.Handlers.Entity)
local fxHandler = require(ss.Handlers.FX)

local burn_effect_server = {}
burn_effect_server.__index = burn_effect_server

local base = require(rp.StatusEffects._effect.Server)
setmetatable(burn_effect_server, base)

local default_config = {
    Damage = 1;
}

function burn_effect_server.new(target: EntityHandler.Entity, cfg: {[any]: any}?)
    local self = setmetatable(base.new(target, cfg), burn_effect_server)

    setmetatable(self.Config, {__index = default_config})

    print(self.Config)

    self.Particle = rp.Assets.Particles.Burn:Clone()
    self.Janitor:Add(self.Particle)

    return self
end

function burn_effect_server:Apply()
    self.Particle.Parent = self.Target.Model.PrimaryPart
	fxHandler:FXAll("PlaySound", {Sound = rp.Assets.Sounds.Flame, Position = self.Target.Model:GetPivot().Position})
end

function burn_effect_server:Update(deltaTime)
    if os.clock() - self.LastUpdate > 0.5 then
		self.LastUpdate = os.clock()

        print("Updating")

		fxHandler:FXAll("Hit", {Model = self.Target.Model, Color = Color3.fromRGB(255, 149, 0)})
		fxHandler:FXAll("PlaySound", {Sound = rp.Assets.Sounds.hitmarker, Position = self.Target.Model:GetPivot().Position})
		fxHandler:FXAll("DamageIndicator", {Color = Color3.fromRGB(255, 128, 0), Position = self.Target.Model:GetPivot().Position, Damage = self.Config.Damage})
		
        print(self.Config.Damage)

        self.Target:TakeDamage(self.Config.Damage)
	end
end

return burn_effect_server