-- ตัวแปร ทั้งหมดที่จำเป็นของ UI -----------------------------------------------------

-- ✅ โหลด Fluent UI และ Addons
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()


-- ✅ สร้างหน้าต่าง Fluent
local Window = Fluent:CreateWindow({
    Title = "ZSOFT HUB",
    SubTitle = "SpongeBob Tower Defense",
    TabWidth = 160,
    Size = UDim2.fromOffset(520, 400),
    Acrylic = false,
    Theme = "Aqua",
    MinimizeKey = Enum.KeyCode.LeftControl
})


-- ✅ สร้าง Tabs แบบถูกต้อง
local Tabs = {
    Macro = Window:AddTab({ Title = "Macro", Icon = "film" }),
    AutoJoin = Window:AddTab({ Title = "AutoJoin", Icon = "game" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- END ตัวแปร ทั้งหมดที่จำเป็นของ UI -----------------------------------------------------



--  MACRO UI -----------------------------------------------------
Tabs.Macro:AddParagraph({
    Title = "Macro",
    Content = "📝 หน้านี้สำหรับ Macro Recorder/Playback"
})

-- ✅ Toggle 1–5
for i = 1, 5 do
    Tabs.Macro:AddToggle("TestToggle" .. i, {
        Title = "🟢 Auto Test Toggle " .. i,
        Default = false,
        Callback = function(state)
            print("Toggle " .. i .. ":", state)
        end
    })
end

-- ✅ Input 1–3 ผสมทดสอบ
for i = 1, 3 do
    Tabs.Macro:AddInput("TestInput" .. i, {
        Title = "⌨️ Test Input " .. i,
        Placeholder = "พิมพ์ข้อความ...",
        Default = "",
        Callback = function(text)
            print("Input " .. i .. ":", text)
        end
    })
end

--  END MACRO UI -----------------------------------------------------



----------------------------------- END Auto Join Challenge ------------------------------------

Tabs.AutoJoin:AddParagraph({
    Title = "Game",
    Content = "🎮 หน้านี้สำหรับระบบ Replay, AutoVote"
})

-- Auto Join Challenge
Tabs.AutoJoin:AddSection("Challenge Mode")

-- ✅ เก็บความยากที่เลือก
Tabs.AutoJoin.State.SelectedChallengeMode = "Nightmare"

-- ✅ Dropdown เลือกความยาก
Tabs.AutoJoin:AddDropdown("SelectChallengeMode", {
    Title = "ความยาก Challenge",
    Description = "เลือกโหมดความยาก",
    Values = { "Hard", "Nightmare" },
    Default = "Nightmare",
    Callback = function(value)
        Tabs.AutoJoin.State.SelectedChallengeMode = value
    end
})


-- ✅ Toggle เปิด/ปิด
Tabs.AutoJoin:AddToggle("EnableChallengeAutoJoin", {
    Title = "Auto Join (Challenge Mode)",
    Description = "จะวาร์ปไปสร้างห้องและเริ่มเกมโดยอัตโนมัติ",
    Default = false,
    Callback = function(state)
        if not state then return end

        task.spawn(function()
            if not isInLobby() then
                Fluent:Notify({
                    Title = "❌ ไม่อยู่ใน Lobby",
                    Content = "ไม่สามารถเริ่ม Challenge ได้",
                    Duration = 3
                })
                return
            end

            -- ✅ วาร์ปไปตำแหน่งตามความยาก
            local difficulty = Tabs.AutoJoin.State.SelectedChallengeMode or "Hard"
            local pos = Vector3.new()

            if difficulty == "Nightmare" then
                pos = Vector3.new(355.2195129394531, 13.200729370117188, -421.3446960449219)
            else
                pos = Vector3.new(332.8740234375, 12.735966682434082, -361.625)
            end


            local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local hrp = char:WaitForChild("HumanoidRootPart")
            hrp.CFrame = CFrame.new(pos)

            Fluent:Notify({
                Title = "🚀 Challenge Mode",
                Content = "วาร์ปไปยังโหมด " .. difficulty,
                Duration = 3
            })
        end)
    end
})

-- Auto Join Challenge
Tabs.AutoJoin:AddSection("Raid Mode")

-- ✅ Raid Mode - เก็บค่าการเลือก
Tabs.AutoJoin.State.SelectedRaidStage = "Mermalair"
Tabs.AutoJoin.State.SelectedRaidMode = "Nightmare"

-- ✅ รายชื่อด่าน
local raidStages = {
    "Mermalair",
    "Middle Ages"
}

-- ✅ Dropdown: เลือกด่าน Raid
Tabs.AutoJoin:AddDropdown("SelectRaidStage", {
    Title = "เลือกด่าน Raid",
    Description = "เลือกแผนที่ที่จะเล่น",
    Values = raidStages,
    Default = "Mermalair",
    Callback = function(val)
        Tabs.AutoJoin.State.SelectedRaidStage = val
    end
})

-- ✅ Dropdown: เลือกความยาก
Tabs.AutoJoin:AddDropdown("SelectRaidMode", {
    Title = "ความยาก Raid",
    Description = "เลือกความยากของด่าน",
    Values = { "Hard", "Nightmare" },
    Default = "Nightmare",
    Callback = function(val)
        Tabs.AutoJoin.State.SelectedRaidMode = val
    end
})

Tabs.AutoJoin:AddToggle("EnableRaidAutoJoin", {
    Title = "Auto Join (Raid Mode)",
    Description = "วาร์ปไปยังด่าน Raid ตามด่านและความยากที่เลือก",
    Default = false,
    Callback = function(state)
        if not state then return end

        task.spawn(function()
            if not isInLobby() then
                Fluent:Notify({
                    Title = "❌ ไม่อยู่ใน Lobby",
                    Content = "ไม่สามารถเข้า Raid Mode ได้",
                    Duration = 3
                })
                return
            end

            local stage = Tabs.AutoJoin.State.SelectedRaidStage
            local difficulty = Tabs.AutoJoin.State.SelectedRaidMode or "Hard"

            -- ✅ กำหนดพิกัดตามด่านและความยาก
            local posMap = {
                ["Mermalair"] = {
                    Hard = Vector3.new(42.56332778930664, 5, -365.46478271484375),
                    Nightmare = Vector3.new(-10.510272026062012, 5, -368.5558166503906)
                },
                ["Middle Ages"] = {
                    Hard = Vector3.new(41.95417404174805, 5, -455.2958984375),
                    Nightmare = Vector3.new(-11.096419334411621, 5, -452.27069091796875)
                }
            }


            local pos = posMap[stage] and posMap[stage][difficulty]

            if pos then
                local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local hrp = char:WaitForChild("HumanoidRootPart")
                hrp.CFrame = CFrame.new(pos)

                Fluent:Notify({
                    Title = "🚀 Raid Mode",
                    Content = string.format("วาร์ปไปยัง %s (%s)", stage, difficulty),
                    Duration = 3
                })
            else
                Fluent:Notify({
                    Title = "❌ ไม่พบพิกัด",
                    Content = "อาจยังไม่ได้กำหนดพิกัดสำหรับ Stage นี้",
                    Duration = 4
                })
            end
        end)
    end
})
----------------------------------- END Auto Join Challenge ------------------------------------










----------------------------------- SETTINGS ------------------------------------

Tabs.Settings:AddParagraph({
    Title = "Settings",
    Content = "⚙️ การตั้งค่า Config, Theme ฯลฯ"
})

----------------------------------- END SETTINGS ------------------------------------









-- ✅ ติดตั้ง Fluent Library ให้ SaveManager/InterfaceManager
local successCfg = pcall(function()
    SaveManager:SetLibrary(Fluent)
    InterfaceManager:SetLibrary(Fluent)

    SaveManager:IgnoreThemeSettings()
    SaveManager:SetFolder("ZSOFT HUB - TEST")
    InterfaceManager:SetFolder("ZSOFT HUB - TEST")

    InterfaceManager:BuildInterfaceSection(Tabs.Settings)
    SaveManager:BuildConfigSection(Tabs.Settings)
end)

if successCfg then
    print("✅ [Settings] โหลด SaveManager/InterfaceManager เสร็จ")
else
    warn("⚠️ [Settings] โหลด Config UI ล้มเหลว")
end

-- ✅ เปิดแท็บ Macro ทันทีเพื่อแก้ปัญหาว่างเปล่า
Window:SelectTab(1)
print("✅ [Fix] เปิด Tab Macro โดยอัตโนมัติสำเร็จ")

-- ✅ แจ้งเตือนตอนโหลดเสร็จ
Fluent:Notify({
    Title = "ZSOFT HUB",
    Content = "SpongeBob Macro UI โหลดสำเร็จแล้ว 🎉",
    Duration = 5
})



---- AUTO SAVE / AUTO LOAD CONFIG --------------------------------
local playerName = game.Players.LocalPlayer.Name
local folder = "ZSOFT HUB - TEST"
local autoloadPath = folder .. "/settings/autoload.txt"

-- ✅ ตั้งค่าเริ่มต้น
SaveManager:SetFolder(folder)
InterfaceManager:SetFolder(folder)
SaveManager.ConfigName = playerName

-- ✅ ป้อนชื่อเข้า UI
if SaveManager.Options and SaveManager.Options.ConfigName and SaveManager.Options.ConfigName.Textbox then
    SaveManager.Options.ConfigName.Textbox.Text = playerName
end

-- ✅ ตรวจว่า autoload.txt ตรงกับชื่อผู้เล่นหรือไม่
local shouldLoad = false
local ok, autoloadName = pcall(readfile, autoloadPath)
if ok and autoloadName == playerName then
    shouldLoad = true
end

-- ✅ โหลดเฉพาะถ้าชื่อตรง และครอบด้วย pcall เพื่อกัน error
if shouldLoad then
    local success, err = pcall(function()
        SaveManager:Load(playerName)
    end)
    if success then
        print("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
        print("✅ Autoload matched:", autoloadName)
    else
        warn("⚠️ Load error (autoload matched):", err)
    end
else
    -- ❌ เขียน autoload ใหม่ และโหลด config ของตัวเอง
    pcall(function()
        writefile(autoloadPath, playerName)
        print("⚠️ Autoload mismatch → overwrite:", autoloadName, "→", playerName)
    end)

    local success, err = pcall(function()
        SaveManager:Load(playerName)
    end)
    if success then
        print("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
        print("✅ Loaded default config for:", playerName)
    else
        warn("⚠️ Load error (new user):", err)
    end
end

-- ✅ ผูก AutoSave กับทุก flag ใน Fluent
for flagName, flagData in pairs(Fluent.Flags or {}) do
    if typeof(flagData) == "table" and typeof(flagData.Changed) == "function" then
        flagData.Changed:Connect(function()
            SaveManager:Save(playerName)
            --print("💾 AutoSaved from:", flagName)
        end)
    end
end

-- ✅ สำรองข้อมูลทุก 5 วิ
task.spawn(function()
    while true do
        task.wait(5)
        SaveManager:Save(playerName)
    end
end)
---- END AUTO SAVE / AUTO LOAD CONFIG --------------------------------
