-- znx9901 - Script completo com GUI, lista de players e loop das funções
--loadstring(game:HttpGet("https://raw.githubusercontent.com/znx99/Lua_scripst/main/cheat.lua"))()
---------------- SERVICES ----------------
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

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
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Name = "Znx99Main"
main.Size = UDim2.fromOffset(520, 360)
main.Position = UDim2.fromScale(0.3, 0.12) -- mais perto do topo
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0,10)

-- TITLE
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,24)
title.Position = UDim2.new(0,0,0,0)
title.BackgroundTransparency = 1
title.Text = "Znx99 Cheat"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.Gotham
title.TextSize = 15

---------------- PLAYER LIST (LEFT) ----------------
local listFrame = Instance.new("Frame", main)
listFrame.Name = "PlayerList"
listFrame.Size = UDim2.new(0,150,1,-30)
listFrame.Position = UDim2.new(0,6,0,28)
listFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
listFrame.BorderSizePixel = 0
Instance.new("UICorner", listFrame).CornerRadius = UDim.new(0,6)

local listLayout = Instance.new("UIListLayout", listFrame)
listLayout.Padding = UDim.new(0,4)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- deselect button
local deselectBtn = Instance.new("TextButton", listFrame)
deselectBtn.Size = UDim2.new(1,-6,0,22)
deselectBtn.Position = UDim2.new(0,3,0,0)
deselectBtn.Text = "Deselecionar"
deselectBtn.Font = Enum.Font.Gotham
deselectBtn.TextSize = 11
deselectBtn.TextColor3 = Color3.new(1,1,1)
deselectBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
Instance.new("UICorner", deselectBtn).CornerRadius = UDim.new(0,6)
deselectBtn.MouseButton1Click:Connect(function()
	SelectedPlayer = nil
	for _,c in pairs(listFrame:GetChildren()) do
		if c:IsA("TextButton") then c.BackgroundColor3 = Color3.fromRGB(45,45,45) end
	end
	deselectBtn.BackgroundColor3 = Color3.fromRGB(70,140,90)
	task.delay(0.12, function() deselectBtn.BackgroundColor3 = Color3.fromRGB(50,50,50) end)
end)

---------------- RIGHT SIDE (TABS & CONTENT) ----------------
local right = Instance.new("Frame", main)
right.Size = UDim2.new(1,-175,1,-30)
right.Position = UDim2.new(0,165,0,28)
right.BackgroundTransparency = 1

-- tabs row
local tabs = Instance.new("Frame", right)
tabs.Size = UDim2.new(1,0,0,24)
tabs.Position = UDim2.new(0,0,0,0)
tabs.BackgroundTransparency = 1

local function tabBtn(txt, x)
	local b = Instance.new("TextButton", tabs)
	b.Size = UDim2.new(0.5,-2,1,0)
	b.Position = UDim2.new(x,2,0,0)
	b.Text = txt
	b.Font = Enum.Font.Gotham
	b.TextSize = 12
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(45,45,45)
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
	return b
end

local tabFarm = tabBtn("Farm", 0)
local tabTrolls = tabBtn("Trolls", 0.5)

local farmFrame = Instance.new("Frame", right)
farmFrame.Size = UDim2.new(1,0,1,-28)
farmFrame.Position = UDim2.new(0,0,0,28)
farmFrame.BackgroundTransparency = 1

local trollsFrame = Instance.new("Frame", right)
trollsFrame.Size = farmFrame.Size
trollsFrame.Position = farmFrame.Position
trollsFrame.BackgroundTransparency = 1
trollsFrame.Visible = false

---------------- Farm Buttons ----------------
local function makeToggleButton(parent, name, posY)
	local b = Instance.new("TextButton", parent)
	b.Size = UDim2.new(1,-10,0,26)
	b.Position = UDim2.new(0,5,0,posY)
	b.Text = name..": OFF"
	b.Font = Enum.Font.Gotham
	b.TextSize = 12
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(50,50,50)
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)

	b.MouseButton1Click:Connect(function()
		if not SCRIPT_ENABLED then return end
		Functions[name] = not Functions[name]
		b.Text = name..": "..(Functions[name] and "ON" or "OFF")
		b.BackgroundColor3 = Functions[name] and Color3.fromRGB(70,170,90) or Color3.fromRGB(50,50,50)
	end)
	return b
end

makeToggleButton(farmFrame, "AutoCollect", 6)
makeToggleButton(farmFrame, "AutoDeposit", 42)
makeToggleButton(farmFrame, "TesteFunction", 78)
makeToggleButton(farmFrame, "AutoBuy", 114)
makeToggleButton(farmFrame, "AutoUpgrade", 150)
makeToggleButton(farmFrame, "BringBanana", 78)
---------------- Trolls Buttons ----------------
-- Follow and Bug use SelectedPlayer
local followBtn = makeToggleButton(trollsFrame, "FollowPlayer", 6)
local bugBtn = makeToggleButton(trollsFrame, "BugPlayer", 42)

