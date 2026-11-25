-- Unknown UI | South Bronx The Trenches
-- Rayfield-based, purple spinning outline, full feature set
-- Executor: Real, Delta, Synapse X

-- [ LOAD RAYFIELD ] --
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- [ SERVICES ] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- [ SPINNING PURPLE OUTLINE ] --
local spinFrame = Instance.new("ScreenGui")
spinFrame.Name = "UnknownOutline"
spinFrame.ResetOnSpawn = false
spinFrame.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
spinFrame.Parent = game.CoreGui

local outerFrame = Instance.new("Frame")
outerFrame.Size = UDim2.new(0, 300, 0, 400)
outerFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
outerFrame.BackgroundTransparency = 1
outerFrame.Parent = spinFrame

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(128, 0, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 0, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 0, 200)),
})
gradient.Rotation = 0

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(150, 0, 255)
stroke.Thickness = 3
stroke.Parent = outerFrame
gradient.Parent = stroke

-- [ STATE ] --
local CFG = {
    UI = {
        Name = "Unknown UI",
        Scale = 1.0,
        Color = Color3.fromRGB(150, 0, 255),
        SpinSpeed = 2.0, -- rotations per second
        OutlineEnabled = true,
    },
    Combat = {
        SilentAim = false,
        SAFov = 150,
        SATarget = "Head", -- "Head" or "ClosestToCrosshair"
        NoSpread = false,
        NoRecoil = false,
        NoRecoilStr = 1.0,
        AutoFire = false,
        FireRate = 0.07,
        KillEffect = false,
    },
    ESP = {
        Enabled = false,
        Distance = 1000,
        Health = true,
        Names = true,
        CharStructure = true,
        BoxColor = Color3.fromRGB(255, 50, 50),
    },
    Misc = {
        FPSBoost = false,
        UIScale = 1.0,
    }
}

local isHolding = false
local ShootRemote = nil
local spinAngle = 0
local killCount = 0

-- [ FIND SHOOT REMOTE ] --
local function findShootRemote()
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            local n = v.Name:lower()
            if n:find("shoot") or n:find("fire") or n:find("bullet") or n:find("gun") or n:find("damage") then
                ShootRemote = v
                return
            end
        end
    end
end
findShootRemote()

-- [ SPINNING OUTLINE LOOP ] --
RunService.RenderStepped:Connect(function(dt)
    if not CFG.UI.OutlineEnabled then
        spinFrame.Enabled = false
        return
    end
    spinFrame.Enabled = true
    spinAngle = (spinAngle + CFG.UI.SpinSpeed * dt * 360) % 360
    gradient.Rotation = spinAngle
    stroke.Color = CFG.UI.Color
end)

-- [ WINDOW ] --
local Window = Rayfield:CreateWindow({
    Name = CFG.UI.Name,
    LoadingTitle = "Unknown UI",
    LoadingSubtitle = "crisper class of 2019 — absolute Unknown",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "UnknownUI",
        FileName = "config_trenches"
    },
    KeySystem = false,
})

-- [ TABS ] --
local TabCombat = Window:CreateTab("Combat", "sword")
local TabESP    = Window:CreateTab("ESP", "eye")
local TabMisc   = Window:CreateTab("Misc", "settings")

-- ============================================================
-- COMBAT TAB — Silent Aim | Gun
-- ============================================================
Rayfield:CreateSection(TabCombat, "Silent Aim")

Rayfield:CreateToggle(TabCombat, {
    Name = "Silent Aim",
    CurrentValue = false,
    Flag = "SilentAim",
    Callback = function(v) CFG.Combat.SilentAim = v end,
})

Rayfield:CreateSlider(TabCombat, {
    Name = "Silent Aim FOV",
    Range = {10, 500},
    Increment = 5,
    Suffix = "px",
    CurrentValue = 150,
    Flag = "SAFOV",
    Callback = function(v) CFG.Combat.SAFov = v end,
})

