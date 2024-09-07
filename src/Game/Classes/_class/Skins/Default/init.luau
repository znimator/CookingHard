local skin_config = {}

function skin_config.new()
    local self = setmetatable({}, {__index = skin_config})

    self.Creator = "Game";

    self.Name = script.Name;
    self.Description = "Default skin";

    self.IsHidden = false;
    self.IsServerLocked = false;

    self.Skin = script:FindFirstChild("Skin");
    self.Figure = script:FindFirstChild("Figure");

    return self
end

return skin_config

