-- Delta Executor Enhanced Fly Script - Mobile Version (Fixed Movement)
-- GUI with Roblox Default Movement Controls - Improved Direction System

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables
local flyEnabled = false
local flySpeed = 1
local flying = false
local flyConnection = nil

-- GUI Creation
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MobileFlyGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main Frame (Draggable and Resizable)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 250, 0, 200)
mainFrame.Position = UDim2.new(0, 20, 0, 20)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Resize Handle (Bottom Right Corner)
local resizeHandle = Instance.new("Frame")
resizeHandle.Name = "ResizeHandle"
resizeHandle.Size = UDim2.new(0, 20, 0, 20)
resizeHandle.Position = UDim2.new(1, -20, 1, -20)
resizeHandle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
resizeHandle.BorderSizePixel = 1
resizeHandle.BorderColor3 = Color3.fromRGB(255, 255, 255)
resizeHandle.Active = true
resizeHandle.Parent = mainFrame

local resizeIndicator = Instance.new("TextLabel")
resizeIndicator.Size = UDim2.new(1, 0, 1, 0)
resizeIndicator.BackgroundTransparency = 1
resizeIndicator.Text = "⟋"
resizeIndicator.TextColor3 = Color3.fromRGB(255, 255, 255)
resizeIndicator.TextScaled = true
resizeIndicator.Font = Enum.Font.SourceSans
resizeIndicator.Parent = resizeHandle

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
enableButton.Size = UDim2.new(1, -20, 0, 30)
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

local speedDownButton = Instance.new("TextButton")
speedDownButton.Name = "SpeedDown"
speedDownButton.Size = UDim2.new(0, 30, 1, 0)
speedDownButton.Position = UDim2.new(0, 0, 0, 0)
speedDownButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
speedDownButton.BorderSizePixel = 1
speedDownButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
speedDownButton.Text = "-"
speedDownButton.TextColor3 = Color3.fromRGB(0, 0, 0)
speedDownButton.TextScaled = true
speedDownButton.Font = Enum.Font.SourceSansBold
speedDownButton.Parent = speedFrame

local speedUpButton = Instance.new("TextButton")
speedUpButton.Name = "SpeedUp"
speedUpButton.Size = UDim2.new(0, 30, 1, 0)
speedUpButton.Position = UDim2.new(0, 40, 0, 0)
speedUpButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
speedUpButton.BorderSizePixel = 1
speedUpButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
speedUpButton.Text = "+"
speedUpButton.TextColor3 = Color3.fromRGB(0, 0, 0)
speedUpButton.TextScaled = true
speedUpButton.Font = Enum.Font.SourceSansBold
speedUpButton.Parent = speedFrame

local speedLabel = Instance.new("TextLabel")
speedLabel.Name = "SpeedLabel"
speedLabel.Size = UDim2.new(1, -80, 1, 0)
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

local hideButton = Instance.new("TextButton")
hideButton.Name = "HideButton"
hideButton.Size = UDim2.new(0.48, 0, 1, 0)
hideButton.Position = UDim2.new(0, 0, 0, 0)
hideButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
hideButton.BorderSizePixel = 1
hideButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
hideButton.Text = "X (Hide)"
hideButton.TextColor3 = Color3.fromRGB(0, 0, 0)
hideButton.TextScaled = true
hideButton.Font = Enum.Font.SourceSans
hideButton.Parent = controlFrame

local showButton = Instance.new("TextButton")
showButton.Name = "ShowButton"
showButton.Size = UDim2.new(0, 100, 0, 30)
showButton.Position = UDim2.new(0, 20, 0, 20)
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
instructionLabel.Size = UDim2.new(1, -20, 0, 25)
instructionLabel.Position = UDim2.new(0, 10, 1, -30)
instructionLabel.BackgroundTransparency = 1
instructionLabel.Text = "Joystick: Gerak | Layar: Arah | UP/DOWN: Naik/Turun"
instructionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
instructionLabel.TextSize = 10
instructionLabel.Font = Enum.Font.SourceSans
instructionLabel.Parent = mainFrame

-- Up/Down Control Buttons
local upDownFrame = Instance.new("Frame")
upDownFrame.Name = "UpDownFrame"
upDownFrame.Size = UDim2.new(0, 60, 0, 120)
upDownFrame.Position = UDim2.new(1, -80, 1, -140)
upDownFrame.BackgroundTransparency = 1
upDownFrame.Parent = screenGui

-- Up Button
local upButton = Instance.new("TextButton")
upButton.Name = "UpButton"
upButton.Size = UDim2.new(1, 0, 0, 55)
upButton.Position = UDim2.new(0, 0, 0, 0)
upButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
upButton.BorderSizePixel = 2
upButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
upButton.Text = "UP"
upButton.TextColor3 = Color3.fromRGB(0, 0, 0)
upButton.TextScaled = true
upButton.Font = Enum.Font.SourceSansBold
upButton.Parent = upDownFrame

-- Down Button
local downButton = Instance.new("TextButton")
downButton.Name = "DownButton"
downButton.Size = UDim2.new(1, 0, 0, 55)
downButton.Position = UDim2.new(0, 0, 0, 65)
downButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
downButton.BorderSizePixel = 2
downButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
downButton.Text = "DOWN"
downButton.TextColor3 = Color3.fromRGB(0, 0, 0)
downButton.TextScaled = true
downButton.Font = Enum.Font.SourceSansBold
downButton.Parent = upDownFrame

-- Movement Variables
local isUpPressed = false
local isDownPressed = false

-- Resize Functionality
local resizing = false
local resizeStart = nil
local startSize = nil

resizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        resizing = true
        resizeStart = input.Position
        startSize = mainFrame.Size
        mainFrame.Draggable = false
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                resizing = false
                mainFrame.Draggable = true
            end
        end)
    end
