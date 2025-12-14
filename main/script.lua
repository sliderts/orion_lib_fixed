local UltimateOrionLib = {}

local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local success, IconsJson = pcall(function()
    return HttpService:JSONDecode(HttpService:GetAsync("https://raw.githubusercontent.com/frappedevs/lucideblox/master/src/modules/util/icons.json"))
end)
if not success then IconsJson = {} end

local Colors = {
    Background = Color3.fromRGB(20, 20, 25),
    Accent = Color3.fromRGB(100, 150, 255),
    Text = Color3.fromRGB(220, 220, 230),
    Secondary = Color3.fromRGB(35, 35, 40),
    Tertiary = Color3.fromRGB(50, 50, 55),
    ToggleOff = Color3.fromRGB(80, 80, 90),
    ToggleOn = Color3.fromRGB(100, 150, 255)
}

local NotificationHolder = Instance.new("ScreenGui")
NotificationHolder.Name = "NotificationHolder"
NotificationHolder.DisplayOrder = 999
NotificationHolder.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
NotificationHolder.Parent = PlayerGui

function UltimateOrionLib:MakeNotification(options)
    local Title = options.Name or "Notification"
    local Content = options.Content or "Content"
    local Icon = options.Image or "bell"
    local Time = options.Time or 5
    
    local NotifFrame = Instance.new("Frame")
    NotifFrame.Size = UDim2.new(0, 300, 0, 80)
    NotifFrame.Position = UDim2.new(1, 320, 1, -100)
    NotifFrame.BackgroundColor3 = Colors.Background
    NotifFrame.BorderSizePixel = 0
    NotifFrame.Parent = NotificationHolder
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = NotifFrame
    
    local NotifIcon = Instance.new("ImageLabel")
    NotifIcon.Size = UDim2.new(0, 24, 0, 24)
    NotifIcon.Position = UDim2.new(0, 15, 0, 15)
    NotifIcon.BackgroundTransparency = 1
    NotifIcon.Image = "rbxassetid://" .. (IconsJson[Icon] or 0)
    NotifIcon.ImageColor3 = Colors.Accent
    NotifIcon.Parent = NotifFrame
    
    local NotifTitle = Instance.new("TextLabel")
    NotifTitle.Size = UDim2.new(1, -50, 0, 20)
    NotifTitle.Position = UDim2.new(0, 50, 0, 10)
    NotifTitle.Text = Title
    NotifTitle.TextColor3 = Colors.Text
    NotifTitle.Font = Enum.Font.GothamBold
    NotifTitle.TextSize = 16
    NotifTitle.BackgroundTransparency = 1
    NotifTitle.Parent = NotifFrame
    
    local NotifContent = Instance.new("TextLabel")
    NotifContent.Size = UDim2.new(1, -50, 0, 40)
    NotifContent.Position = UDim2.new(0, 50, 0, 30)
    NotifContent.Text = Content
    NotifContent.TextColor3 = Colors.Text
    NotifContent.Font = Enum.Font.Gotham
    NotifContent.TextSize = 14
    NotifContent.BackgroundTransparency = 1
    NotifContent.TextWrapped = true
    NotifContent.Parent = NotifFrame
    
    TweenService:Create(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Position = UDim2.new(1, -320, 1, -100)}):Play()
    
    task.wait(Time)
    
    TweenService:Create(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Position = UDim2.new(1, 320, 1, -100)}):Play()
    task.wait(0.5)
    NotifFrame:Destroy()
end

