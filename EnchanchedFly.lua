-- Delta Executor Fly Script - Fixed Version
-- Minimalist GUI with draggable interface

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables
local flyEnabled = false
local flySpeed = 1
local bodyVelocity = nil
local bodyAngularVelocity = nil
local flying = false
local flyConnection = nil

-- GUI Creation
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main Frame (Draggable)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 220, 0, 180)
mainFrame.Position = UDim2.new(0, 50, 0, 50)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Title Bar
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
titleLabel.Text = "Enhanced Fly Script"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Parent = titleBar

-- Enable Button
local enableButton = Instance.new("TextButton")
enableButton.Name = "EnableButton"
enableButton.Size = UDim2.new(0, 200, 0, 30)
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
speedFrame.Position = UDim2.new(0, 10, 0, 75)
speedFrame.BackgroundTransparency = 1
speedFrame.Parent = mainFrame

-- Speed Decrease Button
local speedDownButton = Instance.new("TextButton")
speedDownButton.Name = "SpeedDown"
speedDownButton.Size = UDim2.new(0, 30, 0, 30)
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
speedUpButton.Size = UDim2.new(0, 30, 0, 30)
speedUpButton.Position = UDim2.new(0, 40, 0, 0)
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
speedLabel.Size = UDim2.new(0, 120, 0, 30)
speedLabel.Position = UDim2.new(0, 80, 0, 0)
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
controlFrame.Size = UDim2.new(1, -20, 0, 35)
controlFrame.Position = UDim2.new(0, 10, 0, 115)
controlFrame.BackgroundTransparency = 1
controlFrame.Parent = mainFrame

-- Hide Button (X)
local hideButton = Instance.new("TextButton")
hideButton.Name = "HideButton"
hideButton.Size = UDim2.new(0, 95, 0, 30)
hideButton.Position = UDim2.new(0, 0, 0, 0)
hideButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
hideButton.BorderSizePixel = 1
hideButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
hideButton.Text = "X (Hide)"
hideButton.TextColor3 = Color3.fromRGB(0, 0, 0)
hideButton.TextScaled = true
hideButton.Font = Enum.Font.SourceSans
hideButton.Parent = controlFrame

-- Show Button (V) - Initially hidden
local showButton = Instance.new("TextButton")
showButton.Name = "ShowButton"
showButton.Size = UDim2.new(0, 95, 0, 30)
showButton.Position = UDim2.new(0, 105, 0, 0)
showButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
showButton.BorderSizePixel = 1
showButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
showButton.Text = "V (Show)"
showButton.TextColor3 = Color3.fromRGB(0, 0, 0)
showButton.TextScaled = true
showButton.Font = Enum.Font.SourceSans
showButton.Visible = false
showButton.Parent = screenGui

-- Instructions Label
local instructionLabel = Instance.new("TextLabel")
instructionLabel.Name = "InstructionLabel"
instructionLabel.Size = UDim2.new(1, -20, 0, 20)
instructionLabel.Position = UDim2.new(0, 10, 0, 155)
instructionLabel.BackgroundTransparency = 1
instructionLabel.Text = "WASD: Move | Space/Shift: Up/Down"
instructionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
instructionLabel.TextSize = 12
instructionLabel.Font = Enum.Font.SourceSans
instructionLabel.Parent = mainFrame

-- Fly Functions
local function startFlying()
    local character = player.Character
    if not character then return false end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return false end
    
    -- Create BodyVelocity
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = rootPart
    
    -- Create BodyAngularVelocity
    bodyAngularVelocity = Instance.new("BodyAngularVelocity")
    bodyAngularVelocity.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyAngularVelocity.AngularVelocity = Vector3.new(0, 0, 0)
    bodyAngularVelocity.Parent = rootPart
    
    -- Disable character states
    humanoid.PlatformStand = true
    
    flying = true
    
    -- Start fly loop
    flyConnection = RunService.Heartbeat:Connect(function()
        if flying and bodyVelocity and rootPart then
            local camera = workspace.CurrentCamera
            local direction = Vector3.new(0, 0, 0)
            
            -- Movement controls
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                direction = direction + camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                direction = direction - camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                direction = direction - camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                direction = direction + camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                direction = direction + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                direction = direction - Vector3.new(0, 1, 0)
            end
            
            -- Apply velocity
            bodyVelocity.Velocity = direction * (flySpeed * 16)
        end
    end)
    
    return true
end

local function stopFlying()
    flying = false
    
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    
    if bodyAngularVelocity then
        bodyAngularVelocity:Destroy()
        bodyAngularVelocity = nil
    end
    
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
        end
    end
end

-- Button Events
enableButton.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    
    if flyEnabled then
        enableButton.Text = "Disable"
        enableButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        
        if not startFlying() then
            flyEnabled = false
            enableButton.Text = "Enable"
            enableButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        end
    else
        enableButton.Text = "Enable"
        enableButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        stopFlying()
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
    showButton.Visible = true
    showButton.Position = UDim2.new(0, 50, 0, 50)
end)

showButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    showButton.Visible = false
end)

-- Character respawn handling
player.CharacterAdded:Connect(function()
    wait(2)
    if flyEnabled then
        stopFlying()
        wait(1)
        if not startFlying() then
            flyEnabled = false
            enableButton.Text = "Enable"
            enableButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        end
    end
end)

-- Show GUI immediately when script loads
mainFrame.Visible = true

print("Enhanced Fly Script loaded successfully!")
print("GUI is now visible!")
print("Controls:")
print("- WASD: Movement")
print("- Space: Fly Up") 
print("- Left Shift: Fly Down")
print("- Click X button to hide GUI")
print("- Click V button to show GUI")
