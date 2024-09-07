local rp = game:GetService("ReplicatedStorage")
local uis = game:GetService("UserInputService")

local Remotes = script.Parent.Remotes

local config = require(script.Parent.Config)

local server_skill = {}
server_skill.__index = server_skill

local base = require(rp.Classes._class.Skills._skill.Server)
setmetatable(server_skill, base)

function server_skill.new(plr: Player)
    local self = setmetatable(base.new(plr), server_skill)

    self.Config = config.new()

    return self
end

return server_skill