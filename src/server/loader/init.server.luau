local ss = game:GetService("ServerStorage")

local handlers = {}
for _, v in ss.Handlers:GetChildren() do
	handlers[v.Name] = require(v)
end

-- Initialize all handlers first
for _, handler in handlers do

    if handler.Init == nil then
        continue
    end

    local success, err = pcall(handler.Init, handler)

    if not success then
        warn(err)
    end
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

task.wait(1)

for i, v in game.Players:GetPlayers() do
    local classHandler = handlers.Class
    print(v)
    classHandler:Load(v, "Warrior", "Default")
end