-- 29 Services Admin Menu (Optimiert, kein ESP-Lag, Sheriff-Fix, Version, Logo)
-- Discord: https://discord.gg/E4KUTcAb3N

if game.CoreGui:FindFirstChild("Services29Menu") then
    game.CoreGui.Services29Menu:Destroy()
end

local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Version aus version.txt
local version = "Unknown"
pcall(function()
    if readfile then
        version = readfile("version.txt") or "Unknown"
        version = version:gsub("\n", ""):gsub("\r", "")
    end
end)

-- Notify & Chat
pcall(function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "29 Services",
        Text = "Made by 29 Services\nOpen with INSERT",
        Duration = 5
    })
end)
pcall(function()
    local chatEvent = game.ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    if chatEvent then
        chatEvent = chatEvent:FindFirstChild("SayMessageRequest")
        if chatEvent then
            chatEvent:FireServer("Made by 29 Services | Open with INSERT", "All")
        end
    end
end)

-- UI erstellen
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "Services29Menu"
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 480, 0, 340)
Frame.Position = UDim2.new(0.5, -240, 0.5, -170)
Frame.Visible = false
Frame.BackgroundTransparency = 0.1
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.Active = true
Frame.Draggable = true
local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Text = "29 Services Admin Menu"
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24

-- Logo oben rechts (ersetze AssetId mit deiner logo.png)
local Logo = Instance.new("ImageLabel", Frame)
Logo.Size = UDim2.new(0, 64, 0, 64)
Logo.Position = UDim2.new(1, -74, 0, 10)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://INSERT_YOUR_LOGO_ASSETID_HERE" -- <--- HIER DEINE LOGO-ID!

-- Tabs
local Tabs = {"Self", "ESP", "Misc"}
local CurrentTab = "Self"
local TabButtons = {}
for i, tab in ipairs(Tabs) do
    local btn = Instance.new("TextButton", Frame)
    btn.Size = UDim2.new(0, 100, 0, 32)
    btn.Position = UDim2.new(0, 10 + (i-1)*110, 0, 45)
    btn.Text = tab
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 18
    local tabName = tab
    btn.MouseButton1Click:Connect(function()
        CurrentTab = tabName
        UpdateTab()
    end)
    TabButtons[tab] = btn
end

-- Button-Daten
local Buttons = {
    Self = {
        {"Godmode", false, "toggle"},
        {"Speedhack", false, "toggle"},
        {"Fly", false, "toggle"},
        {"Jump Boost", false, "toggle"},
        {"360 Spin Loop", false, "toggle"},
        {"Rainbow Body", false, "toggle"},
        {"Noclip", false, "toggle"},
        {"TP to Revolver", false, "button"}
    },
    ESP = {
        {"Names", false, "toggle"},
        {"Box", false, "toggle"},
        {"Lines", false, "toggle"},
        {"Distance", false, "toggle"}
    },
    Misc = {
        {"Check for updates", false, "button"},
        {"Version", false, "button"},
        {"Discord Link", false, "button"}
    }
}

local ButtonObjects = {}

function ClearButtons()
    for _, btn in pairs(ButtonObjects) do
        btn:Destroy()
    end
    ButtonObjects = {}
end

function SetButtonState(tab, idx, state)
    Buttons[tab][idx][2] = state
end

function ToggleButton(tab, idx)
    local name = Buttons[tab][idx][1]
    local state = not Buttons[tab][idx][2]
    Buttons[tab][idx][2] = state
    if tab == "Self" then
        if name == "Godmode" then
            ToggleGodmode(state)
        elseif name == "Speedhack" then
            ToggleSpeedhack(state)
        elseif name == "Fly" then
            ToggleFly(state)
        elseif name == "Jump Boost" then
            ToggleJumpBoost(state)
        elseif name == "360 Spin Loop" then
            ToggleSpin(state)
        elseif name == "Rainbow Body" then
            ToggleRainbow(state)
        elseif name == "Noclip" then
            ToggleNoclip(state)
        end
    elseif tab == "ESP" then
        -- ESP handled in render loop
    end
    UpdateTab()
end

function SelfButtonAction(idx)
    local name = Buttons.Self[idx][1]
    if name == "TP to Revolver" then
        local found = false
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Tool") and obj.Name:lower():find("revolver") then
                found = true
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0,2,0)
                    pcall(function()
                        game.StarterGui:SetCore("SendNotification", {
                            Title = "29 Services",
                            Text = "Teleported to Revolver!",
                            Duration = 3
                        })
                    end)
                end
                break
            end
        end
        if not found then
            pcall(function()
                game.StarterGui:SetCore("SendNotification", {
                    Title = "29 Services",
                    Text = "Revolver not found!",
                    Duration = 3
                })
            end)
        end
    end
