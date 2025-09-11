-- RedLibUPD Fixed Version
-- by redpulse

local RedLib = {}
RedLib.__index = RedLib

-- Конфигурация по умолчанию
RedLib.DefaultConfig = {
    WindowSize = UDim2.new(0, 350, 0, 250),
    WindowPosition = UDim2.new(0.5, -175, 0.5, -125),
    BackgroundColor = Color3.fromRGB(15, 15, 15),
    BorderColor = Color3.fromRGB(255, 0, 0),
    TextColor = Color3.fromRGB(255, 100, 100),
    AccentColor = Color3.fromRGB(255, 0, 0),
    SliderWidth = 250,
    SliderHeight = 6,
    KnobSize = 20,
    Title = "RedLib Window"
}

-- Утилиты
function RedLib:CreateElement(className, properties)
    local element = Instance.new(className)
    for property, value in pairs(properties) do
        if element[property] ~= nil then
            element[property] = value
        end
    end
    return element
end

function RedLib:Round(number, decimalPlaces)
    local multiplier = 10 ^ (decimalPlaces or 0)
    return math.floor(number * multiplier + 0.5) / multiplier
end

function RedLib:IsMobile()
    return game:GetService("UserInputService").TouchEnabled
end

-- Создание splash screen
function RedLib:ShowSplash()
    local player = game:GetService("Players").LocalPlayer
    local TweenService = game:GetService("TweenService")
    
    local splashGui = self:CreateElement("ScreenGui", {
        Name = "RedLibrarySplash",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = player.PlayerGui
    })
    
    -- Основной текст (сразу видимый)
    local splashText = self:CreateElement("TextLabel", {
        Size = UDim2.new(0, 300, 0, 60),
        Position = UDim2.new(0.5, -150, 0.5, -30),
        BackgroundTransparency = 1,
        Text = "REDLIBRARY",
        TextColor3 = Color3.fromRGB(255, 0, 0),
        Font = Enum.Font.GothamBlack,
        TextSize = 32,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextTransparency = 0,
        ZIndex = 2,
        Parent = splashGui
    })
    
    -- Свечение текста
    local textGlow = self:CreateElement("UIStroke", {
        Color = Color3.fromRGB(255, 50, 50),
        Thickness = 3,
        Transparency = 0,
        Parent = splashText
    })
    
    -- Анимация появления
    local moveUp = TweenService:Create(splashText, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -150, 0.4, -30)
    })
    
    moveUp:Play()
    moveUp.Completed:Wait()
    
    -- Интенсивная пульсация
    for i = 1, 3 do
        local pulseOut = TweenService:Create(splashText, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextColor3 = Color3.fromRGB(200, 0, 0),
            TextSize = 30
        })
        
        local glowPulseOut = TweenService:Create(textGlow, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Color = Color3.fromRGB(200, 30, 30),
            Thickness = 4
        })
        
        local pulseIn = TweenService:Create(splashText, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextColor3 = Color3.fromRGB(255, 0, 0),
            TextSize = 32
        })
        
        local glowPulseIn = TweenService:Create(textGlow, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Color = Color3.fromRGB(255, 50, 50),
            Thickness = 3
        })
        
        pulseOut:Play()
        glowPulseOut:Play()
        pulseOut.Completed:Wait()
        pulseIn:Play()
        glowPulseIn:Play()
        pulseIn.Completed:Wait()
        
        if i < 3 then
            task.wait(0.2)
        end
    end
    
    -- Исчезновение
    local fadeOutText = TweenService:Create(splashText, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 1,
        Position = UDim2.new(0.5, -150, 0.3, -30)
    })
    
    local fadeOutGlow = TweenService:Create(textGlow, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Transparency = 1
    })
    
    fadeOutText:Play()
    fadeOutGlow:Play()
    fadeOutText.Completed:Wait()
    
    splashGui:Destroy()
end

-- Класс Window
local Window = {}
Window.__index = Window

function RedLib:CreateWindowInstance(config)
    self:ShowSplash()
    task.wait(0.5)
    
    config = config or {}
    setmetatable(config, {__index = self.DefaultConfig})
    
    local window = setmetatable({
        Config = config,
        Elements = {},
        Toggles = {},
        Sliders = {},
        IsVisible = true
    }, Window)
    
    window:Initialize()
    return window
