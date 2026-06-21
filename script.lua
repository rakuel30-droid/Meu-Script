-- ============================================
-- AETHER HUB v2.0 - DELTA OTIMIZADO
-- ============================================

-- FORÇA O SCRIPT A RODAR NO AMBIENTE CORRETO
local env = getgenv() or getfenv() or _ENV

-- ============================================
-- SERVIÇOS
-- ============================================
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

-- ============================================
-- CONFIGURAÇÕES
-- ============================================
local Config = {
    AutoFarm = false,
    AutoCollect = false,
    FastAttack = false,
    BringMobs = false,
    AutoHop = false,
    AutoBuso = false,
    AutoFishing = false
}

-- ============================================
-- FUNÇÃO DE NOTIFICAÇÃO
-- ============================================
local function Notify(title, text, duration)
    duration = duration or 3
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration
        })
    end)
end

-- ============================================
-- FUNÇÃO DE CLICK (DELTA)
-- ============================================
local function MobileClick()
    pcall(function()
        VirtualUser:ClickButton2(Vector2.new())
    end)
    wait(0.1)
end

-- ============================================
-- FUNÇÕES DE TELEPORTE
-- ============================================
local function Teleportar(posicao)
    if hrp then
        hrp.CFrame = CFrame.new(posicao)
        wait(0.2)
        return true
    end
    return false
end

local function TeleportarIlha(nome)
    local ilhas = {
        Inicial = Vector3.new(0, 10, 0),
        Medieval = Vector3.new(1000, 10, 2000),
        Dourada = Vector3.new(-1500, 10, 3000),
        Frozen = Vector3.new(2000, 10, -2000),
        Deserto = Vector3.new(-2000, 10, -2500),
        Jungle = Vector3.new(3000, 10, 1000),
        Vulcanica = Vector3.new(5000, 10, 4000),
        Miragem = Vector3.new(-4000, 10, -4000)
    }
    
    local pos = ilhas[nome]
    if pos then
        Teleportar(pos)
        Notify("✅ Teleportado", "Ilha " .. nome, 2)
    end
end

-- ============================================
-- AUTO FARM
-- ============================================
local function AutoFarmLoop()
    while Config.AutoFarm do
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
            MobileClick()
            wait(0.3)
        end
    end
end

-- ============================================
-- COLETA DE FRUTAS
-- ============================================
local function ColetarFrutas()
    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj:IsA("Tool") and obj:FindFirstChild("Handle") then
            local dist = (hrp.Position - obj.Handle.Position).Magnitude
            if dist < 20 then
                pcall(function()
                    obj.Parent = player.Backpack
                    Notify("🍎 Coletado", obj.Name, 2)
                end)
            end
        end
    end
end

