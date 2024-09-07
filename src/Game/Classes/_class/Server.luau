local rp = game:GetService("ReplicatedStorage")
local janitor = require(rp.Packages.janitor)

local _class_server = {}
_class_server.__index = _class_server

local _skill = require(script.Parent.Skills._skill.Server)
local _config = require(script.Parent.Config)

export type ServerSkill = _skill.ServerSkill
export type ClassConfig = _config.ClassConfig

export type ServerClass = {
	SkinName: string,
	CurrentSkin: Model | nil,

	Janitor: janitor.Janitor,

	Player: Player,

    RootFolder: Folder,

    Confing : ClassConfig,

	Skills: {[string]: ServerSkill},
	Animations: {[string]: AnimationTrack},

	Load: (self: ServerClass) -> (),
    LoadSkin: (self: ServerClass) -> (),
	LoadSkills: (self: ServerClass) -> (),
	LoadAnimations: (self: ServerClass) -> (),

    Unload: (self: ServerClass) -> (),
	Destroy: (self: ServerClass) -> (),
}

local function fixSkin(model: Model)
    for i,v in model:GetDescendants() do
        if v:IsA("BasePart") then
            v = v :: BasePart
            v.Massless = true
            v.Anchored = false
            v.CanCollide = false
            v.CanQuery = false
            v.CanTouch = false
        end
    end
end

function _class_server:LoadSkin()
    local char = self.Player.Character
    local hum = char:WaitForChild("Humanoid") :: Humanoid
    local skinFolder = char:FindFirstChild("Skin") :: Folder

    if skinFolder == nil then
        skinFolder = Instance.new("Folder")
        skinFolder.Name = "Skin"
        skinFolder.Parent = char
    end

    local skinModule = require(self.RootFolder.Skins:FindFirstChild(self.SkinName))

    if skinModule == nil then
        return
    end

    local skin = skinModule.Skin:Clone() :: Model
    fixSkin(skin)
    skin.Parent = skinFolder

    for i,v in skin:GetChildren() do
        local limb = char:FindFirstChild(v.Name) :: BasePart
        
        v.Transparency = 1

        if limb then
            local weld = Instance.new("Weld")
            weld.Part0 = limb
            weld.Part1 = v

            -- weld.C0 = weld.Part0.CFrame:Inverse() * limb.CFrame
            -- weld.C1 = weld.Part1.CFrame:Inverse() * limb.CFrame

            weld.Parent = limb
        end
    end
end

function _class_server:LoadSkills()
	for _, v in self.RootFolder.Skills:GetChildren() do
		self.Skills[v.Name] = require(v).new(self.Player)
	end

	for _, v in self.Skills do
		v:Load()
	end
end

function _class_server:LoadAnimations()
	local char = self.Player.Character
	local hum = char:WaitForChild("Humanoid") :: Humanoid
	local animator = hum:WaitForChild("Animator") :: Animator

	for _, v in self.RootFolder.Assets.Animations:GetChildren() do
		self.Animations[v.Name] = animator:LoadAnimation(v)
	end
end

function _class_server.new(plr: Player, skin: string) : ServerClass
	local self = setmetatable({}, _class_server)

	self.SkinName = skin
    self.CurrentSkin = nil;

    self.Janitor = janitor.new()

    self.Config = _config.new()

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

function _class_server:Load()
    self:LoadSkin()
    self:LoadAnimations()
    self:LoadSkills()
end

function _class_server:Destroy()

    for _, v in self.Skills do
        v:Unload()
    end

	self.Janitor:Destroy()
end

_class_server.Unload = _class_server.Destroy

return _class_server
