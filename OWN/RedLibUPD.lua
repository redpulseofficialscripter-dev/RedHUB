local RedLibrary = {}
RedLibrary.__index = RedLibrary

-- Конфигурация
RedLibrary.Config = {
    Title = "RedPulseOWN",
    TitleColor = Color3.fromRGB(255, 0, 0),
    GlitchColor = Color3.fromRGB(200, 0, 0),
    Duration = 3,
    Font = Enum.Font.SciFi,
    TextSize = 48,
    AccentColor = Color3.fromRGB(255, 0, 0),
    BackgroundColor = Color3.fromRGB(30, 30, 30),
    HeaderColor = Color3.fromRGB(20, 20, 20),
    TabColor = Color3.fromRGB(60, 60, 60),
    ButtonColor = Color3.fromRGB(70, 70, 70)
}

function RedLibrary.new(scriptName)
    local self = setmetatable({}, RedLibrary)
    self.gui = nil
    self.tabs = {}
    self.currentTab = nil
    self.scriptName = scriptName or "RedPulseOWN"
    self.visible = true
    return self
end

function RedLibrary:ApplyRoundCorners(object)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = object
    return corner
end

function RedLibrary:MakeDraggable(gui, handle)
    local dragging = false
    local dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        gui.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X,
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

function RedLibrary:ShowIntro()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "RedLibraryIntro"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "Title"
    textLabel.Size = UDim2.new(0, 0, 0, 0)
    textLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
    textLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = self.scriptName
    textLabel.TextColor3 = self.Config.TitleColor
    textLabel.Font = self.Config.Font
    textLabel.TextSize = self.Config.TextSize
    textLabel.TextTransparency = 1
    textLabel.TextStrokeTransparency = 0.5
    textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    textLabel.Parent = screenGui
    
    -- Анимация появления
    local sizeTween = game:GetService("TweenService"):Create(
        textLabel,
        TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = UDim2.new(0, 400, 0, 80)}
    )
    
    local transparencyTween = game:GetService("TweenService"):Create(
        textLabel,
        TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {TextTransparency = 0}
    )
    
    sizeTween:Play()
    transparencyTween:Play()
    
    -- Глюк-эффект
    spawn(function()
        wait(1.2)
        self:CreateGlitchEffect(textLabel)
    end)
    
    -- Исчезновение
    spawn(function()
        wait(self.Config.Duration)
        
        local disappearTween = game:GetService("TweenService"):Create(
            textLabel,
            TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            {
                Size = UDim2.new(0, 0, 0, 0),
                TextTransparency = 1,
                TextStrokeTransparency = 1
            }
        )
        
        disappearTween:Play()
        disappearTween.Completed:Connect(function()
            screenGui:Destroy()
            self:CreateMainGUI()
        end)
    end)
end