function UltimateOrionLib:MakeWindow(options)
    local Name = options.Name or "Ultimate Hub"
    local SaveConfig = options.SaveConfig or false
    local ConfigFolder = options.ConfigFolder or "Configs"
    
    local Window = {}
    Window.Flags = {}
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UltimateUI"
    ScreenGui.DisplayOrder = 1000
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = PlayerGui
    
    ScreenGui.AncestryChanged:Connect(function()
        if not ScreenGui.Parent then
            task.delay(1, function()
                if not ScreenGui.Parent then
                    ScreenGui.Parent = PlayerGui
                end
            end)
        end
    end)
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "Main"
    MainFrame.Size = UDim2.new(0, 600, 0, 450)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -225)
    MainFrame.BackgroundColor3 = Colors.Background
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame
    
    local UIGradient = Instance.new("UIGradient")
    UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Colors.Background), ColorSequenceKeypoint.new(1, Colors.Secondary)}
    UIGradient.Parent = MainFrame
    
    local dragging = false
    local dragInput, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 50)
    Header.BackgroundColor3 = Colors.Secondary
    Header.Parent = MainFrame
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 12)
    HeaderCorner.Parent = Header
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -200, 1, 0)
    Title.Position = UDim2.new(0, 60, 0, 0)
    Title.Text = Name
    Title.TextColor3 = Colors.Text
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 20
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header
    
    local Avatar = Instance.new("ImageLabel")
    Avatar.Size = UDim2.new(0, 40, 0, 40)
    Avatar.Position = UDim2.new(0, 10, 0, 5)
    Avatar.BackgroundTransparency = 1
    Avatar.Image = "rbxassetid://0"
    Avatar.Parent = Header
    
    local AvatarCorner = Instance.new("UICorner")
    AvatarCorner.CornerRadius = UDim.new(1, 0)
    AvatarCorner.Parent = Avatar
    
    local player = Players.LocalPlayer
    local userId = player.UserId
    local content, isReady = Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.Headshot, Enum.ThumbnailSize.Size48x48)
    if isReady then
        Avatar.Image = content
    end
    
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
    MinimizeButton.Position = UDim2.new(1, -70, 0, 10)
    MinimizeButton.BackgroundColor3 = Colors.Tertiary
    MinimizeButton.Text = "-"
    MinimizeButton.TextColor3 = Colors.Text
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.TextSize = 18
    MinimizeButton.Parent = Header
    
    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 6)
    MinCorner.Parent = MinimizeButton
    
    local minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        MainFrame.Size = minimized and UDim2.new(0, 600, 0, 50) or UDim2.new(0, 600, 0, 450)
    end)
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -30, 0, 10)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Colors.Text
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 18
    CloseButton.Parent = Header
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseButton
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    local TabHolder = Instance.new("Frame")
    TabHolder.Size = UDim2.new(0, 140, 1, -50)
    TabHolder.Position = UDim2.new(0, 0, 0, 50)
    TabHolder.BackgroundTransparency = 1
    TabHolder.Parent = MainFrame
    
    local TabScrolling = Instance.new("ScrollingFrame")
    TabScrolling.Size = UDim2.new(1, 0, 1, 0)
    TabScrolling.BackgroundTransparency = 1
    TabScrolling.ScrollBarThickness = 0
    TabScrolling.Parent = TabHolder
    
    local TabList = Instance.new("UIListLayout")
    TabList.Padding = UDim.new(0, 5)
    TabList.Parent = TabScrolling
    
    local PageHolder = Instance.new("Frame")
    PageHolder.Size = UDim2.new(1, -140, 1, -50)
    PageHolder.Position = UDim2.new(0, 140, 0, 50)
    PageHolder.BackgroundTransparency = 1
    PageHolder.Parent = MainFrame
    
    local ConfigStore
    if SaveConfig then
        ConfigStore = DataStoreService:GetDataStore(ConfigFolder)
    end
    
    function Window:SaveFlags()
        if SaveConfig then
            ConfigStore:SetAsync(player.UserId, HttpService:JSONEncode(Window.Flags))
        end
    end
    
    function Window:LoadFlags()
        if SaveConfig then
            local data = ConfigStore:GetAsync(player.UserId)
            if data then
                Window.Flags = HttpService:JSONDecode(data)
            end
        end
    end
    
    Window:LoadFlags()
    
    function Window:MakeTab(options)
        local TabName = options.Name or "Tab"
        local TabIcon = options.Icon or "layout"
        local PremiumOnly = options.PremiumOnly or false
        
        if PremiumOnly then return end
        
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, 0, 0, 40)
        TabButton.BackgroundColor3 = Colors.Secondary
        TabButton.Text = ""
        TabButton.Parent = TabScrolling
        
        local TabBtnCorner = Instance.new("UICorner")
        TabBtnCorner.CornerRadius = UDim.new(0, 6)
        TabBtnCorner.Parent = TabButton
        
        local TabBtnIcon = Instance.new("ImageLabel")
        TabBtnIcon.Size = UDim2.new(0, 20, 0, 20)
        TabBtnIcon.Position = UDim2.new(0, 10, 0.5, -10)
        TabBtnIcon.BackgroundTransparency = 1
        TabBtnIcon.Image = "rbxassetid://" .. (IconsJson[TabIcon] or 0)
        TabBtnIcon.ImageColor3 = Colors.Text
        TabBtnIcon.Parent = TabButton
        
        local TabBtnText = Instance.new("TextLabel")
        TabBtnText.Size = UDim2.new(1, -40, 1, 0)
        TabBtnText.Position = UDim2.new(0, 40, 0, 0)
        TabBtnText.Text = TabName
        TabBtnText.TextColor3 = Colors.Text
        TabBtnText.Font = Enum.Font.GothamSemibold
        TabBtnText.TextSize = 15
        TabBtnText.BackgroundTransparency = 1
        TabBtnText.TextXAlignment = Enum.TextXAlignment.Left
        TabBtnText.Parent = TabButton
        
        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.ScrollBarThickness = 4
        TabPage.ScrollBarImageColor3 = Colors.Tertiary
        TabPage.Visible = false
        TabPage.Parent = PageHolder
        
        local PageList = Instance.new("UIListLayout")
        PageList.Padding = UDim.new(0, 10)
        PageList.SortOrder = Enum.SortOrder.LayoutOrder
        PageList.Parent = TabPage
        
        local PagePadding = Instance.new("UIPadding")
        PagePadding.PaddingLeft = UDim.new(0, 10)
        PagePadding.PaddingRight = UDim.new(0, 10)
        PagePadding.PaddingTop = UDim.new(0, 10)
        PagePadding.PaddingBottom = UDim.new(0, 10)
        PagePadding.Parent = TabPage
        
        local function SelectTab()
            for _, page in ipairs(PageHolder:GetChildren()) do
                if page:IsA("ScrollingFrame") then page.Visible = false end
            end
            TabPage.Visible = true
            for _, btn in ipairs(TabScrolling:GetChildren()) do
                if btn:IsA("TextButton") then
                    TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Secondary}):Play()
                end
            end
            TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Tertiary}):Play()
        end
        
        TabButton.MouseButton1Click:Connect(SelectTab)
        
        if #TabScrolling:GetChildren() == 1 then SelectTab() end
        
        local Tab = {}
        
        function Tab:AddButton(options)
            local Name = options.Name or "Button"
            local Callback = options.Callback or function() end
            
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, 0, 0, 40)
            Button.BackgroundColor3 = Colors.Secondary
            Button.Text = Name
            Button.TextColor3 = Colors.Text
            Button.Font = Enum.Font.GothamSemibold
            Button.TextSize = 15
            Button.Parent = TabPage
            
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 6)
            BtnCorner.Parent = Button
            
            Button.MouseEnter:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.15), {BackgroundColor3 = Colors.Tertiary}):Play()
            end)
            Button.MouseLeave:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.15), {BackgroundColor3 = Colors.Secondary}):Play()
            end)
            Button.MouseButton1Click:Connect(Callback)
        end
        
        function Tab:AddToggle(options)
            local Name = options.Name or "Toggle"
            local Default = options.Default or false
            local Callback = options.Callback or function() end
            
            local Toggle = Instance.new("Frame")
            Toggle.Size = UDim2.new(1, 0, 0, 40)
            Toggle.BackgroundColor3 = Colors.Secondary
            Toggle.Parent = TabPage
            
            local TogCorner = Instance.new("UICorner")
            TogCorner.CornerRadius = UDim.new(0, 6)
            TogCorner.Parent = Toggle
            
            local TogLabel = Instance.new("TextLabel")
            TogLabel.Size = UDim2.new(1, -60, 1, 0)
            TogLabel.Position = UDim2.new(0, 10, 0, 0)
            TogLabel.Text = Name
            TogLabel.TextColor3 = Colors.Text
            TogLabel.Font = Enum.Font.GothamSemibold
            TogLabel.TextSize = 15
            TogLabel.BackgroundTransparency = 1
            TogLabel.TextXAlignment = Enum.TextXAlignment.Left
            TogLabel.Parent = Toggle
            
            local TogIndicator = Instance.new("Frame")
            TogIndicator.Size = UDim2.new(0, 40, 0, 20)
            TogIndicator.Position = UDim2.new(1, -50, 0.5, -10)
            TogIndicator.BackgroundColor3 = Default and Colors.ToggleOn or Colors.ToggleOff
            TogIndicator.Parent = Toggle
            
            local IndCorner = Instance.new("UICorner")
            IndCorner.CornerRadius = UDim.new(1, 0)
            IndCorner.Parent = TogIndicator
            
            local IndCircle = Instance.new("Frame")
            IndCircle.Size = UDim2.new(0, 16, 0, 16)
            IndCircle.Position = Default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            IndCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            IndCircle.Parent = TogIndicator
            
            local CircleCorner = Instance.new("UICorner")
            CircleCorner.CornerRadius = UDim.new(1, 0)
            CircleCorner.Parent = IndCircle
            
            local state = Default
            Window.Flags[Name] = state
            
            local ToggleBtn = Instance.new("TextButton")
            ToggleBtn.Size = UDim2.new(1, 0, 1, 0)
            ToggleBtn.BackgroundTransparency = 1
            ToggleBtn.Text = ""
            ToggleBtn.Parent = Toggle
            
            ToggleBtn.MouseButton1Click:Connect(function()
                state = not state
                Window.Flags[Name] = state
                TweenService:Create(TogIndicator, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = state and Colors.ToggleOn or Colors.ToggleOff}):Play()
                TweenService:Create(IndCircle, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
                Callback(state)
                Window:SaveFlags()
            end)
            
            return Toggle
        end
        
        function Tab:AddSlider(options)
            local Name = options.Name or "Slider"
            local Min = options.Min or 0
            local Max = options.Max or 100
            local Default = options.Default or Min
            local Increment = options.Increment or 1
            local ValueName = options.ValueName or ""
            local Callback = options.Callback or function() end
            
            local Slider = Instance.new("Frame")
            Slider.Size = UDim2.new(1, 0, 0, 50)
            Slider.BackgroundColor3 = Colors.Secondary
            Slider.Parent = TabPage
            
            local SlCorner = Instance.new("UICorner")
            SlCorner.CornerRadius = UDim.new(0, 6)
            SlCorner.Parent = Slider
            
            local SlLabel = Instance.new("TextLabel")
            SlLabel.Size = UDim2.new(1, -100, 0, 20)
            SlLabel.Position = UDim2.new(0, 10, 0, 5)
            SlLabel.Text = Name
            SlLabel.TextColor3 = Colors.Text
            SlLabel.Font = Enum.Font.GothamSemibold
            SlLabel.TextSize = 15
            SlLabel.BackgroundTransparency = 1
            SlLabel.TextXAlignment = Enum.TextXAlignment.Left
            SlLabel.Parent = Slider
            
            local SlValue = Instance.new("TextLabel")
            SlValue.Size = UDim2.new(0, 80, 0, 20)
            SlValue.Position = UDim2.new(1, -90, 0, 5)
            SlValue.Text = tostring(Default) .. ValueName
            SlValue.TextColor3 = Colors.Text
            SlValue.Font = Enum.Font.Gotham
            SlValue.TextSize = 14
            SlValue.BackgroundTransparency = 1
            SlValue.Parent = Slider
            
            local SlBar = Instance.new("Frame")
            SlBar.Size = UDim2.new(1, -20, 0, 8)
            SlBar.Position = UDim2.new(0, 10, 1, -20)
            SlBar.BackgroundColor3 = Colors.Tertiary
            SlBar.Parent = Slider
            
            local BarCorner = Instance.new("UICorner")
            BarCorner.CornerRadius = UDim.new(1, 0)
            BarCorner.Parent = SlBar
            
            local SlFill = Instance.new("Frame")
            SlFill.Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0)
            SlFill.BackgroundColor3 = Colors.Accent
            SlFill.Parent = SlBar
            
            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(1, 0)
            FillCorner.Parent = SlFill
            
            local value = Default
            Window.Flags[Name] = value
            
            local SlBtn = Instance.new("TextButton")
            SlBtn.Size = UDim2.new(1, 0, 1, 0)
            SlBtn.BackgroundTransparency = 1
            SlBtn.Text = ""
            SlBtn.Parent = Slider
            
            local dragging = false
            SlBtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)
            SlBtn.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            RunService.RenderStepped:Connect(function()
                if dragging then
                    local mouseX = UserInputService:GetMouseLocation().X
                    local barX = SlBar.AbsolutePosition.X
                    local barWidth = SlBar.AbsoluteSize.X
                    local fraction = math.clamp((mouseX - barX) / barWidth, 0, 1)
                    value = Min + (Max - Min) * fraction
                    value = math.floor(value / Increment) * Increment
                    SlFill.Size = UDim2.new(fraction, 0, 1, 0)
                    SlValue.Text = tostring(value) .. ValueName
                    Window.Flags[Name] = value
                    Callback(value)
                    Window:SaveFlags()
                end
            end)
            
            return Slider
        end
        
        function Tab:AddDropdown(options)
            local Name = options.Name or "Dropdown"
            local Default = options.Default or ""
            local Options = options.Options or {}
            local Callback = options.Callback or function() end
            
            local Dropdown = Instance.new("Frame")
            Dropdown.Size = UDim2.new(1, 0, 0, 40)
            Dropdown.BackgroundColor3 = Colors.Secondary
            Dropdown.Parent = TabPage
            
            local DropCorner = Instance.new("UICorner")
            DropCorner.CornerRadius = UDim.new(0, 6)
            DropCorner.Parent = Dropdown
            
            local DropLabel = Instance.new("TextLabel")
            DropLabel.Size = UDim2.new(1, -40, 1, 0)
            DropLabel.Position = UDim2.new(0, 10, 0, 0)
            DropLabel.Text = Name
            DropLabel.TextColor3 = Colors.Text
            DropLabel.Font = Enum.Font.GothamSemibold
            DropLabel.TextSize = 15
            DropLabel.BackgroundTransparency = 1
            DropLabel.TextXAlignment = Enum.TextXAlignment.Left
            DropLabel.Parent = Dropdown
            
            local DropIcon = Instance.new("ImageLabel")
            DropIcon.Size = UDim2.new(0, 20, 0, 20)
            DropIcon.Position = UDim2.new(1, -30, 0.5, -10)
            DropIcon.BackgroundTransparency = 1
            DropIcon.Image = "rbxassetid://" .. (IconsJson["chevron-down"] or 0)
            DropIcon.Parent = Dropdown
            
            local DropList = Instance.new("Frame")
            DropList.Size = UDim2.new(1, 0, 0, 0)
            DropList.Position = UDim2.new(0, 0, 1, 0)
            DropList.BackgroundColor3 = Colors.Tertiary
            DropList.ClipsDescendants = true
            DropList.Visible = false
            DropList.Parent = Dropdown
            
            local DropListCorner = Instance.new("UICorner")
            DropListCorner.CornerRadius = UDim.new(0, 6)
            DropListCorner.Parent = DropList
            
            local DropListLayout = Instance.new("UIListLayout")
            DropListLayout.Padding = UDim.new(0, 5)
            DropListLayout.Parent = DropList
            
            local selected = Default
            Window.Flags[Name] = selected
            
            local function Refresh(newOptions)
                for _, child in ipairs(DropList:GetChildren()) do
                    if child:IsA("TextButton") then child:Destroy() end
                end
                Options = newOptions or Options
                local height = 0
                for _, opt in ipairs(Options) do
                    local OptBtn = Instance.new("TextButton")
                    OptBtn.Size = UDim2.new(1, 0, 0, 30)
                    OptBtn.BackgroundColor3 = Colors.Tertiary
                    OptBtn.Text = opt
                    OptBtn.TextColor3 = Colors.Text
                    OptBtn.Font = Enum.Font.Gotham
                    OptBtn.TextSize = 14
                    OptBtn.Parent = DropList
                    
                    OptBtn.MouseButton1Click:Connect(function()
                        selected = opt
                        DropLabel.Text = Name .. ": " .. opt
                        Window.Flags[Name] = selected
                        DropList.Visible = false
                        DropList.Size = UDim2.new(1, 0, 0, 0)
                        Callback(selected)
                        Window:SaveFlags()
                    end)
                    height = height + 35
                end
            end
            
            Refresh()
            
            local DropBtn = Instance.new("TextButton")
            DropBtn.Size = UDim2.new(1, 0, 1, 0)
            DropBtn.BackgroundTransparency = 1
            DropBtn.Text = ""
            DropBtn.Parent = Dropdown
            
            local open = false
            DropBtn.MouseButton1Click:Connect(function()
                open = not open
                DropList.Visible = open
                local height = #Options * 35
                TweenService:Create(DropList, TweenInfo.new(0.3), {Size = open and UDim2.new(1, 0, 0, height) or UDim2.new(1, 0, 0, 0)}):Play()
            end)
            
            function Dropdown:Refresh(newOptions)
                Refresh(newOptions)
            end
            
            function Dropdown:Set(val)
                selected = val
                DropLabel.Text = Name .. ": " .. val
                Callback(val)
            end
            
            return Dropdown
        end
        
        function Tab:AddBind(options)
            local Name = options.Name or "Keybind"
            local Default = options.Default or Enum.KeyCode.Unknown
            local Hold = options.Hold or false
            local Callback = options.Callback or function() end
            
            local Bind = Instance.new("Frame")
            Bind.Size = UDim2.new(1, 0, 0, 40)
            Bind.BackgroundColor3 = Colors.Secondary
            Bind.Parent = TabPage
            
            local BindCorner = Instance.new("UICorner")
            BindCorner.CornerRadius = UDim.new(0, 6)
            BindCorner.Parent = Bind
            
            local BindLabel = Instance.new("TextLabel")
            BindLabel.Size = UDim2.new(1, -100, 1, 0)
            BindLabel.Position = UDim2.new(0, 10, 0, 0)
            BindLabel.Text = Name
            BindLabel.TextColor3 = Colors.Text
            BindLabel.Font = Enum.Font.GothamSemibold
            BindLabel.TextSize = 15
            BindLabel.BackgroundTransparency = 1
            BindLabel.TextXAlignment = Enum.TextXAlignment.Left
            BindLabel.Parent = Bind
            
            local BindValue = Instance.new("TextLabel")
            BindValue.Size = UDim2.new(0, 80, 1, 0)
            BindValue.Position = UDim2.new(1, -90, 0, 0)
            BindValue.Text = Default.Name
            BindValue.TextColor3 = Colors.Text
            BindValue.Font = Enum.Font.Gotham
            BindValue.TextSize = 14
            BindValue.BackgroundTransparency = 1
            BindValue.Parent = Bind
            
            local key = Default
            Window.Flags[Name] = key
            
            local BindBtn = Instance.new("TextButton")
            BindBtn.Size = UDim2.new(1, 0, 1, 0)
            BindBtn.BackgroundTransparency = 1
            BindBtn.Text = ""
            BindBtn.Parent = Bind
            
            local listening = false
            BindBtn.MouseButton1Click:Connect(function()
                listening = true
                BindValue.Text = "..."
            end)
            
            UserInputService.InputBegan:Connect(function(input)
                if listening then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        key = input.KeyCode
                        BindValue.Text = key.Name
                        Window.Flags[Name] = key
                        listening = false
                        Window:SaveFlags()
                    end
                elseif input.KeyCode == key then
                    if Hold then
                        Callback(true)
                    else
                        Callback()
                    end
                end
            end)
            
            if Hold then
                UserInputService.InputEnded:Connect(function(input)
                    if input.KeyCode == key then
                        Callback(false)
                    end
                end)
            end
            
            return Bind
        end
        
        function Tab:AddColorpicker(options)
            local Name = options.Name or "ColorPicker"
            local Default = options.Default or Color3.fromRGB(255, 255, 255)
            local Callback = options.Callback or function() end
            
            local Picker = Instance.new("Frame")
            Picker.Size = UDim2.new(1, 0, 0, 40)
            Picker.BackgroundColor3 = Colors.Secondary
            Picker.Parent = TabPage
            
            local PickCorner = Instance.new("UICorner")
            PickCorner.CornerRadius = UDim.new(0, 6)
            PickCorner.Parent = Picker
            
            local PickLabel = Instance.new("TextLabel")
            PickLabel.Size = UDim2.new(1, -60, 1, 0)
            PickLabel.Position = UDim2.new(0, 10, 0, 0)
            PickLabel.Text = Name
            PickLabel.TextColor3 = Colors.Text
            PickLabel.Font = Enum.Font.GothamSemibold
            PickLabel.TextSize = 15
            PickLabel.BackgroundTransparency = 1
            PickLabel.TextXAlignment = Enum.TextXAlignment.Left
            PickLabel.Parent = Picker
            
            local PickPreview = Instance.new("Frame")
            PickPreview.Size = UDim2.new(0, 30, 0, 30)
            PickPreview.Position = UDim2.new(1, -40, 0.5, -15)
            PickPreview.BackgroundColor3 = Default
            PickPreview.Parent = Picker
            
            local PrevCorner = Instance.new("UICorner")
            PrevCorner.CornerRadius = UDim.new(0, 4)
            PrevCorner.Parent = PickPreview
            
            local color = Default
            Window.Flags[Name] = color
            
            local PickBtn = Instance.new("TextButton")
            PickBtn.Size = UDim2.new(1, 0, 1, 0)
            PickBtn.BackgroundTransparency = 1
            PickBtn.Text = ""
            PickBtn.Parent = Picker
            
            PickBtn.MouseButton1Click:Connect(function()
                color = Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255))
                PickPreview.BackgroundColor3 = color
                Window.Flags[Name] = color
                Callback(color)
                Window:SaveFlags()
            end)
            
            return Picker
        end
        
        function Tab:AddTextbox(options)
            local Name = options.Name or "Textbox"
            local Default = options.Default or ""
            local TextDisappear = options.TextDisappear or false
            local Callback = options.Callback or function() end
            
            local Textbox = Instance.new("Frame")
            Textbox.Size = UDim2.new(1, 0, 0, 40)
            Textbox.BackgroundColor3 = Colors.Secondary
            Textbox.Parent = TabPage
            
            local TextCorner = Instance.new("UICorner")
            TextCorner.CornerRadius = UDim.new(0, 6)
            TextCorner.Parent = Textbox
            
            local TextInput = Instance.new("TextBox")
            TextInput.Size = UDim2.new(1, -20, 1, -10)
            TextInput.Position = UDim2.new(0, 10, 0, 5)
            TextInput.Text = Default
            TextInput.PlaceholderText = Name
            TextInput.TextColor3 = Colors.Text
            TextInput.Font = Enum.Font.Gotham
            TextInput.TextSize = 14
            TextInput.BackgroundTransparency = 1
            TextInput.ClearTextOnFocus = TextDisappear
            TextInput.Parent = Textbox
            
            TextInput.FocusLost:Connect(function(enter)
                if enter then
                    Window.Flags[Name] = TextInput.Text
                    Callback(TextInput.Text)
                    Window:SaveFlags()
                end
            end)
            
            return TextInput
        end
        
        function Tab:AddParagraph(title, content)
            local Para = Instance.new("Frame")
            Para.Size = UDim2.new(1, 0, 0, 60)
            Para.BackgroundTransparency = 1
            Para.Parent = TabPage
            
            local ParaTitle = Instance.new("TextLabel")
            ParaTitle.Size = UDim2.new(1, 0, 0, 20)
            ParaTitle.Text = title
            ParaTitle.TextColor3 = Colors.Accent
            ParaTitle.Font = Enum.Font.GothamBold
            ParaTitle.TextSize = 16
            ParaTitle.BackgroundTransparency = 1
            ParaTitle.TextXAlignment = Enum.TextXAlignment.Left
            ParaTitle.Parent = Para
            
            local ParaContent = Instance.new("TextLabel")
            ParaContent.Size = UDim2.new(1, 0, 1, -20)
            ParaContent.Position = UDim2.new(0, 0, 0, 20)
            ParaContent.Text = content
            ParaContent.TextColor3 = Colors.Text
            ParaContent.Font = Enum.Font.Gotham
            ParaContent.TextSize = 14
            ParaContent.BackgroundTransparency = 1
            ParaContent.TextWrapped = true
            ParaContent.TextXAlignment = Enum.TextXAlignment.Left
            ParaContent.Parent = Para
        end
        
        function Tab:AddLabel(text)
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, 0, 0, 30)
            Label.Text = text
            Label.TextColor3 = Colors.Text
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 14
            Label.BackgroundTransparency = 1
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = TabPage
            
            function Label:Refresh(newText)
                Label.Text = newText
            end
            
            return Label
        end
        
        return Tab
    end
    
    return Window
end

return UltimateOrionLib
