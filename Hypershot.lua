local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

local EspEnabled = false
local ESP_COLOR = Color3.fromRGB(155, 90, 255)
local activeEspObjects = {}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "QuantumLightMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

local success, targetParent = pcall(function() return gethui() end)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local EspEnabled = false
local AimEnabled = false
local WallCheckEnabled = false
local ESP_COLOR = Color3.fromRGB(155, 90, 255)
local GUI_COLOR = Color3.fromRGB(155, 90, 255)
local activeEspObjects = {}
local AimSmoothness = 6
local AimRadius = 200
local MaxAimDistance = 500
local EspBoxSizeX = 4
local EspBoxSizeY = 6

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GuardCheatRecode2"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
local success, targetParent = pcall(function() return gethui() end)
ScreenGui.Parent = (success and targetParent) or CoreGui

local ToggleMenuBtn = Instance.new("TextButton")
ToggleMenuBtn.Size = UDim2.new(0, 32, 0, 32)
ToggleMenuBtn.Position = UDim2.new(0, 10, 0, 10)
ToggleMenuBtn.BackgroundColor3 = Color3.fromRGB(20, 15, 30)
ToggleMenuBtn.Text = "Q"
ToggleMenuBtn.TextColor3 = GUI_COLOR
ToggleMenuBtn.TextSize = 14
ToggleMenuBtn.Font = Enum.Font.GothamBold
ToggleMenuBtn.Parent = ScreenGui
local BtnStroke = Instance.new("UIStroke")
BtnStroke.Color = GUI_COLOR
BtnStroke.Thickness = 1.5
BtnStroke.Parent = ToggleMenuBtn

local FastAimBtn = Instance.new("TextButton")
FastAimBtn.Size = UDim2.new(0, 55, 0, 55)
FastAimBtn.Position = UDim2.new(0.8, 0, 0.5, 0)
FastAimBtn.BackgroundColor3 = Color3.fromRGB(20, 15, 30)
FastAimBtn.Text = "AIM"
FastAimBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
FastAimBtn.TextSize = 14
FastAimBtn.Font = Enum.Font.GothamBold
FastAimBtn.Active = true
FastAimBtn.Draggable = true
FastAimBtn.Parent = ScreenGui
Instance.new("UICorner").CornerRadius = UDim.new(1, 0)
local AimStroke = Instance.new("UIStroke")
AimStroke.Color = GUI_COLOR
AimStroke.Thickness = 2
AimStroke.Parent = FastAimBtn

local MainPanel = Instance.new("Frame")
MainPanel.Size = UDim2.new(0, 240, 0, 280)
MainPanel.Position = UDim2.new(0.5, -120, 0.3, 0)
MainPanel.BackgroundColor3 = Color3.fromRGB(12, 10, 18)
MainPanel.Active = true
MainPanel.Draggable = true
MainPanel.Parent = ScreenGui
local Stroke = Instance.new("UIStroke")
Stroke.Color = GUI_COLOR
Stroke.Thickness = 2
Stroke.Parent = MainPanel

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundTransparency = 1
Title.Text = "GUARD CHEAT RECODE 2.0"
Title.TextColor3 = Color3.fromRGB(240, 240, 240)
Title.TextSize = 12
Title.Font = Enum.Font.GothamBold
Title.Parent = MainPanel

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, 0, 0, 25)
TabBar.Position = UDim2.new(0, 0, 0, 35)
TabBar.BackgroundColor3 = Color3.fromRGB(18, 15, 26)
TabBar.BorderSizePixel = 0
TabBar.Parent = MainPanel

local MainTabBtn = Instance.new("TextButton")
MainTabBtn.Size = UDim2.new(0.5, 0, 1, 0)
MainTabBtn.BackgroundTransparency = 1
MainTabBtn.Text = "MAIN"
MainTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MainTabBtn.Font = Enum.Font.GothamBold
MainTabBtn.TextSize = 11
MainTabBtn.Parent = TabBar