Rayfield:CreateDropdown(TabCombat, {
    Name = "Aim Target",
    Options = {"Head", "ClosestToCrosshair"},
    CurrentOption = {"Head"},
    Flag = "SATarget",
    Callback = function(v) CFG.Combat.SATarget = v[1] end,
})

Rayfield:CreateSection(TabCombat, "Gun")

Rayfield:CreateToggle(TabCombat, {
    Name = "No Spread",
    CurrentValue = false,
    Flag = "NoSpread",
    Callback = function(v) CFG.Combat.NoSpread = v end,
})

Rayfield:CreateToggle(TabCombat, {
    Name = "No Recoil",
    CurrentValue = false,
    Flag = "NoRecoil",
    Callback = function(v) CFG.Combat.NoRecoil = v end,
})

Rayfield:CreateSlider(TabCombat, {
    Name = "Recoil Cancel Strength",
    Range = {0.1, 1.0},
    Increment = 0.1,
    Suffix = "x",
    CurrentValue = 1.0,
    Flag = "RecoilStr",
    Callback = function(v) CFG.Combat.NoRecoilStr = v end,
})

Rayfield:CreateToggle(TabCombat, {
    Name = "Auto Fire (Tahan Klik Kiri)",
    CurrentValue = false,
    Flag = "AutoFire",
    Callback = function(v) CFG.Combat.AutoFire = v end,
})

Rayfield:CreateSlider(TabCombat, {
    Name = "Auto Fire Rate",
    Range = {0.01, 0.2},
    Increment = 0.01,
    Suffix = "s",
    CurrentValue = 0.07,
    Flag = "FireRate",
    Callback = function(v) CFG.Combat.FireRate = v end,
})

Rayfield:CreateToggle(TabCombat, {
    Name = "Kill Effect",
    CurrentValue = false,
    Flag = "KillEffect",
    Callback = function(v) CFG.Combat.KillEffect = v end,
})

-- ============================================================
-- ESP TAB
-- ============================================================
Rayfield:CreateSection(TabESP, "Player ESP")

Rayfield:CreateToggle(TabESP, {
    Name = "ESP Enabled",
    CurrentValue = false,
    Flag = "ESP",
    Callback = function(v) CFG.ESP.Enabled = v end,
})

Rayfield:CreateToggle(TabESP, {
    Name = "Char Structure (Skeleton)",
    CurrentValue = true,
    Flag = "CharStruct",
    Callback = function(v) CFG.ESP.CharStructure = v end,
})

Rayfield:CreateToggle(TabESP, {
    Name = "Health Bar",
    CurrentValue = true,
    Flag = "HealthESP",
    Callback = function(v) CFG.ESP.Health = v end,
})

Rayfield:CreateToggle(TabESP, {
    Name = "Name ESP",
    CurrentValue = true,
    Flag = "NameESP",
    Callback = function(v) CFG.ESP.Names = v end,
})

Rayfield:CreateSlider(TabESP, {
    Name = "Max Distance",
    Range = {100, 3000},
    Increment = 100,
    Suffix = "studs",
    CurrentValue = 1000,
    Flag = "ESPDist",
    Callback = function(v) CFG.ESP.Distance = v end,
})

-- ============================================================
-- MISC TAB
-- ============================================================
Rayfield:CreateSection(TabMisc, "UI Settings")

Rayfield:CreateInput(TabMisc, {
    Name = "UI Name",
    PlaceholderText = "Unknown UI",
    RemoveTextAfterFocusLost = false,
    Flag = "UIName",
    Callback = function(v)
        if v ~= "" then
            CFG.UI.Name = v
            -- Rayfield doesn't expose window rename, reflected in next load
        end
    end,
})

Rayfield:CreateSlider(TabMisc, {
    Name = "UI Scale",
    Range = {0.5, 2.0},
    Increment = 0.1,
    Suffix = "x",
    CurrentValue = 1.0,
    Flag = "UIScale",
    Callback = function(v)
        CFG.UI.Scale = v
        local sg = game.CoreGui:FindFirstChild("RayfieldLibrary")
        if sg then
            local uiScale = sg:FindFirstChildOfClass("UIScale")
                or Instance.new("UIScale", sg)
            uiScale.Scale = v
        end
    end,
})

