local cs = game:GetService("CollectionService")

local hurtboxes = {}

local function CreateHurtbox()
    local part = Instance.new("Part")

    part.Anchored = false
    part.CanCollide = false
    part.Massless = true

    part.Transparency = 0.75
    part.Material = Enum.Material.Neon
    part.Color = Color3.fromRGB(0, 255, 0)
    part:AddTag("Hurtbox")

    return part
end

function hurtboxes:Add(model: Model, data: table)
    if model:FindFirstChild("Hurtboxes") == nil then
        local folder = Instance.new("Folder")
        folder.Name = "Hurtboxes"
        folder.Parent = model
    end

    local hurtbox = CreateHurtbox()
    hurtbox.Parent = model.Hurtboxes

    hurtbox.Size = data.Size
    hurtbox.CFrame = data.CFrame

    local weld = Instance.new("Weld")
    
    weld.Part0 = data.WeldTo or model.PrimaryPart
    weld.Part1 = hurtbox

    weld.C0 = weld.Part0.CFrame:Inverse() * hurtbox.CFrame
    weld.C1 = weld.Part1.CFrame:Inverse() * hurtbox.CFrame

    weld.Parent = hurtbox

    return hurtbox
end

function hurtboxes:Init()

end

return hurtboxes