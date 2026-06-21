-- Script de teste com StarterGui
wait(2)

print("✅ Script carregado! Criando GUI...")

-- Usando StarterGui em vez de PlayerGui
local StarterGui = game:GetService("StarterGui")

local screen = StarterGui

-- Cria um ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "AetherTest"
gui.Parent = screen

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(20, 10, 40)
frame.BackgroundTransparency = 0.1
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, 0, 1, 0)
label.Text = "✅ SCRIPT FUNCIONOU!"
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.TextScaled = true
label.Font = Enum.Font.GothamBold
label.BackgroundTransparency = 1
label.Parent = frame

print("✅ GUI criada no StarterGui!")