end)

resizeHandle.InputChanged:Connect(function(input)
    if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - resizeStart
        local newWidth = math.max(200, startSize.X.Offset + delta.X)
        local newHeight = math.max(150, startSize.Y.Offset + delta.Y)
        mainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
    end
end)

-- Up/Down Button Events
upButton.MouseButton1Down:Connect(function()
    isUpPressed = true
    upButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
end)

upButton.MouseButton1Up:Connect(function()
    isUpPressed = false
    upButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
end)

upButton.TouchTap:Connect(function()
    isUpPressed = not isUpPressed
    if isUpPressed then
        upButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    else
        upButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

downButton.MouseButton1Down:Connect(function()
    isDownPressed = true
    downButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
end)

downButton.MouseButton1Up:Connect(function()
    isDownPressed = false
    downButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
end)

downButton.TouchTap:Connect(function()
    isDownPressed = not isDownPressed
    if isDownPressed then
        downButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    else
        downButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

-- Function to get movement vector from Roblox default controls
local function getMoveVector()
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        return Vector3.new(0, 0, 0)
    end
    
    -- Get movement direction from Roblox's default controls (joystick input)
    return humanoid.MoveDirection
end

-- Improved Fly Functions with proper direction system
local function startFlying()
    local character = player.Character
    if not character then return false end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return false end
    
    -- Clean up existing fly objects
    for _, obj in pairs(rootPart:GetChildren()) do
        if obj:IsA("BodyVelocity") or obj:IsA("BodyPosition") or obj:IsA("BodyAngularVelocity") then
            obj:Destroy()
        end
    end
    
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = rootPart
    
    local bodyAngularVelocity = Instance.new("BodyAngularVelocity")
    bodyAngularVelocity.MaxTorque = Vector3.new(0, math.huge, 0)
    bodyAngularVelocity.AngularVelocity = Vector3.new(0, 0, 0)
    bodyAngularVelocity.Parent = rootPart
    
    -- Disable default walking
    humanoid.PlatformStand = true
    
    flying = true
    
    -- Show up/down controls
    upDownFrame.Visible = true
    
    -- Start fly loop
    flyConnection = RunService.Heartbeat:Connect(function()
        if flying and bodyVelocity and bodyVelocity.Parent then
            local camera = workspace.CurrentCamera
            local direction = Vector3.new(0, 0, 0)
            
            -- Get horizontal movement from Roblox default joystick
            local moveDirection = getMoveVector()
            if moveDirection.Magnitude > 0 then
                -- Use rootPart orientation instead of camera for movement direction
                -- This makes joystick control the actual movement, not relative to camera
                local rootCFrame = rootPart.CFrame
                local rightVector = rootCFrame.RightVector
                local forwardVector = rootCFrame.LookVector
                
                -- Apply joystick input directly to character's orientation
                direction = direction + (rightVector * moveDirection.X) + (forwardVector * -moveDirection.Z)
            end
            
            -- Handle keyboard up/down for PC
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                direction = direction + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                direction = direction - Vector3.new(0, 1, 0)
            end
            
            -- Handle mobile up/down buttons
            if isUpPressed then
                direction = direction + Vector3.new(0, 1, 0)
            end
            if isDownPressed then
                direction = direction - Vector3.new(0, 1, 0)
            end
            
            -- Apply velocity
            local speed = flySpeed * 50
            bodyVelocity.Velocity = direction * speed
            
            -- Character rotation follows camera look direction (for turning)
            local cameraCFrame = camera.CFrame
            local lookDirection = Vector3.new(cameraCFrame.LookVector.X, 0, cameraCFrame.LookVector.Z).Unit
            local targetCFrame = CFrame.lookAt(rootPart.Position, rootPart.Position + lookDirection)
            
            -- Smooth rotation towards camera direction
            rootPart.CFrame = rootPart.CFrame:Lerp(targetCFrame, 0.1)
            
            -- Keep character upright
            if bodyAngularVelocity and bodyAngularVelocity.Parent then
                bodyAngularVelocity.AngularVelocity = Vector3.new(0, 0, 0)
            end
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
    
    -- Hide up/down controls
    upDownFrame.Visible = false
    
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        
        if humanoid then
            humanoid.PlatformStand = false
        end
        
        if rootPart then
            for _, obj in pairs(rootPart:GetChildren()) do
                if obj:IsA("BodyVelocity") or obj:IsA("BodyPosition") or obj:IsA("BodyAngularVelocity") then
                    obj:Destroy()
                end
            end
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
            warn("Failed to start flying - Character not loaded")
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
    -- Keep up/down buttons visible when main GUI is hidden if fly is enabled
end)

showButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    showButton.Visible = false
end)

-- Character respawn handling
player.CharacterAdded:Connect(function()
    wait(3)
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

-- Initialize - Hide up/down controls initially
upDownFrame.Visible = false

print("Enhanced Fly Script loaded successfully!")
print("SISTEM KONTROL YANG DIPERBAIKI:")
print("✅ JOYSTICK ROBLOX = Mengatur pergerakan (maju/mundur/kiri/kanan)")
print("✅ LAYAR/SWIPE = Mengatur arah pandang dan arah terbang")  
print("✅ UP/DOWN BUTTON = Naik dan turun")
print("")
print("Cara menggunakan:")
print("1. Tekan 'Enable' untuk mulai terbang")
print("2. Gunakan JOYSTICK untuk bergerak (maju/mundur/kiri/kanan)")
print("3. Geser/swipe LAYAR untuk mengatur arah pandang") 
print("4. Gunakan tombol UP/DOWN untuk naik/turun")
print("5. Karakter akan mengikuti arah pandang kamera")
print("6. Drag sudut kanan bawah GUI untuk resize")
