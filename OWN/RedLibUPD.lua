-- RedLib Ultimate Edition
-- Version 3.0
-- by redpulse
-- Полная библиотека с реалистичными анимациями и продвинутым GUI

local RedLib = {}
RedLib.__index = RedLib

-- Конфигурация по умолчанию
RedLib.DefaultConfig = {
    WindowSize = UDim2.new(0, 400, 0, 300),
    WindowPosition = UDim2.new(0.5, -200, 0.5, -150),
    BackgroundColor = Color3.fromRGB(10, 10, 10),
    BorderColor = Color3.fromRGB(255, 0, 0),
    TextColor = Color3.fromRGB(255, 100, 100),
    AccentColor = Color3.fromRGB(255, 0, 0),
    SecondaryColor = Color3.fromRGB(150, 0, 0),
    SliderWidth = 280,
    SliderHeight = 6,
    KnobSize = 18,
    Title = "RedLib Panel",
    AnimationDuration = 0.8
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

function RedLib:EasingStyle()
    return Enum.EasingStyle.Quint
end

-- Реалистичная анимация splash screen
function RedLib:ShowSplash()
    local player = game:GetService("Players").LocalPlayer
    local TweenService = game:GetService("TweenService")
    
    local splashGui = self:CreateElement("ScreenGui", {
        Name = "RedLibrarySplash",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = player.PlayerGui
    })
    
    -- Фон с затемнением
    local background = self:CreateElement("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.7,
        BorderSizePixel = 0,
        Parent = splashGui
    })
    
    -- Основной текст
    local splashText = self:CreateElement("TextLabel", {
        Size = UDim2.new(0, 300, 0, 60),
        Position = UDim2.new(0.5, -150, 0.5, -30),
        BackgroundTransparency = 1,
        Text = "REDLIBRARY",
        TextColor3 = Color3.fromRGB(255, 0, 0),
        Font = Enum.Font.GothamBlack,
        TextSize = 32,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextTransparency = 1,
        ZIndex = 2,
        Parent = splashGui
    })
    
    -- Свечение текста
    local textGlow = self:CreateElement("UIStroke", {
        Color = Color3.fromRGB(255, 50, 50),
        Thickness = 3,
        Transparency = 1,
        Parent = splashText
    })
    
    -- Анимация появления
    local appearTween = TweenService:Create(splashText, TweenInfo.new(1.2, self:EasingStyle(), Enum.EasingDirection.Out), {
        TextTransparency = 0,
        Position = UDim2.new(0.5, -150, 0.45, -30)
    })
    
    local glowAppear = TweenService:Create(textGlow, TweenInfo.new(1.2, self:EasingStyle(), Enum.EasingDirection.Out), {
        Transparency = 0
    })
    
    appearTween:Play()
    glowAppear:Play()
    appearTween.Completed:Wait()
    
    -- Интенсивная пульсация
    for i = 1, 4 do
        local pulseOut = TweenService:Create(splashText, TweenInfo.new(0.4, self:EasingStyle(), Enum.EasingDirection.Out), {
            TextColor3 = Color3.fromRGB(200, 0, 0),
            TextSize = 30,
            Position = UDim2.new(0.5, -150, 0.44, -30)
        })
        
        local glowPulseOut = TweenService:Create(textGlow, TweenInfo.new(0.4, self:EasingStyle(), Enum.EasingDirection.Out), {
            Color = Color3.fromRGB(200, 30, 30),
            Thickness = 4
        })
        
        local pulseIn = TweenService:Create(splashText, TweenInfo.new(0.6, self:EasingStyle(), Enum.EasingDirection.Out), {
            TextColor3 = Color3.fromRGB(255, 0, 0),
            TextSize = 32,
            Position = UDim2.new(0.5, -150, 0.45, -30)
        })
        
        local glowPulseIn = TweenService:Create(textGlow, TweenInfo.new(0.6, self:EasingStyle(), Enum.EasingDirection.Out), {
            Color = Color3.fromRGB(255, 50, 50),
            Thickness = 3
        })
        
        pulseOut:Play()
        glowPulseOut:Play()
        pulseOut.Completed:Wait()
        pulseIn:Play()
        glowPulseIn:Play()
        pulseIn.Completed:Wait()
        
        if i < 4 then
            task.wait(0.3)
        end
    end
    
    -- Реалистичное исчезновение
    local fadeOutText = TweenService:Create(splashText, TweenInfo.new(1.5, self:EasingStyle(), Enum.EasingDirection.Out), {
        TextTransparency = 1,
        Position = UDim2.new(0.5, -150, 0.4, -30)
    })
    
    local fadeOutGlow = TweenService:Create(textGlow, TweenInfo.new(1.5, self:EasingStyle(), Enum.EasingDirection.Out), {
        Transparency = 1
    })
    
    local fadeBackground = TweenService:Create(background, TweenInfo.new(1.5, self:EasingStyle(), Enum.EasingDirection.Out), {
        BackgroundTransparency = 1
    })
    
    fadeOutText:Play()
    fadeOutGlow:Play()
    fadeBackground:Play()
    fadeOutText.Completed:Wait()
    
    splashGui:Destroy()