local ColorTabBtn = Instance.new("TextButton")
ColorTabBtn.Size = UDim2.new(0.5, 0, 1, 0)
ColorTabBtn.Position = UDim2.new(0.5, 0, 0, 0)
ColorTabBtn.BackgroundTransparency = 1
ColorTabBtn.Text = "COLORS"
ColorTabBtn.TextColor3 = Color3.fromRGB(140, 140, 140)
ColorTabBtn.Font = Enum.Font.GothamBold
ColorTabBtn.TextSize = 11
ColorTabBtn.Parent = TabBar

local MainFrame = Instance.new("ScrollingFrame")
MainFrame.Size = UDim2.new(1, 0, 1, -65)
MainFrame.Position = UDim2.new(0, 0, 0, 65)
MainFrame.BackgroundTransparency = 1
MainFrame.CanvasSize = UDim2.new(0, 0, 0, 340)
MainFrame.ScrollBarThickness = 2
MainFrame.Parent = MainPanel
local MainList = Instance.new("UIListLayout")
MainList.Padding = UDim.new(0, 6)
MainList.HorizontalAlignment = Enum.HorizontalAlignment.Center
MainList.Parent = MainFrame

local ColorFrame = Instance.new("ScrollingFrame")
ColorFrame.Size = UDim2.new(1, 0, 1, -65)
ColorFrame.Position = UDim2.new(0, 0, 0, 65)
ColorFrame.BackgroundTransparency = 1
ColorFrame.CanvasSize = UDim2.new(0, 0, 0, 320)
ColorFrame.ScrollBarThickness = 2
ColorFrame.Visible = false
ColorFrame.Parent = MainPanel
local ColorList = Instance.new("UIListLayout")
ColorList.Padding = UDim.new(0, 6)
ColorList.HorizontalAlignment = Enum.HorizontalAlignment.Center
ColorList.Parent = ColorFrame

MainTabBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    ColorFrame.Visible = false
    MainTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ColorTabBtn.TextColor3 = Color3.fromRGB(140, 140, 140)
end)

ColorTabBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ColorFrame.Visible = true
    MainTabBtn.TextColor3 = Color3.fromRGB(140, 140, 140)
    ColorTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

local function CreateButton(text, layoutOrder)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(25, 22, 34)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 100, 100)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.LayoutOrder = layoutOrder
    btn.Parent = MainFrame
    return btn
end

local EspBtn = CreateButton("ESP: OFF", 1)
local AimBtn = CreateButton("AUTO AIM: OFF", 2)
local WallBtn = CreateButton("WALL CHECK: OFF", 3)

local function CreateSlider(text, min, max, default, layoutOrder, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -20, 0, 45)
    container.BackgroundTransparency = 1
    container.LayoutOrder = layoutOrder
    container.Parent = MainFrame
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 15)
    lbl.BackgroundTransparency = 1
    lbl.Text = text .. ": " .. default
    lbl.TextColor3 = Color3.fromRGB(180, 180, 180)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 10
    lbl.Parent = container
    local slideBg = Instance.new("Frame")
    slideBg.Size = UDim2.new(1, 0, 0, 4)
    slideBg.Position = UDim2.new(0, 0, 0, 22)
    slideBg.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    slideBg.BorderSizePixel = 0
    slideBg.Parent = container
    local slideBtn = Instance.new("TextButton")
    slideBtn.Size = UDim2.new(0, 12, 0, 12)
    slideBtn.AnchorPoint = Vector2.new(0.5, 0.5)
    slideBtn.Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0)
    slideBtn.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    slideBtn.BorderSizePixel = 0
    slideBtn.Text = ""
    slideBtn.Parent = slideBg
    local dragging = false
    slideBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local relativeX = math.clamp((input.Position.X - slideBg.AbsolutePosition.X) / slideBg.AbsoluteSize.X, 0, 1)
            slideBtn.Position = UDim2.new(relativeX, 0, 0.5, 0)
            local val = math.floor(min + (max - min) * relativeX)
            lbl.Text = text .. ": " .. val
            callback(val)
        end
    end)
