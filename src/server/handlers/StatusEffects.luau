local rp = game:GetService("ReplicatedStorage")
local ss = game:GetService("ServerStorage")
local uis = game:GetService("UserInputService")
local cs = game:GetService("CollectionService")
local rs = game:GetService("RunService")
local players = game:GetService("Players")

local plr = game.Players.LocalPlayer

local entityHandler = require(ss.Handlers.Entity)

local Remotes = rp.Handlers.StatusEffects.Remotes

local ServerStatusHandler = {}

function ServerStatusHandler:Init()
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

					table.remove(self.AffectedEntities[entity.Model], index)
					Remotes.Remove:FireAllClients(entity.Model, effect.Name)
					continue
				end

				effect:Update(deltaTime)
				effect.LastUpdate = os.clock()
			end
		end
	end)

	game.Players.PlayerAdded:Connect(function(player)
		for model, Effects in self.AffectedEntities do
			local toLoad = {}

			for index, effect in Effects do
				table.insert(toLoad, {
					Target = model;
					Name = effect.Name;
					Config = effect.Config;
					ApplyTimestamp = effect.ApplyTimestamp;
				})
			end

			Remotes.Load:FireClient(player, toLoad)
		end
	end)
end

function ServerStatusHandler:Apply(entity: entityHandler.Entity, name: string, config: {[any] : any}?)
	if self._effects[name] == nil then
		warn("Unknown effect: " .. name)
		return
	end

	local effect = self._effects[name].new(entity, config)

	effect.ApplyTimestamp = os.clock()
	effect:Apply()

	if self.AffectedEntities[entity.Model] == nil then
		self.AffectedEntities[entity.Model] = {}
	end

	table.insert(self.AffectedEntities[entity.Model], name)
	Remotes.Apply:FireAllClients(entity.Model, name, config)
end

-- Clear all Effects entity have
function ServerStatusHandler:ClearAll(entity: entityHandler.Entity)
	Remotes.ClearAll:FireAllClients(entity.Model)

	for _, effect in self.AffectedEntities[entity.Model] do
		effect:Destroy()
	end
end

-- Clear a specific Effect
function ServerStatusHandler:Clear(entity: entityHandler.Entity, name: string)
	Remotes.Clear:FireAllClients(entity.Model, name)

	for _, effect in self.AffectedEntities[entity.Model] do
		if effect.Name == name then
			effect:Destroy()
			break
		end
	end
end

return ServerStatusHandler