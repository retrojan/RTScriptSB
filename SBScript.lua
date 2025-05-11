
-- Защита от дублирования GUI
if game:GetService("CoreGui"):FindFirstChild("AFKToolGUI") then
    game:GetService("CoreGui").AFKToolGUI:Destroy()
end



local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")

local flyActivated = false

    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "ReTrojan Script",
        Text = "Script activated\nHave a fun",
        Icon = "rbxassetid://118017846388806",
        Duration = 5
    })

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AFKToolGUI"
ScreenGui.Parent = game:GetService("CoreGui")


local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 250, 0, 190)
Frame.Position = UDim2.new(0, 20, 1, -160)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Text = "ReTrojan Script v1.3"
Title.Size = UDim2.new(1, -30, 1, 0) -- Оставляем место для кнопки
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local ToggleButton = Instance.new("TextButton")
ToggleButton.Text = "▼"
ToggleButton.Size = UDim2.new(0, 30, 1, 0) -- Такая же высота как у TitleBar
ToggleButton.Position = UDim2.new(1, -30, 0, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Такой же цвет как у TitleBar
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 18
ToggleButton.BorderSizePixel = 0
ToggleButton.Parent = TitleBar

-- Контейнер для кнопок с симметричными отступами
local ButtonsContainer = Instance.new("Frame")
ButtonsContainer.Name = "ButtonsContainer"
ButtonsContainer.Size = UDim2.new(1, -20, 1, -40) -- Отступы по 10 пикселей с каждой стороны
ButtonsContainer.Position = UDim2.new(0, 10, 0, 35)
ButtonsContainer.BackgroundTransparency = 1
ButtonsContainer.Parent = Frame

-- Функция для создания идеально выровненных кнопок
local function createButton(name, yPosition, text)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Text = text
    button.Size = UDim2.new(1, 0, 0, 35) -- Фиксированная высота
    button.Position = UDim2.new(0, 0, 0, yPosition)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.SourceSans
    button.TextSize = 16
    button.Parent = ButtonsContainer
    return button
end

-- Создаем кнопки с равными промежутками
local TeleportButton = createButton("TeleportButton", 0, "TP to AFK Zone")
local AutoClickButton = createButton("AutoClickButton", 45, "Auto-Click: OFF") -- Интервал 45px между кнопками

-- Переменные
local platform = nil
local isClicking = false
local clickInterval = 4
local lastClickTime = 0
local isMenuExpanded = true

-- Функция скрытия/показа меню
local function toggleMenu()
    isMenuExpanded = not isMenuExpanded
    if isMenuExpanded then
        Frame.Size = UDim2.new(0, 250, 0, 190)
        ButtonsContainer.Visible = true
        ToggleButton.Text = "▼"
    else
        Frame.Size = UDim2.new(0, 250, 0, 30)
        ButtonsContainer.Visible = false
        ToggleButton.Text = "▲"
    end
end

-- Функция для клика
local function doClick()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
    task.wait(0.05)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
    lastClickTime = os.time()
end

-- Включение/выключение авто-кликера
local function toggleAutoClick()
    isClicking = not isClicking
    if isClicking then
        AutoClickButton.Text = "Auto-Click: ON"
        AutoClickButton.BackgroundColor3 = Color3.fromRGB(80, 160, 80)
        lastClickTime = os.time() - clickInterval
    else
        AutoClickButton.Text = "Auto-Click: OFF"
        AutoClickButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
end
-- В разделе создания кнопок:
local FlyButton = createButton("FlyButton", 90, "FlyGuiV3")



-- Измените размер Frame для новой кнопки:
Frame.Size = UDim2.new(0, 250, 0, 190) -- Было 160, теперь 190 (30px на новую кнопку)
Frame.Position = UDim2.new(0, 20, 1, -190) -- Обновите позицию соответственно





-- Телепортация в AFK-зону
local function teleportToAFK()
    local targetPosition = Vector3.new(50000, 5000, 50000)
    
    if not Player.Character then
        Player.CharacterAdded:Wait()
    end
    local HumanoidRootPart = Player.Character:WaitForChild("HumanoidRootPart")
    
    HumanoidRootPart.CFrame = CFrame.new(targetPosition)
    
    if not platform or not platform.Parent then
        platform = Instance.new("Part")
        platform.Name = "GiantAFK_Platform"
        platform.Anchored = true
        platform.Size = Vector3.new(500, 3, 500)
        platform.Transparency = 0.5
        platform.CanCollide = true
        platform.Position = targetPosition - Vector3.new(0, 2.5, 0)
        platform.Parent = workspace
    end
end

-- Основной цикл для кликера
RunService.Heartbeat:Connect(function()
    if isClicking and (os.time() - lastClickTime) >= clickInterval then
        doClick()
    end
end)

-- Подключение кнопок
TeleportButton.MouseButton1Click:Connect(teleportToAFK)
AutoClickButton.MouseButton1Click:Connect(toggleAutoClick)
FlyButton.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
    FlyButton.Text = "FlyGuiV3 Activated!"
    FlyButton.BackgroundColor3 = Color3.fromRGB(80, 160, 80)
    
    task.wait(3)
    FlyButton.Text = "FlyGuiV3"
    FlyButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
end)
ToggleButton.MouseButton1Click:Connect(toggleMenu)

-- Удаление GUI при переподключении
Player.PlayerGui.ChildRemoved:Connect(function(child)
    if child == ScreenGui then
        ScreenGui:Destroy()
    end
end)
