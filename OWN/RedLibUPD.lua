local RedLibrary = {}
RedLibrary.__index = RedLibrary

-- Конфигурация
RedLibrary.Config = {
    Title = "RedLibrary",
    TitleColor = Color3.fromRGB(255, 0, 0),
    GlitchColor = Color3.fromRGB(200, 0, 0),
    Duration = 3,
    Font = Enum.Font.SciFi,
    TextSize = 48
}

function RedLibrary.new()
    local self = setmetatable({}, RedLibrary)
    self.gui = nil
    return self
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
    textLabel.Text = ""
    textLabel.TextColor3 = self.Config.TitleColor
    textLabel.Font = self.Config.Font
    textLabel.TextSize = self.Config.TextSize
    textLabel.TextStrokeTransparency = 0.5
    textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    textLabel.Parent = screenGui
    
    -- Анимация появления
    local appearTween = game:GetService("TweenService"):Create(
        textLabel,
        TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {
            Size = UDim2.new(0, 300, 0, 60),
            Text = self.Config.Title
        }
    )
    
    appearTween:Play()
    
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
        
        -- Случайные глюки
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
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 300, 0, 400)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui
    
    -- Заголовок
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    title.BorderSizePixel = 0
    title.Text = "RedLibrary"
    title.TextColor3 = self.Config.TitleColor
    title.Font = self.Config.Font
    title.TextSize = 24
    title.Parent = mainFrame
    
    -- Контент
    local content = Instance.new("ScrollingFrame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -10, 1, -50)
    content.Position = UDim2.new(0, 5, 0, 45)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 5
    content.Parent = mainFrame
    
    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.Parent = content
    uiListLayout.Padding = UDim.new(0, 5)
    
    -- Анимация появления GUI
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    
    local appearTween = game:GetService("TweenService"):Create(
        mainFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {
            Size = UDim2.new(0, 300, 0, 400)
        }
    )
    
    appearTween:Play()
    
    self.gui = screenGui
    return screenGui
end

function RedLibrary:AddButton(text, callback)
    if not self.gui then return end
    
    local content = self.gui.MainFrame.Content
    local button = Instance.new("TextButton")
    button.Name = "Button_" .. text
    button.Size = UDim2.new(1, 0, 0, 40)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.SciFi
    button.TextSize = 18
    button.Parent = content
    
    button.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(
            button,
            TweenInfo.new(0.2),
            {BackgroundColor3 = Color3.fromRGB(80, 80, 80)}
        ):Play()
    end)
    
    button.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(
            button,
            TweenInfo.new(0.2),
            {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}
        ):Play()
    end)
    
    button.MouseButton1Click:Connect(callback)
end

function RedLibrary:Destroy()
    if self.gui then
        self.gui:Destroy()
        self.gui = nil
    end
end

return RedLibrary
