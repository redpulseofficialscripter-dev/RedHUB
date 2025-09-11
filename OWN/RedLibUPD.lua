-- RedLibUPD Fixed Version
-- by redpulse

local RedLib = {}
RedLib.__index = RedLib

-- Конфигурация по умолчанию
RedLib.DefaultConfig = {
    WindowSize = UDim2.new(0, 350, 0, 250),
    WindowPosition = UDim2.new(0.3, 0, 0.3, 0),
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
    
    local splashText = self:CreateElement("TextLabel", {
        Size = UDim2.new(0, 200, 0, 50),
        Position = UDim2.new(0.5, -100, 0.5, -25),
        BackgroundTransparency = 1,
        Text = "RedLibrary",
        TextColor3 = Color3.fromRGB(255, 0, 0),
        Font = Enum.Font.GothamBold,
        TextSize = 24,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextTransparency = 0,
        Parent = splashGui
    })
    
    -- Анимация пульсации
    for i = 1, 3 do
        local pulseOut = TweenService:Create(splashText, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextColor3 = Color3.fromRGB(150, 0, 0),
            TextSize = 22
        })
        
        local pulseIn = TweenService:Create(splashText, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextColor3 = Color3.fromRGB(255, 0, 0),
            TextSize = 24
        })
        
        pulseOut:Play()
        pulseOut.Completed:Wait()
        pulseIn:Play()
        pulseIn.Completed:Wait()
        task.wait(0.2)
    end
    
    -- Исчезновение
    local fadeOut = TweenService:Create(splashText, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 1
    })
    fadeOut:Play()
    fadeOut.Completed:Wait()
    
    splashGui:Destroy()
end

-- Класс Window
local Window = {}
Window.__index = Window

-- ФИКС: Убрана рекурсия - переименована основная функция
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

-- Публичный метод для пользователя
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
        Size = self.Config.WindowSize,
        Position = UDim2.new(0.5, -self.Config.WindowSize.Width.Offset/2, 0.5, -self.Config.WindowSize.Height.Offset/2),
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
    
    if self:IsMobile() then
        local UIS = game:GetService("UserInputService")
        local swipeStartPos = nil
        
        UIS.TouchStarted:Connect(function(input, processed)
            if not processed and self.MainFrame:IsDescendantOf(game) then
                swipeStartPos = input.Position
            end
        end)
        
        UIS.TouchEnded:Connect(function(input, processed)
            if swipeStartPos and not processed then
                local swipeEndPos = input.Position
                local swipeDistance = (swipeEndPos - swipeStartPos).X
                
                if math.abs(swipeDistance) > 50 then
                    if swipeDistance > 0 and not self.IsVisible then
                        self:Show()
                    elseif swipeDistance < 0 and self.IsVisible then
                        self:Hide()
                    end
                end
                swipeStartPos = nil
            end
        end)
    end
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
        Position = UDim2.new(0.5, -self.Config.WindowSize.Width.Offset/2, 0.5, -self.Config.WindowSize.Height.Offset/2)
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
        Size = UDim2.new(0, 60, 1, 0),
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
        Size = UDim2.new(1, -70, 0, self.Config.SliderHeight),
        Position = UDim2.new(0, 65, 0.5, -self.Config.SliderHeight/2),
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
    
    local touchArea = self:CreateElement("TextButton", {
        Size = UDim2.new(1, -70, 1, 0),
        Position = UDim2.new(0, 65, 0, 0),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 3,
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
    
    self:SetupSliderMovement(slider, knob, touchArea, track, fill, valueLabel)
    
    slider.Gui = {
        Frame = sliderFrame,
        Knob = knob,
        Track = track,
        Fill = fill,
        ValueLabel = valueLabel
    }
    
    table.insert(self.Sliders, slider)
    table.insert(self.Elements, sliderFrame)
    
    return slider
end

function Window:SetupSliderMovement(slider, knob, touchArea, track, fill, valueLabel)
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
        knob.Rotation = percentage * 360 - 180
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

    if self:IsMobile() then
        touchArea.TouchTap:Connect(function(touchPositions)
            if #touchPositions > 0 then
                local fakeInput = {Position = Vector2.new(touchPositions[1].X, touchPositions[1].Y)}
                updateSlider(fakeInput)
            end
        end)
    end
    
    local function releaseInput()
        mouseletgo = true
        task.wait(0.1)
        mouseletgo = false
    end
    
    knob.MouseButton1Up:Connect(releaseInput)
    if self:IsMobile() then
        game:GetService("UserInputService").TouchEnded:Connect(releaseInput)
    end
end

function Window:IsMobile()
    return RedLib:IsMobile()
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
