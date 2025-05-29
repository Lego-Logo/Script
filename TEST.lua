-- ตัวแปร ทั้งหมดที่จำเป็นของ UI ------------------------------------------------------

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
    Game = Window:AddTab({ Title = "Game", Icon = "game" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- END ตัวแปร ทั้งหมดที่จำเป็นของ UI -----------------------------------------------------



-- ✅ เพิ่มเนื้อหา Dummy ทดสอบในแต่ละ Tab
Tabs.Macro:AddParagraph({
    Title = "Macro",
    Content = "📝 หน้านี้สำหรับ Macro Recorder/Playback"
})

Tabs.Game:AddParagraph({
    Title = "Game",
    Content = "🎮 หน้านี้สำหรับระบบ Replay, AutoVote"
})

Tabs.Settings:AddParagraph({
    Title = "Settings",
    Content = "⚙️ การตั้งค่า Config, Theme ฯลฯ"
})

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

-- ✅ สำรองข้อมูลทุก 30 วิ
task.spawn(function()
    while true do
        task.wait(30)
        SaveManager:Save(playerName)
        --print("🕒 AutoSaved every 30s for", playerName)
    end
end)
---- END AUTO SAVE / AUTO LOAD CONFIG --------------------------------
