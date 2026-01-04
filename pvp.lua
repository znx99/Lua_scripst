-- CONTAS
-- znx9901
--------------------------------------------------
-- SERVICES
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")

-- PLAYER
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- Atualiza character ao respawn
player.CharacterAdded:Connect(function(c)
	char = c
	hrp = c:WaitForChild("HumanoidRootPart")
end)

--------------------------------------------------
-- CONTROLE GERAL
--------------------------------------------------
local SCRIPT_ENABLED = true
local UI_OPEN = true

--------------------------------------------------
-- FUNÇÕES
--------------------------------------------------
local Functions = {
	Auto_TP = false
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

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.Text = "Znx99 Cheat"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

--------------------------------------------------
-- BOTÕES
--------------------------------------------------
local index = 0
for name in pairs(Functions) do
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(0.28,0,0,28)
	btn.Position = UDim2.new(0.05,0,0,40 + index * 36)
	btn.Text = name .. ": OFF"
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 12
	btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
	btn.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", btn)

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
-- TECLAS GERAIS
--------------------------------------------------
UIS.InputBegan:Connect(function(input, gp)
	if gp then return end

	if input.KeyCode == Enum.KeyCode.Insert then
		SCRIPT_ENABLED = false
		UI_OPEN = false
		frame.Visible = false
		for k in pairs(Functions) do
			Functions[k] = false
		end
	end

	if input.KeyCode == Enum.KeyCode.Zero and SCRIPT_ENABLED then
		UI_OPEN = not UI_OPEN
		frame.Visible = UI_OPEN
	end
end)

--------------------------------------------------
-- AUTO FOLLOW PLAYER
--------------------------------------------------
local followIndex = 0
local followList = {}
local currentTarget = nil

local function updatePlayerList()
	followList = {}
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= player then
			local c = plr.Character
			if c and c:FindFirstChild("HumanoidRootPart") then
				table.insert(followList, plr)
			end
		end
	end
end

local function selectNextPlayer()
	updatePlayerList()
	if #followList == 0 then
		currentTarget = nil
		return
	end

	followIndex += 1
	if followIndex > #followList then
		followIndex = 1
	end

	currentTarget = followList[followIndex]
end

Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)

-- Tecla O troca o alvo
UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.O then
		selectNextPlayer()
	end
end)

--------------------------------------------------
-- LOOP PRINCIPAL
--------------------------------------------------
task.spawn(function()
	while true do
		if SCRIPT_ENABLED and Functions.Auto_TP and currentTarget and hrp then
            local targetChar = currentTarget.Character
            local targetHrp = targetChar and targetChar:FindFirstChild("HumanoidRootPart")

            if targetHrp then
                -- segue atrás
                hrp.CFrame = targetHrp.CFrame * CFrame.new(0, 0, -3)
            end
        end

		task.wait(0.05)
	end
end)
