-- Ultimate UI Library (вдохновлено Orion + Linoria + современный дизайн)
-- Автор: Grok (сделано специально для тебя)

local Library = {}

-- Загружаем иконки Lucide из твоего JSON
local Icons = game:HttpGet("https://raw.githubusercontent.com/frappedevs/lucideblox/master/src/modules/util/icons.json")
Icons = game:GetService("HttpService"):JSONDecode(Icons)

-- Сервисы
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Создаём основной экран
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltimateUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

-- Основной фрейм
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 650, 0, 500)
MainFrame.Position = UDim2.new(0.5, -325, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- Градиентный фон (очень красиво)
local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 20))
}
UIGradient.Rotation = 45
UIGradient.Parent = MainFrame

-- Закругление
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 14)
UICorner.Parent = MainFrame

-- Тень (glow)
local Shadow = Instance.new("ImageLabel")
Shadow.Size = UDim2.new(1, 40, 1, 40)
Shadow.Position = UDim2.new(0, -20, 0, -20)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://6014261993"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.6
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(49, 49, 450, 450)
Shadow.ZIndex = -1
Shadow.Parent = MainFrame

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -120, 0, 50)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Ultimate UI Library"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 24
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- Кнопка закрытия
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 40, 0, 40)
CloseButton.Position = UDim2.new(1, -50, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.new(1,1,1)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 20
CloseButton.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 10)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Контейнер для вкладок
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(0, 150, 1, -60)
TabContainer.Position = UDim2.new(0, 0, 0, 60)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

local TabScrolling = Instance.new("ScrollingFrame")
TabScrolling.Size = UDim2.new(1, 0, 1, 0)
TabScrolling.BackgroundTransparency = 1
TabScrolling.ScrollBarThickness = 4
TabScrolling.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 70)
TabScrolling.Parent = TabContainer

local TabList = Instance.new("UIListLayout")
TabList.Padding = UDim.new(0, 8)
TabList.SortOrder = Enum.SortOrder.LayoutOrder
TabList.Parent = TabScrolling

-- Контейнер контента
local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -160, 1, -60)
ContentContainer.Position = UDim2.new(0, 160, 0, 60)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

