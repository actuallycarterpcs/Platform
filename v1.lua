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
    platform.Name = "FarlandsPlatform"
    platform.Parent = Workspace

    -- Create a rainbow effect
    task.spawn(function()
        while platform.Parent do
            for hue = 0, 1, 0.01 do
                platform.Color = Color3.fromHSV(hue, 1, 1)
                task.wait(0.05)
            end
        end
    end)

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

local function toggleTeleport(humanoidRootPart)
    if isInFarlands then
        teleportBack(humanoidRootPart)
    else
        teleportToFarlands(humanoidRootPart)
    end
end

local function setupCharacter(character)
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    UserInputService.InputBegan:Connect(function(input, isProcessed)
        if isProcessed then return end 

        if input.KeyCode == Enum.KeyCode.T then
            toggleTeleport(humanoidRootPart)
        end
    end)
end

player.CharacterAdded:Connect(function(character)
    setupCharacter(character)
end)

if player.Character then
    setupCharacter(player.Character)
end