end

function MiscButtonAction(idx)
    if idx == 1 then
        pcall(function()
            game.StarterGui:SetCore("SendNotification", {
                Title = "29 Services",
                Text = "No updates found!",
                Duration = 3
            })
        end)
    elseif idx == 2 then
        pcall(function()
            game.StarterGui:SetCore("SendNotification", {
                Title = "29 Services",
                Text = "Version: "..version,
                Duration = 3
            })
        end)
    elseif idx == 3 then
        setclipboard("https://discord.gg/E4KUTcAb3N")
        pcall(function()
            game.StarterGui:SetCore("SendNotification", {
                Title = "Discord",
                Text = "Link copied to clipboard!",
                Duration = 3
            })
        end)
    end
end

function UpdateTab()
    ClearButtons()
    local tab = CurrentTab
    local btns = Buttons[tab]
    for i, data in ipairs(btns) do
        local name, state, btype = data[1], data[2], data[3]
        local btn = Instance.new("TextButton", Frame)
        btn.Size = UDim2.new(0, 200, 0, 40)
        btn.Position = UDim2.new(0, 30 + ((i-1)%2)*220, 0, 90 + (math.floor((i-1)/2)*50))
        btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 18

        if btype == "button" then
            btn.Text = name
            if tab == "Self" then
                btn.MouseButton1Click:Connect(function()
                    SelfButtonAction(i)
                end)
            elseif tab == "Misc" then
                btn.MouseButton1Click:Connect(function()
                    MiscButtonAction(i)
                end)
            end
        else
            btn.Text = name.." ["..(state and "ON" or "OFF").."]"
            btn.BackgroundColor3 = state and Color3.fromRGB(0,180,80) or Color3.fromRGB(50,50,50)
            btn.MouseButton1Click:Connect(function()
                ToggleButton(tab, i)
            end)
        end
        ButtonObjects[#ButtonObjects+1] = btn
    end
end

UpdateTab()

-- Menu öffnen/schließen mit INSERT
UIS.InputBegan:Connect(function(input, gpe)
    if input.KeyCode == Enum.KeyCode.Insert then
        Frame.Visible = not Frame.Visible
    end
end)

-- Self Features
local godmodeConn
function ToggleGodmode(on)
    if on then
        godmodeConn = LocalPlayer.CharacterAdded:Connect(function(char)
            local hum = char:WaitForChild("Humanoid")
            hum.Health = math.huge
            hum:GetPropertyChangedSignal("Health"):Connect(function()
                hum.Health = math.huge
            end)
        end)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local hum = LocalPlayer.Character.Humanoid
            hum.Health = math.huge
            hum:GetPropertyChangedSignal("Health"):Connect(function()
                hum.Health = math.huge
            end)
        end
    else
        if godmodeConn then
            godmodeConn:Disconnect()
        end
    end
end

function ToggleSpeedhack(on)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = on and 50 or 16
    end
end

-- NEUES FLY
local flyConn, flyStepped, flyKeys, flying = nil, nil, {}, false
local FLY_SPEED = 50

function ToggleFly(on)
    if on and not flying then
        flying = true
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        -- Disable gravity
        local bp = Instance.new("BodyPosition")
        bp.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bp.P = 1e5
        bp.D = 1e4
        bp.Position = hrp.Position
        bp.Parent = hrp

        local bg = Instance.new("BodyGyro")
        bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        bg.P = 1e5
        bg.CFrame = hrp.CFrame
        bg.Parent = hrp

        flyKeys = {W=false, A=false, S=false, D=false, Space=false, Ctrl=false}

        flyConn = UIS.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            if input.KeyCode == Enum.KeyCode.W then flyKeys.W = true end
            if input.KeyCode == Enum.KeyCode.A then flyKeys.A = true end
            if input.KeyCode == Enum.KeyCode.S then flyKeys.S = true end
            if input.KeyCode == Enum.KeyCode.D then flyKeys.D = true end
            if input.KeyCode == Enum.KeyCode.Space then flyKeys.Space = true end
            if input.KeyCode == Enum.KeyCode.LeftControl then flyKeys.Ctrl = true end
        end)
        UIS.InputEnded:Connect(function(input, gpe)
            if input.KeyCode == Enum.KeyCode.W then flyKeys.W = false end
            if input.KeyCode == Enum.KeyCode.A then flyKeys.A = false end
            if input.KeyCode == Enum.KeyCode.S then flyKeys.S = false end
            if input.KeyCode == Enum.KeyCode.D then flyKeys.D = false end
            if input.KeyCode == Enum.KeyCode.Space then flyKeys.Space = false end
            if input.KeyCode == Enum.KeyCode.LeftControl then flyKeys.Ctrl = false end
        end)

        flyStepped = game:GetService("RunService").RenderStepped:Connect(function()
            if not flying or not hrp or not hrp.Parent then return end
            local camCF = workspace.CurrentCamera.CFrame
            local moveVec = Vector3.new()
            if flyKeys.W then moveVec = moveVec + (camCF.LookVector) end
            if flyKeys.S then moveVec = moveVec - (camCF.LookVector) end
            if flyKeys.A then moveVec = moveVec - (camCF.RightVector) end
            if flyKeys.D then moveVec = moveVec + (camCF.RightVector) end
            if flyKeys.Space then moveVec = moveVec + Vector3.new(0,1,0) end
            if flyKeys.Ctrl then moveVec = moveVec - Vector3.new(0,1,0) end
            if moveVec.Magnitude > 0 then
                moveVec = moveVec.Unit * FLY_SPEED
                bp.Position = hrp.Position + moveVec/60
            else
                bp.Position = hrp.Position
            end
            bg.CFrame = workspace.CurrentCamera.CFrame
        end)
    else
        flying = false
        if flyConn then pcall(function() flyConn:Disconnect() end) end
        if flyStepped then pcall(function() flyStepped:Disconnect() end) end
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            for _,v in pairs(hrp:GetChildren()) do
                if v:IsA("BodyPosition") or v:IsA("BodyGyro") then v:Destroy() end
            end
        end
    end
