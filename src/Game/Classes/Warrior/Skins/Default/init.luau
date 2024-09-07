local skin_config = {
    Creator = "Game";

    Name = script.Name;
    Description = "Default skin";

    IsHidden = false;
    IsServerLocked = false;

    Skin = script:FindFirstChild("Skin");
    Figure = script:FindFirstChild("Figure");
}

return skin_config