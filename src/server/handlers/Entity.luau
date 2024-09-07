local rp = game:GetService("ReplicatedStorage")
local rs = game:GetService("RunService")

local Remotes = rp.Handlers.Entity.Remotes


local BaseEntity = require(rp.Entities._entity.Server)

export type Entity = BaseEntity.ServerEntity

local EntityHandler = {
	_entities = {},
	Entities = {}
}

function EntityHandler:Register(model: Model, name: string): Entity?
	if not model or not model:IsA("Model") then
        warn("Invalid model provided")
        return
    end

	if self._entities[name] == nil then
		warn("Unknown entity: " .. name)
		return
	end

	local entity = self._entities[name].new(model)

	for i, v in entity.Events do
		v:Connect(function(...)
			Remotes.FireSignal:FireAllClients(model, i, ...)
		end)
	end

	print("Registering entity: " .. name)

	entity.Events.OnDestroy:Connect(function()
		self.Entities[model] = nil
	end)

	Remotes.Register:FireAllClients(model, name)

	self.Entities[model] = entity

	return entity
end

function EntityHandler:GetEntity(model: Model): Entity?
	return self.Entities[model]
end

function EntityHandler:Init()
	-- Load all entity modules
	for _, v in rp.Entities:GetChildren() do
		self._entities[v.Name] = require(v)
	end

	for _, v in rp.Classes:GetChildren() do
		self._entities[v.Name] = require(v.Entity)
	end

	game.Players.PlayerAdded:Connect(function(player)
		for i, v in self.Entities do
			Remotes.Register:FireClient(player, i, v.Name)
		end
	end)

	rs.Heartbeat:Connect(function()
		for _, entity in self.Entities do
			if entity.Properties.IFrames <= 0 then
				continue
			end

			entity.Properties.IFrames = entity.Properties.IFrames - 1
		end
	end)
end

return EntityHandler
