-- Roblox Fly GUI Script untuk Delta Executor
-- Dibuat dengan antarmuka yang bagus dan kontrol lengkap

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Variabel Fly
local flying = false
local flySpeed = 50
local bodyVelocity
local bodyAngularVelocity

-- Membuat GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Frame utama
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 280, 0, 220)
mainFrame.Position = UDim2.new(1, -290, 0.5, -110)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Membuat corner untuk frame utama
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Gradient untuk frame utama
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 45)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 25))
}
gradient.Rotation = 45
gradient.Parent = mainFrame

-- Header
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 40)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

-- Title
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "✈️ Fly Control"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = header

-- Close button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
closeButton.BorderSizePixel = 0
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

-- Status indicator
local statusFrame = Instance.new("Frame")
statusFrame.Name = "StatusFrame"
statusFrame.Size = UDim2.new(1, -20, 0, 30)
statusFrame.Position = UDim2.new(0, 10, 0, 50)
statusFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
statusFrame.BorderSizePixel = 0
statusFrame.Parent = mainFrame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 8)
statusCorner.Parent = statusFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, -20, 1, 0)
statusLabel.Position = UDim2.new(0, 10, 0, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Disabled"
statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = statusFrame

-- Tombol Fly On/Off
local flyToggleButton = Instance.new("TextButton")
flyToggleButton.Name = "FlyToggleButton"
flyToggleButton.Size = UDim2.new(1, -20, 0, 35)
flyToggleButton.Position = UDim2.new(0, 10, 0, 90)
flyToggleButton.BackgroundColor3 = Color3.fromRGB(85, 170, 85)
flyToggleButton.BorderSizePixel = 0
flyToggleButton.Text = "🚀 Enable Fly"
flyToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyToggleButton.TextScaled = true
flyToggleButton.Font = Enum.Font.GothamBold
flyToggleButton.Parent = mainFrame

local flyToggleCorner = Instance.new("UICorner")
flyToggleCorner.CornerRadius = UDim.new(0, 8)
flyToggleCorner.Parent = flyToggleButton

-- Tombol naik
local upButton = Instance.new("TextButton")
upButton.Name = "UpButton"
upButton.Size = UDim2.new(0.48, 0, 0, 35)
upButton.Position = UDim2.new(0, 10, 0, 135)
upButton.BackgroundColor3 = Color3.fromRGB(85, 85, 170)
upButton.BorderSizePixel = 0
upButton.Text = "⬆️ UP"
upButton.TextColor3 = Color3.fromRGB(255, 255, 255)
upButton.TextScaled = true
upButton.Font = Enum.Font.GothamBold
upButton.Visible = false
upButton.Parent = mainFrame

local upCorner = Instance.new("UICorner")
upCorner.CornerRadius = UDim.new(0, 8)
upCorner.Parent = upButton

-- Tombol turun
local downButton = Instance.new("TextButton")
downButton.Name = "DownButton"
downButton.Size = UDim2.new(0.48, 0, 0, 35)
downButton.Position = UDim2.new(0.52, 0, 0, 135)
downButton.BackgroundColor3 = Color3.fromRGB(170, 85, 85)
downButton.BorderSizePixel = 0
downButton.Text = "⬇️ DOWN"
downButton.TextColor3 = Color3.fromRGB(255, 255, 255)
downButton.TextScaled = true
downButton.Font = Enum.Font.GothamBold
downButton.Visible = false
downButton.Parent = mainFrame

local downCorner = Instance.new("UICorner")
downCorner.CornerRadius = UDim.new(0, 8)
downCorner.Parent = downButton

-- Speed slider
local speedFrame = Instance.new("Frame")
speedFrame.Name = "SpeedFrame"
speedFrame.Size = UDim2.new(1, -20, 0, 25)
speedFrame.Position = UDim2.new(0, 10, 0, 180)
speedFrame.BackgroundTransparency = 1
speedFrame.Visible = false
speedFrame.Parent = mainFrame

local speedLabel = Instance.new("TextLabel")
speedLabel.Name = "SpeedLabel"
speedLabel.Size = UDim2.new(0, 80, 1, 0)
speedLabel.Position = UDim2.new(0, 0, 0, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: 50"
speedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.Gotham
speedLabel.Parent = speedFrame

-- Fungsi untuk membuat efek hover pada tombol
local function addButtonEffect(button, hoverColor, clickColor)
    local originalColor = button.BackgroundColor3
    
    button.MouseEnter:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor})
        tween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = originalColor})
        tween:Play()
    end)
    
    button.MouseButton1Down:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = clickColor})
        tween:Play()
    end)
    
    button.MouseButton1Up:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = hoverColor})
        tween:Play()
    end)
