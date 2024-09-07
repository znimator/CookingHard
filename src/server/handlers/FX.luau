local rp = game:GetService("ReplicatedStorage")

local FXHandler = {}

local Remotes = rp.Handlers.FX.Remotes

function FXHandler:FX(plr: Player, name: string, cfg: {[any] : any}?)
    Remotes.RunFX:FireClient(plr, name, cfg)
end

function FXHandler:FXAll(name: string, cfg: {[any] : any}?)
    Remotes.RunFX:FireAllClients(name, cfg)
end

function FXHandler:FXAllExcept(plr: Player, name: string, cfg: {[any] : any})
    for i,v in game.Players:GetPlayers() do
        if v ~= plr then
            Remotes.RunFX:FireClient(v, name, cfg)
        end
    end
end

return FXHandler