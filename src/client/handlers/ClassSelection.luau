local rp = game:GetService("ReplicatedStorage")
local ss = game:GetService("SoundService")
local uis = game:GetService("UserInputService")
local cs = game:GetService("CollectionService")
local rs = game:GetService("RunService")

local players = game:GetService("Players")

local plr = game.Players.LocalPlayer

local cam = workspace.CurrentCamera

local UI = plr.PlayerGui:WaitForChild("ClassSelect")

local fusion = require(rp.Packages.fusion)

local Hydrate = fusion.Hydrate
local Tween = fusion.Tween
local Spring = fusion.Spring
local Value = fusion.Value
local Observer = fusion.Observer
local Children = fusion.Children
local Computed = fusion.Computed
local OnEvent = fusion.OnEvent
local Scoped = fusion.scoped
local Peek = fusion.peek

local fxHandler = require(rp.Handlers.FX)
local playerHandler = require(rp.Handlers.Player)
local classHandler = require(rp.Handlers.Class)

local handler = {}

--[[
	About handler:
	Class Selection
]]

function handler:Open()
	
	local data = playerHandler:RequestData()
	
	for i, v in self.Classes do
		if data.Classes[v.Name] == nil then
			self.ClassInfo[v].Locked:set(true)
		else
			self.ClassInfo[v].Locked:set(false)
		end
	end
	
	cam.CameraType = Enum.CameraType.Scriptable
	self.FakeWall = rp.Assets.Screen:Clone()
	self.FakeWall.Parent = workspace.Temp
	
	local offsetU = self.Scope:Value(0)
	local offsetV = self.Scope:Value(0)
	
	rs:BindToRenderStep("ScreenTexture", Enum.RenderPriority.Last.Value + 1, function(dt)
		offsetU:set(Peek(offsetU) - dt * 5)
		offsetV:set(Peek(offsetV) - dt * 5)
	end)
	
	self.Scope:Hydrate(self.FakeWall.Texture) {
		OffsetStudsU = offsetU,
		OffsetStudsV = offsetV
	}
	
	cam.CFrame = self.FakeWall.CFrame * CFrame.Angles(0, math.pi, 0) * CFrame.new(0, -1, 78)
	
	self.SelectingClass:set(true)

	self:LoadPreview()
end

function handler:Close()
	rs:UnbindFromRenderStep("ScreenTexture")
	
	if Peek(self.SkinPreview) then
		Peek(self.SkinPreview):Destroy()
		self.SkinPreview:set(nil)
	end
	
	self.FakeWall:Destroy()
	
	self.SelectingClass:set(false)
	cam.CameraType = Enum.CameraType.Custom
	
	local class = self.Classes[Peek(self.SelectedClass)]
	print(Peek(self.SelectedClass))
	print(class)

	local isLocked = Peek(self.ClassInfo[class].Locked)

	if class and not isLocked then
		classHandler:RequestChange(class.Name)
	end
end

local function lerp(a, b, t)
	return a + (b - a) * t
end

function handler:LoadPreview()
	ss:PlayLocalSound(rp.Assets.Sounds.Click)
		
	if Peek(self.SkinPreview) then
		Peek(self.SkinPreview):Destroy()
	end

	local module = self.Classes[Peek(self.SelectedClass)]
	print(module)
	
	if module == nil then return end

	local skinInfo = require(module.Skins.Default)

	local figure = skinInfo.Figure:Clone() :: Model
	
	if Peek(self.ClassInfo[module].Locked) then
		local highlight = Instance.new("Highlight")
		highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
		highlight.FillColor = Color3.fromRGB(0, 0, 0)
		highlight.Parent = figure
		highlight.Adornee = figure
		highlight.OutlineTransparency = 1
		highlight.FillTransparency = 0
		
		self.Scope:Hydrate(highlight) {
			FillColor = self.Scope:Tween(self.Scope:Computed(function()
				return Peek(self.IsUnlocking) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
			end), TweenInfo.new(1)),
			FillTransparency = self.Scope:Tween(self.Scope:Computed(function()
				return Peek(self.ClassInfo[module].Locked) and 0 or 1
			end), TweenInfo.new(1))
		}
	end
	
	figure.Parent = workspace.Temp
	
	self.SkinPreview:set(figure)
end