function RedLibrary:CreateGlitchEffect(textLabel)
    local originalText = textLabel.Text
    local originalPosition = textLabel.Position
    
    for i = 1, 5 do
        textLabel.Text = ""
        wait(0.1)
        
        for _ = 1, 3 do
            textLabel.TextColor3 = self.Config.GlitchColor
            textLabel.Position = UDim2.new(
                originalPosition.X.Scale, 
                originalPosition.X.Offset + math.random(-5, 5),
                originalPosition.Y.Scale, 
                originalPosition.Y.Offset + math.random(-5, 5)
            )
            textLabel.Text = string.sub(originalText, 1, math.random(3, #originalText))
            wait(0.05)
        end
        
        textLabel.TextColor3 = self.Config.TitleColor
        textLabel.Position = originalPosition
        textLabel.Text = originalText
        wait(0.2)
    end
end

function RedLibrary:CreateMainGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "RedLibraryGUI"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    local mainContainer = Instance.new("Frame")
    mainContainer.Name = "MainContainer"
    mainContainer.Size = UDim2.new(0, 600, 0, 450)
    mainContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainContainer.AnchorPoint = Vector2.new(0.5, 0.5)
    mainContainer.BackgroundColor3 = self.Config.BackgroundColor
    mainContainer.BorderSizePixel = 0
    mainContainer.ClipsDescendants = true
    mainContainer.Parent = screenGui
    self:ApplyRoundCorners(mainContainer)
    
    -- Header с кнопками управления
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 40)
    header.Position = UDim2.new(0, 0, 0, 0)
    header.BackgroundColor3 = self.Config.HeaderColor
    header.BorderSizePixel = 0
    header.Parent = mainContainer
    
    -- Заголовок
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(0, 200, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = self.scriptName
    title.TextColor3 = self.Config.TitleColor
    title.Font = Enum.Font.SciFi
    title.TextSize = 20
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header
    
    -- Кнопка закрытия
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 80, 0, 30)
    closeButton.Position = UDim2.new(1, -90, 0.5, -15)
    closeButton.AnchorPoint = Vector2.new(0, 0.5)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeButton.BorderSizePixel = 0
    closeButton.Text = "Закрыть"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.Font = Enum.Font.SciFi
    closeButton.TextSize = 14
    closeButton.Parent = header
    self:ApplyRoundCorners(closeButton)
    
    closeButton.MouseButton1Click:Connect(function()
        self:Destroy()
    end)
    
    -- Кнопка скрытия/показа
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, 80, 0, 30)
    toggleButton.Position = UDim2.new(1, -180, 0.5, -15)
    toggleButton.AnchorPoint = Vector2.new(0, 0.5)
    toggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    toggleButton.BorderSizePixel = 0
    toggleButton.Text = "Скрыть"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.Font = Enum.Font.SciFi
    toggleButton.TextSize = 14
    toggleButton.Parent = header
    self:ApplyRoundCorners(toggleButton)
    
    toggleButton.MouseButton1Click:Connect(function()
        self:ToggleVisibility()
    end)
    
    -- Делаем header перетаскиваемым
    self:MakeDraggable(mainContainer, header)
    
    -- Контейнер для вкладок и контента
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Size = UDim2.new(1, -10, 1, -50)
    contentContainer.Position = UDim2.new(0, 5, 0, 45)
    contentContainer.BackgroundTransparency = 1
    contentContainer.BorderSizePixel = 0
    contentContainer.Parent = mainContainer
    
    -- Панель вкладок
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(0, 150, 1, 0)
    tabContainer.Position = UDim2.new(0, 0, 0, 0)
    tabContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tabContainer.BorderSizePixel = 0
    tabContainer.Parent = contentContainer
    self:ApplyRoundCorners(tabContainer)
    
    local tabList = Instance.new("UIListLayout")
    tabList.Parent = tabContainer
    tabList.Padding = UDim.new(0, 5)
    tabList.SortOrder = Enum.SortOrder.LayoutOrder
    
    -- Контейнер контента
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, -160, 1, 0)
    contentFrame.Position = UDim2.new(0, 160, 0, 0)
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0
    contentFrame.ClipsDescendants = true
    contentFrame.Parent = contentContainer
    
    -- Анимация появления
    mainContainer.Size = UDim2.new(0, 0, 0, 0)
    
    local appearTween = game:GetService("TweenService"):Create(
        mainContainer,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = UDim2.new(0, 600, 0, 450)}
    )
    
    appearTween:Play()
    
    self.gui = screenGui
    self.tabContainer = tabContainer
    self.contentFrame = contentFrame
    return screenGui
end

function RedLibrary:AddTab(tabName)
    if not self.gui or not self.tabContainer then return nil end
    
    local tabButton = Instance.new("TextButton")
    tabButton.Name = "Tab_" .. tabName
    tabButton.Size = UDim2.new(1, -10, 0, 40)
    tabButton.Position = UDim2.new(0, 5, 0, 0)
    tabButton.BackgroundColor3 = self.Config.TabColor
    tabButton.BorderSizePixel = 0
    tabButton.Text = tabName
    tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    tabButton.Font = Enum.Font.SciFi
    tabButton.TextSize = 16
    tabButton.Parent = self.tabContainer
    self:ApplyRoundCorners(tabButton)
    
    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Name = "TabContent_" .. tabName
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.Position = UDim2.new(0, 0, 0, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.BorderSizePixel = 0
    tabContent.ScrollBarThickness = 5
    tabContent.Visible = false
    tabContent.Parent = self.contentFrame
    
    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.Parent = tabContent
    uiListLayout.Padding = UDim.new(0, 5)
    
    self.tabs[tabName] = {
        Button = tabButton,
        Content = tabContent,
        Elements = {}
    }
    
    tabButton.MouseButton1Click:Connect(function()
        self:SwitchTab(tabName)
    end)
    
    -- Активируем первую вкладку
    if not self.currentTab then
        self:SwitchTab(tabName)
    end
    
    return self.tabs[tabName]
end

function RedLibrary:SwitchTab(tabName)
    if not self.tabs[tabName] or self.currentTab == tabName then return end
    
    -- Скрываем текущую вкладку
    if self.currentTab then
        self.tabs[self.currentTab].Content.Visible = false
        self.tabs[self.currentTab].Button.BackgroundColor3 = self.Config.TabColor
    end
    
    -- Показываем новую вкладку
    self.tabs[tabName].Content.Visible = true
    self.tabs[tabName].Button.BackgroundColor3 = self.Config.AccentColor
    self.currentTab = tabName
end

function RedLibrary:AddButton(tabName, text, callback)
    if not self.tabs[tabName] then return end
    
    local tab = self.tabs[tabName]
    local button = Instance.new("TextButton")
    button.Name = "Button_" .. text
    button.Size = UDim2.new(1, -10, 0, 40)
    button.Position = UDim2.new(0, 5, 0, 0)
    button.BackgroundColor3 = self.Config.ButtonColor
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.SciFi
    button.TextSize = 16
    button.Parent = tab.Content
    self:ApplyRoundCorners(button)
    
    button.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(
            button,
            TweenInfo.new(0.2),
            {BackgroundColor3 = Color3.fromRGB(90, 90, 90)}
        ):Play()
    end)
    
    button.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(
            button,
            TweenInfo.new(0.2),
            {BackgroundColor3 = self.Config.ButtonColor}
        ):Play()
    end)
    
    button.MouseButton1Click:Connect(callback)
    
    table.insert(tab.Elements, button)
    return button
