-- ============================================
-- AETHER MOBILE v2.0 - CORRIGIDO
-- Compatível com Blox Fruits + Delta Executor
-- ============================================

local Aether = {}

-- ============================================
-- CONFIGURAÇÕES
-- ============================================
Aether.Config = {
    AutoFarm = false,
    AutoCollect = true,
    TeleportDelay = 0.3,
    SafeTeleport = true,
    AntiBan = true,
    ActionCooldown = 1.5,
    RandomDelay = true,
    BuscaIlhas = false,
    RaioBusca = 3000,
    ClickDelay = 0.3
}

-- ============================================
-- SERVIÇOS
-- ============================================
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

-- ============================================
-- NOTIFICAÇÃO DE INÍCIO
-- ============================================
StarterGui:SetCore("SendNotification", {
    Title = "🚀 AETHER MOBILE",
    Text = "Script carregado com sucesso!",
    Duration = 3,
    Button1 = "OK"
})

-- ============================================
-- ANTI-BAN
-- ============================================
Aether.AntiBan = {
    LastAction = 0,
    DelayMin = 0.8,
    DelayMax = 3.0
}

function Aether:CheckAntiBan()
    if not self.Config.AntiBan then return true end
    
    local now = tick()
    local minDelay = self.AntiBan.DelayMin * 1.3
    local maxDelay = self.AntiBan.DelayMax * 1.5
    
    if self.Config.RandomDelay then
        minDelay = minDelay * 0.8
        maxDelay = maxDelay * 1.2
    end
    
    if now - self.AntiBan.LastAction < minDelay then
        return false
    end
    
    if self.Config.RandomDelay then
        local delay = math.random(minDelay * 10, maxDelay * 10) / 10
        wait(delay)
    end
    
    self.AntiBan.LastAction = now
    return true
end

-- ============================================
-- CLICK PARA MOBILE (DELTA)
-- ============================================
function Aether:MobileClick()
    pcall(function()
        VirtualUser:ClickButton2(Vector2.new())
    end)
    
    pcall(function()
        local touch = {X = 0.5, Y = 0.5}
        UserInputService:SendInputEvent(Enum.UserInputType.Touch, touch, true)
        wait(0.05)
        UserInputService:SendInputEvent(Enum.UserInputType.Touch, touch, false)
    end)
    
    wait(self.Config.ClickDelay)
end

-- ============================================
-- TELEPORTE
-- ============================================
function Aether:Teleportar(posicao)
    if not self:CheckAntiBan() then return end
    
    local cframe
    if type(posicao) == "Vector3" then
        cframe = CFrame.new(posicao)
    elseif type(posicao) == "table" then
        cframe = CFrame.new(posicao.x or 0, posicao.y or 0, posicao.z or 0)
    else
        cframe = posicao
    end
    
    if hrp then
        hrp.CFrame = cframe
        wait(self.Config.TeleportDelay)
        return true
    end
    return false
end

function Aether:TeleportarSeguro(posicao)
    if self.Config.SafeTeleport then
        local safePos = Vector3.new(
            posicao.X or posicao.x or 0,
            math.max(posicao.Y or posicao.y or 0, 10),
            posicao.Z or posicao.z or 0
        )
        return self:Teleportar(safePos)
    end
    return self:Teleportar(posicao)
end

-- ============================================
-- ILHAS
-- ============================================
Aether.Ilhas = {
    Ilha_Inicial = {pos = Vector3.new(0, 10, 0), spawnavel = true},
    Ilha_Medieval = {pos = Vector3.new(1000, 10, 2000), spawnavel = true},
    Ilha_Dourada = {pos = Vector3.new(-1500, 10, 3000), spawnavel = true},
    Ilha_Frozen = {pos = Vector3.new(2000, 10, -2000), spawnavel = true},
    Ilha_Deserto = {pos = Vector3.new(-2000, 10, -2500), spawnavel = true},
    Ilha_Jungle = {pos = Vector3.new(3000, 10, 1000), spawnavel = true},
    Ilha_Cyber = {pos = Vector3.new(-3000, 10, -1000), spawnavel = true},
    Ilha_Neve = {pos = Vector3.new(4000, 10, 3000), spawnavel = true},
    Ilha_Vulcânica = {pos = Vector3.new(5000, 10, 4000), spawnavel = false},
    Ilha_Miragem = {pos = Vector3.new(-4000, 10, -4000), spawnavel = false},
}

