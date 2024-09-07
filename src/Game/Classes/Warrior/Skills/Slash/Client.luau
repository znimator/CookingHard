local rp = game:GetService("ReplicatedStorage")
local uis = game:GetService("UserInputService")

local plr = game.Players.LocalPlayer

local Remotes = script.Parent.Remotes

local hitboxHandler = require(rp.Handlers.Hitbox)

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
    self.Janitor:Add(
        uis.InputBegan:Connect(function(input, pro)
            if pro then
                return
            end

            local char = plr.Character
            local root = char:FindFirstChild("HumanoidRootPart")

            if root == nil then
                return
            end

            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                for _ = 1, 10 do
                    hitboxHandler:Cast(Vector3.new(7, 4, 4), root.CFrame * CFrame.new(0, 0, -3.5), function(enemy)
                        print(enemy)
                    end)
                    task.wait(0.025)
                end
            end
        end), "Disconnect")
end

return client_skill