end

function RedLibrary:AddLabel(tabName, text)
    if not self.tabs[tabName] then return end
    
    local tab = self.tabs[tabName]
    local label = Instance.new("TextLabel")
    label.Name = "Label_" .. text
    label.Size = UDim2.new(1, -10, 0, 30)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.SciFi
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = tab.Content
    
    table.insert(tab.Elements, label)
    return label
end

function RedLibrary:AddToggle(tabName, text, defaultValue, callback)
    if not self.tabs[tabName] then return end
    
    local tab = self.tabs[tabName]
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = "Toggle_" .. text
    toggleFrame.Size = UDim2.new(1, -10, 0, 40)
    toggleFrame.Position = UDim2.new(0, 5, 0, 0)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = tab.Content
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Name = "ToggleLabel"
    toggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    toggleLabel.Position = UDim2.new(0, 0, 0, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = text
    toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleLabel.Font = Enum.Font.SciFi
    toggleLabel.TextSize = 16
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Parent = toggleFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, 50, 0, 25)
    toggleButton.Position = UDim2.new(1, -55, 0.5, -12.5)
    toggleButton.AnchorPoint = Vector2.new(1, 0.5)
    toggleButton.BackgroundColor3 = defaultValue and self.Config.AccentColor or Color3.fromRGB(80, 80, 80)
    toggleButton.BorderSizePixel = 0
    toggleButton.Text = defaultValue and "ON" or "OFF"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.Font = Enum.Font.SciFi
    toggleButton.TextSize = 12
    toggleButton.Parent = toggleFrame
    self:ApplyRoundCorners(toggleButton)
    
    local state = defaultValue
    
    toggleButton.MouseButton1Click:Connect(function()
        state = not state
        toggleButton.BackgroundColor3 = state and self.Config.AccentColor or Color3.fromRGB(80, 80, 80)
        toggleButton.Text = state and "ON" or "OFF"
        if callback then callback(state) end
    end)
    
    table.insert(tab.Elements, toggleFrame)
    return toggleFrame
end

