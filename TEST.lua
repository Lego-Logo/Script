repeat wait() until game:IsLoaded()
if getgenv().__ZSoftTestLoaded then return end
getgenv().__ZSoftTestLoaded = true

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "ZSOFT HUB",
    SubTitle = "🧪 UI Stress Test",
    TabWidth = 160,
    Size = UDim2.fromOffset(520, 400),
    Acrylic = false,
    Theme = "Aqua",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "box" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
}

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

-- ✅ Settings UI
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:SetFolder("ZSOFT HUB/TESTUI")
InterfaceManager:SetFolder("ZSOFT HUB/TESTUI")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- ✅ Load config (Safe)
task.delay(1, function()
    local ok, count = SaveManager:LoadSafely(game.Players.LocalPlayer.Name, 0.03)
    print("✅ Loaded config toggles:", count)
end)

-- ✅ Notify success
Fluent:Notify({
    Title = "ZSOFT HUB",
    Content = "🧪 Fluent UI Test โหลดสำเร็จ",
    Duration = 5
})


---- AUTO SAVE / AUTO LOAD CONFIG --------------------------------

local playerName = game.Players.LocalPlayer.Name
local folder = "ZSOFT HUB - TEST SAVE-LOAD"
local autoloadPath = folder .. "/settings/autoload.txt"

-- ✅ ตั้งค่าเริ่มต้น
SaveManager:SetFolder(folder)
InterfaceManager:SetFolder(folder)
SaveManager.ConfigName = playerName

-- ✅ ป้อนชื่อเข้า UI (กัน textbox ว่าง)
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
        print("✅ Loaded default config for:", playerName)
    else
        warn("⚠️ Load error (new user):", err)
    end
end

-- ✅ ผูก AutoSave กับทุก flag ใน Fluent
local lastSaveTime = 0
local SAVE_INTERVAL = 1.5

for flagName, flagData in pairs(Fluent.Flags or {}) do
    if typeof(flagData) == "table" and typeof(flagData.Changed) == "function" then
        flagData.Changed:Connect(function()
            local now = tick()
            if now - lastSaveTime >= SAVE_INTERVAL then
                SaveManager:Save(playerName)
                lastSaveTime = now
            end
        end)
    end
end

-- ✅ สำรองข้อมูลทุก 30 วิ (เสมอ)
task.spawn(function()
    while true do
        task.wait(30)
        SaveManager:Save(playerName)
    end
end)

---- END AUTO SAVE / AUTO LOAD CONFIG --------------------------------