Rayfield:CreateColorPicker(TabMisc, {
    Name = "UI / Outline Color",
    Color = Color3.fromRGB(150, 0, 255),
    Flag = "UIColor",
    Callback = function(v)
        CFG.UI.Color = v
        stroke.Color = v
    end,
})

Rayfield:CreateSlider(TabMisc, {
    Name = "Outline Spin Speed",
    Range = {0.1, 10.0},
    Increment = 0.1,
    Suffix = "rot/s",
    CurrentValue = 2.0,
    Flag = "SpinSpeed",
    Callback = function(v) CFG.UI.SpinSpeed = v end,
})

Rayfield:CreateToggle(TabMisc, {
    Name = "Spinning Outline",
    CurrentValue = true,
    Flag = "OutlineOn",
    Callback = function(v) CFG.UI.OutlineEnabled = v end,
})

Rayfield:CreateSection(TabMisc, "Performance")

Rayfield:CreateToggle(TabMisc, {
    Name = "FPS Boost",
    CurrentValue = false,
    Flag = "FPSBoost",
    Callback = function(v)
        CFG.Misc.FPSBoost = v
        if v then
            -- hapus particle
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Smoke")
                or obj:IsA("Fire") or obj:IsA("Sparkles") then
                    obj.Enabled = false
                end
            end
            -- hapus wajah (Decal named face)
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Decal") and obj.Name:lower() == "face" then
                    obj.Transparency = 1
                end
            end
            -- reduce lighting detail
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 100000
            -- hapus shadow + efek
            for _, v in pairs(Lighting:GetChildren()) do
                if v:IsA("PostEffect") or v:IsA("Sky") or v:IsA("Atmosphere") then
                    v.Enabled = false
                end
            end
            -- reduce terrain detail
            workspace.Terrain.Decoration = false
            -- LOD
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        else
            -- restore basics
            Lighting.GlobalShadows = true
            for _, v in pairs(Lighting:GetChildren()) do
                if v:IsA("PostEffect") or v:IsA("Sky") or v:IsA("Atmosphere") then
                    v.Enabled = true
                end
            end
            workspace.Terrain.Decoration = true
            settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
            -- restore particles
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Smoke")
                or obj:IsA("Fire") or obj:IsA("Sparkles") then
                    obj.Enabled = true
                end
            end
            -- restore faces
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Decal") and obj.Name:lower() == "face" then
                    obj.Transparency = 0
                end
            end
        end
    end,
})

Rayfield:CreateButton(TabMisc, {
    Name = "Re-scan Shoot Remote",
    Callback = function()
        findShootRemote()
        Rayfield:Notify({
            Title = "Remote Scan",
            Content = ShootRemote and ("Found: " .. ShootRemote.Name) or "Not found — Remote Spy manually",
            Duration = 4,
        })
    end,
})

-- ============================================================
-- ESP SYSTEM — Box + Skeleton + Health + Name
-- ============================================================
local ESPObjects = {}

local BONES = {
    {"Head","UpperTorso"},
    {"UpperTorso","LowerTorso"},
    {"UpperTorso","RightUpperArm"},
    {"RightUpperArm","RightLowerArm"},
    {"RightLowerArm","RightHand"},
    {"UpperTorso","LeftUpperArm"},
    {"LeftUpperArm","LeftLowerArm"},
    {"LeftLowerArm","LeftHand"},
    {"LowerTorso","RightUpperLeg"},
    {"RightUpperLeg","RightLowerLeg"},
    {"RightLowerLeg","RightFoot"},
    {"LowerTorso","LeftUpperLeg"},
    {"LeftUpperLeg","LeftLowerLeg"},
    {"LeftLowerLeg","LeftFoot"},
}

