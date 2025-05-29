-- ตัวแปร ทั้งหมดที่จำเป็นของ UI -----------------------------------------------------

-- ✅ โหลด Fluent UI และ Addons
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()


-- ✅ สร้างหน้าต่าง Fluent
local Window = Fluent:CreateWindow({
    Title = "ZSOFT HUB",
    SubTitle = "TEST",
    TabWidth = 160,
    Size = UDim2.fromOffset(520, 400),
    Acrylic = false,
    Theme = "Aqua",
    MinimizeKey = Enum.KeyCode.LeftControl
})


-- ✅ สร้าง Tabs แบบถูกต้อง
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "box" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
}

-- END ตัวแปร ทั้งหมดที่จำเป็นของ UI -----------------------------------------------------


-- ✅ UI Components (Toggle / Slider / Input / Dropdown / Keybind)
Tabs.Main:AddToggle("TestToggle", {
    Title = "🟢 Auto Test Toggle",
    Default = false,
    Callback = function(state)
        print("Toggle State:", state)
    end
})

Tabs.Main:AddSlider("TestSlider", {
    Title = "🎚️ Test Slider",
    Description = "Slider for test",
    Default = 50,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Callback = function(value)
        print("Slider Value:", value)
    end
})

Tabs.Main:AddInput("TestInput", {
    Title = "⌨️ Test Input",
    Placeholder = "Enter something...",
    Numeric = false,
    Callback = function(text)
        print("Input Text:", text)
    end
})

Tabs.Main:AddDropdown("TestDropdown", {
    Title = "📋 Test Dropdown",
    Values = { "One", "Two", "Three" },
    Multi = false,
    Default = "One",
    Callback = function(val)
        print("Dropdown:", val)
    end
})

Tabs.Main:AddKeybind("TestKey", {
    Title = "🧷 Test Keybind",
    Mode = "Toggle",
    Default = Enum.KeyCode.F,
    Callback = function()
        print("Keybind F Pressed")
    end
})




---  END TABS: SETTINGS -----------------------------------------------------------------------

Tabs.Settings:AddParagraph({
    Title = "Settings",
    Content = "⚙️ การตั้งค่า Config, Theme ฯลฯ"
})
---  END TABS: SETTINGS -----------------------------------------------------------------------



-- ✅ ติดตั้ง Fluent Library ให้ SaveManager/InterfaceManager
local successCfg = pcall(function()
    SaveManager:SetLibrary(Fluent)
    InterfaceManager:SetLibrary(Fluent)

    SaveManager:IgnoreThemeSettings()
    SaveManager:SetFolder("ZSOFT HUB - TEST")
    InterfaceManager:SetFolder("ZSOFT HUB - TEST")

    InterfaceManager:BuildInterfaceSection(Tabs.Settings)
    SaveManager:BuildConfigSection(Tabs.Settings)

    -- ✅ โหลด config หลังตั้งค่าทุกอย่างเสร็จ
    SaveManager:LoadAutoloadConfig()
end)



-- ✅ เปิดแท็บ Macro ทันทีเพื่อแก้ปัญหาว่างเปล่า
Window:SelectTab(1)

-- ✅ แจ้งเตือนตอนโหลดเสร็จ
Fluent:Notify({
    Title = "ZSOFT HUB",
    Content = "ZSOFT HUB - TEST Ready",
    Duration = 5
})


