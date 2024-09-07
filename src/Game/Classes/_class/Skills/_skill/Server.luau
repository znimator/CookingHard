local rp = game:GetService("ReplicatedStorage")
local uis = game:GetService("UserInputService")
local ss = game:GetService("ServerStorage")

local Remotes = script.Parent.Remotes

local config = require(script.Parent.Config)

local janitor = require(rp.Packages.janitor)

export type ServerSkill = {
    Config: config.SkillConfig,
    Janitor: janitor.Janitor,
    Player: Player,

    Load: (self: ServerSkill) -> (),
    Unload: (self: ServerSkill) -> (),
    Destroy: (self: ServerSkill) -> (),
}

local server_skill = {}
server_skill.__index = server_skill

function server_skill.new(plr: Player) : ServerSkill
    local self = setmetatable({}, server_skill)

    self.Config = config.new()

    self.Player = plr

    self.Janitor = janitor.new()

    return self
end

function server_skill:Load()
    
end

function server_skill:Destroy()
    self.Janitor:Destroy()
end

server_skill.Unload = server_skill.Destroy -- Allias for Destroy

return server_skill