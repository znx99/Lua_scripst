---------------- FUNÇÃO PARA DUPLICAR O SCRIPT ----------------
Functions.DuplicateScript = false

local function duplicateScriptToPlayer(targetPlayer)
    if not targetPlayer then return end
    
    -- Aguarda o PlayerGui do target
    local targetGui = targetPlayer:WaitForChild("PlayerGui")
    
    -- Criar o mesmo script no jogador alvo
    local clonedGui = gui:Clone()
    clonedGui.Parent = targetGui
    
    -- Modificar o nome para identificar que é uma cópia
    clonedGui.Znx99Main.Title.Text = "Znx99 Cheat (CÓPIA)"
    
    -- Remover o botão de fechar se quiser manter controle
    -- (opcional) Você pode remover a tecla Insert do clone para evitar que seja fechado
    
    -- Notificar no console
    print("[DUPLICAÇÃO] Script enviado para: " .. targetPlayer.Name)
    
    return clonedGui
end

-- Versão que envia o código fonte (mais avançado)
local function sendScriptSource(targetPlayer)
    if not targetPlayer then return end
    
    -- Pegar o código fonte atual do script
    -- Nota: Isso não é possível diretamente no Roblox, então vamos criar um script similar
    local basicScript = [[
        -- Script Básico Znx99 Clone
        local player = game:GetService("Players").LocalPlayer
        local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
        gui.ResetOnSpawn = false
        
        local main = Instance.new("Frame", gui)
        main.Name = "Znx99Clone"
        main.Size = UDim2.fromOffset(300, 200)
        main.Position = UDim2.fromScale(0.5, 0.5)
        main.AnchorPoint = Vector2.new(0.5, 0.5)
        main.BackgroundColor3 = Color3.fromRGB(25,25,25)
        main.BorderSizePixel = 0
        Instance.new("UICorner", main).CornerRadius = UDim.new(0,10)
        
        local title = Instance.new("TextLabel", main)
        title.Size = UDim2.new(1,0,0,40)
        title.Position = UDim2.new(0,0,0,0)
        title.BackgroundTransparency = 1
        title.Text = "SCRIPT CLONADO\nZnx99 Cheat"
        title.TextColor3 = Color3.new(1,1,1)
        title.Font = Enum.Font.Gotham
        title.TextSize = 16
        title.TextWrapped = true
        
        local msg = Instance.new("TextLabel", main)
        msg.Size = UDim2.new(1,0,1,-40)
        msg.Position = UDim2.new(0,0,0,40)
        msg.BackgroundTransparency = 1
        msg.Text = "Você foi clonado por Znx99!\nEste script foi injetado no seu cliente."
        msg.TextColor3 = Color3.new(1,0.5,0.5)
        msg.Font = Enum.Font.Gotham
        msg.TextSize = 14
        msg.TextWrapped = true
        
        -- Auto-destruir após 10 segundos
        wait(10)
        gui:Destroy()
    ]]
    
    -- Criar um LocalScript no Backpack do jogador
    local localScript = Instance.new("LocalScript")
    localScript.Name = "Znx99CloneScript"
    localScript.Source = basicScript
    
    -- Tentar colocar no Backpack primeiro
    local backpack = targetPlayer:FindFirstChild("Backpack")
    if backpack then
        localScript.Parent = backpack
        print("[DUPLICAÇÃO] Script LocalScript enviado para o Backpack de: " .. targetPlayer.Name)
    else
        -- Se não tiver backpack, tentar no PlayerScripts
        local playerScripts = targetPlayer:FindFirstChild("PlayerScripts")
        if playerScripts then
            localScript.Parent = playerScripts
            print("[DUPLICAÇÃO] Script LocalScript enviado para PlayerScripts de: " .. targetPlayer.Name)
        end
    end
end

---------------- BOTÃO NA ABA TROLLS ----------------
-- Adicionar este botão na aba trollsFrame (ajuste a posição Y conforme necessário)
local duplicateBtn = Instance.new("TextButton", trollsFrame)
duplicateBtn.Size = UDim2.new(1,-10,0,26)
duplicateBtn.Position = UDim2.new(0,5,0, 366) -- Ajuste a posição Y
duplicateBtn.Text = "DUPLICAR SCRIPT"
duplicateBtn.Font = Enum.Font.Gotham
duplicateBtn.TextSize = 12
duplicateBtn.TextColor3 = Color3.new(1,1,1)
duplicateBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 180) -- Cor roxa
Instance.new("UICorner", duplicateBtn).CornerRadius = UDim.new(0,6)

