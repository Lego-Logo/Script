local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Nui = require(Packages:WaitForChild("Nui"))

return function(parent, props)
    local values = props.Values or {}
    local default = props.Default or {}
    local title = props.Title or "Select Items"
    local callback = props.OnChanged

    local selected = {}
    for _, v in ipairs(default) do
        selected[v] = true
    end

    -- Main Container (Frame)
    local container = Nui.Create("Frame", {
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundTransparency = 1,
        Parent = parent
    })

    -- Button to open dropdown
    local button = Nui.Create("Button", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(31, 31, 31),
        BorderSizePixel = 0,
        Text = title,
        Font = Enum.Font.GothamSemibold,
        TextSize = 14,
        TextColor3 = Color3.fromRGB(240, 240, 240),
        TextXAlignment = Enum.TextXAlignment.Left,
        ClipsDescendants = true,
        Parent = container,
    })
    Nui.Create("UICorner", {Parent = button, CornerRadius = UDim.new(0, 6)})

    -- Dropdown List Frame
    local listFrame = Nui.Create("Frame", {
        Position = UDim2.new(0, 0, 1, 4),
        Size = UDim2.new(1, 0, 0, #values * 30),
        BackgroundColor3 = Color3.fromRGB(24, 24, 24),
        BorderSizePixel = 0,
        Visible = false,
        ClipsDescendants = true,
        Parent = container
    })
    Nui.Create("UICorner", {Parent = listFrame, CornerRadius = UDim.new(0, 6)})

    local layout = Nui.Create("UIListLayout", {
        Parent = listFrame,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4)
    })

    -- Create Option Buttons
    local options = {}

    local function updateButtonText()
        local selectedList = {}
        for k,v in pairs(selected) do
            if v then table.insert(selectedList, k) end
        end
        if #selectedList > 0 then
            button.Text = title .. ": " .. table.concat(selectedList, ", ")
        else
            button.Text = title
        end
    end

    for i, val in ipairs(values) do
        local opt = Nui.Create("Button", {
            Size = UDim2.new(1, -12, 0, 28),
            Position = UDim2.new(0, 6, 0, 0),
            BackgroundColor3 = Color3.fromRGB(35, 35, 35),
            BorderSizePixel = 0,
            TextColor3 = Color3.fromRGB(220, 220, 220),
            Font = Enum.Font.Gotham,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            Text = (selected[val] and "☑ " or "☐ ") .. val,
            Parent = listFrame
        })
        Nui.Create("UICorner", {Parent = opt, CornerRadius = UDim.new(0, 4)})

        opt.MouseButton1Click:Connect(function()
            selected[val] = not selected[val]
            opt.Text = (selected[val] and "☑ " or "☐ ") .. val
            updateButtonText()
            if callback then
                local current = {}
                for k,v in pairs(selected) do if v then table.insert(current, k) end end
                callback(current)
            end
        end)

        options[val] = opt
    end

    -- Toggle Dropdown Visibility
    local open = false
    button.MouseButton1Click:Connect(function()
        open = not open
        listFrame.Visible = open
    end)

    -- Public API
    return {
        GetValue = function()
            local result = {}
            for k,v in pairs(selected) do
                if v then table.insert(result, k) end
            end
            return result
        end,
        SetValue = function(newValues)
            for k in pairs(selected) do
                selected[k] = false
            end
            for _, v in ipairs(newValues) do
                if options[v] then
                    selected[v] = true
                end
            end
            for val,opt in pairs(options) do
                opt.Text = (selected[val] and "☑ " or "☐ ") .. val
            end
            updateButtonText()
        end,
        Container = container,
        Options = options
    }
end
