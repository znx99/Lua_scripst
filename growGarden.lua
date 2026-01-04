-- COntas
--znx9901
------------------
-- SERVICES
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local VIM = game:GetService("VirtualInputManager")
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
	Colect_Carrot = false,
    Plant_carrot = false,
    BuyEggs = false
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
--------------------------------------------------
-- LOOP PRINCIPAL (OTIMIZADO)
--------------------------------------------------
--------------------------------------------------
-- CONFIG / CACHE
--------------------------------------------------
local TARGET_OWNER = "znx9900"
local plot_cache = nil
local carrot_cache = nil

--------------------------------------------------
-- FUNÇÕES OTIMIZADAS
--------------------------------------------------
local function findPlot()
	if plot_cache and plot_cache.Parent then
		return plot_cache
	end

	local farm = workspace:FindFirstChild("Farm")
	if not farm then return nil end

	for _, plot in ipairs(farm:GetChildren()) do
		local sign = plot:FindFirstChild("Sign")
		if sign then
			local label =
				sign:FindFirstChild("Core_Part")
				and sign.Core_Part:FindFirstChild("SurfaceGui")
				and sign.Core_Part.SurfaceGui:FindFirstChild("Player")
				and sign.Core_Part.SurfaceGui.Player:FindFirstChildWhichIsA("TextLabel")

			if label and label.Text:lower():find("znx99", 1, true) then
				plot_cache = plot
				return plot
			end
		end
	end

	return nil
end

local function findCarrot(plot)
	if carrot_cache and carrot_cache.Parent then
		return carrot_cache
	end

	local carrot = plot:FindFirstChild("Carrot", true)
	if not carrot then return nil end

	local block = carrot:FindFirstChild("1", true)
	if block and block:IsA("BasePart") then
		carrot_cache = block
		return block
	end

	return nil
end
task.spawn(function()
	while true do
		if not SCRIPT_ENABLED then
			task.wait(1)
			continue
		end

		if Functions.Colect_Carrot and hrp then
			local plot = findPlot()
			if plot then
				local carrot_block = findCarrot(plot)
				if carrot_block then
					hrp.CFrame = carrot_block.CFrame + Vector3.new(0, 3, 0)
                    VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game) -- pressiona
                    task.wait(0.1)
                    VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game) -- solta
				end
			end
		end
        if Functions.Plant_carrot then
            local player = game.Players.LocalPlayer
            local char = player.Character or player.CharacterAdded:Wait()
            local backpack = player:WaitForChild("Backpack")

            local myTool = backpack:FindFirstChild("Carrot Seed [2x]")
			moveToolToSlot(myTool, 2) -- tenta colocar em slot 1
        end
        if Functions.BuyEggs then
            local Players = game:GetService("Players")
            local player = Players.LocalPlayer
            local playerGui = player:WaitForChild("PlayerGui")

            -- ajuste o caminho até o botão
            local button = playerGui:WaitForChild("ShopGui")
                :WaitForChild("ShowMeTheEggsShop")

            -- clica automaticamente
            button:Activate()
        end
		task.wait(0.25) -- loop leve
	end
end)
