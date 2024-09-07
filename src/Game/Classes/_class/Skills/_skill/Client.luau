local rp = game:GetService("ReplicatedStorage")
local uis = game:GetService("UserInputService")

local plr = game.Players.LocalPlayer

local Remotes = script.Parent.Remotes

local config = require(script.Parent.Config)

local janitor = require(rp.Packages.janitor)

export type ClientSkill = {
    Config: config.SkillConfig,
    Janitor: janitor.Janitor,

    Load: (self: ClientSkill) -> (),
    Unload: (self: ClientSkill) -> (),
    Destroy: (self: ClientSkill) -> (),
}

local client_skill = {}
client_skill.__index = client_skill

function client_skill.new() : ClientSkill
	local self = setmetatable({}, client_skill)

	self.Config = config.new()

    self.Janitor = janitor.new()

	return self
end

function client_skill:Load()

end

function client_skill:Destroy()
    self.Janitor:Destroy()
end

client_skill.Unload = client_skill.Destroy -- Allias for Destroy

return client_skill
