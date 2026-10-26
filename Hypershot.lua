-- [[ ПОЛНЫЙ СКРИПТ AIMBOT + ESP С МЕНЮ ДЛЯ HYPERSHOT ]]

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/main/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/main/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Quantum Onyx | Hypershot",
    SubTitle = "by flazhy",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Переменные и сервисы
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Настройки по умолчанию
local Options = {
    AimbotEnabled = false,
    AimPart = "Head",
    Smoothness = 1,
    TeamCheck = true,
    VisibleCheck = true,
    
    FovEnabled = false,
    FovRadius = 100,
    FovColor = Color3.fromRGB(255, 255, 255),
    
    EspEnabled = false,
    EspBoxes = false,
    EspTracers = false,
    EspNames = false,
    EspDistance = false,
    EspTeamCheck = true,
    EspColor = Color3.fromRGB(155, 90, 255)
}

-- FOV Круг
local FovCircle = Drawing.new("Circle")
FovCircle.Thickness = 1
FovCircle.NumSides = 60
FovCircle.Radius = Options.FovRadius
FovCircle.Filled = false
FovCircle.Visible = false
FovCircle.Color = Options.FovColor

-- Вкладки меню
local Tabs = {
    Combat = Window:AddTab({ Title = "Combat", Icon = "crosshair" }),
    Visuals = Window:AddTab({ Title = "Visuals", Icon = "eye" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- [ COMBAT TAB ]
Tabs.Combat:AddParagraph({ Title = "Aimbot Settings", Content = "Настройки автоматической наводки" })

local AimToggle = Tabs.Combat:AddToggle("AimToggle", { Title = "Включить Aimbot", Default = false })
AimToggle:OnChanged(function(Value) Options.AimbotEnabled = Value end)

local AimPartDropdown = Tabs.Combat:AddDropdown("AimPart", {
    Title = "Часть тела",
    Values = {"Head", "HumanoidRootPart"},
    CurrentValue = "Head"
})
AimPartDropdown:OnChanged(function(Value) Options.AimPart = Value end)

local SmoothSlider = Tabs.Combat:AddSlider("SmoothSlider", {
    Title = "Плавность аима",
    Min = 1, Max = 10, Default = 1,
    Rounding = 1
})
SmoothSlider:OnChanged(function(Value) Options.Smoothness = Value end)

local TeamToggle = Tabs.Combat:AddToggle("TeamToggle", { Title = "Проверка на команду", Default = true })
TeamToggle:OnChanged(function(Value) Options.TeamCheck = Value end)

local WallToggle = Tabs.Combat:AddToggle("WallToggle", { Title = "Проверка видимости (Стены)", Default = true })
WallToggle:OnChanged(function(Value) Options.VisibleCheck = Value end)

Tabs.Combat:AddParagraph({ Title = "FOV Settings", Content = "Радиус захвата цели" })

local FovToggle = Tabs.Combat:AddToggle("FovToggle", { Title = "Показывать FOV круг", Default = false })
FovToggle:OnChanged(function(Value) Options.FovEnabled = Value end)

local FovSlider = Tabs.Combat:AddSlider("FovSlider", {
    Title = "Радиус FOV",
    Min = 30, Max = 500, Default = 100,
    Rounding = 0
})
FovSlider:OnChanged(function(Value) Options.FovRadius = Value end)


-- [ VISUALS TAB ]
Tabs.Visuals:AddParagraph({ Title = "ESP Settings", Content = "Взлом видимости игроков" })

local EspToggle = Tabs.Visuals:AddToggle("EspToggle", { Title = "Включить ESP Master", Default = false })
EspToggle:OnChanged(function(Value) Options.EspEnabled = Value end)

local BoxesToggle = Tabs.Visuals:AddToggle("BoxesToggle", { Title = "Боксы (Boxes)", Default = false })
BoxesToggle:OnChanged(function(Value) Options.EspBoxes = Value end)

local TracersToggle = Tabs.Visuals:AddToggle("TracersToggle", { Title = "Линии (Tracers)", Default = false })
TracersToggle:OnChanged(function(Value) Options.EspTracers = Value end)

local NamesToggle = Tabs.Visuals:AddToggle("NamesToggle", { Title = "Имена игроков", Default = false })
NamesToggle:OnChanged(function(Value) Options.EspNames = Value end)

local DistToggle = Tabs.Visuals:AddToggle("DistToggle", { Title = "Дистанция", Default = false })
DistToggle:OnChanged(function(Value) Options.EspDistance = Value end)

local EspTeamToggle = Tabs.Visuals:AddToggle("EspTeamToggle", { Title = "Игнорировать союзников", Default = true })
EspTeamToggle:OnChanged(function(Value) Options.EspTeamCheck = Value end)

local EspColorPicker = Tabs.Visuals:AddColorpicker("EspColorPicker", {
    Title = "Цвет ESP",
    Default = Color3.fromRGB(155, 90, 255)
})
EspColorPicker:OnChanged(function(Value) Options.EspColor = Value end)


-- [[ ЛОГИКА AIMBOT ]]
local function IsVisible(targetPart)
    if not Options.VisibleCheck then return true end
    local castPoints = {Camera.CFrame.Position, targetPart.Position}
    local ignoreList = {LocalPlayer.Character, targetPart.Parent}
    local parts = Camera:GetPartsObscuringTarget(castPoints, ignoreList)
    return #parts == 0
end

local function GetClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(Options.AimPart) and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            if Options.TeamCheck and player.Team == LocalPlayer.Team then continue end
            
            local targetPart = player.Character[Options.AimPart]
            if not IsVisible(targetPart) then continue end

            local pos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
            if onScreen then
                local distance = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)).Magnitude
                if distance < shortestDistance and (not Options.FovEnabled or distance <= Options.FovRadius) then
                    shortestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end
    return closestPlayer
end

-- Хук рендера для Aimbot и FOV
RunService.RenderStepped:Connect(function()
    -- Обновление круга FOV
    if Options.FovEnabled and Options.AimbotEnabled then
        FovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        FovCircle.Radius = Options.FovRadius
        FovCircle.Visible = true
    else
        FovCircle.Visible = false
    end

    -- Наводка
    if Options.AimbotEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = GetClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild(Options.AimPart) then
            local targetPos = Camera:WorldToViewportPoint(target.Character[Options.AimPart].Position)
            local mousePos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            mouseclick((targetPos.X - mousePos.X) / Options.Smoothness, (targetPos.Y - mousePos.Y) / Options.Smoothness)
        end
    end
end)


-- [[ ЛОГИКА ESP ]]
local espCache = {}

local function CreateEsp(player)
    local drawings = {
        Box = Drawing.new("Square"),
        Tracer = Drawing.new("Line"),
        Name = Drawing.new("Text")
    }
    
    drawings.Box.Thickness = 1
    drawings.Box.Filled = false
    
    drawings.Tracer.Thickness = 1
    
    drawings.Name.Size = 13
    drawings.Name.Center = true
    drawings.Name.Outline = true
    
    espCache[player] = drawings
end

local function RemoveEsp(player)
    if espCache[player] then
        for _, drawing in pairs(espCache[player]) do
            drawing:Remove()
        end
        espCache[player] = nil
    end
end

Players.PlayerAdded:Connect(CreateEsp)
Players.PlayerRemoving:Connect(RemoveEsp)
for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then CreateEsp(p) end end

RunService.RenderStepped:Connect(function()
    for player, drawings in pairs(espCache) do
        if Options.EspEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            if Options.EspTeamCheck and player.Team == LocalPlayer.Team then
                drawings.Box.Visible = false
                drawings.Tracer.Visible = false
                drawings.Name.Visible = false
                continue
            end

            local hrp = player.Character.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)

            if onScreen then
                local distance = (Camera.CFrame.Position - hrp.Position).Magnitude
                
                -- Рендер Бокса
                if Options.EspBoxes then
                    local sizeX = 2000 / pos.Z
                    local sizeY = 3000 / pos.Z
                    drawings.Box.Size = Vector2.new(sizeX, sizeY)
                    drawings.Box.Position = Vector2.new(pos.X - sizeX / 2, pos.Y - sizeY / 2)
                    drawings.Box.Color = Options.EspColor
                    drawings.Box.Visible = true
                else
                    drawings.Box.Visible = false
                end

                -- Рендер Трейсеров
                if Options.EspTracers then
                    drawings.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    drawings.Tracer.To = Vector2.new(pos.X, pos.Y)
                    drawings.Tracer.Color = Options.EspColor
                    drawings.Tracer.Visible = true
                else
                    drawings.Tracer.Visible = false
                end

                -- Рендер Имени и Дистанции
                if Options.EspNames then
                    local infoText = player.Name
                    if Options.EspDistance then
                        infoText = infoText .. " [" .. math.floor(distance) .. "m]"
                    end
                    drawings.Name.Text = infoText
                    drawings.Name.Position = Vector2.new(pos.X, pos.Y - (3500 / pos.Z) / 2 - 15)
                    drawings.Name.Color = Options.EspColor
                    drawings.Name.Visible = true
                else
                    drawings.Name.Visible = false
                end
            else
                drawings.Box.Visible = false
                drawings.Tracer.Visible = false
                drawings.Name.Visible = false
            end
        else
            drawings.Box.Visible = false
            drawings.Tracer.Visible = false
            drawings.Name.Visible = false
        end
    end
end)

Window:SelectTab(1)
Fluent:Notify({ Title = "Quantum Onyx", Content = "Скрипт успешно запущен!", Duration = 5 })
