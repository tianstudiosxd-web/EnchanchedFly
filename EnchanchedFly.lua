-- Delta Executor Fly Script
-- Minimalist GUI with draggable interface

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables
local flyEnabled = false
local flySpeed = 1
local bodyVelocity = nil
local bodyPosition = nil
local flying = false

-- GUI Creation
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main Frame (Draggable)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 200, 0, 160)
mainFrame.Position = UDim2.new(0, 50, 0, 50)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
mainFrame.Parent = screenGui

-- Title Bar for dragging
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 25)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
titleBar.BorderSizePixel = 1
titleBar.BorderColor3 = Color3.fromRGB(255, 255, 255)
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Fly Script"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.SourceSans
titleLabel.Parent = titleBar

-- Enable Button
local enableButton = Instance.new("TextButton")
enableButton.Name = "EnableButton"
enableButton.Size = UDim2.new(0, 180, 0, 25)
enableButton.Position = UDim2.new(0, 10, 0, 35)
enableButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
enableButton.BorderSizePixel = 1
enableButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
enableButton.Text = "Enable"
enableButton.TextColor3 = Color3.fromRGB(0, 0, 0)
enableButton.TextScaled = true
enableButton.Font = Enum.Font.SourceSansBold
enableButton.Parent = mainFrame

-- Speed Controls Frame
local speedFrame = Instance.new("Frame")
speedFrame.Name = "SpeedFrame"
speedFrame.Size = UDim2.new(1, -20, 0, 30)
speedFrame.Position = UDim2.new(0, 10, 0, 70)
speedFrame.BackgroundTransparency = 1
speedFrame.Parent = mainFrame

-- Speed Decrease Button
local speedDownButton = Instance.new("TextButton")
speedDownButton.Name = "SpeedDown"
speedDownButton.Size = UDim2.new(0, 25, 0, 25)
speedDownButton.Position = UDim2.new(0, 0, 0, 0)
speedDownButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
speedDownButton.BorderSizePixel = 1
speedDownButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
speedDownButton.Text = "-"
speedDownButton.TextColor3 = Color3.fromRGB(0, 0, 0)
speedDownButton.TextScaled = true
speedDownButton.Font = Enum.Font.SourceSansBold
speedDownButton.Parent = speedFrame

-- Speed Increase Button
local speedUpButton = Instance.new("TextButton")
speedUpButton.Name = "SpeedUp"
speedUpButton.Size = UDim2.new(0, 25, 0, 25)
speedUpButton.Position = UDim2.new(0, 35, 0, 0)
speedUpButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
speedUpButton.BorderSizePixel = 1
speedUpButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
speedUpButton.Text = "+"
speedUpButton.TextColor3 = Color3.fromRGB(0, 0, 0)
speedUpButton.TextScaled = true
speedUpButton.Font = Enum.Font.SourceSansBold
speedUpButton.Parent = speedFrame

-- Speed Display
local speedLabel = Instance.new("TextLabel")
speedLabel.Name = "SpeedLabel"
speedLabel.Size = UDim2.new(0, 110, 0, 25)
speedLabel.Position = UDim2.new(0, 70, 0, 0)
speedLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.BorderSizePixel = 1
speedLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
speedLabel.Text = "Speed: 1"
speedLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.SourceSans
speedLabel.Parent = speedFrame

-- Control Buttons Frame
local controlFrame = Instance.new("Frame")
controlFrame.Name = "ControlFrame"
controlFrame.Size = UDim2.new(1, -20, 0, 30)
controlFrame.Position = UDim2.new(0, 10, 0, 110)
controlFrame.BackgroundTransparency = 1
controlFrame.Parent = mainFrame

-- Hide Button
local hideButton = Instance.new("TextButton")
hideButton.Name = "HideButton"
hideButton.Size = UDim2.new(0, 85, 0, 25)
hideButton.Position = UDim2.new(0, 0, 0, 0)
hideButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
hideButton.BorderSizePixel = 1
hideButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
hideButton.Text = "X (Hide)"
hideButton.TextColor3 = Color3.fromRGB(0, 0, 0)
hideButton.TextScaled = true
hideButton.Font = Enum.Font.SourceSans
hideButton.Parent = controlFrame

-- Show Button
local showButton = Instance.new("TextButton")
showButton.Name = "ShowButton"
showButton.Size = UDim2.new(0, 85, 0, 25)
showButton.Position = UDim2.new(0, 95, 0, 0)
showButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
showButton.BorderSizePixel = 1
showButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
showButton.Text = "V (Show)"
showButton.TextColor3 = Color3.fromRGB(0, 0, 0)
showButton.TextScaled = true
showButton.Font = Enum.Font.SourceSans
showButton.Parent = controlFrame

-- Instructions Label
local instructionLabel = Instance.new("TextLabel")
instructionLabel.Name = "InstructionLabel"
instructionLabel.Size = UDim2.new(1, -20, 0, 15)
instructionLabel.Position = UDim2.new(0, 10, 0, 142)
instructionLabel.BackgroundTransparency = 1
instructionLabel.Text = "WASD: Move | Space/Shift: Up/Down"
instructionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
instructionLabel.TextScaled = true
instructionLabel.Font = Enum.Font.SourceSans
instructionLabel.Parent = mainFrame

