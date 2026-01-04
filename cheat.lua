-- znx9901 - Script completo com GUI, lista de players e loop das funções
-- Versão Mobile Compatível
--loadstring(game:HttpGet("https://raw.githubusercontent.com/znx99/Lua_scripst/main/cheat.lua"))()

---------------- SERVICES ----------------
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

---------------- PLAYER ----------------
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- atualiza referencias no respawn
player.CharacterAdded:Connect(function(c)
	char = c
	hrp = c:WaitForChild("HumanoidRootPart")
end)

---------------- CONTROLE ----------------
local SCRIPT_ENABLED = true
local SelectedPlayer = nil

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

---------------- GUI ----------------
local gui = Instance.new("ScreenGui")
gui.Name = "Znx99CheatGUI"
gui.Parent = CoreGui  -- Usar CoreGui para mobile
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.ResetOnSpawn = false

-- Botão de toggle para abrir/fechar menu (para mobile)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleMenuBtn"
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0, 20, 0.5, -25)
toggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Text = "☰"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 20
toggleBtn.ZIndex = 100
toggleBtn.BorderSizePixel = 0
toggleBtn.Visible = true
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)
toggleBtn.Parent = gui

local main = Instance.new("Frame")
main.Name = "Znx99Main"
main.Size = UDim2.fromOffset(500, 400)
main.Position = UDim2.new(0.5, -250, 0.5, -200)  -- Centralizado
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.BorderSizePixel = 0
main.Visible = false  -- Começa invisível
main.ZIndex = 10
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

-- Sombreamento
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.new(0, 0, 0)
shadow.ImageTransparency = 0.8
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)
shadow.BackgroundTransparency = 1
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(0, -10, 0, -10)
shadow.Parent = main

main.Parent = gui

-- TITLE
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
titleBar.BorderSizePixel = 0
titleBar.ZIndex = 11
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10)
titleBar.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.8, 0, 1, 0)
title.Position = UDim2.new(0.1, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Znx99 Cheat v2.0"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 12
title.Parent = titleBar

-- Botão de fechar
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0.5, -15)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.ZIndex = 12
closeBtn.BorderSizePixel = 0
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)
closeBtn.Parent = titleBar

---------------- PLAYER LIST (LEFT) ----------------
local listFrame = Instance.new("ScrollingFrame")
listFrame.Name = "PlayerList"
listFrame.Size = UDim2.new(0, 180, 1, -50)
listFrame.Position = UDim2.new(0, 10, 0, 50)
listFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
listFrame.BorderSizePixel = 0
listFrame.ScrollBarThickness = 6
listFrame.ZIndex = 11
Instance.new("UICorner", listFrame).CornerRadius = UDim.new(0, 6)
listFrame.Parent = main

local listLayout = Instance.new("UIListLayout", listFrame)
listLayout.Padding = UDim.new(0, 4)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- deselect button
local deselectBtn = Instance.new("TextButton")
deselectBtn.Size = UDim2.new(1, -12, 0, 30)
deselectBtn.Position = UDim2.new(0, 6, 0, 6)
deselectBtn.Text = "Deselecionar"
deselectBtn.Font = Enum.Font.Gotham
deselectBtn.TextSize = 14
deselectBtn.TextColor3 = Color3.new(1, 1, 1)
deselectBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
deselectBtn.ZIndex = 12
deselectBtn.AutoButtonColor = true
Instance.new("UICorner", deselectBtn).CornerRadius = UDim.new(0, 6)
deselectBtn.Parent = listFrame

---------------- RIGHT SIDE (TABS & CONTENT) ----------------
local right = Instance.new("Frame")
right.Size = UDim2.new(1, -200, 1, -50)
right.Position = UDim2.new(0, 190, 0, 50)
right.BackgroundTransparency = 1
right.ZIndex = 11
right.Parent = main

-- tabs row
local tabs = Instance.new("Frame")
tabs.Size = UDim2.new(1, 0, 0, 40)
tabs.Position = UDim2.new(0, 0, 0, 0)
tabs.BackgroundTransparency = 1
tabs.ZIndex = 12
tabs.Parent = right

local function tabBtn(txt, x)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0.5, -5, 1, 0)
	b.Position = UDim2.new(x, 0, 0, 0)
	b.Text = txt
	b.Font = Enum.Font.GothamBold
	b.TextSize = 14
	b.TextColor3 = Color3.new(1, 1, 1)
	b.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	b.ZIndex = 12
	b.AutoButtonColor = true
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
	b.Parent = tabs
	return b
end

local tabFarm = tabBtn("Farm", 0)
local tabTrolls = tabBtn("Trolls", 0.5)

