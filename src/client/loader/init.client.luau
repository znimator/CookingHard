local rp = game:GetService("ReplicatedStorage")
local uis = game:GetService("UserInputService")
local plr = game.Players.LocalPlayer

local handlers = {}
for _, v in rp.Handlers:GetChildren() do
	handlers[v.Name] = require(v)
end

-- Initialize all handlers first
for _, handler in handlers do

    if handler.Init == nil then
        continue
    end

    handler:Init()
end

-- Then start all handlers
for _, handler in handlers do

    if handler.Start == nil then
        continue
    end

    local success, err = pcall(handler.Start, handler)

    if not success then
        warn(err)
    end
end