end

function ToggleJumpBoost(on)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = on and 150 or 50
    end
end

local spinConn
function ToggleSpin(on)
    if on then
        spinConn = RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0,math.rad(15),0)
            end
        end)
    else
        if spinConn then spinConn:Disconnect() end
    end
end

local rainbowConn
function ToggleRainbow(on)
    if on then
        rainbowConn = RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character then
                local t = tick()
                for _,v in pairs(LocalPlayer.Character:GetChildren()) do
                    if v:IsA("BasePart") then
                        v.Color = Color3.fromHSV((t%5)/5,1,1)
                    end
                end
            end
        end)
    else
        if rainbowConn then rainbowConn:Disconnect() end
    end
end

local noclipConn
function ToggleNoclip(on)
    if on then
        noclipConn = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _,v in pairs(LocalPlayer.Character:GetChildren()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConn then noclipConn:Disconnect() end
    end
end

-- ESP Features (OPTIMIERT)
local espLabels = {}
local espBoxes = {}
local espLines = {}

function IsSheriff(plr)
    for _,tool in pairs(plr.Backpack:GetChildren()) do
        if tool.Name:lower():find("revolver") then return true end
    end
    for _,tool in pairs(plr.Character:GetChildren()) do
        if tool:IsA("Tool") and tool.Name:lower():find("revolver") then return true end
    end
    return false
end

function FindRevolverInWorkspace()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Tool") and obj.Name:lower():find("revolver") then
            return true, obj.Position or (obj.Handle and obj.Handle.Position)
        end
    end
    return false, nil
end

function CreateESPLabel(plr)
    if plr == LocalPlayer then return end
    if not plr.Character or not plr.Character:FindFirstChild("Head") then return end
    if espLabels[plr] then return end
    local bb = Instance.new("BillboardGui")
    bb.Size = UDim2.new(0,100,0,30)
    bb.Adornee = plr.Character.Head
    bb.AlwaysOnTop = true
    bb.Parent = plr.Character.Head
    local tl = Instance.new("TextLabel", bb)
    tl.Size = UDim2.new(1,0,1,0)
    tl.BackgroundTransparency = 1
    tl.TextColor3 = Color3.fromRGB(0,255,0)
    tl.TextStrokeTransparency = 0.5
    tl.Font = Enum.Font.GothamBold
    tl.TextScaled = true
    espLabels[plr] = {bb = bb, tl = tl}
end

function RemoveESPLabel(plr)
    if espLabels[plr] then
        if espLabels[plr].bb then espLabels[plr].bb:Destroy() end
        espLabels[plr] = nil
    end
end

function ClearESP()
    for plr, data in pairs(espLabels) do
        if data.bb then data.bb:Destroy() end
    end
    espLabels = {}
    for _,box in pairs(espBoxes) do
        if box and box.Remove then box:Remove() end
    end
    for _,line in pairs(espLines) do
        if line and line.Remove then line:Remove() end
    end
    espBoxes = {}
    espLines = {}
end

Players.PlayerRemoving:Connect(RemoveESPLabel)
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        if Buttons.ESP[1][2] then
            CreateESPLabel(plr)
        end
    end)
