local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
 
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
 
local RED = Color3.fromRGB(220, 35, 45)
local DARK = Color3.fromRGB(15, 15, 19)
local PANEL = Color3.fromRGB(25, 25, 31)
local WHITE = Color3.fromRGB(245, 245, 245)
 
local ItemIds = {
    71901756141385,
    78213948783383,
    129248390193548,
    84157839829384,
    108779540836692,
    76021150968519,
    94957558588055,
    109890923609417,
    97572811348973,
    72166960279767,
    77345423116262
}
 

local FireUGC = ReplicatedStorage
    :WaitForChild("Shared")
    :WaitForChild("Network")
    :WaitForChild("FireUGC")
 

local Scripts = {}
 
for i, id in ipairs(ItemIds) do
    local assetId = id
 
    Scripts[i] = function()
        local args = {assetId}
        FireUGC:FireServer(unpack(args))
    end
end
 

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VITNS_HUB"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui
 
local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(330, 440)
Main.Position = UDim2.new(0.5, -165, 0.5, -220)
Main.BackgroundColor3 = DARK
Main.BorderSizePixel = 0
Main.Parent = ScreenGui
 
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
 
local Stroke = Instance.new("UIStroke")
Stroke.Color = RED
Stroke.Thickness = 2
Stroke.Parent = Main
 
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 55)
Header.BackgroundColor3 = PANEL
Header.BorderSizePixel = 0
Header.Parent = Main
 
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)
 
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.fromOffset(15, 0)
Title.BackgroundTransparency = 1
Title.Text = "VITNS HUB"
Title.TextColor3 = RED
Title.TextSize = 23
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header
 
local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.fromOffset(35, 35)
Minimize.Position = UDim2.new(1, -45, 0, 10)
Minimize.BackgroundColor3 = RED
Minimize.Text = "—"
Minimize.TextColor3 = WHITE
Minimize.TextSize = 20
Minimize.Font = Enum.Font.GothamBold
Minimize.Parent = Header
 
Instance.new("UICorner", Minimize).CornerRadius = UDim.new(0, 8)
 
local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -24, 0, 30)
Status.Position = UDim2.fromOffset(12, 62)
Status.BackgroundTransparency = 1
Status.Text = "● READY"
Status.TextColor3 = Color3.fromRGB(80, 220, 120)
Status.TextSize = 12
Status.Font = Enum.Font.GothamBold
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.Parent = Main
 
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -24, 1, -110)
Scroll.Position = UDim2.fromOffset(12, 100)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 4
Scroll.ScrollBarImageColor3 = RED
Scroll.CanvasSize = UDim2.new(0, 0, 0, #ItemIds * 48)
Scroll.Parent = Main
 
local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 7)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = Scroll
 

for index, assetId in ipairs(ItemIds) do
    local Button = Instance.new("TextButton")
    Button.Name = "Item_" .. index
    Button.Size = UDim2.new(1, -5, 0, 40)
    Button.BackgroundColor3 = PANEL
    Button.BorderSizePixel = 0
    Button.Text = "  ITEM " .. index .. "  •  " .. assetId
    Button.TextColor3 = WHITE
    Button.TextSize = 12
    Button.Font = Enum.Font.GothamSemibold
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Button.LayoutOrder = index
    Button.Parent = Scroll
 
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 7)
 
    local ButtonStroke = Instance.new("UIStroke")
    ButtonStroke.Color = RED
    ButtonStroke.Thickness = 1
    ButtonStroke.Transparency = 0.45
    ButtonStroke.Parent = Button
 
    Button.MouseButton1Click:Connect(function()
        local scriptFunction = Scripts[index]
 
        if not scriptFunction then
            return
        end
 
        Status.Text = " SENDING ITEM " .. index
        Status.TextColor3 = RED
 
        local success, err = pcall(scriptFunction)
 
        if success then
            Status.Text = " REQUEST SENT: ITEM " .. index
            Status.TextColor3 = Color3.fromRGB(80, 220, 120)
        else
            Status.Text = " REQUEST ERROR"
            warn("VITNS:", err)
        end
    end)
end
 

local minimized = false
 
Minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
 
    Scroll.Visible = not minimized
    Status.Visible = not minimized
 
    if minimized then
        Main.Size = UDim2.fromOffset(330, 55)
        Minimize.Text = "+"
    else
        Main.Size = UDim2.fromOffset(330, 440)
        Minimize.Text = "—"
    end
end)
 
-- Перетаскивание
local dragging = false
local dragStart
local startPosition
 
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
 
        dragging = true
        dragStart = input.Position
        startPosition = Main.Position
    end
end)
 
UserInputService.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - dragStart
 
        Main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)
 
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
