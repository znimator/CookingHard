local rp = game:GetService("ReplicatedStorage")
local ss = game:GetService("ServerStorage")
local uis = game:GetService("UserInputService")
local cs = game:GetService("CollectionService")
local rs = game:GetService("RunService")
local players = game:GetService("Players")

local plr = game.Players.LocalPlayer

local cursor = plr.PlayerGui:WaitForChild("Cursor")

local handler = {}

--[[
	About handler:
	Cursor Render
]]

function handler:Start()
	
	uis.MouseIconEnabled = false
	
	rs.RenderStepped:Connect(function(dt)
		local mousePos = uis:GetMouseLocation()
		cursor.Cursor.Position = UDim2.fromOffset(mousePos.X, mousePos.Y)
	end)
end

return handler