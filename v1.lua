local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer

local lastPosition
local safeFarlandsPosition = Vector3.new(10000, 500, 10000)

local isInFarlands = false
local farlandsPlatform

local function createPlatform(position)
    local platform = Instance.new("Part")
    platform.Size = Vector3.new(50, 1, 50)
    platform.Position = position - Vector3.new(0, 5, 0)
    platform.Anchored = true
    platform.CanCollide = true
    platform.Material = Enum.Material.SmoothPlastic
    platform.Color = Color3.new(1, 0, 0)
    platform.Name = "FarlandsPlatform"
    platform.Parent = Workspace
    return platform
end

local function cleanupObby()
    -- No obby parts to clean up anymore
end

local function teleportToFarlands(humanoidRootPart)
    if isInFarlands then
        warn("stop tryna go to the platform, ur alr there")
        return
    end

    lastPosition = humanoidRootPart.Position
    humanoidRootPart.CFrame = CFrame.new(safeFarlandsPosition)

    farlandsPlatform = createPlatform(safeFarlandsPosition)
    isInFarlands = true

    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "teleport",
        Text = "platform",
        Duration = 3
    })
end

local function teleportBack(humanoidRootPart)
    if not isInFarlands then
        warn("stop trying to go back when ur not even in the platform")
        return
    end

    if lastPosition then
        humanoidRootPart.CFrame = CFrame.new(lastPosition)
        if farlandsPlatform then
            farlandsPlatform:Destroy()
            farlandsPlatform = nil
        end
        isInFarlands = false

        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "teleported",
            Text = "back",
            Duration = 3
        })
    else
        warn("error saving last position sorry")
    end
end

local function setupCharacter(character)
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    UserInputService.InputBegan:Connect(function(input, isProcessed)
        if isProcessed then return end

        if input.KeyCode == Enum.KeyCode.T then
            teleportToFarlands(humanoidRootPart)
        elseif input.KeyCode == Enum.KeyCode.R then
            teleportBack(humanoidRootPart)
        end
    end)
end

player.CharacterAdded:Connect(function(character)
    setupCharacter(character)
end)

if player.Character then
    setupCharacter(player.Character)
end