end

function RedLib:CreateWindow(config)
    return self:CreateWindowInstance(config)
end

function Window:Initialize()
    local player = game:GetService("Players").LocalPlayer
    
    self.Gui = self:CreateElement("ScreenGui", {
        Name = "RedLibWindow",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = player.PlayerGui
    })
    
    self.MainFrame = self:CreateElement("Frame", {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundColor3 = self.Config.BackgroundColor,
        BorderColor3 = self.Config.BorderColor,
        BorderSizePixel = 2,
        ClipsDescendants = true,
        Active = true,
        Draggable = true,
        Selectable = true,
        Parent = self.Gui
    })
    
    self:CreateElement("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 0, 0)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 0, 0))
        }),
        Rotation = 45,
        Parent = self.MainFrame
    })
    
    self.Title = self:CreateElement("TextLabel", {
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = self.Config.Title,
        TextColor3 = self.Config.AccentColor,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Center,
        Active = true,
        Parent = self.MainFrame
    })
    
    self.ContentFrame = self:CreateElement("Frame", {
        Size = UDim2.new(1, -40, 1, -60),
        Position = UDim2.new(0, 20, 0, 40),
        BackgroundTransparency = 1,
        Parent = self.MainFrame
    })
    
    self.HideButton = self:CreateElement("TextButton", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -35, 0, 5),
        BackgroundColor3 = self.Config.AccentColor,
        TextColor3 = Color3.fromRGB(0, 0, 0),
        Font = Enum.Font.GothamBold,
        Text = "×",
        TextSize = 16,
        BorderSizePixel = 0,
        Parent = self.MainFrame
    })
    
    -- Анимация появления окна
    local TweenService = game:GetService("TweenService")
    local sizeTween = TweenService:Create(self.MainFrame, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = self.Config.WindowSize,
        Position = self.Config.WindowPosition
    })
    
    sizeTween:Play()
    
    self:SetupAnimations()
    self:SetupEvents()
end

function Window:CreateElement(className, properties)
    return RedLib:CreateElement(className, properties)
end

function Window:SetupAnimations()
    self.TweenService = game:GetService("TweenService")
    
    task.spawn(function()
        while self.MainFrame and self.MainFrame.Parent do
            local glowTween = self.TweenService:Create(self.MainFrame, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                BorderColor3 = Color3.fromRGB(150, 0, 0)
            })
            glowTween:Play()
            task.wait(1.5)
            
            local glowTween2 = self.TweenService:Create(self.MainFrame, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                BorderColor3 = self.Config.BorderColor
            })
            glowTween2:Play()
            task.wait(1.5)
        end
    end)
end

function Window:SetupEvents()
    self.HideButton.MouseButton1Click:Connect(function()
        self:ToggleVisibility()
    end)
end

function Window:ToggleVisibility()
    if self.IsVisible then
        self:Hide()
    else
        self:Show()
    end
end

function Window:Hide()
    self.IsVisible = false
    local targetPosition = UDim2.new(-0.3, 0, self.MainFrame.Position.Y.Scale, self.MainFrame.Position.Y.Offset)
    local tween = self.TweenService:Create(self.MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = targetPosition
    })
    tween:Play()
    self.HideButton.Text = "○"
end

function Window:Show()
    self.IsVisible = true
    local tween = self.TweenService:Create(self.MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = self.Config.WindowPosition
    })
    tween:Play()
    self.HideButton.Text = "×"
end

function Window:AddLabel(text, position)
    local label = self:CreateElement("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        Position = position or UDim2.new(0, 0, 0, #self.Elements * 30),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = self.Config.TextColor,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.ContentFrame
    })
    
    table.insert(self.Elements, label)
    return label
end

function Window:AddButton(name, callback)
    local button = self:CreateElement("TextButton", {
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0, #self.Elements * 40),
        BackgroundColor3 = self.Config.AccentColor,
        TextColor3 = Color3.fromRGB(0, 0, 0),
        Font = Enum.Font.GothamBold,
        Text = name,
        TextSize = 12,
        BorderSizePixel = 0,
        Parent = self.ContentFrame
    })
    
    button.MouseButton1Click:Connect(callback)
    table.insert(self.Elements, button)
    return button
end

return RedLib