end

-- Класс Window
local Window = {}
Window.__index = Window

function RedLib:CreateWindow(config)
    self:ShowSplash()
    task.wait(0.3)
    
    config = config or {}
    setmetatable(config, {__index = self.DefaultConfig})
    
    local window = setmetatable({
        Config = config,
        Elements = {},
        Toggles = {},
        Sliders = {},
        Buttons = {},
        IsVisible = true,
        IsMinimized = false
    }, Window)
    
    window:Initialize()
    return window
end

function Window:Initialize()
    local player = game:GetService("Players").LocalPlayer
    local TweenService = game:GetService("TweenService")
    
    -- Основной GUI
    self.Gui = self:CreateElement("ScreenGui", {
        Name = "RedLibWindow",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = player.PlayerGui
    })
    
    -- Контейнер окна
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
    
    -- Градиентный фон с бликами
    local mainGradient = self:CreateElement("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 0, 0)),
            ColorSequenceKeypoint.new(0.3, Color3.fromRGB(10, 0, 0)),
            ColorSequenceKeypoint.new(0.7, Color3.fromRGB(10, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 0, 0))
        }),
        Rotation = 45,
        Parent = self.MainFrame
    })
    
    -- Блик на фоне
    local shineEffect = self:CreateElement("Frame", {
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(255, 50, 50),
        BackgroundTransparency = 0.9,
        BorderSizePixel = 0,
        Parent = self.MainFrame
    })
    
    -- Анимация блика
    spawn(function()
        while self.MainFrame and self.MainFrame.Parent do
            local moveShine = TweenService:Create(shineEffect, TweenInfo.new(2, self:EasingStyle(), Enum.EasingDirection.InOut), {
                Position = UDim2.new(0, 0, 1, -20)
            })
            moveShine:Play()
            moveShine.Completed:Wait()
            
            local moveBack = TweenService:Create(shineEffect, TweenInfo.new(2, self:EasingStyle(), Enum.EasingDirection.InOut), {
                Position = UDim2.new(0, 0, 0, 0)
            })
            moveBack:Play()
            moveBack.Completed:Wait()
        end
    end)
    
    -- Заголовок окна
    self.TitleBar = self:CreateElement("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        BorderSizePixel = 0,
        Parent = self.MainFrame
    })
    
    -- Текст заголовка
    self.Title = self:CreateElement("TextLabel", {
        Size = UDim2.new(1, -60, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = self.Config.Title,
        TextColor3 = self.Config.AccentColor,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.TitleBar
    })
    
    -- Кнопка закрытия
    self.CloseButton = self:CreateElement("TextButton", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -30, 0, 0),
        BackgroundColor3 = Color3.fromRGB(255, 50, 50),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        Text = "×",
        TextSize = 18,
        BorderSizePixel = 0,
        Parent = self.TitleBar
    })
    
    -- Кнопка сворачивания
    self.MinimizeButton = self:CreateElement("TextButton", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -60, 0, 0),
        BackgroundColor3 = Color3.fromRGB(100, 100, 100),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        Text = "_",
        TextSize = 18,
        BorderSizePixel = 0,
        Parent = self.TitleBar
    })
    
    -- Контейнер контента
    self.ContentFrame = self:CreateElement("Frame", {
        Size = UDim2.new(1, -20, 1, -50),
        Position = UDim2.new(0, 10, 0, 40),
        BackgroundTransparency = 1,
        Parent = self.MainFrame
    })
    
    -- Анимация появления окна
    local sizeTween = TweenService:Create(self.MainFrame, TweenInfo.new(self.Config.AnimationDuration, self:EasingStyle(), Enum.EasingDirection.Out), {
        Size = self.Config.WindowSize,
        Position = self.Config.WindowPosition
    })
    
    sizeTween:Play()
    sizeTween.Completed:Wait()
    
    self:SetupAnimations()
    self:SetupEvents()
