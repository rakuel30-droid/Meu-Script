-- ============================================
-- AETHER HUB - VERSÃO SIMPLIFICADA
-- SEM ABAS, APENAS BOTÕES FUNCIONAIS
-- ============================================

print("🔵 AETHER HUB INICIANDO...")

-- ============================================
-- SERVIÇOS
-- ============================================
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

-- ============================================
-- VARIÁVEIS
-- ============================================
local AutoFarmAtivo = false
local AutoCollectAtivo = false

-- ============================================
-- FUNÇÕES
-- ============================================

-- Notificação
local function Notify(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 3
        })
    end)
end

-- Click
local function Click()
    pcall(function()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

-- Teleporte
local function Teleportar(pos)
    if hrp then
        hrp.CFrame = CFrame.new(pos)
        wait(0.2)
    end
end

-- Teleporte para Ilhas
local function TeleportarIlha(nome)
    local ilhas = {
        Inicial = Vector3.new(0, 10, 0),
        Medieval = Vector3.new(1000, 10, 2000),
        Dourada = Vector3.new(-1500, 10, 3000),
        Vulcanica = Vector3.new(5000, 10, 4000),
        Miragem = Vector3.new(-4000, 10, -4000)
    }
    
    local pos = ilhas[nome]
    if pos then
        Teleportar(pos)
        Notify("✅ Teleportado", "Ilha " .. nome)
    end
end

-- Coletar Frutas
local function ColetarFrutas()
    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj:IsA("Tool") and obj:FindFirstChild("Handle") then
            local dist = (hrp.Position - obj.Handle.Position).Magnitude
            if dist < 20 then
                pcall(function()
                    obj.Parent = player.Backpack
                    Notify("🍎 Coletado", obj.Name)
                end)
            end
        end
    end
end

-- Auto Farm Loop
local function AutoFarmLoop()
    while AutoFarmAtivo do
        wait(0.5)
        
        local alvo = nil
        local distMin = 999
        
        for _, obj in ipairs(Workspace:GetChildren()) do
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") then
                if obj.Name ~= player.Name and obj:FindFirstChild("HumanoidRootPart") then
                    local dist = (hrp.Position - obj.HumanoidRootPart.Position).Magnitude
                    if dist < 200 and dist < distMin then
                        distMin = dist
                        alvo = obj
                    end
                end
            end
        end
        
        if alvo then
            hrp.CFrame = CFrame.new(alvo.HumanoidRootPart.Position + Vector3.new(0, 0, 5))
            wait(0.2)
            Click()
            wait(0.3)
        end
    end
end

-- ============================================
-- CRIAR GUI (SIMPLES E FUNCIONAL)
-- ============================================
local function CriarGUI()
    print("🔵 Criando GUI...")
    
    local playerGui = player:FindFirstChild("PlayerGui")
    if not playerGui then
        print("❌ PlayerGui não encontrado!")
        Notify("❌ Erro", "PlayerGui não encontrado")
        return
    end
    
    print("✅ PlayerGui encontrado!")
    
    -- ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AetherGUI"
    screenGui.Parent = playerGui
    
    -- Frame Principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 350, 0, 420)
    mainFrame.Position = UDim2.new(0.5, -175, 0.5, -210)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 10, 35)
    mainFrame.BackgroundTransparency = 0.05
    mainFrame.BorderSizePixel = 2
    mainFrame.BorderColor3 = Color3.fromRGB(255, 0, 255)
    mainFrame.Parent = screenGui
    
    -- Cantos
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 45)
    title.Position = UDim2.new(0, 0, 0, 5)
    title.Text = "✦ AETHER HUB ✦"
    title.TextColor3 = Color3.fromRGB(200, 150, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.BackgroundTransparency = 1
    title.Parent = mainFrame
    
    -- ============================================
    -- BOTÕES
    -- ============================================
    local botoes = {
        {texto = "▶ AUTO FARM", cor = Color3.fromRGB(16, 185, 129), y = 60},
        {texto = "🔄 AUTO COLLECT", cor = Color3.fromRGB(99, 102, 241), y = 115},
        {texto = "🌋 VULCÂNICA", cor = Color3.fromRGB(239, 68, 68), y = 170},
        {texto = "✨ MIRAGEM", cor = Color3.fromRGB(251, 191, 36), y = 225},
        {texto = "🍎 COLETAR FRUTAS", cor = Color3.fromRGB(168, 85, 247), y = 280},
        {texto = "📊 STATUS", cor = Color3.fromRGB(59, 130, 246), y = 335}
    }
    
    for _, btnInfo in ipairs(botoes) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 200, 0, 45)
        btn.Position = UDim2.new(0.5, -100, 0, btnInfo.y)
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
            if btnInfo.texto == "▶ AUTO FARM" then
                AutoFarmAtivo = not AutoFarmAtivo
                btn.Text = AutoFarmAtivo and "⏹ PARAR FARM" or "▶ AUTO FARM"
                btn.BackgroundColor3 = AutoFarmAtivo and Color3.fromRGB(239, 68, 68) or Color3.fromRGB(16, 185, 129)
                
                if AutoFarmAtivo then
                    spawn(AutoFarmLoop)
                    Notify("✅ Farm Ativo", "Auto Farm iniciado!")
                else
                    Notify("⏹ Farm Parado", "Auto Farm desativado!")
                end
                
            elseif btnInfo.texto == "🔄 AUTO COLLECT" then
                AutoCollectAtivo = not AutoCollectAtivo
                btn.Text = AutoCollectAtivo and "⏹ PARAR COLLECT" or "🔄 AUTO COLLECT"
                btn.BackgroundColor3 = AutoCollectAtivo and Color3.fromRGB(239, 68, 68) or Color3.fromRGB(99, 102, 241)
                Notify(AutoCollectAtivo and "✅ Ativado" or "⏹ Desativado", "Auto Collect")
                
            elseif btnInfo.texto == "🌋 VULCÂNICA" then
                TeleportarIlha("Vulcanica")
                
            elseif btnInfo.texto == "✨ MIRAGEM" then
                TeleportarIlha("Miragem")
                
            elseif btnInfo.texto == "🍎 COLETAR FRUTAS" then
                ColetarFrutas()
                Notify("✅ Coletando", "Procurando frutas...")
                
            elseif btnInfo.texto == "📊 STATUS" then
                local nivel = player:FindFirstChild("Data") and player.Data.Level.Value or 0
                local fruta = player:FindFirstChild("Data") and player.Data.Fruit.Value or "Nenhuma"
                Notify("📊 STATUS", string.format("Nível: %d | Fruta: %s", nivel, fruta))
            end
        end)
    end
    
    -- ============================================
    -- BOTÃO FECHAR
    -- ============================================
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
    
    Notify("✅ AETHER HUB", "GUI carregada com sucesso!")
    print("✅ GUI criada com sucesso!")
end

-- ============================================
-- EXECUTA
-- ============================================
local sucesso, erro = pcall(CriarGUI)

if not sucesso then
    print("❌ Erro ao criar GUI:", erro)
    Notify("❌ ERRO", "Erro: " .. tostring(erro))
end

print("🔵 AETHER HUB FINALIZADO!")