function handler:Init()

	self.Scope = Scoped({
		Value = fusion.Value,
		Observer = fusion.Observer,
		Computed = fusion.Computed,
		Tween = fusion.Tween,
		Hydrate = fusion.Hydrate,
		Spring = fusion.Spring,
		doCleanup = fusion.doCleanup
	})

	self.SelectingClass = self.Scope:Value(false)
	self.SelectedClass = self.Scope:Value(1)
	self.SelectedSkin = self.Scope:Value("Default")
	
	self.IsUnlocking = self.Scope:Value(false)
	
	self.SkinPreview = self.Scope:Value(nil)
	
	self.FakeWall = nil
	
	self.ClassInfo = {}
	self.Classes = {}
	
	local particle = rp.Assets.ClassSelection.Absorb:Clone()
	local stars = rp.Assets.ClassSelection.Stars:Clone()
	stars.Attachment.Star.Enabled = false
	
	
	
	self.Scope:Observer(self.IsUnlocking):onChange(function()
		local module = self.Classes[Peek(self.SelectedClass)]
		local isLocked = Peek(self.ClassInfo[module].Locked)
		
		if Peek(self.IsUnlocking) and isLocked then
			if Peek(self.SkinPreview) == nil then return end
			
			particle.Parent = workspace.Temp
			particle:PivotTo(CFrame.new(Peek(self.SkinPreview):GetPivot().Position))
		else
			particle.Parent = nil
		end
	end)
	
	self.Scope:Hydrate(UI.Main.LockedBG.ImageLabel) {
		Visible = self.Scope:Computed(function()
			if Peek(self.SelectedClass) == nil then
				return false	
			end
			
			local module = self.Classes[Peek(self.SelectedClass)]
			
			if module == nil then 
				return false
			end
			
			local isLocked = Peek(self.ClassInfo[module].Locked)
			
			if isLocked == nil then
				return false
			end
			
			return isLocked
		end),
		ImageTransparency = self.Scope:Tween(self.Scope:Computed(function()
			if Peek(self.SelectedClass) == nil then
				return 1	
			end
			
			local module = self.Classes[Peek(self.SelectedClass)]

			if module == nil then 
				return 1
			end
			
			local isLocked = Peek(self.ClassInfo[module].Locked)

			if isLocked == nil then
				return 1
			end

			return isLocked and 0 or 1
		end), TweenInfo.new(1))
	}
	
	self.Scope:Observer(self.SkinPreview):onChange(function()
		task.wait(0.1)
		if Peek(self.SkinPreview) then
			print("change star pos")
			stars.Parent = workspace.Temp
			stars:PivotTo(CFrame.new(Peek(self.SkinPreview):GetPivot().Position))
		else
			stars.Parent = nil
		end
	end)
	
	self.Scope:Observer(self.SelectedClass):onChange(function()
		self:LoadPreview()
	end)
	
	local rotation = 0
	
	local mouseDrag = Vector2.new(0, 0)
	
	local shakeCFrame = CFrame.new()
	local lockImagePos = UI.Main.LockedBG.ImageLabel.Position
	local shakeVector2 = Vector2.new()
	
	local orbSummon = os.clock()
	
	local lastPlaySound = os.clock()
	
	local camDistance = -10
	
	local rotSpeed = 1
	
	local unlockTime = 1.5
	local currentUnlockingTime = os.clock()
	
	rs.RenderStepped:Connect(function(dt)
		
		if Peek(self.SelectingClass) == false then return end
		
		local model = Peek(self.SkinPreview) :: Model?
		if model then
			if uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
				uis.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
				
				local delta = uis:GetMouseDelta()
				mouseDrag = mouseDrag:Lerp(mouseDrag + Vector2.new(delta.X * dt, delta.Y * dt), 1)
				
			else
				uis.MouseBehavior = Enum.MouseBehavior.Default
				mouseDrag = mouseDrag:Lerp(Vector2.new(0, 0), dt * 5)
				rotation += dt * rotSpeed
			end
			
			local cf = cam.CFrame * CFrame.new(0, 0, camDistance)
			local shakeCFrame = CFrame.new()
			
			local module = self.Classes[Peek(self.SelectedClass)]
			local isLocked = Peek(self.ClassInfo[module].Locked)
			
			if Peek(self.IsUnlocking) and isLocked then
				
				if os.clock() - lastPlaySound >= 0.15 then
					lastPlaySound = os.clock()
					rp.Assets.Sounds.Magic.PlaybackSpeed = math.random(50, 100) / 40
					ss:PlayLocalSound(rp.Assets.Sounds.Magic)
				end
				
				local x, y, z = math.random(-200, 200) / 100, math.random(-200, 200) / 100, math.random(-200, 200) / 100
				--local x, y, z = math.random(-100, 100) / 100, math.random(-100, 100) / 100, math.random(-100, 100) / 100
				local randPos = Vector3.new(x, y, z)
				--local randRotation = Vector3.new()
				shakeCFrame = shakeCFrame:Lerp(CFrame.new(randPos), dt * 10)
				shakeVector2 = shakeVector2:Lerp(Vector2.new(randPos.X, randPos.Y), dt * 50)
				
				camDistance = lerp(camDistance, -5, dt)
				rotSpeed = lerp(rotSpeed, 90, dt)
				
				if os.clock() - currentUnlockingTime >= unlockTime then
					self.IsUnlocking:set(false)
					ss:PlayLocalSound(rp.Assets.Sounds["Unlock Class"])
					local module = self.Classes[Peek(self.SelectedClass)]
					self.ClassInfo[module].Locked:set(false)
					fxHandler:FX("Vignette")
					fxHandler:FX("Blur")
					stars.Attachment.Star:Emit(15)
				end
			else
				currentUnlockingTime = os.clock()
				camDistance = lerp(camDistance, -10, dt * 10)
				rotSpeed = lerp(rotSpeed, 1, dt * 2)
				shakeVector2 = shakeVector2:Lerp(Vector2.new(0, 0), dt * 10)
			end

			local rotCF = CFrame.Angles(mouseDrag.Y, math.pi + rotation * 0.25 + mouseDrag.X, 0)
			
			UI.Main.LockedBG.ImageLabel.Position = UDim2.fromScale(lockImagePos.X.Scale + shakeVector2.X / 85, lockImagePos.Y.Scale + shakeVector2.Y / 85)
			
			model:PivotTo(cf * shakeCFrame * rotCF)
		end
	end)
	
	local switch = false
	
	
	for i,v in rp.Classes:GetChildren() do
		if v.Name == "_class" then continue end
		if v.Name == "Template" then continue end

		self.ClassInfo[v] = {Locked = self.Scope:Value(false)}
		table.insert(self.Classes, v)
	end
	
	table.sort(self.Classes, function(a, b)
		return a.Name:lower() < b.Name:lower()
	end)

	-- event to check mouse wheel movement
	local mouseWheelConnection
	mouseWheelConnection = uis.InputChanged:Connect(function(input, gameProcessedEvent)
		--if gameProcessedEvent then return end
		if Peek(self.SelectingClass) == false then return end
		if Peek(self.IsUnlocking) then return end
		if input.UserInputType ~= Enum.UserInputType.MouseWheel then return end

		if input.Position.Z > 0 then
			--print("Up")
			self.SelectedClass:set(math.clamp(Peek(self.SelectedClass) - 1, 1, #self.Classes))
		else
			--print("Down")
			self.SelectedClass:set(math.clamp(Peek(self.SelectedClass) + 1, 1, #self.Classes))
		end
	end)

	for i,v in self.Classes do
		local _template = rp.Assets.ClassSelection.Template:Clone()
		_template.Parent = UI.Main.List.Classes
		
		local skinInfo = require(v.Skins.Default)
		local classInfo = require(v.Config).new()
		print(skinInfo)
		
		local figure = skinInfo.Figure:Clone()
		
		_template.Canvas.Background.BackgroundColor3 = classInfo.Color
		_template.Canvas.TextLabel.Text = classInfo.Name
		figure.Parent = _template.Canvas.ViewportFrame.WorldModel
		
		local newCam = Instance.new("Camera")
		newCam.CameraType = Enum.CameraType.Scriptable
		newCam.Parent = _template.Canvas.ViewportFrame
		
		_template.Canvas.ViewportFrame.CurrentCamera = newCam
		_template.Canvas.ViewportFrame.CurrentCamera.CFrame = figure:GetPivot() * CFrame.Angles(0, math.pi, 0) * CFrame.new(0, 0, 6)

		self.Scope:Hydrate(_template.Canvas) {
			[Children] = {
				ClassLocked = self.Scope:Hydrate(_template.Canvas.ClassLocked) {
					[Children] = {
						ImageLabel = self.Scope:Hydrate(_template.Canvas.ClassLocked.ImageLabel) {
							Visible = self.Scope:Computed(function()
								return Peek(self.ClassInfo[v].Locked)
							end)
						}
					},
					Transparency = self.Scope:Tween(self.Scope:Computed(function()
						return (Peek(self.SelectedClass) == i and Peek(self.ClassInfo[v].Locked) == false) and 1 or 0.25
					end), TweenInfo.new(0.15))
				},
				Button = self.Scope:Hydrate(_template.Canvas.Button) {
					[OnEvent "Activated"] = function()
						self.SelectedClass:set(i)
					end,
				},
				Selected = self.Scope:Hydrate(_template.Canvas.Selected) {
					ImageTransparency = self.Scope:Tween(self.Scope:Computed(function()
						return Peek(self.SelectedClass) == i and 0 or 1
					end), TweenInfo.new(0.15))
				}
			},
			Size = self.Scope:Spring(self.Scope:Computed(function()
				return Peek(self.SelectedClass) == i and UDim2.fromScale(1, 1) or UDim2.fromScale(0.9, 0.9)
			end), 35, 0.75)
		}
	end
	
	self.Scope:Hydrate(UI) {
		Enabled = self.SelectingClass
	}
	
	self.Scope:Hydrate(UI.Main.List.Classes) {
		Position = self.Scope:Spring(self.Scope:Computed(function()
			return UDim2.fromScale(0.5 - (0.05 * (Peek(self.SelectedClass) - 1)), 0.5)
		end), 35, 0.75)
	}
	
	uis.InputBegan:Connect(function(inp, pro)
		if pro then return end
		if inp.KeyCode == Enum.KeyCode.P then
			switch = not switch
			if switch then
				self:Open()
			else
				self:Close()
			end
		end
	end)
	
	uis.InputBegan:Connect(function(inp, pro)
		if pro then return end
		if inp.KeyCode == Enum.KeyCode.F then
			self.IsUnlocking:set(true)
		end
	end)
	
	uis.InputEnded:Connect(function(inp, pro)
		if pro then return end
		if inp.KeyCode == Enum.KeyCode.F then
			self.IsUnlocking:set(false)
		end
	end)
end

function handler:Start()

end

return handler
