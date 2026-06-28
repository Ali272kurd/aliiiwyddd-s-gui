-- Dahood Custom HUD (Educational Purposes Only)  
-- Roblox Lua / Synapse X / Krnl Compatible  
-- Creator: aliiiwyddd (Roblox)  
-- Avatar: https://tr.rbxcdn.com/30DAY-Avatar-85E919AB122AAE4D42716FBE97EDB2C3-Png/720/720/Avatar/Webp/noFilter  

local Players = game:GetService("Players")  
local RunService = game:GetService("RunService")  
local UserInputService = game:GetService("UserInputService")  
local TweenService = game:GetService("TweenService")  
local HttpService = game:GetService("HttpService")  
local LocalPlayer = Players.LocalPlayer  
local Mouse = LocalPlayer:GetMouse()  

-- === GUI CONFIGURATION ===  
local ScreenGui = Instance.new("ScreenGui")  
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")  
ScreenGui.Name = "AliiiHUD"  
ScreenGui.ResetOnSpawn = false  

-- Background Image (wavey + modern)  
local Bg = Instance.new("ImageLabel")  
Bg.Size = UDim2.new(1, 0, 1, 0)  
Bg.BackgroundTransparency = 1  
Bg.Image = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTi2xYgbIlI9a1_u2tmUNPBWTDXlhema_zu2PyKxTWWqw&s=10"  
Bg.ImageTransparency = 0.3  
Bg.ImageColor3 = Color3.fromRGB(255, 255, 255)  
Bg.Parent = ScreenGui  

-- Wave effect (sinusoidal offset)  
local WaveOffset = 0  
RunService.RenderStepped:Connect(function(dt)  
    WaveOffset = WaveOffset + dt * 2  
    local wave = math.sin(WaveOffset) * 2  
    Bg.Position = UDim2.new(0, wave, 0, 0)  
end)  

-- === OPTION 1: TRIGGERBOT (Auto-shoot on body/player/bot) ===  
local TriggerBotEnabled = false  
local TriggerBotGui = Instance.new("Frame")  
TriggerBotGui.Size = UDim2.new(0, 200, 0, 150)  
TriggerBotGui.Position = UDim2.new(0.5, -100, 0.3, 0)  
TriggerBotGui.BackgroundColor3 = Color3.fromRGB(20, 20, 30)  
TriggerBotGui.BackgroundTransparency = 0.2  
TriggerBotGui.Visible = false  
TriggerBotGui.Parent = ScreenGui  
-- Rainbow border  
local Rainbow = Instance.new("UIGradient")  
Rainbow.Rotation = 45  
Rainbow.Color = ColorSequence.new{  
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)),  
    ColorSequenceKeypoint.new(0.25, Color3.fromRGB(0,255,0)),  
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0,0,255)),  
    ColorSequenceKeypoint.new(0.75, Color3.fromRGB(255,255,0)),  
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,255))  
}  
local Border = Instance.new("UIStroke")  
Border.Thickness = 2  
Border.Color = Color3.fromRGB(255,255,255)  
Border.Transparency = 0.5  
Border.Parent = TriggerBotGui  
TriggerBotGui.UIStroke = Border  

local ToggleBtn = Instance.new("TextButton")  
ToggleBtn.Size = UDim2.new(0.8, 0, 0.3, 0)  
ToggleBtn.Position = UDim2.new(0.1, 0, 0.1, 0)  
ToggleBtn.Text = "Enable TriggerBot"  
ToggleBtn.BackgroundColor3 = Color3.fromRGB(40,40,60)  
ToggleBtn.TextColor3 = Color3.fromRGB(255,255,255)  
ToggleBtn.Parent = TriggerBotGui  
ToggleBtn.MouseButton1Click:Connect(function()  
    TriggerBotEnabled = not TriggerBotEnabled  
    ToggleBtn.Text = TriggerBotEnabled and "Disable TriggerBot" or "Enable TriggerBot"  
end)  