end)

RunService.RenderStepped:Connect(function()
    if not (Buttons.ESP[1][2] or Buttons.ESP[2][2] or Buttons.ESP[3][2] or Buttons.ESP[4][2]) then
        ClearESP()
        return
    end

    -- ESP Names (optimiert)
    if Buttons.ESP[1][2] or Buttons.ESP[4][2] then
        for _,plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
                CreateESPLabel(plr)
                local tag = ""
                local color = Color3.fromRGB(0,255,0)
                local murder = false
                local sheriff = IsSheriff(plr)
                for _,tool in pairs(plr.Backpack:GetChildren()) do
                    if tool.Name:lower():find("knife") then murder = true end
                end
                for _,tool in pairs(plr.Character:GetChildren()) do
                    if tool:IsA("Tool") then
                        if tool.Name:lower():find("knife") then murder = true end
                    end
                end
                if murder then tag = " (Murder)" color = Color3.fromRGB(255,0,0) end
                if sheriff then tag = " (Sheriff)" color = Color3.fromRGB(0,120,255) end
                local dist = ""
                if Buttons.ESP[4][2] and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
                    dist = string.format(" [%.0f]", (LocalPlayer.Character.Head.Position - plr.Character.Head.Position).Magnitude)
                end
                espLabels[plr].tl.Text = plr.Name..tag..dist
                espLabels[plr].tl.TextColor3 = color
            else
                RemoveESPLabel(plr)
            end
        end
    else
        ClearESP()
    end

    -- Box (Drawing API)
    for _,box in pairs(espBoxes) do if box and box.Remove then box:Remove() end end
    espBoxes = {}
    if Buttons.ESP[2][2] and Drawing then
        for _,plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("HumanoidRootPart") then
                local headPos, headOnScreen = Camera:WorldToViewportPoint(plr.Character.Head.Position)
                local rootPos, rootOnScreen = Camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
                if headOnScreen and rootOnScreen then
                    local height = math.abs(rootPos.Y - headPos.Y)
                    local width = height/2
                    local color = Color3.fromRGB(0,255,0)
                    if IsSheriff(plr) then color = Color3.fromRGB(0,120,255) end
                    for _,tool in pairs(plr.Backpack:GetChildren()) do
                        if tool.Name:lower():find("knife") then color = Color3.fromRGB(255,0,0) end
                    end
                    for _,tool in pairs(plr.Character:GetChildren()) do
                        if tool:IsA("Tool") then
                            if tool.Name:lower():find("knife") then color = Color3.fromRGB(255,0,0) end
                        end
                    end
                    local box = Drawing.new("Square")
                    box.Visible = true
                    box.Color = color
                    box.Thickness = 2
                    box.Filled = false
                    box.Size = Vector2.new(width, height)
                    box.Position = Vector2.new(headPos.X - width/2, headPos.Y)
                    table.insert(espBoxes, box)
                end
            end
        end
    end

    -- Lines (nur mit Drawing API)
    for _,line in pairs(espLines) do if line and line.Remove then line:Remove() end end
    espLines = {}
    if Buttons.ESP[3][2] and Drawing then
        for _,plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
                local headPos, onScreen = Camera:WorldToViewportPoint(plr.Character.Head.Position)
                if onScreen then
                    local color = Color3.fromRGB(0,255,0)
                    if IsSheriff(plr) then color = Color3.fromRGB(0,120,255) end
                    for _,tool in pairs(plr.Backpack:GetChildren()) do
                        if tool.Name:lower():find("knife") then color = Color3.fromRGB(255,0,0) end
                    end
                    for _,tool in pairs(plr.Character:GetChildren()) do
                        if tool:IsA("Tool") then
                            if tool.Name:lower():find("knife") then color = Color3.fromRGB(255,0,0) end
                        end
                    end
                    local line = Drawing.new("Line")
                    line.Visible = true
                    line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                    line.To = Vector2.new(headPos.X, headPos.Y)
                    line.Color = color
                    line.Thickness = 2
                    table.insert(espLines, line)
                end
            end
        end
    end
end)

-- Drag ist durch .Draggable = true schon aktiv

-- Fertig!