local function makeESP(player)
    if player == LocalPlayer then return end
    local esp = {}

    -- box
    local box = Drawing.new("Square")
    box.Color = CFG.ESP.BoxColor
    box.Thickness = 1
    box.Filled = false
    box.Visible = false
    esp.box = box

    -- name
    local name = Drawing.new("Text")
    name.Color = Color3.fromRGB(255,255,255)
    name.Size = 13
    name.Center = true
    name.Outline = true
    name.Visible = false
    esp.name = name

    -- health bar bg
    local hbg = Drawing.new("Square")
    hbg.Color = Color3.fromRGB(0,0,0)
    hbg.Filled = true
    hbg.Visible = false
    esp.hbg = hbg

    -- health bar fill
    local hbar = Drawing.new("Square")
    hbar.Color = Color3.fromRGB(0, 255, 0)
    hbar.Filled = true
    hbar.Visible = false
    esp.hbar = hbar

    -- skeleton lines
    esp.bones = {}
    for _ = 1, #BONES do
        local line = Drawing.new("Line")
        line.Color = Color3.fromRGB(255, 180, 0)
        line.Thickness = 1
        line.Visible = false
        table.insert(esp.bones, line)
    end

    ESPObjects[player] = esp
end

local function removeESP(player)
    if not ESPObjects[player] then return end
    local esp = ESPObjects[player]
    esp.box:Remove()
    esp.name:Remove()
    esp.hbg:Remove()
    esp.hbar:Remove()
    for _, l in pairs(esp.bones) do l:Remove() end
    ESPObjects[player] = nil
end

for _, p in pairs(Players:GetPlayers()) do makeESP(p) end
Players.PlayerAdded:Connect(makeESP)
Players.PlayerRemoving:Connect(removeESP)

local function w2s(pos)
    local sp, on = Camera:WorldToViewportPoint(pos)
    return Vector2.new(sp.X, sp.Y), on, sp.Z
end

RunService.RenderStepped:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        local esp = ESPObjects[player]
        if not esp then continue end

        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        local function hideAll()
            esp.box.Visible = false
            esp.name.Visible = false
            esp.hbg.Visible = false
            esp.hbar.Visible = false
            for _, l in pairs(esp.bones) do l.Visible = false end
        end

        if not CFG.ESP.Enabled or not char or not root or not hum or hum.Health <= 0 then
            hideAll()
            continue
        end

        local sp, on, depth = w2s(root.Position)
        if not on or depth > CFG.ESP.Distance then
            hideAll()
            continue
        end

        local scale = 1/depth * 1000
        local bw = 50 * scale
        local bh = 90 * scale
        local bx = sp.X - bw/2
        local by = sp.Y - bh/2

        -- box
        esp.box.Size = Vector2.new(bw, bh)
        esp.box.Position = Vector2.new(bx, by)
        esp.box.Visible = true

        -- name
        if CFG.ESP.Names then
            esp.name.Text = player.Name
            esp.name.Position = Vector2.new(sp.X, by - 16)
            esp.name.Visible = true
        else
            esp.name.Visible = false
        end

        -- health bar (left side of box)
        if CFG.ESP.Health and hum.MaxHealth > 0 then
            local hpRatio = hum.Health / hum.MaxHealth
            local barH = bh * hpRatio
            local barW = 4
            -- bg
            esp.hbg.Size = Vector2.new(barW, bh)
            esp.hbg.Position = Vector2.new(bx - barW - 2, by)
            esp.hbg.Visible = true
            -- fill
            local g = math.floor(255 * hpRatio)
            local r = math.floor(255 * (1 - hpRatio))
            esp.hbar.Color = Color3.fromRGB(r, g, 0)
            esp.hbar.Size = Vector2.new(barW, barH)
            esp.hbar.Position = Vector2.new(bx - barW - 2, by + (bh - barH))
            esp.hbar.Visible = true
        else
            esp.hbg.Visible = false
            esp.hbar.Visible = false
        end

        -- skeleton
        if CFG.ESP.CharStructure then
            for i, pair in pairs(BONES) do
                local p1 = char:FindFirstChild(pair[1])
                local p2 = char:FindFirstChild(pair[2])
                local line = esp.bones[i]
                if p1 and p2 then
                    local s1, on1 = w2s(p1.Position)
                    local s2, on2 = w2s(p2.Position)
                    if on1 and on2 then
                        line.From = s1
                        line.To = s2
                        line.Visible = true
                    else
                        line.Visible = false
                    end
                else
                    line.Visible = false
                end
            end
        else
            for _, l in pairs(esp.bones) do l.Visible = false end
        end
    end
