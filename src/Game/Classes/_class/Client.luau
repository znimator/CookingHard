local rp = game:GetService("ReplicatedStorage")
local janitor = require(rp.Packages.janitor)

local plr = game.Players.LocalPlayer

local _class_client = {}
_class_client.__index = _class_client

local _skill = require(script.Parent.Skills._skill.Client)
local _config = require(script.Parent.Config)

export type ClientSkill = _skill.ClientSkill
export type ClassConfig = _config.ClassConfig

export type ClientClass = {
	SkinName: string,
	CurrentSkin: string | nil,

	Janitor: janitor.Janitor,

	Player: Player,

    RootFolder: Folder,

    Config: ClassConfig,

	Skills: {[string]: ClientSkill},
	Animations: {[string]: AnimationTrack},

	Load: (self: ClientClass) -> (),
	LoadSkills: (self: ClientClass) -> (),
	LoadAnimations: (self: ClientClass) -> (),

    Unload: (self: ClientClass) -> (),
	Destroy: (self: ClientClass) -> (),
}

function _class_client:LoadSkills()
	for _, v in self.RootFolder.Skills:GetChildren() do
		self.Skills[v.Name] = require(v).new(self.Player)
	end

	for _, v in self.Skills do
		v:Load()
	end
end

function _class_client:LoadAnimations()
	local char = self.Player.Character
	local hum = char:WaitForChild("Humanoid") :: Humanoid
	local animator = hum:WaitForChild("Animator") :: Animator

	for _, v in self.RootFolder.Assets.Animations:GetChildren() do
		self.Animations[v.Name] = animator:LoadAnimation(v)
	end
end

function _class_client.new(skin: string) : ClientClass
	local self = setmetatable({}, _class_client)

	self.SkinName = skin
    self.CurrentSkin = nil;

    self.Janitor = janitor.new()

    self.RootFolder = script.Parent

    local skinFolder = plr.Character:FindFirstChild("Skin") :: Folder
    local classTempFolder = plr.Character:FindFirstChild("Class") :: Folder

    if skinFolder == nil then
        local folder = Instance.new("Folder")
        folder.Name = "Skin"

        skinFolder = folder
    end
    
    if classTempFolder == nil then
        local folder = Instance.new("Folder")
        folder.Name = "Class"

        classTempFolder = folder
    end

    self.Janitor:Add(skinFolder, "Destroy")
    self.Janitor:Add(classTempFolder, "Destroy")

	self.Player = plr

	self.Skills = {}
	self.Animations = {}

	return self
end

function _class_client:Load()
    print("Load anims")
    self:LoadAnimations()
    print("Load skills")
    self:LoadSkills()
end

function _class_client:Destroy()

    for _, v in self.Skills do
        v:Unload()
    end

	self.Janitor:Destroy()
end

_class_client.Unload = _class_client.Destroy

return _class_client