function RedLibrary:AddSlider(tabName, text, min, max, defaultValue, callback)
    if not self.tabs[tabName] then return end
    
    local tab = self.tabs[tabName]
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = "Slider_" .. text
    sliderFrame.Size = UDim2.new(1, -10, 0, 60)
    sliderFrame.Position = UDim2.new(0, 5, 0, 0)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = tab.Content
    
    local sliderLabel = Instance.new("TextLabel")
    sliderLabel.Name = "SliderLabel"
    sliderLabel.Size = UDim2.new(1, 0, 0, 20)
    sliderLabel.Position = UDim2.new(0, 0, 0, 0)
    sliderLabel.BackgroundTransparency = 1
    sliderLabel.Text = text .. ": " .. defaultValue
    sliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    sliderLabel.Font = Enum.Font.SciFi
    sliderLabel.TextSize = 14
    sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    sliderLabel.Parent = sliderFrame
    
    local sliderTrack = Instance.new("Frame")
    sliderTrack.Name = "SliderTrack"
    sliderTrack.Size = UDim2.new(1, 0, 0, 10)
    sliderTrack.Position = UDim2.new(0, 0, 0, 30)
    sliderTrack.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    sliderTrack.BorderSizePixel = 0
    sliderTrack.Parent = sliderFrame
    self:ApplyRoundCorners(sliderTrack)
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "SliderFill"
    sliderFill.Size = UDim2.new((defaultValue - min) / (max - min), 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = self.Config.AccentColor
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderTrack
    self:ApplyRoundCorners(sliderFill)
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Name = "SliderButton"
    sliderButton.Size = UDim2.new(0, 20, 0, 20)
    sliderButton.Position = UDim2.new((defaultValue - min) / (max - min), -10, 0.5, -10)
    sliderButton.AnchorPoint = Vector2.new(0, 0.5)
    sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderButton.BorderSizePixel = 0
    sliderButton.Text = ""
    sliderButton.Parent = sliderTrack
    self:ApplyRoundCorners(sliderButton)
    
    local dragging = false
    
    local function updateValue(input)
        local relativeX = (input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X
        relativeX = math.clamp(relativeX, 0, 1)
        local value = math.floor(min + (max - min) * relativeX)
        
        sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
        sliderButton.Position = UDim2.new(relativeX, -10, 0.5, -10)
        sliderLabel.Text = text .. ": " .. value
        
        if callback then callback(value) end
    end
    
    sliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateValue(input)
        end
    end)
    
    sliderButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateValue(input)
        end
    end)
    
    table.insert(tab.Elements, sliderFrame)
    return sliderFrame
end