end

function Window:CreateElement(className, properties)
    return RedLib:CreateElement(className, properties)
end

function Window:SetupAnimations()
    self.TweenService = game:GetService("TweenService")
    
    -- Пульсация границы окна
    spawn(function()
        while self.MainFrame and self.MainFrame.Parent do
            local glowTween = self.TweenService:Create(self.MainFrame, TweenInfo.new(1.5, self:EasingStyle(), Enum.EasingDirection.InOut), {
                BorderColor3 = self.Config.SecondaryColor
            })
            glowTween:Play()
            task.wait(1.5)
            
            local glowTween2 = self.TweenService:Create(self.MainFrame, TweenInfo.new(1.5, self:EasingStyle(), Enum.EasingDirection.InOut), {
                BorderColor3 = self.Config.BorderColor
            })
            glowTween2:Play()
            task.wait(1.5)
        end
    end)
    
    -- Анимация кнопок
    spawn(function()
        while self.MainFrame and self.MainFrame.Parent do
            local buttonPulse = self.TweenService:Create(self.CloseButton, TweenInfo.new(0.8, self:EasingStyle(), Enum.EasingDirection.Out), {
                BackgroundColor3 = Color3.fromRGB(255, 30, 30)
            })
            buttonPulse:Play()
            task.wait(0.8)
            
            local buttonPulse2 = self.TweenService:Create(self.CloseButton, TweenInfo.new(0.8, self:EasingStyle(), Enum.EasingDirection.Out), {
                BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            })
            buttonPulse2:Play()
            task.wait(0.8)
        end
    end)
end

function Window:SetupEvents()
    -- Кнопка закрытия
    self.CloseButton.MouseButton1Click:Connect(function()
        self:Close()
    end)
    
    -- Кнопка сворачивания
    self.MinimizeButton.MouseButton1Click:Connect(function()
        self:ToggleMinimize()
    end)
    
    -- Ховер эффекты для кнопок
    self.CloseButton.MouseEnter:Connect(function()
        self.TweenService:Create(self.CloseButton, TweenInfo.new(0.2, self:EasingStyle()), {
            BackgroundColor3 = Color3.fromRGB(255, 20, 20)
        }):Play()
    end)
    
    self.CloseButton.MouseLeave:Connect(function()
        self.TweenService:Create(self.CloseButton, TweenInfo.new(0.2, self:EasingStyle()), {
            BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        }):Play()
    end)
    
    self.MinimizeButton.MouseEnter:Connect(function()
        self.TweenService:Create(self.MinimizeButton, TweenInfo.new(0.2, self:EasingStyle()), {
            BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        }):Play()
    end)
    
    self.MinimizeButton.MouseLeave:Connect(function()
        self.TweenService:Create(self.MinimizeButton, TweenInfo.new(0.2, self:EasingStyle()), {
            BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        }):Play()
    end)