local farmFrame = Instance.new("ScrollingFrame")
farmFrame.Size = UDim2.new(1, 0, 1, -45)
farmFrame.Position = UDim2.new(0, 0, 0, 45)
farmFrame.BackgroundTransparency = 1
farmFrame.ScrollBarThickness = 6
farmFrame.ZIndex = 11
farmFrame.Parent = right

local trollsFrame = Instance.new("ScrollingFrame")
trollsFrame.Size = farmFrame.Size
trollsFrame.Position = farmFrame.Position
trollsFrame.BackgroundTransparency = 1
trollsFrame.ScrollBarThickness = 6
trollsFrame.ZIndex = 11
trollsFrame.Visible = false
trollsFrame.Parent = right

---------------- Farm Buttons ----------------
local function makeToggleButton(parent, name, posY)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, -20, 0, 40)
	b.Position = UDim2.new(0, 10, 0, posY)
	b.Text = name..": OFF"
	b.Font = Enum.Font.Gotham
	b.TextSize = 14
	b.TextColor3 = Color3.new(1, 1, 1)
	b.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	b.ZIndex = 12
	b.AutoButtonColor = true
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
	
	local textLabel = b:Clone()
	textLabel.Parent = b
	textLabel.BackgroundTransparency = 1
	textLabel.Text = name
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.Position = UDim2.new(0, 0, 0, 0)
	
	local status = Instance.new("TextLabel")
	status.Size = UDim2.new(0, 60, 0, 25)
	status.Position = UDim2.new(1, -65, 0.5, -12.5)
	status.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
	status.Text = "OFF"
	status.Font = Enum.Font.GothamBold
	status.TextSize = 12
	status.TextColor3 = Color3.new(1, 1, 1)
	status.ZIndex = 13
	Instance.new("UICorner", status).CornerRadius = UDim.new(1, 0)
	status.Parent = b

	b.MouseButton1Click:Connect(function()
		if not SCRIPT_ENABLED then return end
		Functions[name] = not Functions[name]
		status.Text = Functions[name] and "ON" or "OFF"
		status.BackgroundColor3 = Functions[name] and Color3.fromRGB(70, 170, 90) or Color3.fromRGB(150, 50, 50)
		textLabel.TextColor3 = Functions[name] and Color3.fromRGB(0, 255, 0) or Color3.new(1, 1, 1)
	end)
	
	b.Parent = parent
	return b
end

local yPos = 10
local farmButtons = {}
farmButtons.AutoCollect = makeToggleButton(farmFrame, "AutoCollect", yPos); yPos = yPos + 50
farmButtons.AutoDeposit = makeToggleButton(farmFrame, "AutoDeposit", yPos); yPos = yPos + 50
farmButtons.TesteFunction = makeToggleButton(farmFrame, "TesteFunction", yPos); yPos = yPos + 50
farmButtons.AutoBuy = makeToggleButton(farmFrame, "AutoBuy", yPos); yPos = yPos + 50
farmButtons.AutoUpgrade = makeToggleButton(farmFrame, "AutoUpgrade", yPos); yPos = yPos + 50
farmButtons.BringBanana = makeToggleButton(farmFrame, "BringBanana", yPos)

---------------- Trolls Buttons ----------------
local yPos2 = 10
local trollButtons = {}
trollButtons.FollowPlayer = makeToggleButton(trollsFrame, "FollowPlayer", yPos2); yPos2 = yPos2 + 50
trollButtons.BugPlayer = makeToggleButton(trollsFrame, "BugPlayer", yPos2)

---------------- PLAYER LIST REFRESH ----------------
local function rebuildPlayerList()
	-- remove old (keep first element Deselecionar)
	for _,v in pairs(listFrame:GetChildren()) do
		if v:IsA("TextButton") and v ~= deselectBtn then
			v:Destroy()
		end
	end

	local yPosList = 45
	for _,p in ipairs(Players:GetPlayers()) do
		if p ~= player then
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, -12, 0, 35)
			btn.Position = UDim2.new(0, 6, 0, yPosList)
			btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
			btn.Font = Enum.Font.Gotham
			btn.TextSize = 14
			btn.TextColor3 = Color3.new(1, 1, 1)
			btn.Text = p.Name
			btn.ZIndex = 12
			btn.AutoButtonColor = true
			Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
			
			btn.MouseButton1Click:Connect(function()
				SelectedPlayer = p
				-- highlight selection
				for _,c in pairs(listFrame:GetChildren()) do
					if c:IsA("TextButton") and c ~= deselectBtn then 
						c.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
					end
				end
				btn.BackgroundColor3 = Color3.fromRGB(70, 140, 90)
			end)
			
			btn.Parent = listFrame
			yPosList = yPosList + 40
		end
	end
	
	listFrame.CanvasSize = UDim2.new(0, 0, 0, yPosList + 10)