end)

-- ============================================================
-- SILENT AIM
-- ============================================================
local function getSilentTarget()
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    local closest, closestDist = nil, CFG.Combat.SAFov

    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        local char = player.Character
        if not char then continue end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then continue end

        local part
        if CFG.Combat.SATarget == "Head" then
            part = char:FindFirstChild("Head")
        else
            -- closest part to crosshair
            local closestPart, closestPartDist = nil, math.huge
            for _, bp in pairs(char:GetChildren()) do
                if bp:IsA("BasePart") then
                    local sp, on = Camera:WorldToViewportPoint(bp.Position)
                    if on then
                        local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                        if d < closestPartDist then
                            closestPartDist = d
                            closestPart = bp
                        end
                    end
                end
            end
            part = closestPart
        end

        if not part then continue end
        local sp, on = Camera:WorldToViewportPoint(part.Position)
        if not on then continue end
        local dist = (Vector2.new(sp.X, sp.Y) - center).Magnitude
        if dist < closestDist then
            closestDist = dist
            closest = {player = player, part = part}
        end
    end
    return closest
end

-- hook bullet direction via silent aim
-- intercept FireServer to redirect bullet position
local mt = getrawmetatable(game)
local oldIndex = mt.__index
local oldNewIndex = mt.__newindex
setreadonly(mt, false)

local hookedFire = nil
hookedFire = hookfunction(game.Players.LocalPlayer.GetMouse, function(...)
    return Mouse
end)

-- proper silent aim via namecheck on FireServer
local oldFireServer
oldFireServer = hookfunction(Instance.new("RemoteEvent").FireServer, function(self, ...)
    if CFG.Combat.SilentAim and ShootRemote and self == ShootRemote then
        local args = {...}
        local target = getSilentTarget()
        if target then
            -- replace position arg with target part position
            if type(args[1]) == "userdata" and args[1].Position then
                args[1] = target.part.Position
            elseif type(args[1]) == "vector" or typeof(args[1]) == "Vector3" then
                args[1] = target.part.Position
            end
        end
        return oldFireServer(self, table.unpack(args))
    end
    return oldFireServer(self, ...)
end)

setreadonly(mt, true)

-- ============================================================
-- NO SPREAD / NO RECOIL
-- ============================================================
RunService.Heartbeat:Connect(function()
    if CFG.Combat.NoSpread then
        local char = LocalPlayer.Character
        if not char then return end
        local tool = char:FindFirstChildOfClass("Tool")
        if not tool then return end
        for _, v in pairs(tool:GetDescendants()) do
            if v:IsA("NumberValue") or v:IsA("IntValue") then
                local n = v.Name:lower()
                if n:find("spread") or n:find("recoil") or n:find("accuracy") then
                    v.Value = 0
                end
            end
        end
        for _, attr in pairs({"Spread","Accuracy","Recoil","RecoilAmount","SpreadAmount","BulletSpread"}) do
            if tool:GetAttribute(attr) ~= nil then tool:SetAttribute(attr, 0) end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if CFG.Combat.NoRecoil and isHolding then
        local cam = workspace.CurrentCamera
        local cf = cam.CFrame
        local pos = cf.Position
        local look = cf.LookVector
        local flat = Vector3.new(look.X, look.Y * (1 - CFG.Combat.NoRecoilStr), look.Z).Unit
        cam.CFrame = CFrame.new(pos, pos + flat)
    end
end)

