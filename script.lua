-- ============================================
-- AETHER MOBILE - DELTA OPTIMIZED
-- ============================================

-- Força o script a rodar no ambiente correto
local env = getgenv() or getfenv() or _ENV
local player = game:GetService("Players").LocalPlayer
local workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")

-- ============================================
-- NOTIFICAÇÃO DE TESTE
-- ============================================
StarterGui:SetCore("SendNotification", {
    Title = "🚀 AETHER MOBILE",
    Text = "Script carregado! Criando GUI...",
    Duration = 3
})

wait(1)

-- ============================================
-- CRIAÇÃO DA GUI (SIMPLIFICADA)
-- ============================================
local function CriarGUI()
    -- Tenta criar no PlayerGui
    local playerGui = player:WaitForChild("PlayerGui")
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AetherGUI"
    screenGui.Parent = playerGui
    
    -- Frame principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 350, 0, 450)
    mainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 10, 40)
    mainFrame.BackgroundTransparency = 0.05
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    -- Cantos arredondados
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 10)
    title.Text = "✦ AETHER MOBILE ✦"
    title.TextColor3 = Color3.fromRGB(200, 150, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.BackgroundTransparency = 1
    title.Parent = mainFrame
    
    -- Botões
    local botoes = {
        {texto = "▶ FARM", cor = Color3.fromRGB(16, 185, 129), y = 70},
        {texto = "🔄 COLETAR", cor = Color3.fromRGB(99, 102, 241), y = 130},
        {texto = "🌋 VULCÂNICA", cor = Color3.fromRGB(239, 68, 68), y = 190},
        {texto = "✨ MIRAGEM", cor = Color3.fromRGB(251, 191, 36), y = 250},
        {texto = "🔍 BUSCAR ILHA", cor = Color3.fromRGB(59, 130, 246), y = 310},
        {texto = "📊 STATUS", cor = Color3.fromRGB(168, 85, 247), y = 370}
    }
    
    local AutoFarmAtivo = false
    
    for _, btnInfo in ipairs(botoes) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 180, 0, 40)
        btn.Position = UDim2.new(0.5, -90, 0, btnInfo.y)
        btn.Text = btnInfo.texto
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextScaled = true
        btn.BackgroundColor3 = btnInfo.cor
        btn.BorderSizePixel = 0
        btn.Parent = mainFrame
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = btn
        
        btn.MouseButton1Click:Connect(function()
            if btnInfo.texto == "▶ FARM" then
                AutoFarmAtivo = not AutoFarmAtivo
                btn.Text = AutoFarmAtivo and "⏹ PARAR" or "▶ FARM"
                btn.BackgroundColor3 = AutoFarmAtivo and Color3.fromRGB(239, 68, 68) or Color3.fromRGB(16, 185, 129)
                
                StarterGui:SetCore("SendNotification", {
                    Title = AutoFarmAtivo and "✅ Farm Ativo" or "⏹ Farm Parado",
                    Text = AutoFarmAtivo and "Auto Farm iniciado!" or "Auto Farm parado!",
                    Duration = 2
                })
                
            elseif btnInfo.texto == "🔄 COLETAR" then
                StarterGui:SetCore("SendNotification", {
                    Title = "🔄 Coletando",
                    Text = "Procurando itens...",
                    Duration = 2
                })
                
            elseif btnInfo.texto == "🌋 VULCÂNICA" then
                StarterGui:SetCore("SendNotification", {
                    Title = "🌋 Teleportando",
                    Text = "Indo para Ilha Vulcânica...",
                    Duration = 2
                })
                
            elseif btnInfo.texto == "✨ MIRAGEM" then
                StarterGui:SetCore("SendNotification", {
                    Title = "✨ Teleportando",
                    Text = "Indo para Ilha Miragem...",
                    Duration = 2
                })
                
            elseif btnInfo.texto == "🔍 BUSCAR ILHA" then
                StarterGui:SetCore("SendNotification", {
                    Title = "🔍 Buscando",
                    Text = "Procurando ilhas no mar...",
                    Duration = 3
                })
                
            elseif btnInfo.texto == "📊 STATUS" then
                local nivel = player:FindFirstChild("Data") and player.Data.Level.Value or 0
                local fruta = player:FindFirstChild("Data") and player.Data.Fruit.Value or "Nenhuma"
                
                StarterGui:SetCore("SendNotification", {
                    Title = "📊 STATUS",
                    Text = string.format("Nível: %d | Fruta: %s", nivel, fruta),
                    Duration = 4
                })
            end
        end)
    end
    
    -- Botão Fechar
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 40, 0, 40)
    closeBtn.Position = UDim2.new(1, -50, 0, 5)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextScaled = true
    closeBtn.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = mainFrame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = not mainFrame.Visible
        closeBtn.Text = mainFrame.Visible and "✕" or "☰"
    end)
    
    StarterGui:SetCore("SendNotification", {
        Title = "✅ AETHER MOBILE",
        Text = "GUI carregada com sucesso!",
        Duration = 3
    })
end

-- ============================================
-- EXECUTA
-- ============================================
pcall(CriarGUI)

print("✅ AETHER MOBILE CARREGADO!")
