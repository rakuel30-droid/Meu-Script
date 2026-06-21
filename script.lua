-- Script com notificação
wait(2)

print("✅ Script carregado!")

-- Notificação do Roblox
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "✅ AETHER MOBILE",
    Text = "Script carregado com sucesso!",
    Duration = 5,
    Button1 = "OK"
})

-- Também tenta criar a GUI
local player = game:GetService("Players").LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "AetherTest"
gui.Parent = player:WaitForChild("PlayerGui")

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
label.Text = "✅ GUI CRIADA!"
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.TextScaled = true
label.Font = Enum.Font.GothamBold
label.BackgroundTransparency = 1
label.Parent = frame

-- Cria um botão de teste
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 150, 0, 40)
btn.Position = UDim2.new(0.5, -75, 0.8, 0)
btn.Text = "TESTAR"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
btn.Parent = frame

btn.MouseButton1Click:Connect(function()
    print("✅ Botão foi clicado!")
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "✅ FUNCIONOU!",
        Text = "O botão está funcionando!",
        Duration = 3
    })
end)

print("✅ GUI criada com sucesso!")
