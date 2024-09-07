local rp = game:GetService("ReplicatedStorage")

local EntityHandler = {}

local Remotes = script.Remotes

local BaseEntity = require(rp.Entities._entity.Client)

export type Entity = BaseEntity.ClientEntity

function EntityHandler:Register(model: Model, name: string) : Entity?

    if not model or not model:IsA("Model") then
        warn("Invalid model provided")
        return
    end

    if self._entities[name] == nil then
        warn("Unknown entity: " .. name)
        return
    end

    local entity = self._entities[name].new(model)

    entity.Events.OnDestroy:Connect(function()
        self.Entities[model] = nil
    end)

    self.Entities[model] = entity

    return entity
end

function EntityHandler:GetEntity(model: Model) : Entity?
	return self.Entities[model]
end

function EntityHandler:DebugEntity(model: Model)
    print(self.Entities[model])
    
    --TODO: Actual debug
end

function EntityHandler:Init()
    self._entities = {}
    self.Entities = {}

    -- Load all entity modules
    for _, v in rp.Entities:GetChildren() do
        self._entities[v.Name] = require(v)
    end

    for i,v in rp.Classes:GetChildren() do
        self._entities[v.Name] = require(v.Entity)
    end

    Remotes.FireSignal.OnClientEvent:Connect(function(model: Model, name: string, ...)
        local entity = self:GetEntity(model)

        if entity == nil then
            warn("Unknown entity to Fire Signal: " .. name)
            return
        end

        entity.Events[name]:Fire(...)

    end)

    Remotes.Register.OnClientEvent:Connect(function(model: Model, name: string)
        self:Register(model, name)
    end)
end

return EntityHandler