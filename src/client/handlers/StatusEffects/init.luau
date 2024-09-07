local rp = game:GetService("ReplicatedStorage")
local ss = game:GetService("ServerStorage")
local uis = game:GetService("UserInputService")
local cs = game:GetService("CollectionService")
local rs = game:GetService("RunService")
local players = game:GetService("Players")

local plr = game.Players.LocalPlayer

local entityHandler = require(rp.Handlers.Entity)

local Remotes = script.Remotes

local ClientStatusHandler = {}

function ClientStatusHandler:Init()
	self.AffectedEntities = {}
	self._effects = {}

	-- Load all effect modules
	for i,v in rp.StatusEffects:GetChildren() do
		self._effects[v.Name] = require(v)
	end

	rs.Heartbeat:Connect(function(deltaTime)
		local timestamp = os.clock()
		for entity, effects in self.AffectedEntities do
			for index, effect in effects do

				if timestamp - effect.ApplyTimestamp >= effect.Config.Duration then
					effect:Destroy()

					table.remove(self.AffectedEntities[entity], index)
					continue
				end

				effect:Update(deltaTime)
				effect.LastUpdate = os.clock()
			end
		end
	end)


	Remotes.Apply.OnClientEvent:Connect(function(model: Model, name: string, config: {[any] : any}?)
		local entity = entityHandler:GetEntity(model)
		self:Apply(entity, name, config)
	end)

	Remotes.ClearAll.OnClientEvent:Connect(function(model: Model)
		local entity = entityHandler:GetEntity(model)
		self:ClearAll(entity)
	end)

	Remotes.Clear.OnClientEvent:Connect(function(model: Model, name: string)
		local entity = entityHandler:GetEntity(model)
		self:Clear(entity, name)
	end)
end

function ClientStatusHandler:Apply(entity: Model, name: string, config: {[any] : any}?)
	if self._effects[name] == nil then
		warn("Unknown effect: " .. name)
		return
	end

	local effect = self._effects[name].new(entity, config)

	effect.ApplyTimestamp = os.clock()
	effect:Apply()

	if self.AffectedEntities[entity] == nil then
		self.AffectedEntities[entity] = {}
	end

	table.insert(self.AffectedEntities[entity], effect)
end

-- Clear all Effects entity have
function ClientStatusHandler:ClearAll(entity: entityHandler.Entity)
	for _, effect in self.AffectedEntities[entity] do
		effect:Destroy()
	end
end

-- Clear a specific Effect
function ClientStatusHandler:Clear(entity: entityHandler.Entity, name: string)
	for _, effect in self.AffectedEntities[entity] do
		if effect.Name == name then
			effect:Destroy()
			break
		end
	end
end

return ClientStatusHandler