-- Перетаскивание окна
local dragging, dragInput, dragStart, startPos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Функция создания вкладки
function Library:CreateTab(name, icon)
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, -20, 0, 50)
    TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    TabButton.Text = ""
    TabButton.AutoButtonColor = false
    TabButton.Parent = TabScrolling
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 10)
    TabCorner.Parent = TabButton
    
    local TabIcon = Instance.new("ImageLabel")
    TabIcon.Size = UDim2.new(0, 24, 0, 24)
    TabIcon.Position = UDim2.new(0, 15, 0.5, -12)
    TabIcon.BackgroundTransparency = 1
    TabIcon.Image = "rbxassetid://0" -- по умолчанию
    TabIcon.ImageColor3 = Color3.fromRGB(180, 180, 190)
    TabIcon.Parent = TabButton
    
    -- Ищем иконку Lucide
    if icon and Icons[icon] then
        TabIcon.Image = "rbxassetid://" .. Icons[icon]
    end
    
    local TabText = Instance.new("TextLabel")
    TabText.Size = UDim2.new(1, -60, 1, 0)
    TabText.Position = UDim2.new(0, 55, 0, 0)
    TabText.BackgroundTransparency = 1
    TabText.Text = name
    TabText.TextColor3 = Color3.fromRGB(200, 200, 210)
    TabText.TextSize = 16
    TabText.Font = Enum.Font.GothamSemibold
    TabText.TextXAlignment = Enum.TextXAlignment.Left
    TabText.Parent = TabButton
    
    -- Контейнер для контента вкладки
    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.BackgroundTransparency = 1
    TabContent.ScrollBarThickness = 4
    TabContent.Visible = false
    TabContent.Parent = ContentContainer
    
    local ContentList = Instance.new("UIListLayout")
    ContentList.Padding = UDim.new(0, 10)
    ContentList.SortOrder = Enum.SortOrder.LayoutOrder
    ContentList.Parent = TabContent
    
    local ContentPadding = Instance.new("UIPadding")
    ContentPadding.PaddingLeft = UDim.new(0, 15)
    ContentPadding.PaddingRight = UDim.new(0, 15)
    ContentPadding.PaddingTop = UDim.new(0, 15)
    ContentPadding.PaddingBottom = UDim.new(0, 15)
    ContentPadding.Parent = TabContent
    
    -- Активная вкладка
    local function SelectTab()
        for _, tab in pairs(ContentContainer:GetChildren()) do
            if tab:IsA("ScrollingFrame") then
                tab.Visible = false
            end
        end
        TabContent.Visible = true
        
        for _, btn in pairs(TabScrolling:GetChildren()) do
            if btn:IsA("TextButton") then
                TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}):Play()
                btn.TextLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
                btn.ImageLabel.ImageColor3 = Color3.fromRGB(180, 180, 190)
            end
        end
        
        TweenService:Create(TabButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(60, 160, 255)}):Play()
        TabText.TextColor3 = Color3.new(1, 1, 1)
        TabIcon.ImageColor3 = Color3.new(1, 1, 1)
    end
    
    TabButton.MouseButton1Click:Connect(SelectTab)
    
    -- Первая вкладка сразу активна
    if #TabScrolling:GetChildren() == 2 then
        SelectTab()
    end
    
    -- API для вкладки
    local Tab = {}
    
    function Tab:CreateButton(text, callback)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, 0, 0, 50)
        Button.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        Button.Text = text
        Button.TextColor3 = Color3.new(1,1,1)
        Button.Font = Enum.Font.GothamSemibold
        Button.TextSize = 16
        Button.AutoButtonColor = false
        Button.Parent = TabContent
        
        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 10)
        BtnCorner.Parent = Button
        
        Button.MouseEnter:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 70)}):Play()
        end)
        
        Button.MouseLeave:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}):Play()
        end)
        
        Button.MouseButton1Click:Connect(function()
            if callback then callback() end
        end)
        
        return Button
    end
    
    function Tab:CreateToggle(text, default, callback)
        local Toggle = Instance.new("TextButton")
        Toggle.Size = UDim2.new(1, 0, 0, 50)
        Toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        Toggle.Text = ""
        Toggle.AutoButtonColor = false
        Toggle.Parent = TabContent
        
        local ToggleCorner = Instance.new("UICorner")
        ToggleCorner.CornerRadius = UDim.new(0, 10)
        ToggleCorner.Parent = Toggle
        
        local ToggleLabel = Instance.new("TextLabel")
        ToggleLabel.Size = UDim2.new(1, -80, 1, 0)
        ToggleLabel.Position = UDim2.new(0, 15, 0, 0)
        ToggleLabel.BackgroundTransparency = 1
        ToggleLabel.Text = text
        ToggleLabel.TextColor3 = Color3.new(1,1,1)
        ToggleLabel.TextSize = 16
        ToggleLabel.Font = Enum.Font.GothamSemibold
        ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        ToggleLabel.Parent = Toggle
        
        local ToggleIndicator = Instance.new("Frame")
        ToggleIndicator.Size = UDim2.new(0, 44, 0, 24)
        ToggleIndicator.Position = UDim2.new(1, -60, 0.5, -12)
        ToggleIndicator.BackgroundColor3 = default and Color3.fromRGB(60, 160, 255) or Color3.fromRGB(70, 70, 80)
        ToggleIndicator.Parent = Toggle
        
        local IndicatorCorner = Instance.new("UICorner")
        IndicatorCorner.CornerRadius = UDim.new(1, 0)
        IndicatorCorner.Parent = ToggleIndicator
        
        local IndicatorCircle = Instance.new("Frame")
        IndicatorCircle.Size = UDim2.new(0, 18, 0, 18)
        IndicatorCircle.Position = default and UDim2.new(0, 24, 0.5, -9) or UDim2.new(0, 4, 0.5, -9)
        IndicatorCircle.BackgroundColor3 = Color3.new(1,1,1)
        IndicatorCircle.Parent = ToggleIndicator
        
        local CircleCorner = Instance.new("UICorner")
        CircleCorner.CornerRadius = UDim.new(1, 0)
        CircleCorner.Parent = IndicatorCircle
        
        local state = default
        
        Toggle.MouseButton1Click:Connect(function()
            state = not state
            TweenService:Create(ToggleIndicator, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                BackgroundColor3 = state and Color3.fromRGB(60, 160, 255) or Color3.fromRGB(70, 70, 80)
            }):Play()
            
            TweenService:Create(IndicatorCircle, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Position = state and UDim2.new(0, 24, 0.5, -9) or UDim2.new(0, 4, 0.5, -9)
            }):Play()
            
            if callback then callback(state) end
        end)
        
        return Toggle
    end
    
    -- Добавь сюда другие элементы: Slider, Dropdown, Keybind и т.д. (по запросу)
    
    return Tab
end

-- Возвращаем библиотеку
return Library