end

CreateSlider("FOV RADIUS", 50, 500, 200, 4, function(v) AimRadius = v end)
CreateSlider("SMOOTHNESS", 1, 20, 6, 5, function(v) AimSmoothness = v end)
CreateSlider("BOX WIDTH", 1, 10, 4, 6, function(v) EspBoxSizeX = v end)

ToggleMenuBtn.MouseButton1Click:Connect(function() 
    MainPanel.Visible = not MainPanel.Visible 
    FastAimBtn.Draggable = MainPanel.Visible
end)
local function UpdateTheme(newColor)
    ESP_COLOR = newColor
    GUI_COLOR = newColor
    Stroke.Color = newColor
    BtnStroke.Color = newColor
    ToggleMenuBtn.TextColor3 = newColor
    AimStroke.Color = newColor
    for p, obj in pairs(activeEspObjects) do
        if obj and obj:IsA("BoxHandleAdornment") and obj.Name == "QuantumBox" then 
            local isTeammate = IsPlayerTeammate(p)
            if not isTeammate then
                obj.Color3 = newColor
            end
        end
    end
end

local function CreateThemeBtn(text, color, layoutOrder)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(25, 22, 34)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = color
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.LayoutOrder = layoutOrder
    btn.Parent = ColorFrame
    btn.MouseButton1Click:Connect(function() 
        UpdateTheme(color) 
    end)
    return btn
end

CreateThemeBtn("PURPLE THEME", Color3.fromRGB(155, 90, 255), 1)
CreateThemeBtn("RED THEME", Color3.fromRGB(255, 70, 70), 2)
CreateThemeBtn("GREEN THEME", Color3.fromRGB(70, 255, 70), 3)
CreateThemeBtn("BLUE THEME", Color3.fromRGB(70, 160, 255), 4)
CreateThemeBtn("GOLD THEME", Color3.fromRGB(255, 200, 50), 5)

local function ClearEsp()
    for _, obj in pairs(activeEspObjects) do
        if obj then pcall(function() obj:Destroy() end) end
    end
    table.clear(activeEspObjects)
end

function IsPlayerTeammate(player)
    if not player or not player.Character then return false end
    local char = player.Character
    for _, child in ipairs(char:GetDescendants()) do
        if child:IsA("BillboardGui") or child:IsA("Decal") or child:IsA("ImageLabel") or child:IsA("MeshPart") then
            local name = child.Name:lower()
            if name:find("team") or name:find("friend") or name:find("indicator") or name:find("green") or name:find("triangle") or name:find("arrow") then
                return true
            end
        end
    end
    return false
end

local function ApplyEsp()
    ClearEsp()
    if not EspEnabled then return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = p.Character.HumanoidRootPart
            local isTeammate = IsPlayerTeammate(p)
            
            local box = Instance.new("BoxHandleAdornment")
            box.Name = "QuantumBox"
            box.Size = Vector3.new(EspBoxSizeX, EspBoxSizeY, EspBoxSizeX)
            box.Color3 = isTeammate and Color3.fromRGB(70, 255, 70) or ESP_COLOR
            box.Transparency = 0.6
            box.AlwaysOnTop = true
            box.ZIndex = 10
            box.Adornee = hrp
            box.Parent = CoreGui
            activeEspObjects[p] = box
            
            local bb = Instance.new("BillboardGui")
            bb.Size = UDim2.new(0, 200, 0, 50)
            bb.StudsOffset = Vector3.new(0, 4, 0)
            bb.AlwaysOnTop = true
            bb.Adornee = hrp
            bb.Parent = CoreGui
            
            local tl = Instance.new("TextLabel")
            tl.Size = UDim2.new(1, 0, 1, 0)
            tl.BackgroundTransparency = 1
            tl.Text = p.Name
            tl.TextColor3 = isTeammate and Color3.fromRGB(70, 255, 70) or ESP_COLOR
            tl.TextSize = 11
            tl.Font = Enum.Font.GothamBold
            tl.Parent = bb
        end
    end
