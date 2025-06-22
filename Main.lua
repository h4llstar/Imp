local RS = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local EggsFolder = workspace:WaitForChild("Eggs")

local function getPriorityQuestEgg()
    local q = Player:WaitForChild("QuestsClans")
    local egg1 = q:FindFirstChild("EggRequired")
    local egg2 = q:FindFirstChild("EggRequired2")
    local goal1 = q:FindFirstChild("HatchEggsQuest") and q.HatchEggsQuest.Value or 0
    local goal2 = q:FindFirstChild("RandomEggQuest1") and q.RandomEggQuest1.Value or 0

    if goal1 == 2500 then
        return egg1 and egg1.Value or nil
    elseif goal2 == 2500 then
        return egg2 and egg2.Value or nil
    elseif goal2 > goal1 then
        return egg2 and egg2.Value or nil
    else
        return egg1 and egg1.Value or nil
    end
end

local function teleportToEgg(eggName)
    local model = EggsFolder:FindFirstChild(eggName)
    local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if model and model:FindFirstChild("Egg") and hrp then
        TweenService:Create(hrp, TweenInfo.new(0.4), {CFrame = model.Egg.CFrame}):Play()
    end
end

local function hatchEgg(eggName)
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Events"):WaitForChild("BuyEgg"):FireServer(eggName, "Max")
end

local auto = true
task.spawn(function()
    while task.wait(1.5) do
        if auto then
            local egg = getPriorityQuestEgg()
            if egg then
    teleportToEgg(egg)
    local eggPart = workspace.Eggs:FindFirstChild(egg) and workspace.Eggs[egg]:FindFirstChild("Egg")
    if eggPart then
        repeat
            task.wait(0.1)
        until (Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and
              (Player.Character.HumanoidRootPart.Position - eggPart.Position).Magnitude <= 10)
        task.wait(0.3)
        hatchEgg(egg)
                 end
            end
        end
    end
end)