end

-- Menambahkan efek hover ke semua tombol
addButtonEffect(flyToggleButton, Color3.fromRGB(95, 180, 95), Color3.fromRGB(75, 160, 75))
addButtonEffect(upButton, Color3.fromRGB(95, 95, 180), Color3.fromRGB(75, 75, 160))
addButtonEffect(downButton, Color3.fromRGB(180, 95, 95), Color3.fromRGB(160, 75, 75))
addButtonEffect(closeButton, Color3.fromRGB(255, 95, 95), Color3.fromRGB(235, 75, 75))

-- Fungsi Fly
local function startFly()
    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyAngularVelocity then bodyAngularVelocity:Destroy() end
    
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = rootPart
    
    bodyAngularVelocity = Instance.new("BodyAngularVelocity")
    bodyAngularVelocity.MaxTorque = Vector3.new(0, math.huge, 0)
    bodyAngularVelocity.AngularVelocity = Vector3.new(0, 0, 0)
    bodyAngularVelocity.Parent = rootPart
    
    flying = true
    humanoid.PlatformStand = true
    
    -- Update UI
    statusLabel.Text = "Status: Flying ✈️"
    statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    flyToggleButton.Text = "🛑 Disable Fly"
    flyToggleButton.BackgroundColor3 = Color3.fromRGB(170, 85, 85)
    upButton.Visible = true
    downButton.Visible = true
    speedFrame.Visible = true
end

local function stopFly()
    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyAngularVelocity then bodyAngularVelocity:Destroy() end
    
    flying = false
    humanoid.PlatformStand = false
    
    -- Update UI
    statusLabel.Text = "Status: Disabled"
    statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    flyToggleButton.Text = "🚀 Enable Fly"
    flyToggleButton.BackgroundColor3 = Color3.fromRGB(85, 170, 85)
    upButton.Visible = false
    downButton.Visible = false
    speedFrame.Visible = false
end

-- Kontrol gerakan
local function updateFly()
    if not flying or not bodyVelocity then return end
    
    local camera = workspace.CurrentCamera
    local moveVector = humanoid.MoveDirection
    local lookVector = camera.CFrame.LookVector
    local rightVector = camera.CFrame.RightVector
    
    local velocity = Vector3.new(0, 0, 0)
    
    if moveVector.Magnitude > 0 then
        velocity = (lookVector * moveVector.Z + rightVector * moveVector.X) * flySpeed
    end
    
    bodyVelocity.Velocity = velocity
end

-- Event handlers
flyToggleButton.MouseButton1Click:Connect(function()
    if flying then
        stopFly()
    else
        startFly()
    end
end)

upButton.MouseButton1Click:Connect(function()
    if flying and bodyVelocity then
        bodyVelocity.Velocity = bodyVelocity.Velocity + Vector3.new(0, flySpeed, 0)
        wait(0.1)
        bodyVelocity.Velocity = bodyVelocity.Velocity - Vector3.new(0, flySpeed, 0)
    end
end)

downButton.MouseButton1Click:Connect(function()
    if flying and bodyVelocity then
        bodyVelocity.Velocity = bodyVelocity.Velocity + Vector3.new(0, -flySpeed, 0)
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