end

function Window:Close()
    local tween = self.TweenService:Create(self.MainFrame, TweenInfo.new(0.5, self:EasingStyle(), Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    })
    tween:Play()
    tween.Completed:Wait()
    self.Gui:Destroy()
end

function Window:ToggleMinimize()
    if self.IsMinimized then
        self:Maximize()
    else
        self:Minimize()
    end
end

function Window:Minimize()
    self.IsMinimized = true
    local tween = self.TweenService:Create(self.MainFrame, TweenInfo.new(0.3, self:EasingStyle(), Enum.EasingDirection.Out), {
        Size = UDim2.new(0, self.Config.WindowSize.Width.Offset, 0, 30)
    })
    tween:Play()
    self.MinimizeButton.Text = "+"
end

function Window:Maximize()
    self.IsMinimized = false
    local tween = self.TweenService:Create(self.MainFrame, TweenInfo.new(0.3, self:EasingStyle(), Enum.EasingDirection.Out), {
        Size = self.Config.WindowSize
    })
    tween:Play()
    self.MinimizeButton.Text = "_"
end

-- Методы для создания элементов
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

function Window:AddSlider(name, defaultValue, minValue, maxValue, callback)
    local yPosition = #self.Elements * 40
    local slider = {
        Name = name,
        Value = defaultValue or 0,
        Min = minValue or 0,
        Max = maxValue or 1,
        Callback = callback
    }
    
    local sliderFrame = self:CreateElement("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.new(0, 0, 0, yPosition),
        BackgroundTransparency = 1,
        Parent = self.ContentFrame
    })
    
    local label = self:CreateElement("TextLabel", {
        Size = UDim2.new(0, 80, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = self.Config.TextColor,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = sliderFrame
    })
    
    local track = self:CreateElement("Frame", {
        Size = UDim2.new(1, -90, 0, self.Config.SliderHeight),
        Position = UDim2.new(0, 85, 0.5, -self.Config.SliderHeight/2),
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = sliderFrame
    })
    
    local fill = self:CreateElement("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = self.Config.AccentColor,
        BorderSizePixel = 0,
        Parent = track
    })
    
    local knob = self:CreateElement("TextButton", {
        Size = UDim2.new(0, self.Config.KnobSize, 0, self.Config.KnobSize),
        Position = UDim2.new(0, -self.Config.KnobSize/2, 0.5, -self.Config.KnobSize/2),
        BackgroundColor3 = self.Config.AccentColor,
        BorderColor3 = Color3.fromRGB(100, 0, 0),
        BorderSizePixel = 2,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 2,
        Parent = sliderFrame
    })
    
    local valueLabel = self:CreateElement("TextLabel", {
        Size = UDim2.new(0, 40, 1, 0),
        Position = UDim2.new(1, -40, 0, 0),
        BackgroundTransparency = 1,
        Text = tostring(defaultValue),
        TextColor3 = self.Config.TextColor,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = sliderFrame
    })
    
    self:SetupSliderMovement(slider, knob, track, fill, valueLabel)
    
    table.insert(self.Sliders, slider)
    table.insert(self.Elements, sliderFrame)
    
    return slider
end

