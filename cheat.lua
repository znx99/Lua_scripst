-- COntas
-- znx9901
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/znx99/Lua_scripst/main/cheat.lua"))()

-- SERVICES
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")

-- PLAYER
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

--------------------------------------------------
-- CONTROLE GERAL
--------------------------------------------------
local SCRIPT_ENABLED = true
local UI_OPEN = true

--------------------------------------------------
-- FUNÇÕES
--------------------------------------------------
local Functions = {
	AutoCollect = false,
	AutoDeposit = false,
	TesteFunction = false,
	AutoBuy = false,
	AutoUpgrade = false,
	BringBanana = false,
	FollowPlayer = false,
	BugPlayer = false
}

local FollowTargetName = "" -- nick a ser seguido
local BugTargetName = "" -- nick a ser bugado

-- Ordem fixa dos botões (para layout consistente)
local functionOrder = {
	"AutoCollect",
	"AutoDeposit",
	"TesteFunction",
	"AutoBuy",
	"AutoUpgrade",
	"BringBanana",
	"FollowPlayer",
	"BugPlayer"
}

--------------------------------------------------
-- GUI
--------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "Znx99UI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(420, 420) -- aumentei a altura para caber os inputs
frame.Position = UDim2.fromScale(0.35, 0.3)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

-- TÍTULO
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.Text = "Znx99 Cheat"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.Gotham
title.TextSize = 16
title.Parent = frame

--------------------------------------------------
-- INPUT NICK (para FollowPlayer)
--------------------------------------------------
local nameBox = Instance.new("TextBox")
nameBox.Size = UDim2.new(0.9, 0, 0, 28)
nameBox.Position = UDim2.new(0.05, 0, 0, 35)
nameBox.PlaceholderText = "Nick do player para seguir"
nameBox.Text = ""
nameBox.ClearTextOnFocus = false
nameBox.Font = Enum.Font.Gotham
nameBox.TextSize = 12
nameBox.TextColor3 = Color3.new(1,1,1)
nameBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
nameBox.Parent = frame
Instance.new("UICorner", nameBox).CornerRadius = UDim.new(0,6)

nameBox.FocusLost:Connect(function(enterPressed)
	if nameBox.Text and nameBox.Text ~= "" then
		FollowTargetName = nameBox.Text
	else
		FollowTargetName = ""
	end
end)

--------------------------------------------------
-- INPUT NICK (para BugPlayer)
--------------------------------------------------
local bugBox = Instance.new("TextBox")
bugBox.Size = UDim2.new(0.9, 0, 0, 28)
bugBox.Position = UDim2.new(0.05, 0, 0, 70)
bugBox.PlaceholderText = "Nick do player para bugar"
bugBox.Text = ""
bugBox.ClearTextOnFocus = false
bugBox.Font = Enum.Font.Gotham
bugBox.TextSize = 12
bugBox.TextColor3 = Color3.new(1,1,1)
bugBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
bugBox.Parent = frame
Instance.new("UICorner", bugBox).CornerRadius = UDim.new(0,6)

bugBox.FocusLost:Connect(function(enterPressed)
	if bugBox.Text and bugBox.Text ~= "" then
		BugTargetName = bugBox.Text
	else
		BugTargetName = ""
	end
end)

--------------------------------------------------
-- BOTÕES (3 COLUNAS)
--------------------------------------------------
local columns = 3
local btnWidth = 0.28 -- escala X
local btnHeight = 28   -- pixels Y
local paddingX = 0.05  -- escala X
local paddingY = 8     -- pixels Y
local startY = 110     -- offset Y em pixels (abaixo dos inputs)

for i, name in ipairs(functionOrder) do
	local index = i - 1
	local col = index % columns
	local row = math.floor(index / columns)

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(btnWidth, 0, 0, btnHeight)
	-- Posiciona usando escala X e offset Y
	local posX = paddingX + col * (btnWidth + 0.03)
	local posY = startY + row * (btnHeight + paddingY)
	btn.Position = UDim2.new(posX, 0, 0, posY)

	btn.Text = name .. ": OFF"
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 12
	btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Parent = frame
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)

	btn.MouseButton1Click:Connect(function()
		if not SCRIPT_ENABLED then return end

		Functions[name] = not Functions[name]
		if Functions[name] then
			btn.Text = name .. ": ON"
			btn.BackgroundColor3 = Color3.fromRGB(70,170,90)
		else
			btn.Text = name .. ": OFF"
			btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
		end
	end)
end

--------------------------------------------------
-- TECLAS
--------------------------------------------------
UIS.InputBegan:Connect(function(input, gp)
	if gp then return end

	-- INSERT = PARA TUDO
	if input.KeyCode == Enum.KeyCode.Insert then
		SCRIPT_ENABLED = false
		UI_OPEN = false
		frame.Visible = false

		for k in pairs(Functions) do
			Functions[k] = false
		end
	end

	-- 0 = ABRE / FECHA UI (só se script habilitado)
	if input.KeyCode == Enum.KeyCode.Zero and SCRIPT_ENABLED then
		UI_OPEN = not UI_OPEN
		frame.Visible = UI_OPEN
	end
end)

--------------------------------------------------
-- FUNÇÕES AUXILIARES
--------------------------------------------------
local function getPlayerHRPByName(playerName)
	if not playerName or playerName == "" then return nil end
	for _, plr in pairs(Players:GetPlayers()) do
		if plr.Name:lower() == playerName:lower() then
			local c = plr.Character
			if c then
				local p = c:FindFirstChild("HumanoidRootPart")
				if p then
					return p
				end
			end
		end
	end
	return nil
end