duplicateBtn.MouseButton1Click:Connect(function()
    if not SCRIPT_ENABLED then return end
    
    if SelectedPlayer then
        -- Opção 1: Clone da GUI (visual)
        local success1 = pcall(function()
            duplicateScriptToPlayer(SelectedPlayer)
        end)
        
        -- Opção 2: Enviar código fonte
        local success2 = pcall(function()
            sendScriptSource(SelectedPlayer)
        end)
        
        if success1 or success2 then
            duplicateBtn.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
            duplicateBtn.Text = "DUPLICADO!"
            print("[SUCESSO] Script duplicado para: " .. SelectedPlayer.Name)
        else
            duplicateBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
            duplicateBtn.Text = "FALHOU!"
            print("[ERRO] Falha ao duplicar script")
        end
        
        -- Reset do botão após 1.5 segundos
        wait(1.5)
        duplicateBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 180)
        duplicateBtn.Text = "DUPLICAR SCRIPT"
    else
        -- Nenhum jogador selecionado
        duplicateBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
        duplicateBtn.Text = "SELECIONE UM PLAYER!"
        wait(1)
        duplicateBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 180)
        duplicateBtn.Text = "DUPLICAR SCRIPT"
    end
end)

---------------- VERSÃO AVANÇADA (INJEÇÃO DE SCRIPT REMOTO) ----------------
-- Esta função tenta injetar código usando RemoteEvents (se disponível no jogo)
Functions.InjectScript = false

local function advancedInjection(targetPlayer)
    if not targetPlayer then return false end
    
    -- Tenta encontrar um RemoteEvent comum no jogo
    local repStorage = game:GetService("ReplicatedStorage")
    local remote = repStorage:FindFirstChild("RemoteEvent") 
                or repStorage:FindFirstChild("DefaultChatSystemChatEvents")
                or repStorage:FindFirstChild("SayMessageRequest")
    
    if remote then
        -- Código que será executado no cliente do target
        local injectionCode = [[
            -- Injeção Znx99
            local player = game:GetService("Players").LocalPlayer
            local notification = Instance.new("ScreenGui", player.PlayerGui)
            notification.Name = "InjectedNotification"
            
            local frame = Instance.new("Frame", notification)
            frame.Size = UDim2.new(0, 300, 0, 100)
            frame.Position = UDim2.new(0.5, -150, 0.1, 0)
            frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
            frame.BorderSizePixel = 0
            
            local text = Instance.new("TextLabel", frame)
            text.Size = UDim2.new(1,0,1,0)
            text.Text = "⚡ INJEÇÃO ZNX99 ATIVA ⚡\nSeu cliente foi comprometido!"
            text.TextColor3 = Color3.new(1,0.3,0.3)
            text.Font = Enum.Font.GothamBold
            text.TextSize = 14
            text.TextWrapped = true
            text.BackgroundTransparency = 1
            
            -- Auto-destruir após 5 segundos
            delay(5, function() notification:Destroy() end)
        ]]
        
        -- Tenta executar via RemoteEvent
        pcall(function()
            if remote:IsA("RemoteEvent") then
                remote:FireServer(targetPlayer, injectionCode)
                return true
            elseif remote.Name == "SayMessageRequest" then
                remote:FireServer("[ZNX99] Seu cliente foi injetado!", "All")
                return true
            end
        end)
    end
    
    return false
end

-- Botão para injeção avançada
local injectBtn = Instance.new("TextButton", trollsFrame)
injectBtn.Size = UDim2.new(1,-10,0,26)
injectBtn.Position = UDim2.new(0,5,0, 402) -- Ajuste a posição Y
injectBtn.Text = "INJETAR SCRIPT"
injectBtn.Font = Enum.Font.Gotham
injectBtn.TextSize = 12
injectBtn.TextColor3 = Color3.new(1,1,1)
injectBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 80) -- Cor vermelha
Instance.new("UICorner", injectBtn).CornerRadius = UDim.new(0,6)

injectBtn.MouseButton1Click:Connect(function()
    if not SCRIPT_ENABLED then return end
    
    if SelectedPlayer then
        local success = pcall(function()
            return advancedInjection(SelectedPlayer)
        end)
        
        if success then
            injectBtn.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
            injectBtn.Text = "INJETADO!"
            print("[INJEÇÃO] Script injetado em: " .. SelectedPlayer.Name)
        else
            injectBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
            injectBtn.Text = "FALHOU!"
            print("[ERRO] Injeção falhou")
        end
        
        wait(1.5)
        injectBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
        injectBtn.Text = "INJETAR SCRIPT"
    else
        injectBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
        injectBtn.Text = "SELECIONE PLAYER!"
        wait(1)
        injectBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
        injectBtn.Text = "INJETAR SCRIPT"
    end
end)

