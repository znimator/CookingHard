local rp = game:GetService("ReplicatedStorage")
local tw = game:GetService("TweenService")
local rs = game:GetService("RunService")

local plr = game.Players.LocalPlayer

local default = {}

return function (cfg : {[any] : any}?)
    setmetatable(cfg, {__index = default})

end