function RedLibrary:AddDropdown(tabName, text, options, callback)
    if not self.tabs[tabName] then return end
    
    local tab = self.tabs[tabName]
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Name = "Dropdown_" .. text
    dropdownFrame.Size = UDim2.new(1, -10, 0, 40)
    dropdownFrame.Position = UDim2.new(0, 5, 0, 0)
    dropdownFrame.BackgroundTransparency = 1
    dropdownFrame.ClipsDescendants = true
    dropdownFrame.Parent = tab.Content
    
    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Name = "DropdownButton"
    dropdownButton.Size = UDim2.new(1, 0, 0, 40)
    dropdownButton.Position = UDim2.new(0, 0, 0, 0)
    dropdownButton.BackgroundColor3 = self.Config.ButtonColor
    dropdownButton.BorderSizePixel = 0
    dropdownButton.Text = text .. ": " .. (options[1] or "Выбрать")
    dropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdownButton.Font = Enum.Font.SciFi
    dropdownButton.TextSize = 16
    dropdownButton.Parent = dropdownFrame
    self:ApplyRoundCorners(dropdownButton)
    
    local dropdownOpen = false
    local optionFrames = {}
    
    local function toggleDropdown()
        dropdownOpen = not dropdownOpen
        for _, frame in pairs(optionFrames) do
            frame.Visible = dropdownOpen
        end
        dropdownFrame.Size = UDim2.new(1, -10, 0, dropdownOpen and (40 + #options * 35) or 40)
    end
    
    dropdownButton.MouseButton1Click:Connect(toggleDropdown)
    
    for i, option in ipairs(options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Name = "Option_" .. option
        optionButton.Size = UDim2.new(1, 0, 0, 30)
        optionButton.Position = UDim2.new(0, 0, 0, 40 + (i-1) * 35)
        optionButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        optionButton.BorderSizePixel = 0
        optionButton.Text = option
        optionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        optionButton.Font = Enum.Font.SciFi
        optionButton.TextSize = 14
        optionButton.Visible = false
        optionButton.Parent = dropdownFrame
        self:ApplyRoundCorners(optionButton)
        
        optionButton.MouseButton1Click:Connect(function()
            dropdownButton.Text = text .. ": " .. option
            toggleDropdown()
            if callback then callback(option) end
        end)
        
        table.insert(optionFrames, optionButton)
    end
    
    table.insert(tab.Elements, dropdownFrame)
    return dropdownFrame
end

function RedLibrary:AddTextbox(tabName, text, placeholder, callback)
    if not self.tabs[tabName] then return end
    
    local tab = self.tabs[tabName]
    local textboxFrame = Instance.new("Frame")
    textboxFrame.Name = "Textbox_" .. text
    textboxFrame.Size = UDim2.new(1, -10, 0, 50)
    textboxFrame.Position = UDim2.new(0, 5, 0, 0)
    textboxFrame.BackgroundTransparency = 1
    textboxFrame.Parent = tab.Content
    
    local textboxLabel = Instance.new("TextLabel")
    textboxLabel.Name = "TextboxLabel"
    textboxLabel.Size = UDim2.new(1, 0, 0, 20)
    textboxLabel.Position = UDim2.new(0, 0, 0, 0)
    textboxLabel.BackgroundTransparency = 1
    textboxLabel.Text = text
    textboxLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textboxLabel.Font = Enum.Font.SciFi
    textboxLabel.TextSize = 14
    textboxLabel.TextXAlignment = Enum.TextXAlignment.Left
    textboxLabel.Parent = textboxFrame
    
    local textbox = Instance.new("TextBox")
    textbox.Name = "Textbox"
    textbox.Size = UDim2.new(1, 0, 0, 30)
    textbox.Position = UDim2.new(0, 0, 0, 25)
    textbox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    textbox.BorderSizePixel = 0
    textbox.Text = ""
    textbox.PlaceholderText = placeholder or "Введите текст..."
    textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textbox.Font = Enum.Font.SciFi
    textbox.TextSize = 14
    textbox.Parent = textboxFrame
    self:ApplyRoundCorners(textbox)
    
    textbox.FocusLost:Connect(function(enterPressed)
        if enterPressed and callback then
            callback(textbox.Text)
        end
    end)
    
    table.insert(tab.Elements, textboxFrame)
    return textboxFrame
end

function RedLibrary:AddSeparator(tabName)
    if not self.tabs[tabName] then return end
    
    local tab = self.tabs[tabName]
    local separator = Instance.new("Frame")
    separator.Name = "Separator"
    separator.Size = UDim2.new(1, -10, 0, 2)
    separator.Position = UDim2.new(0, 5, 0, 0)
    separator.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    separator.BorderSizePixel = 0
    separator.Parent = tab.Content
    
    table.insert(tab.Elements, separator)
    return separator
end

function RedLibrary:ToggleVisibility()
    if not self.gui then return end
    
    self.visible = not self.visible
    self.gui.Enabled = self.visible
    
    local toggleButton = self.gui.MainContainer.Header.ToggleButton
    if toggleButton then
        toggleButton.Text = self.visible and "Скрыть" or "Показать"
    end
end

function RedLibrary:Notify(title, message, duration)
    duration = duration or 5
    
    local notifyGui = Instance.new("ScreenGui")
    notifyGui.Name = "Notification"
    notifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    notifyGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    local notifyFrame = Instance.new("Frame")
    notifyFrame.Name = "NotifyFrame"
    notifyFrame.Size = UDim2.new(0, 300, 0, 80)
    notifyFrame.Position = UDim2.new(1, -320, 1, -100)
    notifyFrame.AnchorPoint = Vector2.new(1, 1)
    notifyFrame.BackgroundColor3 = self.Config.BackgroundColor
    notifyFrame.BorderSizePixel = 0
    notifyFrame.Parent = notifyGui
    self:ApplyRoundCorners(notifyFrame)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -10, 0, 25)
    titleLabel.Position = UDim2.new(0, 5, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = self.Config.AccentColor
    titleLabel.Font = Enum.Font.SciFi
    titleLabel.TextSize = 18
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = notifyFrame
    
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Name = "Message"
    messageLabel.Size = UDim2.new(1, -10, 1, -35)
    messageLabel.Position = UDim2.new(0, 5, 0, 30)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = message
    messageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    messageLabel.Font = Enum.Font.SciFi
    messageLabel.TextSize = 14
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextYAlignment = Enum.TextYAlignment.Top
    messageLabel.TextWrapped = true
    messageLabel.Parent = notifyFrame
    
    notifyFrame.Position = UDim2.new(1, 300, 1, -100)
    
    local slideIn = game:GetService("TweenService"):Create(
        notifyFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Position = UDim2.new(1, -320, 1, -100)}
    )
    
    slideIn:Play()
    
    wait(duration)
    
    local slideOut = game:GetService("TweenService"):Create(
        notifyFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Position = UDim2.new(1, 300, 1, -100)}
    )
    
    slideOut:Play()
    slideOut.Completed:Connect(function()
        notifyGui:Destroy()
    end)
end

function RedLibrary:Destroy()
    if self.gui then
        self.gui:Destroy()
        self.gui = nil
    end
    self.tabs = {}
    self.currentTab = nil
end

return RedLibrary