function Window:SetupSliderMovement(slider, knob, track, fill, valueLabel)
    local mouseletgo = false
    
    local function updateSlider(input)
        local trackAbsolutePos = track.AbsolutePosition.X
        local trackAbsoluteSize = track.AbsoluteSize.X
        local inputX = input.Position.X
        
        local percentage = (inputX - trackAbsolutePos) / trackAbsoluteSize
        percentage = math.clamp(percentage, 0, 1)
        
        local value = slider.Min + (percentage * (slider.Max - slider.Min))
        value = self:Round(value, 2)
        
        slider.Value = value
        if slider.Callback then
            slider.Callback(value)
        end
        
        knob.Position = UDim2.new(percentage, -self.Config.KnobSize/2, 0.5, -self.Config.KnobSize/2)
        fill.Size = UDim2.new(percentage, 0, 1, 0)
        valueLabel.Text = tostring(value)
    end

    knob.MouseButton1Down:Connect(function()
        local connection
        connection = game:GetService("RunService").Heartbeat:Connect(function()
            if mouseletgo then 
                connection:Disconnect()
                return 
            end
            updateSlider(mouse)
        end)
    end)

    knob.MouseButton1Up:Connect(function()
        mouseletgo = true
        task.wait(0.1)
        mouseletgo = false
    end)
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
    
    -- Анимация кнопки
    button.MouseEnter:Connect(function()
        self.TweenService:Create(button, TweenInfo.new(0.2, self:EasingStyle()), {
            BackgroundColor3 = self.Config.SecondaryColor
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        self.TweenService:Create(button, TweenInfo.new(0.2, self:EasingStyle()), {
            BackgroundColor3 = self.Config.AccentColor
        }):Play()
    end)
    
    button.MouseButton1Click:Connect(callback)
    table.insert(self.Buttons, button)
    table.insert(self.Elements, button)
    
    return button
end

function Window:AddToggle(name, defaultValue, callback)
    local toggle = {
        Name = name,
        Value = defaultValue or false,
        Callback = callback
    }
    
    local toggleFrame = self:CreateElement("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0, #self.Elements * 40),
        BackgroundTransparency = 1,
        Parent = self.ContentFrame
    })
    
    local label = self:CreateElement("TextLabel", {
        Size = UDim2.new(0, 120, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = self.Config.TextColor,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = toggleFrame
    })
    
    local toggleButton = self:CreateElement("TextButton", {
        Size = UDim2.new(0, 50, 0, 20),
        Position = UDim2.new(1, -50, 0.5, -10),
        BackgroundColor3 = defaultValue and self.Config.AccentColor or Color3.fromRGB(50, 50, 50),
        Text = "",
        BorderSizePixel = 0,
        Parent = toggleFrame
    })
    
    local toggleKnob = self:CreateElement("Frame", {
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(defaultValue and 1 or 0, defaultValue and -18 or 2, 0.5, -8),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Parent = toggleButton
    })
    
    toggleButton.MouseButton1Click:Connect(function()
        toggle.Value = not toggle.Value
        if toggle.Callback then
            toggle.Callback(toggle.Value)
        end
        
        local newPosition = toggle.Value and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        local newColor = toggle.Value and self.Config.AccentColor or Color3.fromRGB(50, 50, 50)
        
        self.TweenService:Create(toggleKnob, TweenInfo.new(0.2, self:EasingStyle()), {
            Position = newPosition
        }):Play()
        
        self.TweenService:Create(toggleButton, TweenInfo.new(0.2, self:EasingStyle()), {
            BackgroundColor3 = newColor
        }):Play()
    end)
    
    table.insert(self.Toggles, toggle)
    table.insert(self.Elements, toggleFrame)
    
    return toggle
end

-- Публичные методы
function Window:SetTitle(newTitle)
    self.Title.Text = newTitle
end

function Window:SetSize(newSize)
    self.Config.WindowSize = newSize
    self.MainFrame.Size = newSize
end

function Window:SetPosition(newPosition)
    self.Config.WindowPosition = newPosition
    self.MainFrame.Position = newPosition
end

function Window:IsMobile()
    return RedLib:IsMobile()
end

-- Глобальные методы библиотеки
function RedLib:CreateGUI(config)
    return self:CreateWindow(config)
end

function RedLib:CreateWindow(config)
    return self:CreateWindow(config)
end

function RedLib:CreatePanel(config)
    return self:CreateWindow(config)
end

function RedLib:CreateInterface(config)
    return self:CreateWindow(config)
end

function RedLib:NewWindow(config)
    return self:CreateWindow(config)
end

function RedLib:NewGUI(config)
    return self:CreateWindow(config)
end

function RedLib:Destroy()
    if self.Gui then
        self.Gui:Destroy()
    end
end

return RedLib
