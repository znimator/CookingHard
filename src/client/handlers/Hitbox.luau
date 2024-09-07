local rp = game:GetService("ReplicatedStorage")
local cs = game:GetService("CollectionService")
local debris = game:GetService("Debris")

local plr = game.Players.LocalPlayer

local EntityHandler = require(rp.Handlers.Entity)

local Hitbox = {}

local function VisualiseHitbox(size: Vector3, cf: CFrame)
    local part = Instance.new("Part")

    part.Anchored = true
    part.CanCollide = false
    part.Massless = true
    part.Transparency = 0.85
    part.Material = Enum.Material.Neon
    part.Color = Color3.fromRGB(255, 0, 0)
    part.Size = size
    part.CFrame = cf
    part.Parent = workspace.Temp

    debris:AddItem(part, 0.15)

    return part
end

function Hitbox:Cast(size: Vector3, cf: CFrame, callback : (entity: EntityHandler.Entity) -> ())
    local params = OverlapParams.new()

    params.FilterType = Enum.RaycastFilterType.Include
    params.FilterDescendantsInstances = {cs:GetTagged("Hurtbox")}

    local hits = workspace:GetPartBoundsInBox(cf, size, params)

    VisualiseHitbox(size, cf)

    if #hits == 0 then
        return
    end

    for _, v in hits do
        local entity = EntityHandler:GetEntity(v.Parent.Parent)

        if entity == nil then
            continue
        end

        callback(entity)
    end

end

return Hitbox