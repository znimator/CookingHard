local rp = game:GetService("ReplicatedStorage")
local ss = game:GetService("ServerStorage")
local uis = game:GetService("UserInputService")
local cs = game:GetService("CollectionService")
local rs = game:GetService("RunService")
local players = game:GetService("Players")

local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid") :: Humanoid

local cursor = plr.PlayerGui:WaitForChild("Cursor")

local handler = {}

--[[
	About handler:
	Enhanced Character Movement
]]

function handler:Start()
	
	local root = char:WaitForChild("HumanoidRootPart")
	local rootJoint = root:WaitForChild("RootJoint") :: Motor6D
	local c0 = rootJoint.C0
	
	self._tilt = CFrame.Angles(0, 0, 0)
	
	plr.CharacterAdded:Connect(function(new)
		print("CHAR ADDED")
		char = new
		hum = new:WaitForChild("Humanoid") :: Humanoid
		root = char:WaitForChild("HumanoidRootPart")
		rootJoint = root:WaitForChild("RootJoint") :: Motor6D
	end)
	
	rs.Heartbeat:Connect(function(dt)
		if char == nil then return end
		if hum == nil then return end

		--print("Render stuff", dt)
		
		local moveDir = hum.MoveDirection
		
		local tiltDir = root.CFrame:VectorToObjectSpace(moveDir)

		self._tilt = self._tilt:Lerp(CFrame.Angles(math.rad(tiltDir.Z) * 10 - math.pi / 2, math.rad(tiltDir.X) * 20, math.pi), dt * 15)
		rootJoint.C0 = self._tilt
	end)
end

return handler