function Aether:TeleportarParaIlha(nomeIlha)
    local ilha = self.Ilhas[nomeIlha]
    if not ilha then
        print("[Aether] Ilha não encontrada:", nomeIlha)
        return false
    end
    
    if ilha.spawnavel then
        return self:TeleportarSeguro(ilha.pos)
    else
        print("[Aether] Ilha não spawnada, iniciando busca...")
        return self:BuscarIlha(nomeIlha)
    end
end

function Aether:TeleportarIlhaVulcanica()
    StarterGui:SetCore("SendNotification", {
        Title = "🌋 Teleportando",
        Text = "Indo para Ilha Vulcânica...",
        Duration = 2
    })
    return self:TeleportarParaIlha("Ilha_Vulcânica")
end

function Aether:TeleportarIlhaMiragem()
    StarterGui:SetCore("SendNotification", {
        Title = "✨ Teleportando",
        Text = "Indo para Ilha Miragem...",
        Duration = 2
    })
    return self:TeleportarParaIlha("Ilha_Miragem")
end

-- ============================================
-- BUSCA DE ILHAS
-- ============================================
function Aether:BuscarIlha(nomeIlha)
    print("[Aether] Buscando ilha:", nomeIlha)
    self.Config.BuscaIlhas = true
    
    local ilha = self.Ilhas[nomeIlha]
    if not ilha then return false end
    
    local posicaoBase = ilha.pos
    local raioBusca = self.Config.RaioBusca
    local angulo = 0
    local incremento = math.pi / 6
    local encontrado = false
    local tentativas = 0
    
    while self.Config.BuscaIlhas and not encontrado and tentativas < 20 do
        for raio = 0, raioBusca, 300 do
            for i = 0, 6 do
                angulo = angulo + incremento
                local x = posicaoBase.X + raio * math.cos(angulo)
                local z = posicaoBase.Z + raio * math.sin(angulo)
                
                local posicaoTeste = Vector3.new(x, 10, z)
                local check = self:CheckTerreno(posicaoTeste)
                
                if check then
                    print("[Aether] Ilha encontrada em:", posicaoTeste)
                    self:TeleportarSeguro(posicaoTeste)
                    encontrado = true
                    break
                end
                
                wait(0.15)
            end
            if encontrado then break end
        end
        
        if not encontrado then
            tentativas = tentativas + 1
            raioBusca = raioBusca + 500
            print(string.format("[Aether] Expandindo busca... Tentativa %d/20", tentativas))
            wait(self.Config.IntervaloBusca)
        end
    end
    
    self.Config.BuscaIlhas = false
    return encontrado
end

function Aether:CheckTerreno(posicao)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    
    local origin = posicao + Vector3.new(0, 50, 0)
    local direction = Vector3.new(0, -100, 0)
    
    local result = Workspace:Raycast(origin, direction, raycastParams)
    
    if result then
        local hit = result.Instance
        if hit and hit:IsA("Part") and hit.Material ~= Enum.Material.Air then
            return true
        end
    end
    return false
end

