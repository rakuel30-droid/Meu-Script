-- ============================================
-- TESTE MINIMO - DELTA
-- ============================================

print("🔵 SCRIPT INICIADO!")

local player = game:GetService("Players").LocalPlayer
local StarterGui = game:GetService("StarterGui")

-- Notificação
StarterGui:SetCore("SendNotification", {
    Title = "✅ TESTE",
    Text = "Script está rodando!",
    Duration = 5
})

-- Criar uma GUI simples
local function CriarGUITeste()
    local playerGui = player:FindFirstChild("PlayerGui")
    if not playerGui then
        print("❌ PlayerGui não encontrado!")
        return
    end
    
    print("✅ PlayerGui encontrado!")
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "TesteGUI"
    screenGui.Parent = playerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 200)
    frame.Position = UDim2.new(0.5, -150, 0.5, -100)
    frame.BackgroundColor3 = Color3.fromRGB(30, 15, 50)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.fromRGB(255, 0, 255)
    frame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Text = "✅ FUNCIONOU!"
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.BackgroundTransparency = 1
    label.Parent = frame
    
    print("✅ GUI criada com sucesso!")
end

-- Executa com pcall
local sucesso, erro = pcall(CriarGUITeste)

if not sucesso then
    print("❌ Erro ao criar GUI:", erro)
    StarterGui:SetCore("SendNotification", {
        Title = "❌ ERRO",
        Text = "Erro: " .. tostring(erro),
        Duration = 5
    })
end

print("🔵 FIM DO SCRIPT DE TESTE!")
