-- Full-featured Summon Rift GUI Script with Options

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SummonRiftToggle"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- LeftCtrl GUI Toggle
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.LeftControl then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)


-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 180)
MainFrame.Position = UDim2.new(0, 10, 1, -220)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 8)
UICornerMain.Parent = MainFrame

-- Toggle Button
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(1, -20, 0, 40)
ToggleButton.Position = UDim2.new(0, 10, 0, 10)
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
ToggleButton.Text = "Start Summon Rift"
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.TextScaled = true
ToggleButton.Parent = MainFrame

local UICornerToggle = Instance.new("UICorner")
UICornerToggle.CornerRadius = UDim.new(0, 6)
UICornerToggle.Parent = ToggleButton

-- Dropdown for World
local WorldDropdown = Instance.new("TextBox")
WorldDropdown.Size = UDim2.new(1, -20, 0, 30)
WorldDropdown.Position = UDim2.new(0, 10, 0, 60)
WorldDropdown.PlaceholderText = "Enter World (e.g., Minigame Paradise, The Overworld)"
WorldDropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
WorldDropdown.TextColor3 = Color3.new(1, 1, 1)
WorldDropdown.Font = Enum.Font.SourceSans
WorldDropdown.TextScaled = true
WorldDropdown.Parent = MainFrame

-- Dropdown for Egg
local EggDropdown = Instance.new("TextBox")
EggDropdown.Size = UDim2.new(1, -20, 0, 30)
EggDropdown.Position = UDim2.new(0, 10, 0, 100)
EggDropdown.PlaceholderText = "Enter Egg Name (e.g., Mining Egg)"
EggDropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
EggDropdown.TextColor3 = Color3.new(1, 1, 1)
EggDropdown.Font = Enum.Font.SourceSans
EggDropdown.TextScaled = true
EggDropdown.Parent = MainFrame

-- Timer Display
local TimerLabel = Instance.new("TextLabel")
TimerLabel.Size = UDim2.new(1, -20, 0, 30)
TimerLabel.Position = UDim2.new(0, 10, 0, 140)
TimerLabel.BackgroundTransparency = 1
TimerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TimerLabel.Font = Enum.Font.SourceSansBold
TimerLabel.TextScaled = true
TimerLabel.Text = "Next summon: N/A"
TimerLabel.Parent = MainFrame

-- Toggle state
local running = false
local countdown = 0

-- Function to trigger SummonRift
local function summon()
    local egg = EggDropdown.Text ~= "" and EggDropdown.Text or "Mining Egg"
    local world = WorldDropdown.Text ~= "" and WorldDropdown.Text or "Minigame Paradise"

    local args = {
        "SummonRift",
        {
            Type = "Egg",
            Time = 5, -- 5 = 30 minutes
            Name = egg,
            Luck = 5,
            World = world
        }
    }

    local remote = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("RemoteFunction")
    local success, result = pcall(function()
        return remote:InvokeServer(unpack(args))
    end)

    if success then
        print("[SummonRift] Invoked successfully for", egg)
    else
        warn("[SummonRift] Failed:", result)
    end
end

-- Toggle logic
ToggleButton.MouseButton1Click:Connect(function()
    running = not running
    ToggleButton.Text = running and "Stop Summon Rift" or "Start Summon Rift"
    ToggleButton.BackgroundColor3 = running and Color3.fromRGB(85, 255, 85) or Color3.fromRGB(255, 85, 85)
end)

-- Countdown and loop
spawn(function()
    while true do
        if running then
            if countdown <= 0 then
                summon()
                countdown = 1800 -- 30 minutes
            else
                countdown -= 1
                TimerLabel.Text = "Next summon: " .. math.floor(countdown / 60) .. "m " .. (countdown % 60) .. "s"
            end
        else
            TimerLabel.Text = "Next summon: N/A"
        end
        wait(1)
    end
end)
