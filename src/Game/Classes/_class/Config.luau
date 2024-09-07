local class_config = {}
class_config.__index = class_config

export type ClassConfig = {
    Name: string,
    Description: string,

    Health: number,
    WalkSpeed: number,

    Color: Color3,

    IsServerLocked: boolean,
    IsHidden: boolean,
}

function class_config.new() : ClassConfig
    local self = setmetatable({}, class_config)

    self.Name = script.Parent.Name
    self.Description = "Placeholder Description"

    self.Health = 100;
    self.WalkSpeed = 32;

    self.Color = Color3.fromRGB(255, 255, 255);

    self.IsServerLocked = false;
    self.IsHidden = false;

    return self
end

return class_config