--------------------------------------------------
-- LOOP PRINCIPAL
--------------------------------------------------
local colects = 0
local time_to_buy = 0
local time_to_upgrade = 0

task.spawn(function()
	while true do
		-- atualiza referência do personagem/HRP a cada ciclo (tratamento de respawn)
		char = player.Character or player.CharacterAdded:Wait()
		hrp = char and char:FindFirstChild("HumanoidRootPart")

		if not SCRIPT_ENABLED then
			task.wait(1)
			continue
		end

		-- Incrementos de contadores
		if Functions.AutoDeposit then
			colects = colects + 1
		end
		if Functions.AutoBuy then
			time_to_buy = time_to_buy + 1
		end
		if Functions.AutoUpgrade then
			time_to_upgrade = time_to_upgrade + 1
		end

		-- AUTO COLLECT (teleporta perto do Drop)
		if Functions.AutoCollect then
			local part = workspace:FindFirstChild("Dropper_Drop", true)
			if part and part:IsA("BasePart") and hrp then
				-- posiciona um pouco acima para evitar colisão direta
				pcall(function()
					hrp.CFrame = CFrame.new(part.Position + Vector3.new(0, 3, 0))
				end)
			end
		end

		-- AUTO DEPOSIT (quando colects >= 200)
		if Functions.AutoDeposit and colects >= 200 and hrp then
			colects = 0
			local initial_player_cframe = hrp.CFrame
			local deposit = workspace:FindFirstChild("DepositButton", true)
			if deposit then
				local deposit_glow = deposit:FindFirstChild("Glow", true)
				if deposit_glow and deposit_glow:IsA("BasePart") then
					local deposit_path = deposit_glow.Position + Vector3.new(0, 5, 0)
					pcall(function() hrp.CFrame = CFrame.new(deposit_path) end)
				end
			end
			task.wait(0.05)
			pcall(function() if hrp and hrp.Parent then hrp.CFrame = initial_player_cframe end end)
		end

		-- AUTO BUY (tempo baseado no contador)
		if Functions.AutoBuy and time_to_buy >= 200 and hrp then
			time_to_buy = 0
			local initial_player_cframe = hrp.CFrame
			local buy_button = workspace:FindFirstChild("BuyDropper5", true)
			if buy_button then
				local buy_button_glow = buy_button:FindFirstChild("Glow", true)
				if buy_button_glow and buy_button_glow:IsA("BasePart") then
					local buy_button_path = buy_button_glow.Position
					pcall(function()
						hrp.CFrame = CFrame.new(buy_button_path)
					end)
					task.wait(0.6)
					pcall(function() if hrp and hrp.Parent then hrp.CFrame = initial_player_cframe end end)
				end
			end
		end

		-- AUTO UPGRADE
		if Functions.AutoUpgrade and time_to_upgrade >= 150 and hrp then
			time_to_upgrade = 0
			local initial_player_cframe = hrp.CFrame
			local upgrade_button = workspace:FindFirstChild("BuySpeed", true)
			if upgrade_button then
				local upgrade_button_base = upgrade_button:FindFirstChild("Base", true)
				if upgrade_button_base and upgrade_button_base:IsA("BasePart") then
					local upgrade_button_path = upgrade_button_base.Position
					pcall(function() hrp.CFrame = CFrame.new(upgrade_button_path) end)
					task.wait(0.2)
				end
			end
			pcall(function() if hrp and hrp.Parent then hrp.CFrame = initial_player_cframe end end)
		end

		-- TESTE FUNCTION (exemplo de uso)
		if Functions.TesteFunction then
			local StarterGui = game:GetService("StarterGui")
			-- pcall para evitar erros se MainUI não existir
			pcall(function()
				if StarterGui and StarterGui:FindFirstChild("MainUI") and StarterGui.MainUI:FindFirstChild("RightAds") then
					print(StarterGui.MainUI.RightAds.Visible)
				end
			end)
		end

		-- TELETRANSPORTAR BANANA PARA O JOGADOR
		if Functions.BringBanana and hrp then
			local banana = workspace:FindFirstChild("Dropper_Drop", true)
						or workspace:FindFirstChild("BananaDrop", true)
						or workspace:FindFirstChild("BananaModel", true)
			if banana then
				local rootPart
				if banana:IsA("Model") then
					rootPart = banana.PrimaryPart or banana:FindFirstChildWhichIsA("BasePart")
				elseif banana:IsA("BasePart") then
					rootPart = banana
				else
					rootPart = banana:FindFirstChildWhichIsA("BasePart")
				end

				if rootPart and hrp then
					-- posiciona a banana 3 studs acima do jogador
					pcall(function()
						rootPart.CFrame = hrp.CFrame + Vector3.new(0, 3, 0)
					end)
				end
			end
		end

		-- FOLLOW PLAYER (TP infinito pelo nick)
		if Functions.FollowPlayer and FollowTargetName ~= "" and hrp then
			local targetHRP = getPlayerHRPByName(FollowTargetName)
			if targetHRP and targetHRP.Parent then
				pcall(function()
					-- posiciona atrás do alvo (3 studs)
					hrp.CFrame = targetHRP.CFrame * CFrame.new(0, 0, -3)
				end)
			end
		end

		-- BUG PLAYER (teleporta o player alvo pra você infinitamente)
		if Functions.BugPlayer and BugTargetName ~= "" and hrp then
			local targetHRP = getPlayerHRPByName(BugTargetName)
			if targetHRP and targetHRP.Parent then
				pcall(function()
					-- cola o player em você (ligeiramente na frente)
					targetHRP.CFrame = hrp.CFrame * CFrame.new(0, 0, -2)
				end)
			end
		end

		task.wait(0.1)
	end
end)
