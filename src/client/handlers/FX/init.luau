local FXHandler = {}

local Remotes = script.Remotes

function FXHandler:FX(name: string, cfg: {[any] : any}?)
    if self._effects[name] == nil then
        warn("Unknown FX: " .. name)
        return
    end

    task.spawn(function()
        self._effects[name](cfg or {})
    end)
end

function FXHandler:Init()
    self._effects = {}

    -- Load all effect modules
    for _, v in script.Effects:GetChildren() do
        local success, effect = pcall(require, v)
        if not success then
            warn(string.format("Failed to load effect module: %s", v.Name))
            warn(effect)
        else
            self._effects[v.Name] = effect
        end
    end

    Remotes.RunFX.OnClientEvent:Connect(function(name: string, cfg: {[any] : any}?)
        self:FX(name, cfg)
    end)

end

return FXHandler