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

print("✅ [UI] ใส่ Paragraph ในทุก Tab เรียบร้อย")

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
