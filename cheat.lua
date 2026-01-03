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
	BringBanana = false
}

-- Ordem fixa dos botões (para layout consistente)
local functionOrder = {
	"AutoCollect",
	"AutoDeposit",
	"TesteFunction",
	"AutoBuy",
	"AutoUpgrade",
	"BringBanana"
}

--------------------------------------------------
-- GUI
--------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "Znx99UI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(420, 300)
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
-- BOTÕES (3 COLUNAS)
--------------------------------------------------
local columns = 3
local btnWidth = 0.28 -- escala X
local btnHeight = 28   -- pixels Y
local paddingX = 0.05  -- escala X
local paddingY = 8     -- pixels Y
local startY = 40      -- offset Y em pixels

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
-- LOOP PRINCIPAL
--------------------------------------------------
local colects = 0
local time_to_buy = 0
local time_to_upgrade = 0

task.spawn(function()
	while true do
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
			if part and part:IsA("BasePart") then
				-- posiciona um pouco acima para evitar colisão direta
				pcall(function()
					hrp.CFrame = CFrame.new(part.Position + Vector3.new(0, 3, 0))
				end)
			end
		end

		-- AUTO DEPOSIT (quando colects == 5)
		if Functions.AutoDeposit and colects >= 50 then
			local hrp = char:WaitForChild("HumanoidRootPart")
			local initial_player_position = hrp.Position
			colects = 0
			local deposit = workspace:FindFirstChild("DepositButton", true)
			if deposit then
				local deposit_glow = deposit:FindFirstChild("Glow", true)
				if deposit_glow and deposit_glow:IsA("BasePart") then
					local deposit_path = deposit_glow.Position + Vector3.new(0, 5, 0)
					pcall(function() hrp.CFrame = CFrame.new(deposit_path) end)
				end
			end
			task.wait(0.05)
			hrp.CFrame = CFrame.new(initial_player_position)
		end

		-- AUTO BUY (tempo baseado no contador)
		if Functions.AutoBuy and time_to_buy >= 500 then
			time_to_buy = 0
			local hrp = char:WaitForChild("HumanoidRootPart")
			local initial_player_position = hrp.Position
			local buy_button = workspace:FindFirstChild("BuyDropper5", true)
			if buy_button then
				local buy_button_glow = buy_button:FindFirstChild("Glow", true)
				if buy_button_glow and buy_button_glow:IsA("BasePart") then
					local buy_button_path = buy_button_glow.Position + Vector3.new(0, 0, 0)
					pcall(function()
						hrp.CFrame = CFrame.new(buy_button_path)
					end)
					task.wait(0.6)
					hrp.CFrame = CFrame.new(initial_player_position)
				end
			end
		end

		-- AUTO UPGRADE
		if Functions.AutoUpgrade and time_to_upgrade >= 150 then
			local hrp = char:WaitForChild("HumanoidRootPart")
			local initial_player_position = hrp.Position
			time_to_upgrade = 0
			local upgrade_button = workspace:FindFirstChild("BuySpeed", true)
			if upgrade_button then
				local upgrade_button_base = upgrade_button:FindFirstChild("Base", true)
				if upgrade_button_base and upgrade_button_base:IsA("BasePart") then
					local upgrade_button_path = upgrade_button_base.Position + Vector3.new(0, 0, 0)
					pcall(function() hrp.CFrame = CFrame.new(upgrade_button_path) end)
					task.wait(0.2)
				end
			end
			hrp.CFrame = CFrame.new(initial_player_position)
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
		if Functions.BringBanana then
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

		task.wait(0.1)
	end
end)
