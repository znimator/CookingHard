local rp = game:GetService("ReplicatedStorage")

local FXHandler = {}

local Remotes = rp.Handlers.FX.Remotes

function FXHandler:FX(plr: Player, name: string, cfg: {[any] : any}?)
    Remotes.RunFX:FireClient(plr, name, cfg)
end

function FXHandler:FXAll(name: string, cfg: {[any] : any}?)
    Remotes.RunFX:FireAllClients(name, cfg)
end

return FXHandler