end

Players.PlayerAdded:Connect(rebuildPlayerList)
Players.PlayerRemoving:Connect(function()
	if SelectedPlayer and SelectedPlayer.Parent == nil then SelectedPlayer = nil end
	rebuildPlayerList()
end)
rebuildPlayerList()

---------------- HELPERS ----------------
local function getSelectedHRP()
	if not SelectedPlayer then return nil end
	local c = SelectedPlayer.Character
	if not c then return nil end
	local p = c:FindFirstChild("HumanoidRootPart")
	return p
end

---------------- COUNTERS ----------------
local colects = 0
local time_to_buy = 0
local time_to_upgrade = 0

---------------- MAIN LOOP (FUNCOES) ----------------
task.spawn(function()
	while true do
		task.wait(0.1)
		
		-- atualizar referências de personagem local caso respawn
		if not char or not char.Parent then
			char = player.Character or player.CharacterAdded:Wait()
			hrp = char:WaitForChild("HumanoidRootPart")
		end
		
		if not SCRIPT_ENABLED or not hrp then
			continue
		end

		-- incrementos de contadores
		if Functions.AutoDeposit then
			colects = colects + 1
		end
		if Functions.AutoBuy then
			time_to_buy = time_to_buy + 1
		end
		if Functions.AutoUpgrade then
			time_to_upgrade = time_to_upgrade + 1
		end

		-- AUTO COLLECT
		if Functions.AutoCollect and hrp then
			local part = workspace:FindFirstChild("Dropper_Drop", true)
			if part then
				pcall(function()
					hrp.CFrame = CFrame.new(part.Position + Vector3.new(0, 3, 0))
				end)
			end
		end

		-- AUTO DEPOSIT
		if Functions.AutoDeposit and colects >= 200 and hrp then
			colects = 0
			local initial_cframe = hrp.CFrame
			local deposit = workspace:FindFirstChild("DepositButton", true)
			if deposit then
				local deposit_glow = deposit:FindFirstChild("Glow", true)
				if deposit_glow and deposit_glow:IsA("BasePart") then
					pcall(function() hrp.CFrame = CFrame.new(deposit_glow.Position + Vector3.new(0, 5, 0)) end)
					task.wait(0.1)
					pcall(function() hrp.CFrame = initial_cframe end)
				end
			end
		end

		-- AUTO BUY
		if Functions.AutoBuy and time_to_buy >= 200 and hrp then
			time_to_buy = 0
			local initial_cframe = hrp.CFrame
			local buy_button = workspace:FindFirstChild("BuyDropper5", true)
			if buy_button then
				local buy_glow = buy_button:FindFirstChild("Glow", true)
				if buy_glow and buy_glow:IsA("BasePart") then
					pcall(function() hrp.CFrame = CFrame.new(buy_glow.Position) end)
					task.wait(0.6)
					pcall(function() hrp.CFrame = initial_cframe end)
				end
			end
		end

		-- AUTO UPGRADE
		if Functions.AutoUpgrade and time_to_upgrade >= 150 and hrp then
			time_to_upgrade = 0
			local initial_cframe = hrp.CFrame
			local upgrade_button = workspace:FindFirstChild("BuySpeed", true)
			if upgrade_button then
				local upgrade_base = upgrade_button:FindFirstChild("Base", true)
				if upgrade_base and upgrade_base:IsA("BasePart") then
					pcall(function() hrp.CFrame = CFrame.new(upgrade_base.Position) end)
					task.wait(0.2)
					pcall(function() hrp.Cframe = initial_cframe end)
				end
			end
		end

		-- TESTE FUNCTION
		if Functions.TesteFunction then
			pcall(function()
				local StarterGui = game:GetService("StarterGui")
				if StarterGui and StarterGui:FindFirstChild("MainUI") and StarterGui.MainUI:FindFirstChild("RightAds") then
					print("RightAds.Visible =", StarterGui.MainUI.RightAds.Visible)
				end
			end)
		end

		-- BRING BANANA
		if Functions.BringBanana and hrp then
			local banana = workspace:FindFirstChild("Dropper_Drop", true) or
						  workspace:FindFirstChild("BananaDrop", true) or
						  workspace:FindFirstChild("BananaModel", true)
			if banana then
				local rootPart
				if banana:IsA("Model") then
					rootPart = banana.PrimaryPart or banana:FindFirstChildWhichIsA("BasePart")
				elseif banana:IsA("BasePart") then
					rootPart = banana
				else
					rootPart = banana:FindFirstChildWhichIsA("BasePart")
				end
				if rootPart then
					pcall(function() rootPart.CFrame = hrp.CFrame + Vector3.new(0, 3, 0) end)
				end
			end
		end

		-- FOLLOW PLAYER
		if Functions.FollowPlayer and SelectedPlayer and hrp then
			local targetHRP = getSelectedHRP()
			if targetHRP and targetHRP.Parent then
				pcall(function() 
					hrp.CFrame = targetHRP.CFrame * CFrame.new(0, 0, -3) 
				end)
			end
		end

		-- BUG PLAYER
		if Functions.BugPlayer and SelectedPlayer and hrp then
			local targetHRP = getSelectedHRP()
			if targetHRP and targetHRP.Parent then
				pcall(function() 
					targetHRP.CFrame = hrp.CFrame * CFrame.new(0, 0, -2) 
				end)
			end
		end
	end
end)