function Aether:BuscarIlhasNoMar()
    StarterGui:SetCore("SendNotification", {
        Title = "🔍 Buscando",
        Text = "Procurando ilhas no mar...",
        Duration = 3
    })
    
    print("[Aether] Iniciando busca por ilhas no mar...")
    self.Config.BuscaIlhas = true
    
    local direcoes = {
        Vector3.new(1, 0, 0),
        Vector3.new(0, 0, 1),
        Vector3.new(-1, 0, 0),
        Vector3.new(0, 0, -1)
    }
    
    local indice = 1
    local distancia = 500
    
    while self.Config.BuscaIlhas do
        local dir = direcoes[indice]
        indice = (indice % #direcoes) + 1
        
        local posicao = hrp.Position
        local destino = posicao + (dir * distancia)
        
        while (hrp.Position - destino).Magnitude > 50 do
            if not self.Config.BuscaIlhas then break end
            
            local dir2 = (destino - hrp.Position).Unit
            local novaPos = hrp.Position + (dir2 * 80)
            novaPos = Vector3.new(novaPos.X, math.max(novaPos.Y, 5), novaPos.Z)
            
            self:TeleportarSeguro(novaPos)
            wait(0.5)
            
            if self:CheckTerreno(hrp.Position) then
                print("[Aether] Terra encontrada!")
                StarterGui:SetCore("SendNotification", {
                    Title = "✅ Encontrada!",
                    Text = "Ilha encontrada no mar!",
                    Duration = 3
                })
                self.Config.BuscaIlhas = false
                return true
            end
        end
        
        distancia = distancia + 300
        wait(3)
    end
    
    self.Config.BuscaIlhas = false
    return false
end

-- ============================================
-- COLETA DE ITENS
-- ============================================
function Aether:ColetarTodosItens()
    print("[Aether] Coletando todos os itens...")
    
    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj:IsA("Tool") and obj:FindFirstChild("Handle") then
            self:ColetarFrutaMobile(obj)
            wait(0.5)
        end
    end
    
    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj:IsA("Model") and (obj.Name:lower():find("baú") or obj.Name:lower():find("chest")) then
            self:AbrirBauMobile(obj)
            wait(0.5)
        end
    end
end

function Aether:ColetarFrutaMobile(fruta)
    if not fruta or not fruta:IsA("Tool") then return end
    if not self:CheckAntiBan() then return end
    
    local pos = fruta.Handle.Position
    local dist = (hrp.Position - pos).Magnitude
    
    if dist > 10 then
        self:Teleportar(pos + Vector3.new(0, 0, 5))
        wait(0.3)
    end
    
    pcall(function()
        self:MobileClick()
        wait(0.2)
        fruta.Parent = player.Backpack
        print("[Aether] Fruta coletada:", fruta.Name)
    end)
end

function Aether:AbrirBauMobile(bau)
    if not bau then return end
    if not self:CheckAntiBan() then return end
    
    local dist = (hrp.Position - bau.PrimaryPart.Position).Magnitude
    if dist > 5 then
        self:Teleportar(bau.PrimaryPart.Position + Vector3.new(0, 0, 3))
        wait(0.3)
    end
    
    pcall(function()
        self:MobileClick()
        wait(0.2)
        print("[Aether] Baú aberto!")
    end)
end

function Aether:ColetarTodosItensMapa()
    StarterGui:SetCore("SendNotification", {
        Title = "🔄 Coletando",
        Text = "Varrendo o mapa em busca de itens...",
        Duration = 3
    })
    
    print("[Aether] Varrendo o mapa em busca de itens...")
    
    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj:IsA("Tool") then
            local pos = obj.Handle.Position
            self:TeleportarSeguro(pos + Vector3.new(0, 5, 0))
            wait(0.3)
            
            for _, item in ipairs(Workspace:GetChildren()) do
                if item:IsA("Tool") then
                    local itemPos = item.Handle.Position
                    local dist = (pos - itemPos).Magnitude
                    if dist < 100 then
                        self:ColetarFrutaMobile(item)
                    end
                end
            end
            wait(0.3)
        end
    end
    
    StarterGui:SetCore("SendNotification", {
        Title = "✅ Concluído",
        Text = "Coleta finalizada!",
        Duration = 2
    })
end

-- ============================================
-- AUTO FARM
-- ============================================
function Aether:AtacarAlvoMobile(alvo)
    if not alvo or not self:CheckAntiBan() then return end
    
    local alvoObj = Workspace:FindFirstChild(alvo.nome)
    if not alvoObj then return end
    
    local alvoHrp = alvoObj:FindFirstChild("HumanoidRootPart")
    if not alvoHrp then return end
    
    local posicao = alvoHrp.Position + Vector3.new(0, 0, 5)
    self:Teleportar(posicao)
    wait(0.2)
    
    self:MobileClick()
end

function Aether:ColetarDadosJogo()
    local dados = {
        jogador = player.Name,
        nivel = player:FindFirstChild("Data") and player.Data.Level.Value or 0,
        vida = humanoid.Health,
        vidaMax = humanoid.MaxHealth,
        posicao = {
            x = hrp.Position.X,
            y = hrp.Position.Y,
            z = hrp.Position.Z
        },
        fruta = player:FindFirstChild("Data") and player.Data.Fruit.Value or "Nenhuma",
        inimigos = {},
        timestamp = os.time()
    }
    
    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") then
            local dist = (hrp.Position - obj.HumanoidRootPart.Position).Magnitude
            if dist < 200 and obj.Name ~= player.Name then
                table.insert(dados.inimigos, {
                    nome = obj.Name,
                    distancia = dist,
                    vida = obj.Humanoid.Health
                })
            end
        end
    end
    
    return dados
end

-- ============================================
-- LOOP PRINCIPAL
-- ============================================
function Aether:IniciarLoop()
    print("[Aether] Sistema Mobile iniciado! 📱")
    
    spawn(function()
        while true do
            if not self.Config.AutoFarm then
                wait(1)
                continue
            end
            
            local dadosJogo = self:ColetarDadosJogo()
            
            local melhorAlvo = nil
            local melhorDist = math.huge
            
            for _, inimigo in ipairs(dadosJogo.inimigos) do
                if inimigo.distancia < melhorDist then
                    melhorDist = inimigo.distancia
                    melhorAlvo = inimigo
                end
            end
            
            if melhorAlvo then
                self:AtacarAlvoMobile(melhorAlvo)
            end
            
            if self.Config.AutoCollect then
                self:ColetarTodosItens()
            end
            
            wait(self.Config.IntervaloFarm or 1.5)
        end
    end)
end

-- ============================================
-- GUI MOBILE (CORRIGIDA)
-- ============================================
function Aether:CriarGUI()
    -- Usando StarterGui como fallback
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AetherGUI"
    screenGui.Parent = StarterGui
    
    -- Também tenta no PlayerGui
    pcall(function()
        local playerGui = player:WaitForChild("PlayerGui")
        screenGui.Parent = playerGui
    end)
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 400, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 10, 30)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 16)
    corner.Parent = mainFrame
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 40, 140)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 20, 90))
    })
    gradient.Parent = mainFrame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 60)
    title.Text = "✦ AETHER MOBILE ✦"
    title.TextColor3 = Color3.fromRGB(200, 150, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.BackgroundTransparency = 1
    title.Parent = mainFrame
    
    local botoes = {
        {texto = "▶ FARM", cor = Color3.fromRGB(16, 185, 129), y = 70},
        {texto = "🔄 COLETAR", cor = Color3.fromRGB(99, 102, 241), y = 130},
        {texto = "🌋 VULCÂNICA", cor = Color3.fromRGB(239, 68, 68), y = 190},
        {texto = "✨ MIRAGEM", cor = Color3.fromRGB(251, 191, 36), y = 250},
        {texto = "🔍 BUSCAR ILHA", cor = Color3.fromRGB(59, 130, 246), y = 310},
        {texto = "📊 STATUS", cor = Color3.fromRGB(168, 85, 247), y = 370}
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
        btnCorner.CornerRadius = UDim.new(0, 10)
        btnCorner.Parent = btn
        
        btn.MouseButton1Click:Connect(function()
            if btnInfo.texto == "▶ FARM" then
                Aether.Config.AutoFarm = not Aether.Config.AutoFarm
                btn.Text = Aether.Config.AutoFarm and "⏹ PARAR FARM" or "▶ FARM"
                btn.BackgroundColor3 = Aether.Config.AutoFarm and Color3.fromRGB(239, 68, 68) or Color3.fromRGB(16, 185, 129)
                
                StarterGui:SetCore("SendNotification", {
                    Title = Aether.Config.AutoFarm and "✅ Farm Ativado" or "⏹ Farm Desativado",
                    Text = Aether.Config.AutoFarm and "Auto Farm iniciado!" or "Auto Farm parado!",
                    Duration = 2
                })
                
            elseif btnInfo.texto == "🔄 COLETAR" then
                Aether:ColetarTodosItensMapa()
                
            elseif btnInfo.texto == "🌋 VULCÂNICA" then
                Aether:TeleportarIlhaVulcanica()
                
            elseif btnInfo.texto == "✨ MIRAGEM" then
                Aether:TeleportarIlhaMiragem()
                
            elseif btnInfo.texto == "🔍 BUSCAR ILHA" then
                Aether:BuscarIlhasNoMar()
                
            elseif btnInfo.texto == "📊 STATUS" then
                local nivel = player:FindFirstChild("Data") and player.Data.Level.Value or 0
                local fruta = player:FindFirstChild("Data") and player.Data.Fruit.Value or "Nenhuma"
                
                StarterGui:SetCore("SendNotification", {
                    Title = "📊 STATUS",
                    Text = string.format("Nível: %d | Fruta: %s | Farm: %s", 
                        nivel, 
                        fruta, 
                        Aether.Config.AutoFarm and "Ativo" or "Inativo"
                    ),
                    Duration = 4
                })
                
                print("[Aether] Status:")
                print("  - Auto Farm:", Aether.Config.AutoFarm)
                print("  - Nível:", nivel)
                print("  - Fruta:", fruta)
                print("  - Vida:", math.round(humanoid.Health), "/", math.round(humanoid.MaxHealth))
            end
        end)
    end
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 50, 0, 50)
    closeBtn.Position = UDim2.new(1, -60, 0, 10)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextScaled = true
    closeBtn.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = mainFrame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 10)
    closeCorner.Parent = closeBtn
    