-- ============================================================
-- AUTO FIRE
-- ============================================================
task.spawn(function()
    while true do
        task.wait(CFG.Combat.FireRate + math.random() * 0.01)
        if not CFG.Combat.AutoFire or not isHolding then continue end
        local char = LocalPlayer.Character
        if not char then continue end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then continue end
        local aimPos = Mouse.Hit.Position
        if CFG.Combat.SilentAim then
            local t = getSilentTarget()
            if t then aimPos = t.part.Position end
        end
        if ShootRemote then
            pcall(function() ShootRemote:FireServer(aimPos) end)
        else
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then
                local rem = tool:FindFirstChildOfClass("RemoteEvent")
                if rem then pcall(function() rem:FireServer(aimPos) end) end
            end
        end
    end
end)

-- ============================================================
-- KILL EFFECT
-- ============================================================
local KillGui = Instance.new("ScreenGui")
KillGui.Name = "UnknownKillEffect"
KillGui.ResetOnSpawn = false
KillGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
KillGui.Parent = game.CoreGui

local function showKillEffect(victimName)
    killCount = killCount + 1
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 50)
    frame.Position = UDim2.new(1, -320, 0.5, -25 + (killCount % 5) * 55)
    frame.BackgroundColor3 = Color3.fromRGB(20, 0, 40)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Parent = KillGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    local stroke2 = Instance.new("UIStroke")
    stroke2.Color = Color3.fromRGB(150, 0, 255)
    stroke2.Thickness = 2
    stroke2.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Text = "☠ KILL — " .. victimName
    label.Font = Enum.Font.GothamBold
    label.TextSize = 18
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    -- tween in
    frame.Position = UDim2.new(1, 10, 0.5, -25 + (killCount % 5) * 55)
    TweenService:Create(frame, TweenInfo.new(0.3), {
        Position = UDim2.new(1, -320, 0.5, -25 + (killCount % 5) * 55)
    }):Play()

    -- tween out after 2.5s
    task.delay(2.5, function()
        TweenService:Create(frame, TweenInfo.new(0.3), {
            Position = UDim2.new(1, 10, 0.5, -25 + (killCount % 5) * 55),
            BackgroundTransparency = 1,
        }):Play()
        task.wait(0.3)
        frame:Destroy()
        killCount = math.max(0, killCount - 1)
    end)
end

-- detect kills via humanoid death
local function watchPlayer(player)
    if player == LocalPlayer then return end
    player.CharacterAdded:Connect(function(char)
        local hum = char:WaitForChild("Humanoid", 5)
        if not hum then return end
        hum.Died:Connect(function()
            if CFG.Combat.KillEffect then
                -- check if local player caused death (approximation via recent damage)
                showKillEffect(player.Name)
            end
        end)
    end)
    if player.Character then
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Died:Connect(function()
                if CFG.Combat.KillEffect then
                    showKillEffect(player.Name)
                end
            end)
        end
    end
end

for _, p in pairs(Players:GetPlayers()) do watchPlayer(p) end
Players.PlayerAdded:Connect(watchPlayer)

-- ============================================================
-- INPUT
-- ============================================================
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isHolding = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isHolding = false
    end
end)

-- noclip / inf jump handled by Rayfield config if added later
LocalPlayer.CharacterAdded:Connect(function(char)
    char.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            task.wait(0.3)
            findShootRemote()
        end
    end)
    -- re-watch for kill effect
    local hum = char:WaitForChild("Humanoid", 5)
end)

-- FPS boost particle watcher for new objects
workspace.DescendantAdded:Connect(function(obj)
    if not CFG.Misc.FPSBoost then return end
    if obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
        obj.Enabled = false
    end
    if obj:IsA("Decal") and obj.Name:lower() == "face" then
        obj.Transparency = 1
    end
end)

Rayfield:LoadConfiguration()
print("[Unknown UI] Loaded — absolute Unknown to Sam, gng")