-- Dragging functionality
local dragging = false
local dragStart = nil
local startPos = nil

local function updateDrag(input)
    local delta = input.Position - dragStart
    local newPosition = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    mainFrame.Position = newPosition
end

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        updateDrag(input)
    end
end)

-- Fly Functions
local function createFlyObjects()
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return false
    end
    
    local rootPart = character.HumanoidRootPart
    
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = rootPart
    
    bodyPosition = Instance.new("BodyPosition")
    bodyPosition.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyPosition.Position = rootPart.Position
    bodyPosition.Parent = rootPart
    
    return true
end

local function removeFlyObjects()
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    if bodyPosition then
        bodyPosition:Destroy()
        bodyPosition = nil
    end
end

local function updateFly()
    if not flying or not bodyVelocity or not bodyPosition then return end
    
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local rootPart = character.HumanoidRootPart
    local camera = workspace.CurrentCamera
    local moveVector = Vector3.new(0, 0, 0)
    
    -- Get input
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        moveVector = moveVector + camera.CFrame.LookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        moveVector = moveVector - camera.CFrame.LookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        moveVector = moveVector - camera.CFrame.RightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        moveVector = moveVector + camera.CFrame.RightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        moveVector = moveVector + Vector3.new(0, 1, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        moveVector = moveVector - Vector3.new(0, 1, 0)
    end
    
    -- Apply movement
    local speed = flySpeed * 16
    bodyVelocity.Velocity = moveVector * speed
    bodyPosition.Position = rootPart.Position + (moveVector * speed * 0.1)
end

-- Button Functions
enableButton.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    
    if flyEnabled then
        enableButton.Text = "Disable"
        enableButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        
        if createFlyObjects() then
            flying = true
            local character = player.Character
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.PlatformStand = true
            end
        end
    else
        enableButton.Text = "Enable"
        enableButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        flying = false
        
        removeFlyObjects()
        
        local character = player.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.PlatformStand = false
        end
    end
end)

speedUpButton.MouseButton1Click:Connect(function()
    if flySpeed < 10 then
        flySpeed = flySpeed + 1
        speedLabel.Text = "Speed: " .. flySpeed
    end
end)

speedDownButton.MouseButton1Click:Connect(function()
    if flySpeed > 1 then
        flySpeed = flySpeed - 1
        speedLabel.Text = "Speed: " .. flySpeed
    end
end)

hideButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

showButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
end)

-- Keyboard shortcuts
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.X then
        mainFrame.Visible = false
    elseif input.KeyCode == Enum.KeyCode.V then
        mainFrame.Visible = true
    end
end)

-- Update loop
RunService.Heartbeat:Connect(updateFly)

-- Character respawn handling
player.CharacterAdded:Connect(function()
    wait(1)
    if flyEnabled then
        flying = false
        removeFlyObjects()
        wait(0.5)
        if createFlyObjects() then
            flying = true
            local character = player.Character
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.PlatformStand = true
            end
        end
    end
end)

print("Fly Script loaded successfully!")
print("Controls:")
print("- WASD: Movement")
print("- Space: Fly Up")
print("- Left Shift: Fly Down")
print("- X: Hide GUI")
print("- V: Show GUI")lySpeed, 0)
        wait(0.1)
        bodyVelocity.Velocity = bodyVelocity.Velocity - Vector3.new(0, -flySpeed, 0)
    end
end)

closeButton.MouseButton1Click:Connect(function()
    if flying then stopFly() end
    screenGui:Destroy()
end)

-- Kontrol keyboard
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if flying then
        if input.KeyCode == Enum.KeyCode.Space then
            if bodyVelocity then
                bodyVelocity.Velocity = bodyVelocity.Velocity + Vector3.new(0, flySpeed, 0)
            end
        elseif input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
            if bodyVelocity then
                bodyVelocity.Velocity = bodyVelocity.Velocity + Vector3.new(0, -flySpeed, 0)
            end
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if flying then
        if input.KeyCode == Enum.KeyCode.Space then
            if bodyVelocity then
                bodyVelocity.Velocity = bodyVelocity.Velocity - Vector3.new(0, flySpeed, 0)
            end
        elseif input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
            if bodyVelocity then
                bodyVelocity.Velocity = bodyVelocity.Velocity - Vector3.new(0, -flySpeed, 0)
            end
        end
    end
end)

-- Update loop
RunService.Heartbeat:Connect(function()
    updateFly()
end)

-- Handle character respawn
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    if flying then
        flying = false
        stopFly()
    end
end)

-- Drag functionality untuk GUI
local dragging = false
local dragInput, mousePos, framePos

local function updateInput(input)
    local delta = input.Position - mousePos
    mainFrame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
end

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateInput(input)
    end
end)

print("Fly GUI berhasil dimuat! Gunakan tombol di GUI untuk mengontrol fly.")
print("Kontrol keyboard: Space = Naik, Shift = Turun, WASD = Bergerak")