end

local function CheckWall(targetPart)
    if not WallCheckEnabled then return true end
    local origin = Camera.CFrame.Position
    local direction = targetPart.Position - origin
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, targetPart.Parent, CoreGui}
    raycastParams.IgnoreWater = true
    
    local result = Workspace:Raycast(origin, direction, raycastParams)
    if result and result.Instance and result.Instance.CanCollide then
        return false
    end
    return true
end

local currentTarget = nil

local function IsValidTarget(player)
    if player and player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
        if not IsPlayerTeammate(player) then
            local hrp = player.Character.HumanoidRootPart
            local distanceToTarget = (LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
            if distanceToTarget <= MaxAimDistance then
                local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                if onScreen and CheckWall(hrp) then
                    local mousePos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                    local screenDist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                    if screenDist <= AimRadius then
                        return true
                    end
                end
            end
        end
    end
    return false
end

local function GetClosestTarget()
    if IsValidTarget(currentTarget) then
        return currentTarget
    end
    
    currentTarget = nil
    local closestPlayer = nil
    local shortestDistance = AimRadius
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            if not IsPlayerTeammate(player) then
                local hrp = player.Character.HumanoidRootPart
                local distanceToTarget = (LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                if distanceToTarget <= MaxAimDistance then
                    local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                    if onScreen and CheckWall(hrp) then
                        local mousePos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                        local screenDist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                        if screenDist < shortestDistance then
                            shortestDistance = screenDist
                            closestPlayer = player
                        end
                    end
                end
            end
        end
    end
    currentTarget = closestPlayer
    return closestPlayer
end

local function ToggleAimState(state)
    AimEnabled = state
    if AimEnabled then
        AimBtn.Text = "AUTO AIM: ON"
        AimBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
        FastAimBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        AimBtn.Text = "AUTO AIM: OFF"
        AimBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
        FastAimBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
        currentTarget = nil
    end
end

EspBtn.MouseButton1Click:Connect(function()
    if not MainFrame.Visible or not MainPanel.Visible then return end
    EspEnabled = not EspEnabled
    if EspEnabled then
        EspBtn.Text = "ESP: ON" EspBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        EspBtn.Text = "ESP: OFF" EspBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
    ApplyEsp()
end)

AimBtn.MouseButton1Click:Connect(function()
    if not MainFrame.Visible or not MainPanel.Visible then return end
    ToggleAimState(not AimEnabled)
end)

FastAimBtn.MouseButton1Click:Connect(function()
    if MainPanel.Visible then return end
    ToggleAimState(not AimEnabled)
end)

WallBtn.MouseButton1Click:Connect(function()
    if not MainFrame.Visible or not MainPanel.Visible then return end
    WallCheckEnabled = not WallCheckEnabled
    if WallCheckEnabled then
        WallBtn.Text = "WALL CHECK: ON" WallBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        WallBtn.Text = "WALL CHECK: OFF" WallBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

RunService.RenderStepped:Connect(function()
    if EspEnabled then
        for p, obj in pairs(activeEspObjects) do
            if obj and obj:IsA("BoxHandleAdornment") and obj.Name == "QuantumBox" then
                obj.Size = Vector3.new(EspBoxSizeX, EspBoxSizeY, EspBoxSizeX)
            end
        end
    end

    if AimEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local target = GetClosestTarget()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local currentCF = Camera.CFrame
            local targetCF = CFrame.lookAt(currentCF.Position, target.Character.HumanoidRootPart.Position)
            Camera.CFrame = currentCF:Lerp(targetCF, 1 / AimSmoothness)
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        if EspEnabled then ApplyEsp() end
    end
end)
