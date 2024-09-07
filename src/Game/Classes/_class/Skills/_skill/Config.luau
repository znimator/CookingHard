local skill_config = {}

export type SkillConfig = {
    Cooldown: number,
    Key: Enum.KeyCode | Enum.UserInputType,
    IsUltimate: boolean,
    IsPassive: boolean,
    IsHidden: boolean
}

function skill_config.new() : SkillConfig
    local self = setmetatable({}, skill_config)

    self.Cooldown = 1;

    self.Key = Enum.KeyCode.F;

    self.IsUltimate = false;
    self.IsPassive = false;
    self.IsHidden = false;

    return self
end

return skill_config