---------------- TAB SWITCH ----------------
local function setTab(t)
	farmFrame.Visible = t == "Farm"
	trollsFrame.Visible = t == "Trolls"
	tabFarm.BackgroundColor3 = t == "Farm" and Color3.fromRGB(70, 120, 200) or Color3.fromRGB(45, 45, 45)
	tabTrolls.BackgroundColor3 = t == "Trolls" and Color3.fromRGB(70, 120, 200) or Color3.fromRGB(45, 45, 45)
end

tabFarm.MouseButton1Click:Connect(function() setTab("Farm") end)
tabTrolls.MouseButton1Click:Connect(function() setTab("Trolls") end)
setTab("Farm")

---------------- CONTROLES DE INTERFACE ----------------
-- Toggle menu
toggleBtn.MouseButton1Click:Connect(function()
	main.Visible = not main.Visible
	if main.Visible then
		rebuildPlayerList()
	end
end)

-- Fechar menu
closeBtn.MouseButton1Click:Connect(function()
	main.Visible = false
end)

-- Arrastar menu
local dragging = false
local dragInput, dragStart, startPos

local function updateInput(input)
	local delta = input.Position - dragStart
	main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = main.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

titleBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and (input == dragInput) then
		updateInput(input)
	end
end)

-- Botão para desativar/ativar script
local scriptToggle = Instance.new("TextButton")
scriptToggle.Size = UDim2.new(0, 150, 0, 40)
scriptToggle.Position = UDim2.new(0.5, -75, 1, -50)
scriptToggle.Text = "DESATIVAR SCRIPT"
scriptToggle.Font = Enum.Font.GothamBold
scriptToggle.TextSize = 14
scriptToggle.TextColor3 = Color3.new(1, 1, 1)
scriptToggle.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
scriptToggle.ZIndex = 12
scriptToggle.AutoButtonColor = true
Instance.new("UICorner", scriptToggle).CornerRadius = UDim.new(0, 6)
scriptToggle.Parent = main

scriptToggle.MouseButton1Click:Connect(function()
	SCRIPT_ENABLED = not SCRIPT_ENABLED
	if SCRIPT_ENABLED then
		scriptToggle.Text = "DESATIVAR SCRIPT"
		scriptToggle.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
	else
		scriptToggle.Text = "ATIVAR SCRIPT"
		scriptToggle.BackgroundColor3 = Color3.fromRGB(60, 200, 60)
		-- Desliga todas as funções
		for name, _ in pairs(Functions) do
			Functions[name] = false
			if farmButtons[name] then
				farmButtons[name]:FindFirstChildWhichIsA("TextLabel").Text = name..": OFF"
			end
			if trollButtons[name] then
				trollButtons[name]:FindFirstChildWhichIsA("TextLabel").Text = name..": OFF"
			end
		end
	end
end)

-- Ajustar para mobile
if UIS.TouchEnabled then
	-- Aumentar botões para touch
	toggleBtn.Size = UDim2.new(0, 70, 0, 70)
	toggleBtn.TextSize = 28
	
	-- Aumentar tamanho do menu para mobile
	main.Size = UDim2.new(0.9, 0, 0.8, 0)
	main.Position = UDim2.new(0.5, 0, 0.5, 0, 'BrickCellSize', 'InOutQuad')
	
	-- Aumentar botões internos
	for _, btn in pairs(farmFrame:GetChildren()) do
		if btn:IsA("TextButton") then
			btn.Size = UDim2.new(1, -20, 0, 50)
		end
	end
end

print("Znx99 Cheat Mobile v2.0 Carregado!")
print("Toque no botão ☰ para abrir o menu")