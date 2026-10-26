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
if success and targetParent then
    ScreenGui.Parent = targetParent
else
    ScreenGui.Parent = CoreGui
end

local MainPanel = Instance.new("Frame")
MainPanel.Name = "MainPanel"
MainPanel.Size = UDim2.new(0, 180, 0, 90)
MainPanel.Position = UDim2.new(0.5, -90, 0.2, 0)
MainPanel.BackgroundColor3 = Color3.fromRGB(20, 15, 30)
MainPanel.BorderSizePixel = 0
MainPanel.Active = true
MainPanel.Draggable = true
MainPanel.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = MainPanel

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(155, 90, 255)
Stroke.Thickness = 1.5
Stroke.Parent = MainPanel

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "Quantum Onyx Light"
Title.TextColor3 = Color3.fromRGB(220, 200, 255)
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.Parent = MainPanel

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(1, -20, 0, 40)
ToggleButton.Position = UDim2.new(0, 10, 0, 38)
ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 25, 70)
ToggleButton.Text = "ESP: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 100, 100)
ToggleButton.TextSize = 14
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Parent = MainPanel

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 6)
BtnCorner.Parent = ToggleButton

local function ClearEsp()
    for _, obj in ipairs(activeEspObjects) do
        if obj then pcall(function() obj:Destroy() end) end
    end
    table.clear(activeEspObjects)
end

local function ApplyEsp()
    ClearEsp()
    if not EspEnabled then return end
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            if p.Team ~= LocalPlayer.Team or p.Team == nil then
                local hrp = p.Character.HumanoidRootPart
                
                local box = Instance.new("BoxHandleAdornment")
                box.Name = "QuantumBox"
                box.Size = Vector3.new(4, 6, 4)
                box.Color3 = ESP_COLOR
                box.Transparency = 0.6
                box.AlwaysOnTop = true
                box.ZIndex = 10
                box.Adornee = hrp
                box.Parent = CoreGui
                table.insert(activeEspObjects, box)
                
                local bb = Instance.new("BillboardGui")
                bb.Name = "QuantumName"
                bb.Size = UDim2.new(0, 200, 0, 50)
                bb.StudsOffset = Vector3.new(0, 4, 0)
                bb.AlwaysOnTop = true
                bb.Adornee = hrp
                bb.Parent = CoreGui
                table.insert(activeEspObjects, bb)
                
                local tl = Instance.new("TextLabel")
                tl.Size = UDim2.new(1, 0, 1, 0)
                tl.BackgroundTransparency = 1
                tl.Text = p.Name
                tl.TextColor3 = ESP_COLOR
                tl.TextSize = 12
                tl.Font = Enum.Font.GothamBold
                tl.TextStrokeTransparency = 0
                tl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                tl.Parent = bb
            end
        end
    end
end

ToggleButton.MouseButton1Click:Connect(function()
    EspEnabled = not EspEnabled
    if EspEnabled then
        ToggleButton.Text = "ESP: ON"
        ToggleButton.TextColor3 = Color3.fromRGB(100, 255, 100)
        ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 35, 95)
    else
        ToggleButton.Text = "ESP: OFF"
        ToggleButton.TextColor3 = Color3.fromRGB(255, 100, 100)
        ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 25, 70)
    end
    ApplyEsp()
end)

task.spawn(function()
    while task.wait(1) do
        if EspEnabled then
            ApplyEsp()
        end
    end
end)