---------------- PLAYER LIST REFRESH ----------------
local function rebuildPlayerList()
	-- remove old (keep first element Deselecionar)
	for _,v in pairs(listFrame:GetChildren()) do
		if v:IsA("TextButton") and v ~= deselectBtn then
			v:Destroy()
		end
	end

	for _,p in ipairs(Players:GetPlayers()) do
		if p ~= player then
			local btn = Instance.new("TextButton", listFrame)
			btn.Size = UDim2.new(1,-6,0,22)
			btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
			btn.Font = Enum.Font.Gotham
			btn.TextSize = 11
			btn.TextColor3 = Color3.new(1,1,1)
			btn.Text = p.Name
			Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)

			btn.MouseButton1Click:Connect(function()
				SelectedPlayer = p
				-- highlight selection
				for _,c in pairs(listFrame:GetChildren()) do
					if c:IsA("TextButton") then c.BackgroundColor3 = Color3.fromRGB(45,45,45) end
				end
				btn.BackgroundColor3 = Color3.fromRGB(70,140,90)
			end)
		end
	end
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
-- Use task.spawn loop (0.1s) to run farm logic and trolls logic
task.spawn(function()
	while true do
		-- atualizar referências de personagem local caso respawn
		char = player.Character or player.CharacterAdded:Wait()
		hrp = char and char:FindFirstChild("HumanoidRootPart")

		if not SCRIPT_ENABLED then
			task.wait(1)
			continue
		end

		-- incrementos de contadores (segue sua lógica anterior)
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
		if Functions.AutoCollect and hrp then
			local part = workspace:FindFirstChild("Dropper_Drop", true)
			if part then
				pcall(function()
					hrp.CFrame = CFrame.new(part.Position + Vector3.new(0,3,0))
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
					local deposit_path = deposit_glow.Position + Vector3.new(0,5,0)
					pcall(function() hrp.CFrame = CFrame.new(deposit_path) end)
				end
			end
			task.wait(0.1)
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
					pcall(function() hrp.CFrame = CFrame.new(buy_button_path) end)
					task.wait(0.6)
				end
			end
			pcall(function() if hrp and hrp.Parent then hrp.CFrame = initial_player_cframe end end)
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

		-- TESTE FUNCTION (exemplo)
		if Functions.TesteFunction then
			pcall(function()
				local StarterGui = game:GetService("StarterGui")
				if StarterGui and StarterGui:FindFirstChild("MainUI") and StarterGui.MainUI:FindFirstChild("RightAds") then
					print("RightAds.Visible =", StarterGui.MainUI.RightAds.Visible)
				end
			end)
		end

		-- BRING BANANA (teleporta banana pra perto de você)
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
				if rootPart then
					pcall(function() rootPart.CFrame = hrp.CFrame + Vector3.new(0,3,0) end)
				end
			end
		end

		-- FOLLOW PLAYER (usa SelectedPlayer)
		if Functions.FollowPlayer and SelectedPlayer and hrp then
			local targetHRP = getSelectedHRP()
			if targetHRP and targetHRP.Parent then
				pcall(function() hrp.CFrame = targetHRP.CFrame * CFrame.new(0,0,-3) end)
			end
		end

		-- BUG PLAYER (teleporta target para perto de você)
		if Functions.BugPlayer and SelectedPlayer and hrp then
			local targetHRP = getSelectedHRP()
			if targetHRP and targetHRP.Parent then
				pcall(function() targetHRP.CFrame = hrp.CFrame * CFrame.new(0,0,-2) end)
			end
		end

		task.wait(0.1)
	end
end)

---------------- TAB SWITCH ----------------
local function setTab(t)
	farmFrame.Visible = t == "Farm"
	trollsFrame.Visible = t == "Trolls"
	tabFarm.BackgroundColor3 = t == "Farm" and Color3.fromRGB(70,70,70) or Color3.fromRGB(45,45,45)
	tabTrolls.BackgroundColor3 = t == "Trolls" and Color3.fromRGB(70,70,70) or Color3.fromRGB(45,45,45)
end

tabFarm.MouseButton1Click:Connect(function() setTab("Farm") end)
tabTrolls.MouseButton1Click:Connect(function() setTab("Trolls") end)
setTab("Farm")

---------------- KEYS ----------------
UIS.InputBegan:Connect(function(i,gp)
	if gp then return end
	if i.KeyCode == Enum.KeyCode.Insert then
		SCRIPT_ENABLED = false
		gui:Destroy()
	end
	if i.KeyCode == Enum.KeyCode.Zero then
		main.Visible = not main.Visible
	end
end)
