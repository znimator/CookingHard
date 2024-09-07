local rp = game:GetService("ReplicatedStorage")
local uis = game:GetService("UserInputService")

local plr = game.Players.LocalPlayer

local Remotes = script.Parent.Remotes

local hitboxHandler = require(rp.Handlers.Hitbox)
local fxHandler = require(rp.Handlers.FX)
local classHandler = require(rp.Handlers.Class)

local config = require(script.Parent.Config)

local client_skill = {}
client_skill.__index = client_skill

local base = require(rp.Classes._class.Skills._skill.Client)
setmetatable(client_skill, base)

function client_skill.new()
	local self = setmetatable(base.new(), client_skill)

    self.Config = config.new()

	return self
end

function client_skill:Load()

    local class = classHandler:GetClass()
    local animations = class.Animations

    local combo = 1

    self.Janitor:Add(
        uis.InputBegan:Connect(function(input, pro)
            if pro then
                return
            end

            local db = {}

            local char = plr.Character
            local root = char:FindFirstChild("HumanoidRootPart")

            if root == nil then
                return
            end

            if input.UserInputType == Enum.UserInputType.MouseButton1 then

                print(combo)

                for i,v in animations do
                    if string.sub(i, 1, 2) == "M1" then
                        animations[i]:Stop()
                    end
                end

                animations[`M1_`..combo]:Play()
                combo = (combo % 3) + 1

                for _ = 1, 10 do
                    hitboxHandler:Cast(Vector3.new(7, 4, 4), root.CFrame * CFrame.new(0, 0, -3.5), function(enemy)

                        if table.find(db, enemy) then
                            return
                        end
                        table.insert(db, enemy)

                        fxHandler:FX("Hit", {Model = enemy.Model, Color = Color3.fromRGB(255, 255, 255)})
                        fxHandler:FX("PlaySound", {Sound = rp.Assets.Sounds.hitmarker, Position = enemy.Model:GetPivot().Position})
                        fxHandler:FX("DamageIndicator", {Position = enemy.Model:GetPivot().Position, Damage = self.Config.Damage or 10})
                      
                        fxHandler:FX("CameraShake", {
                            Magnitude = 7, 
                            Roughness = 25, 
                            FadeInTime = 0, 
                            FadeOutTime = 0.1, 
                            PosInfluence = 5, 
                            RotInfluence = 1
                        })

                        fxHandler:FX("Blur")
                        fxHandler:FX("Vignette")

                        Remotes.Use:FireServer(enemy.Model)

                        print(enemy)
                    end)
                    task.wait(0.025)
                end
            end
        end), "Disconnect")
end

return client_skill