-- ============================================
-- CRIAÇÃO DA GUI (COM BORDAS RGB)
-- ============================================
local function CriarGUI()
    -- Aguarda o PlayerGui carregar
    local playerGui = player:WaitForChild("PlayerGui", 5)
    if not playerGui then
        Notify("❌ Erro", "PlayerGui não encontrado", 3)
        return
    end
    
    -- ScreenGui Principal
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AetherHub"
    screenGui.Parent = playerGui
    
    -- ============================================
    -- FRAME PRINCIPAL COM BORDAS RGB
    -- ============================================
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 400, 0, 520)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -260)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 10, 30)
    mainFrame.BackgroundTransparency = 0.05
    mainFrame.BorderSizePixel = 2
    mainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0) -- Vermelho inicial
    mainFrame.Parent = screenGui
    
    -- Cantos arredondados
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    -- ============================================
    -- ANIMAÇÃO RGB NAS BORDAS
    -- ============================================
    spawn(function()
        local colors = {
            Color3.fromRGB(255, 0, 0),    -- Vermelho
            Color3.fromRGB(255, 165, 0),  -- Laranja
            Color3.fromRGB(255, 255, 0),  -- Amarelo
            Color3.fromRGB(0, 255, 0),    -- Verde
            Color3.fromRGB(0, 0, 255),    -- Azul
            Color3.fromRGB(75, 0, 130),   -- Índigo
            Color3.fromRGB(238, 130, 238) -- Violeta
        }
        
        local index = 1
        while mainFrame and mainFrame.Parent do
            mainFrame.BorderColor3 = colors[index]
            index = index % #colors + 1
            wait(0.5)
        end
    end)
    
    -- Gradiente de fundo
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 40, 140)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 20, 90))
    })
    gradient.Parent = mainFrame
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 5)
    title.Text = "✦ AETHER HUB ✦"
    title.TextColor3 = Color3.fromRGB(200, 150, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.BackgroundTransparency = 1
    title.Parent = mainFrame
    
    -- Versão
    local version = Instance.new("TextLabel")
    version.Size = UDim2.new(1, 0, 0, 20)
    version.Position = UDim2.new(0, 0, 0, 50)
    version.Text = "Version 2.0 | Mobile"
    version.TextColor3 = Color3.fromRGB(150, 150, 200)
    version.TextScaled = true
    version.Font = Enum.Font.Gotham
    version.BackgroundTransparency = 1
    version.Parent = mainFrame
    
    -- ============================================
    -- SISTEMA DE ABAS
    -- ============================================
    local tabs = {"Home", "Farming", "Teleport", "Items", "Settings"}
    local tabButtons = {}
    local tabContents = {}
    
    -- Container das abas
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(1, -20, 0, 40)
    tabContainer.Position = UDim2.new(0, 10, 0, 75)
    tabContainer.BackgroundTransparency = 1
    tabContainer.Parent = mainFrame
    
    -- Criar abas
    for i, tabName in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1/#tabs, -4, 1, 0)
        btn.Position = UDim2.new((i-1)/#tabs, 2, 0, 0)
        btn.Text = tabName
        btn.TextColor3 = Color3.fromRGB(200, 200, 255)
        btn.TextScaled = true
        btn.Font = Enum.Font.GothamSemibold
        btn.BackgroundColor3 = Color3.fromRGB(40, 20, 70)
        btn.BorderSizePixel = 0
        btn.Parent = tabContainer
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn
        
        tabButtons[i] = btn
    end
    
    -- Container do conteúdo
    local contentContainer = Instance.new("Frame")
    contentContainer.Size = UDim2.new(1, -20, 1, -130)
    contentContainer.Position = UDim2.new(0, 10, 0, 120)
    contentContainer.BackgroundTransparency = 1
    contentContainer.Parent = mainFrame
    
    -- ============================================
    -- ABA 1: HOME
    -- ============================================
    local homeContent = Instance.new("Frame")
    homeContent.Size = UDim2.new(1, 0, 1, 0)
    homeContent.BackgroundTransparency = 1
    homeContent.Parent = contentContainer
    
    local homeTitle = Instance.new("TextLabel")
    homeTitle.Size = UDim2.new(1, 0, 0, 30)
    homeTitle.Position = UDim2.new(0, 0, 0, 10)
    homeTitle.Text = "🏠 Home"
    homeTitle.TextColor3 = Color3.fromRGB(200, 150, 255)
    homeTitle.TextScaled = true
    homeTitle.Font = Enum.Font.GothamBold
    homeTitle.BackgroundTransparency = 1
    homeTitle.Parent = homeContent
    
    local statusText = Instance.new("TextLabel")
    statusText.Size = UDim2.new(1, 0, 0, 80)
    statusText.Position = UDim2.new(0, 0, 0, 50)
    statusText.Text = "Nível: 0\nFruta: Nenhuma\nVida: 100/100"
    statusText.TextColor3 = Color3.fromRGB(200, 200, 255)
    statusText.TextScaled = true
    statusText.Font = Enum.Font.Gotham
    statusText.BackgroundTransparency = 1
    statusText.TextXAlignment = Enum.TextXAlignment.Left
    statusText.Parent = homeContent
    
    -- Atualiza status
    spawn(function()
        while true do
            local nivel = player:FindFirstChild("Data") and player.Data.Level.Value or 0
            local fruta = player:FindFirstChild("Data") and player.Data.Fruit.Value or "Nenhuma"
            statusText.Text = string.format("Nível: %d\nFruta: %s\nVida: %.0f/%.0f", 
                nivel, fruta, humanoid.Health, humanoid.MaxHealth)
            wait(3)
        end
    end)
    
    -- ============================================
    -- ABA 2: FARMING
    -- ============================================
    local farmContent = Instance.new("Frame")
    farmContent.Size = UDim2.new(1, 0, 1, 0)
    farmContent.BackgroundTransparency = 1
    farmContent.Visible = false
    farmContent.Parent = contentContainer
    
    local farmTitle = Instance.new("TextLabel")
    farmTitle.Size = UDim2.new(1, 0, 0, 30)
    farmTitle.Position = UDim2.new(0, 0, 0, 5)
    farmTitle.Text = "⚔️ Farming"
    farmTitle.TextColor3 = Color3.fromRGB(200, 150, 255)
    farmTitle.TextScaled = true
    farmTitle.Font = Enum.Font.GothamBold
    farmTitle.BackgroundTransparency = 1
    farmTitle.Parent = farmContent
    
    local farmBotoes = {
        {texto = "▶ Auto Farm", cor = Color3.fromRGB(16, 185, 129), y = 50, chave = "AutoFarm"},
        {texto = "🔄 Auto Collect", cor = Color3.fromRGB(99, 102, 241), y = 100, chave = "AutoCollect"},
        {texto = "⚡ Fast Attack", cor = Color3.fromRGB(239, 68, 68), y = 150, chave = "FastAttack"},
        {texto = "👥 Bring Mobs", cor = Color3.fromRGB(251, 191, 36), y = 200, chave = "BringMobs"}
    }
    
    for _, btnInfo in ipairs(farmBotoes) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 180, 0, 40)
        btn.Position = UDim2.new(0.5, -90, 0, btnInfo.y)
        btn.Text = btnInfo.texto
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextScaled = true
        btn.BackgroundColor3 = btnInfo.cor
        btn.BorderSizePixel = 0
        btn.Parent = farmContent
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = btn
        
        btn.MouseButton1Click:Connect(function()
            Config[btnInfo.chave] = not Config[btnInfo.chave]
            btn.Text = Config[btnInfo.chave] and "⏹ " .. btnInfo.texto:sub(3) or btnInfo.texto
            btn.BackgroundColor3 = Config[btnInfo.chave] and Color3.fromRGB(239, 68, 68) or btnInfo.cor
            
            if btnInfo.chave == "AutoFarm" and Config.AutoFarm then
                spawn(AutoFarmLoop)
            end
            
            Notify(Config[btnInfo.chave] and "✅ Ativado" or "⏹ Desativado", btnInfo.texto:sub(3), 2)
        end)
    end
    
    -- ============================================
    -- ABA 3: TELEPORT
    -- ============================================
    local teleportContent = Instance.new("Frame")
    teleportContent.Size = UDim2.new(1, 0, 1, 0)
    teleportContent.BackgroundTransparency = 1
    teleportContent.Visible = false
    teleportContent.Parent = contentContainer
    
    local teleportTitle = Instance.new("TextLabel")
    teleportTitle.Size = UDim2.new(1, 0, 0, 30)
    teleportTitle.Position = UDim2.new(0, 0, 0, 5)
    teleportTitle.Text = "🌍 Teleport"
    teleportTitle.TextColor3 = Color3.fromRGB(200, 150, 255)
    teleportTitle.TextScaled = true
    teleportTitle.Font = Enum.Font.GothamBold
    teleportTitle.BackgroundTransparency = 1
    teleportTitle.Parent = teleportContent
    
    local teleportBotoes = {
        {texto = "🏝️ Inicial", cor = Color3.fromRGB(16, 185, 129), y = 50, ilha = "Inicial"},
        {texto = "🏰 Medieval", cor = Color3.fromRGB(99, 102, 241), y = 90, ilha = "Medieval"},
        {texto = "🌟 Dourada", cor = Color3.fromRGB(251, 191, 36), y = 130, ilha = "Dourada"},
        {texto = "❄️ Frozen", cor = Color3.fromRGB(59, 130, 246), y = 170, ilha = "Frozen"},
        {texto = "🏜️ Deserto", cor = Color3.fromRGB(239, 68, 68), y = 210, ilha = "Deserto"},
        {texto = "🌋 Vulcânica", cor = Color3.fromRGB(239, 68, 68), y = 250, ilha = "Vulcanica"},
        {texto = "✨ Miragem", cor = Color3.fromRGB(168, 85, 247), y = 290, ilha = "Miragem"}
    }
    
    for _, btnInfo in ipairs(teleportBotoes) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 160, 0, 32)
        btn.Position = UDim2.new(0.5, -80, 0, btnInfo.y)
        btn.Text = btnInfo.texto
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextScaled = true
        btn.BackgroundColor3 = btnInfo.cor
        btn.BorderSizePixel = 0
        btn.Parent = teleportContent
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn
        
        btn.MouseButton1Click:Connect(function()
            TeleportarIlha(btnInfo.ilha)
        end)
    end
    
    -- ============================================
    -- ABA 4: ITEMS
    -- ============================================
    local itemsContent = Instance.new("Frame")
    itemsContent.Size = UDim2.new(1, 0, 1, 0)
    itemsContent.BackgroundTransparency = 1
    itemsContent.Visible = false
    itemsContent.Parent = contentContainer
    
    local itemsTitle = Instance.new("TextLabel")
    itemsTitle.Size = UDim2.new(1, 0, 0, 30)
    itemsTitle.Position = UDim2.new(0, 0, 0, 5)
    itemsTitle.Text = "📦 Items"
    itemsTitle.TextColor3 = Color3.fromRGB(200, 150, 255)
    itemsTitle.TextScaled = true
    itemsTitle.Font = Enum.Font.GothamBold
    itemsTitle.BackgroundTransparency = 1
    itemsTitle.Parent = itemsContent
    
    local itemsBotoes = {
        {texto = "🍎 Coletar Frutas", cor = Color3.fromRGB(16, 185, 129), y = 50},
        {texto = "📦 Coletar Baús", cor = Color3.fromRGB(99, 102, 241), y = 100},
        {texto = "🗺️ Coletar Tudo", cor = Color3.fromRGB(168, 85, 247), y = 150}
    }
    
    for _, btnInfo in ipairs(itemsBotoes) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 180, 0, 40)
        btn.Position = UDim2.new(0.5, -90, 0, btnInfo.y)
        btn.Text = btnInfo.texto
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextScaled = true
        btn.BackgroundColor3 = btnInfo.cor
        btn.BorderSizePixel = 0
        btn.Parent = itemsContent
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = btn
        
        btn.MouseButton1Click:Connect(function()
            if btnInfo.texto == "🍎 Coletar Frutas" then
                ColetarFrutas()
                Notify("✅ Coletando", "Procurando frutas...", 2)
            elseif btnInfo.texto == "📦 Coletar Baús" then
                Notify("📦 Coletando", "Procurando baús...", 2)
            elseif btnInfo.texto == "🗺️ Coletar Tudo" then
                ColetarFrutas()
                Notify("🗺️ Coletando", "Coletando todos os itens...", 2)
            end
        end)
    end
    
    -- ============================================
    -- ABA 5: SETTINGS
    -- ============================================
    local settingsContent = Instance.new("Frame")
    settingsContent.Size = UDim2.new(1, 0, 1, 0)
    settingsContent.BackgroundTransparency = 1
    settingsContent.Visible = false
    settingsContent.Parent = contentContainer
    
    local settingsTitle = Instance.new("TextLabel")
    settingsTitle.Size = UDim2.new(1, 0, 0, 30)
    settingsTitle.Position = UDim2.new(0, 0, 0, 5)
    settingsTitle.Text = "⚙️ Settings"
    settingsTitle.TextColor3 = Color3.fromRGB(200, 150, 255)
    settingsTitle.TextScaled = true
    settingsTitle.Font = Enum.Font.GothamBold
    settingsTitle.BackgroundTransparency = 1
    settingsTitle.Parent = settingsContent
    
    local settingsBotoes = {
        {texto = "🔄 Auto Hop", cor = Color3.fromRGB(99, 102, 241), y = 50, chave = "AutoHop"},
        {texto = "👊 Auto Buso", cor = Color3.fromRGB(239, 68, 68), y = 100, chave = "AutoBuso"},
        {texto = "🎣 Auto Fishing", cor = Color3.fromRGB(16, 185, 129), y = 150, chave = "AutoFishing"}
    }
    
    for _, btnInfo in ipairs(settingsBotoes) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 180, 0, 40)
        btn.Position = UDim2.new(0.5, -90, 0, btnInfo.y)
        btn.Text = btnInfo.texto
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextScaled = true
        btn.BackgroundColor3 = btnInfo.cor
        btn.BorderSizePixel = 0
        btn.Parent = settingsContent
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = btn
        
        btn.MouseButton1Click:Connect(function()
            Config[btnInfo.chave] = not Config[btnInfo.chave]
            btn.Text = Config[btnInfo.chave] and "⏹ " .. btnInfo.texto:sub(3) or btnInfo.texto
            btn.BackgroundColor3 = Config[btnInfo.chave] and Color3.fromRGB(239, 68, 68) or btnInfo.cor
            
            Notify(Config[btnInfo.chave] and "✅ Ativado" or "⏹ Desativado", btnInfo.texto:sub(3), 2)
        end)
    end
    
    -- ============================================
    -- SISTEMA DE TROCA DE ABAS
    -- ============================================
    local function SelectTab(index)
        for _, content in ipairs(tabContents) do
            if content then
                content.Visible = false
            end
        end
        
        if tabContents[index] then
            tabContents[index].Visible = true
        end
        
        for i, btn in ipairs(tabButtons) do
            if i == index then
                btn.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                btn.BackgroundColor3 = Color3.fromRGB(40, 20, 70)
                btn.TextColor3 = Color3.fromRGB(200, 200, 255)
            end
        end
    end
    
    tabContents = {
        homeContent,
        farmContent,
        teleportContent,
    