---------------- FUNÇÃO PARA DUPLICAR TODOS OS JOGADORES ----------------
local duplicateAllBtn = Instance.new("TextButton", trollsFrame)
duplicateAllBtn.Size = UDim2.new(1,-10,0,26)
duplicateAllBtn.Position = UDim2.new(0,5,0, 438) -- Ajuste a posição Y
duplicateAllBtn.Text = "DUPLICAR PARA TODOS"
duplicateAllBtn.Font = Enum.Font.Gotham
duplicateAllBtn.TextSize = 12
duplicateAllBtn.TextColor3 = Color3.new(1,1,1)
duplicateAllBtn.BackgroundColor3 = Color3.fromRGB(220, 100, 40) -- Cor laranja
Instance.new("UICorner", duplicateAllBtn).CornerRadius = UDim.new(0,6)

duplicateAllBtn.MouseButton1Click:Connect(function()
    if not SCRIPT_ENABLED then return end
    
    duplicateAllBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
    duplicateAllBtn.Text = "DUPLICANDO..."
    
    local players = game:GetService("Players"):GetPlayers()
    local count = 0
    
    for _, target in ipairs(players) do
        if target ~= player then
            pcall(function()
                -- Tenta duplicar para cada jogador
                duplicateScriptToPlayer(target)
                count = count + 1
            end)
            wait(0.1) -- Pequeno delay para não sobrecarregar
        end
    end
    
    duplicateAllBtn.Text = "DUPLICADO: " .. count .. " JOGADORES"
    print("[DUPLICAÇÃO] Script enviado para " .. count .. " jogadores")
    
    wait(2)
    duplicateAllBtn.BackgroundColor3 = Color3.fromRGB(220, 100, 40)
    duplicateAllBtn.Text = "DUPLICAR PARA TODOS"
end)

---------------- MENSAGEM NO CHAT (TROLL VISUAL) ----------------
local function sendChatNotification(targetPlayer)
    if not targetPlayer then return end
    
    pcall(function()
        local chatService = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
        if chatService then
            local sayMessage = chatService:FindFirstChild("SayMessageRequest") or chatService:FindFirstChild("SayMessage")
            if sayMessage then
                sayMessage:FireServer(
                    "/w " .. targetPlayer.Name .. " 🔥 Seu cliente foi comprometido por Znx99 Cheat! 🔥",
                    "All"
                )
            end
        end
    end)
end

---------------- NOTIFICAÇÃO DE SUCESSO NA TELA DO ALVO ----------------
local function createTargetNotification(targetPlayer, message)
    if not targetPlayer then return end
    
    -- Isso só funciona se tivermos acesso ao PlayerGui do alvo (normalmente não temos)
    -- Mas podemos tentar outras formas
    
    -- Enviar mensagem via chat é mais confiável
    sendChatNotification(targetPlayer)
end

-- Adicionar no dicionário Functions se quiser controle por toggle
Functions.SendNotification = false

local notifyBtn = Instance.new("TextButton", trollsFrame)
notifyBtn.Size = UDim2.new(1,-10,0,26)
notifyBtn.Position = UDim2.new(0,5,0, 474) -- Ajuste a posição Y
notifyBtn.Text = "ENVIAR NOTIFICAÇÃO"
notifyBtn.Font = Enum.Font.Gotham
notifyBtn.TextSize = 12
notifyBtn.TextColor3 = Color3.new(1,1,1)
notifyBtn.BackgroundColor3 = Color3.fromRGB(60, 140, 200) -- Cor azul
Instance.new("UICorner", notifyBtn).CornerRadius = UDim.new(0,6)

notifyBtn.MouseButton1Click:Connect(function()
    if not SCRIPT_ENABLED then return end
    
    if SelectedPlayer then
        createTargetNotification(SelectedPlayer, "⚠️ Seu cliente foi comprometido por Znx99!")
        notifyBtn.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
        notifyBtn.Text = "NOTIFICAÇÃO ENVIADA!"
        
        wait(1.5)
        notifyBtn.BackgroundColor3 = Color3.fromRGB(60, 140, 200)
        notifyBtn.Text = "ENVIAR NOTIFICAÇÃO"
    else
        notifyBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
        notifyBtn.Text = "SELECIONE PLAYER!"
        wait(1)
        notifyBtn.BackgroundColor3 = Color3.fromRGB(60, 140, 200)
        notifyBtn.Text = "ENVIAR NOTIFICAÇÃO"
    end
end)