-- TriggerBot logic  
RunService.RenderStepped:Connect(function()  
    if not TriggerBotEnabled then return end  
    local target = nil  
    local closest = math.huge  
    for _, v in pairs(Players:GetPlayers()) do  
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") then  
            local dist = (v.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude  
            if dist < closest then  
                closest = dist  
                target = v  
            end  
        end  
    end  
    if target and target.Character and target.Character:FindFirstChild("Humanoid") then  
        local hrp = target.Character.HumanoidRootPart  
        if hrp then  
            -- Simulate mouse aiming and click (works with synapse/custom mouse)  
            local oldPos = Mouse.Hit.p  
            Mouse.Hit = CFrame.new(hrp.Position)  
            mouse1click()  
            task.wait(0.05)  
            Mouse.Hit = CFrame.new(oldPos)  
        end  
    end  
end)  

-- === OPTION 2: SPEED & JUMP CHANGER ===  
local SpeedJumpGui = Instance.new("Frame")  
SpeedJumpGui.Size = UDim2.new(0, 200, 0, 120)  
SpeedJumpGui.Position = UDim2.new(0.5, -100, 0.5, 0)  
SpeedJumpGui.BackgroundColor3 = Color3.fromRGB(20,20,30)  
SpeedJumpGui.BackgroundTransparency = 0.2  
SpeedJumpGui.Visible = false  
SpeedJumpGui.Parent = ScreenGui  
local Border2 = Border:Clone()  
Border2.Parent = SpeedJumpGui  

local SpeedSlider = Instance.new("TextLabel")  
SpeedSlider.Size = UDim2.new(0.8, 0, 0.3, 0)  
SpeedSlider.Position = UDim2.new(0.1, 0, 0.1, 0)  
SpeedSlider.Text = "Speed: 16"  
SpeedSlider.BackgroundColor3 = Color3.fromRGB(40,40,60)  
SpeedSlider.TextColor3 = Color3.fromRGB(255,255,255)  
SpeedSlider.Parent = SpeedJumpGui  

local JumpSlider = Instance.new("TextLabel")  
JumpSlider.Size = UDim2.new(0.8, 0, 0.3, 0)  
JumpSlider.Position = UDim2.new(0.1, 0, 0.4, 0)  
JumpSlider.Text = "Jump: 50"  
JumpSlider.BackgroundColor3 = Color3.fromRGB(40,40,60)  
JumpSlider.TextColor3 = Color3.fromRGB(255,255,255)  
JumpSlider.Parent = SpeedJumpGui  

-- Speed/Jump modification (walk speed / jump power)  
RunService.RenderStepped:Connect(function()  
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then  
        local hum = LocalPlayer.Character.Humanoid  
        if SpeedJumpGui.Visible then  
            -- Read slider values from UI (simplified - you'd add actual slider objects)  
            hum.WalkSpeed = 16 -- default, change with slider  
            hum.JumpPower = 50  
        else  
            hum.WalkSpeed = 16  
            hum.JumpPower = 50  
        end  
    end  
end)  

-- === OPTION 3: TELEPORT TO PLAYER (by username) ===  
local TeleportGui = Instance.new("Frame")  
TeleportGui.Size = UDim2.new(0, 250, 0, 180)  
TeleportGui.Position = UDim2.new(0.5, -125, 0.7, 0)  
TeleportGui.BackgroundColor3 = Color3.fromRGB(20,20,30)  
TeleportGui.BackgroundTransparency = 0.2  
TeleportGui.Visible = false  
TeleportGui.Parent = ScreenGui  
local Border3 = Border:Clone()  
Border3.Parent = TeleportGui  

local InputBox = Instance.new("TextBox")  
InputBox.Size = UDim2.new(0.8, 0, 0.25, 0)  
InputBox.Position = UDim2.new(0.1, 0, 0.1, 0)  
InputBox.PlaceholderText = "Username"  
InputBox.BackgroundColor3 = Color3.fromRGB(40,40,60)  
InputBox.TextColor3 = Color3.fromRGB(255,255,255)  
InputBox.Parent = TeleportGui  

local TeleportBtn = Instance.new("TextButton")  
TeleportBtn.Size = UDim2.new(0.4, 0, 0.25, 0)  
TeleportBtn.Position = UDim2.new(0.3, 0, 0.4, 0)  
TeleportBtn.Text = "Teleport"  
TeleportBtn.BackgroundColor3 = Color3.fromRGB(60,60,90)  
TeleportBtn.TextColor3 = Color3.fromRGB(255,255,255)  
TeleportBtn.Parent = TeleportGui  
TeleportBtn.MouseButton1Click:Connect(function()  
    local targetName = InputBox.Text  
    for _, v in pairs(Players:GetPlayers()) do  
        if v.Name:lower() == targetName:lower() then  
            if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then  
                LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame  
                -- Also get info: creation date, avatar cost (mock)  
                local info = {  
                    Created = v.AccountAge or "Unknown",  
                    AvatarCost = "~500 R$ (estimate)"  
                }  
                print("Player: "..v.Name.." | Created: "..tostring(info.Created).." | Cost: "..info.AvatarCost)  
            end  
            break  
        end  
    end  
end)  

-- === OPTION 4: REJOIN ===  
local RejoinBtn = Instance.new("TextButton")  
RejoinBtn.Size = UDim2.new(0, 120, 0, 40)  
RejoinBtn.Position = UDim2.new(0.8, 0, 0.1, 0)  
RejoinBtn.Text = "Rejoin"  
RejoinBtn.BackgroundColor3 = Color3.fromRGB(60,60,90)  
RejoinBtn.TextColor3 = Color3.fromRGB(255,255,255)  
RejoinBtn.Parent = ScreenGui  
RejoinBtn.MouseButton1Click:Connect(function()  
    game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)  
end)  

-- === OPTION 5: AUTO-JOIN PLAYER (even offline/not friend) ===  
local AutoJoinGui = Instance.new("Frame")  
AutoJoinGui.Size = UDim2.new(0, 200, 0, 100)  
AutoJoinGui.Position = UDim2.new(0.8, -200, 0.5, 0)  
AutoJoinGui.BackgroundColor3 = Color3.fromRGB(20,20,30)  
AutoJoinGui.BackgroundTransparency = 0.2  
AutoJoinGui.Visible = false  
AutoJoinGui.Parent = ScreenGui  
local Border5 = Border:Clone()  
Border5.Parent = AutoJoinGui  

local JoinInput = Instance.new("TextBox")  
JoinInput.Size = UDim2.new(0.8, 0, 0.3, 0)  
JoinInput.Position = UDim2.new(0.1, 0, 0.1, 0)  
JoinInput.PlaceholderText = "Username to join"  
JoinInput.BackgroundColor3 = Color3.fromRGB(40,40,60)  
JoinInput.TextColor3 = Color3.fromRGB(255,255,255)  
JoinInput.Parent = AutoJoinGui  

local JoinBtn = Instance.new("TextButton")  
JoinBtn.Size = UDim2.new(0.4, 0, 0.3, 0)  
JoinBtn.Position = UDim2.new(0.3, 0, 0.5, 0)  
JoinBtn.Text = "Join"  
JoinBtn.BackgroundColor3 = Color3.fromRGB(60,60,90)  
JoinBtn.TextColor3 = Color3.fromRGB(255,255,255)  
JoinBtn.Parent = AutoJoinGui  
JoinBtn.MouseButton1Click:Connect(function()  
    local uname = JoinInput.Text  
    -- Use HttpService to get user ID (simplified, requires proxy)  
    local userId = nil  
    -- In real scenario, you'd call Roblox API with http request  
    -- Mock: try to find in current server, else teleport to their server via friend/join (bypass not fully possible)  
    -- For educational demo: if not found, print message  
    for _, v in pairs(Players:GetPlayers()) do  
        if v.Name:lower() == uname:lower() then  
            game:GetService("TeleportService"):Teleport(game.PlaceId, v)  
            return  
        end  
    end  
    print("Player not in server. Auto-join offline not supported without API key.")  
end)  

-- === OPTION 6: FPS COUNTER (Real-time) ===  
local FpsLabel = Instance.new("TextLabel")  
FpsLabel.Size = UDim2.new(0, 80, 0, 30)  
FpsLabel.Position = UDim2.new(0, 10, 0, 10)  
FpsLabel.BackgroundTransparency = 1  
FpsLabel.Text = "FPS: 0"  
FpsLabel.TextColor3 = Color3.fromRGB(255,255,255)  
FpsLabel.TextScaled = true  
FpsLabel.Parent = ScreenGui  

local frameCount = 0  
local timeAccum = 0  
RunService.RenderStepped:Connect(function(dt)  
    frameCount = frameCount + 1  
    timeAccum = timeAccum + dt  
    if timeAccum >= 0.5 then  
        local fps = math.floor(frameCount / timeAccum)  
        FpsLabel.Text = "FPS: "..tostring(fps)  
        frameCount = 0  
        timeAccum = 0  
    end  
end)  

-- === KEYBINDS: Toggle GUIs ===  
UserInputService.InputBegan:Connect(function(input, gameProcessed)  
    if gameProcessed then return end  
    if input.KeyCode == Enum.KeyCode.One then  
        TriggerBotGui.Visible = not TriggerBotGui.Visible  
    elseif input.KeyCode == Enum.KeyCode.Two then  
        SpeedJumpGui.Visible = not SpeedJumpGui.Visible  
    elseif input.KeyCode == Enum.KeyCode.Three then  
        TeleportGui.Visible = not TeleportGui.Visible  
    elseif input.KeyCode == Enum.KeyCode.Four then  
        -- Rejoin already has button  
    elseif input.KeyCode == Enum.KeyCode.Five then  
        AutoJoinGui.Visible = not AutoJoinGui.Visible  
    end  
end)  

-- Credits (aliiiwyddd)  
local CreditLabel = Instance.new("TextLabel")  
CreditLabel.Size = UDim2.new(0, 200, 0, 20)  
CreditLabel.Position = UDim2.new(0.5, -100, 0.95, 0)  
CreditLabel.BackgroundTransparency = 1  
CreditLabel.Text = "Made by aliiiwyddd"  
CreditLabel.TextColor3 = Color3.fromRGB(255,200,100)  
CreditLabel.TextScaled = true  
CreditLabel.Parent = ScreenGui  

print("Dahood Custom HUD loaded - Educational use only")  