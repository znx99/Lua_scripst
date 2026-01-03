-- COntas
--znx9901
------------------
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
    AutoBuy = false,
    AutoUpgrade = false,
	Delay =false,
	AntiAfk = false
}

--------------------------------------------------
-- GUI
--------------------------------------------------
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "Znx99UI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(420, 300)
frame.Position = UDim2.fromScale(0.35, 0.3)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

-- TÍTULO
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.Text = "Znx99 Cheat"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

--------------------------------------------------
-- BOTÕES (3 COLUNAS)
--------------------------------------------------
local columns = 3
local btnWidth = 0.28
local btnHeight = 28
local paddingX = 0.05
local paddingY = 8

local index = 0

for name in pairs(Functions) do
	local col = index % columns
	local row = math.floor(index / columns)

	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(btnWidth,0,0,btnHeight)
	btn.Position = UDim2.new(
		paddingX + col * (btnWidth + 0.03),
		0,
		0,
		40 + row * (btnHeight + paddingY)
	)

	btn.Text = name .. ": OFF"
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 12
	btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
	btn.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)

	btn.MouseButton1Click:Connect(function()
		if not SCRIPT_ENABLED then return end

		Functions[name] = not Functions[name]
		btn.Text = name .. (Functions[name] and ": ON" or ": OFF")
		btn.BackgroundColor3 = Functions[name]
			and Color3.fromRGB(70,170,90)
			or Color3.fromRGB(50,50,50)
	end)

	index += 1
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

		warn("SCRIPT PARADO PELO INSERT")
	end

	-- 0 = ABRE / FECHA UI
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

		-- EXEMPLO
		if Functions.AutoCollect then
			local part = workspace:FindFirstChild("Dropper_Drop", true)
			if part then
                if Functions.AutoDeposit then
                    colects = colects + 1
                end
                if Functions.AutoBuy then
                    time_to_buy = time_to_buy + 1
                end
                if Functions.AutoUpgrade then
                    time_to_upgrade = time_to_upgrade + 1
                end
				hrp.CFrame = CFrame.new(part.Position)
			end
		end
        if Functions.AutoDeposit and colects == 5 then
            colects = 0
            local deposit = workspace:FindFirstChild("DepositButton", true) 
            local deposit_glow = deposit:FindFirstChild("Glow", true) 
            local deposit_path = deposit_glow.Position + Vector3.new(0, 5, 0)
            hrp.CFrame = CFrame.new(deposit_path)
        end
        if Functions.AutoBuy and time_to_buy == 10 then
            time_to_buy = 0
            local buy_button = workspace:FindFirstChild("BuyDropper5", true)
            local buy_button_glow = buy_button:FindFirstChild("Glow", true)
            local buy_button_path = buy_button_glow.Position + Vector3.new(0, 5, 0)
            hrp.CFrame = CFrame.new(buy_button_path)
            task.wait(0.6)
        end
        if Functions.AutoUpgrade and time_to_upgrade == 50 then
            time_to_upgrade = 0
            local upgrade_button = workspace:FindFirstChild("BuySpeed", true)
            local upgrade_button_base = upgrade_button:FindFirstChild("Base", true)
            local upgrade_button_path = upgrade_button_base.Position + Vector3.new(0, 2, 0)
            hrp.CFrame = CFrame.new(upgrade_button_path)
            task.wait(0.6)
        end
        if Functions.TesteFunction then
            local StarterGui = game:GetService("StarterGui")
            print(StarterGui.MainUI.RightAds.Visible)
        end
		if Functions.Delay then
			task.wait(1)
		end
		if Functions.AntiAFK then
			local VirtualUser = game:GetService("VirtualUser")

			player.Idled:Connect(function()
				VirtualUser:CaptureController()
				VirtualUser:ClickButton2(Vector2.new())
				print("Anti-AFK ativado")
			end)
		end
		task.wait(0.1)
	end
end)
