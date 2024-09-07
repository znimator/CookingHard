local rp = game:GetService("ReplicatedStorage")

local PlayerHandler = {}

local Remotes = rp.Handlers.Player.Remotes

function PlayerHandler:Init()
    self.Players = {}

    game.Players.PlayerAdded:Connect(function(player)
        PlayerHandler:Load(player)
    end)

    game.Players.PlayerRemoving:Connect(function(player)
        PlayerHandler:Unload(player)
    end)
    
    Remotes.RequestData.OnServerInvoke = function(plr)
        return PlayerHandler:GetData(plr)
    end
end

function PlayerHandler:Load(player: Player)
    -- Load all player data here

    self.Players[player] = {}

    self.Players[player].Data = {
        Classes = {}
    }

    player.CharacterAdded:Connect(function(character)
        character.PrimaryPart = character:WaitForChild("HumanoidRootPart")
    end)
end

function PlayerHandler:Unload(player: Player)
    -- Unload all player data here
    self.Players[player] = nil
end

function PlayerHandler:GetData(player: Player)
    -- Return the loaded player data here

    return self.Players[player].Data
end

function PlayerHandler:GetPlayer(player: Player)
    -- Return the loaded player here

    return self.Players[player]
end

return PlayerHandler
