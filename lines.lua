--[[\
    Neon Trail Effect Script for Roblox Injectors
    - Leaves a permanent trailing neon line behind the player that fades out.
]]--

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local TOGGLE_NAME = "NeonTrailScriptRunning_Toggle"

local existingMarker = CoreGui:FindFirstChild(TOGGLE_NAME)
if existingMarker then
    existingMarker:Destroy()
    
    if LocalPlayer.Character then
        local oldFolder = LocalPlayer.Character:FindFirstChild("NeonTrailFolder")
        if oldFolder then oldFolder:Destroy() end
    end
    
    return
end

local marker = Instance.new("Folder")
marker.Name = TOGGLE_NAME
marker.Parent = CoreGui

local EFFECT_COLOR = Color3.fromRGB(0, 195, 255)
local TRAIL_LIFETIME = 1.5 -- Время жизни каждого сегмента шлейфа в секундах

local function setupTrailEffect(character)
    local rootPart = character:WaitForChild("HumanoidRootPart", 5)
    if not rootPart then return end

    local trailFolder = character:FindFirstChild("NeonTrailFolder")
    if trailFolder then trailFolder:Destroy() end
    
    trailFolder = Instance.new("Folder")
    trailFolder.Name = "NeonTrailFolder"
    trailFolder.Parent = character

    -- Создаем встроенный Roblox Trail для идеального плавного шлейфа
    local attachment0 = Instance.new("Attachment")
    attachment0.Name = "TrailAttachment0"
    attachment0.Position = Vector3.new(0, -1, 0)
    attachment0.Parent = rootPart

    local attachment1 = Instance.new("Attachment")
    attachment1.Name = "TrailAttachment1"
    attachment1.Position = Vector3.new(0, 1, 0)
    attachment1.Parent = rootPart

    local trail = Instance.new("Trail")
    trail.Name = "NeonPlayerTrail"
    trail.Attachment0 = attachment0
    trail.Attachment1 = attachment1
    trail.Lifetime = TRAIL_LIFETIME
    trail.MinLength = 0.1
    trail.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.1),
        NumberSequenceKeypoint.new(1, 1)
    })
    trail.Color = ColorSequence.new(EFFECT_COLOR)
    trail.LightEmission = 0.8
    trail.Texture = "rbxassetid://243047363"
    trail.Parent = trailFolder

    -- Проверка на тогл
    task.spawn(function()
        while character.Parent and CoreGui:FindFirstChild(TOGGLE_NAME) do
            task.wait(0.5)
        end
        attachment0:Destroy()
        attachment1:Destroy()
        trail:Destroy()
    end)
end

LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    if not CoreGui:FindFirstChild(TOGGLE_NAME) then return end
    task.spawn(setupTrailEffect, newCharacter)
end)

if LocalPlayer.Character then
    task.spawn(setupTrailEffect, LocalPlayer.Character)
end
