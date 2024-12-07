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
    platform.Size = Vector3.new(200, 1, 200)
    platform.Position = position - Vector3.new(0, 5, 0)
    platform.Anchored = true
    platform.CanCollide = true
    platform.Material = Enum.Material.SmoothPlastic
    platform.Color = Color3.new(0, 0, 0)
    platform.Transparency = 0.5
    platform.Name = "FarlandsPlatform"
    platform.Parent = Workspace

    local highlight = Instance.new("Highlight")
    highlight.Parent = platform
    highlight.FillColor = Color3.new(0, 0, 0)
    highlight.OutlineColor = Color3.new(0, 0, 0)
    highlight.OutlineTransparency = 0
    highlight.FillTransparency = 0.5

    return platform
end

local function teleportToFarlands(humanoidRootPart)
    if isInFarlands then
        warn("Stop trying to go to the Farlands while being in the Farlands!")
        return
    end

    lastPosition = humanoidRootPart.Position
    humanoidRootPart.CFrame = CFrame.new(safeFarlandsPosition)

    farlandsPlatform = createPlatform(safeFarlandsPosition)
    isInFarlands = true
end

local function teleportBack(humanoidRootPart)
    if not isInFarlands then
        warn("Stop trying to go back when you're not even in the Farlands!")
        return
    end

    if lastPosition then
        humanoidRootPart.CFrame = CFrame.new(lastPosition)
        if farlandsPlatform then
            farlandsPlatform:Destroy()
            farlandsPlatform = nil
        end
        isInFarlands = false
    else
        warn("Error saving last position, sorry!")
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
