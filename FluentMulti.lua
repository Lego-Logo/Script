-- ✅ Modified Fluent main.lua to support Multi-Selection Dropdown
-- Original: https://github.com/dawid-scripts/Fluent

local Fluent = {}

-- Example structure; insert this inside your Fluent implementation:

function Tab:AddDropdown(opts)
    local UIS = game:GetService("UserInputService")
    local selectedValues = {}
    local dropdownOpen = false

    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, 0, 0, 36)
    holder.BackgroundTransparency = 1
    holder.Parent = self.Content

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 36)
    button.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
    button.BorderSizePixel = 0
    button.AutoButtonColor = false
    button.TextColor3 = Color3.fromRGB(240, 240, 240)
    button.Font = Enum.Font.GothamSemibold
    button.TextSize = 14
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.Text = opts.Title or "เลือกหลายค่า"
    button.ClipsDescendants = true
    button.Parent = holder

    local uicorner = Instance.new("UICorner", button)
    uicorner.CornerRadius = UDim.new(0, 6)

    local listFrame = Instance.new("Frame")
    listFrame.Position = UDim2.new(0, 0, 1, 4)
    listFrame.Size = UDim2.new(1, 0, 0, #opts.Values * 32)
    listFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    listFrame.BorderSizePixel = 0
    listFrame.Visible = false
    listFrame.ClipsDescendants = true
    listFrame.Parent = holder

    local corner = Instance.new("UICorner", listFrame)
    corner.CornerRadius = UDim.new(0, 6)

    local layout = Instance.new("UIListLayout", listFrame)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 4)

    -- Initialize values
    if opts.Multi then
        for _, val in pairs(opts.Default or {}) do
            selectedValues[val] = true
        end
    else
        selectedValues = opts.Default or opts.Values[1]
        button.Text = opts.Title .. ": " .. tostring(selectedValues)
    end

    for _, val in ipairs(opts.Values or {}) do
        local option = Instance.new("TextButton")
        option.Size = UDim2.new(1, -12, 0, 28)
        option.Position = UDim2.new(0, 6, 0, 0)
        option.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        option.BorderSizePixel = 0
        option.TextColor3 = Color3.fromRGB(220, 220, 220)
        option.Font = Enum.Font.Gotham
        option.TextSize = 13
        option.TextXAlignment = Enum.TextXAlignment.Left
        option.Parent = listFrame

        local optCorner = Instance.new("UICorner", option)
        optCorner.CornerRadius = UDim.new(0, 4)

        if opts.Multi then
            option.Text = (selectedValues[val] and "☑ " or "☐ ") .. val
        else
            option.Text = val
        end

        option.MouseButton1Click:Connect(function()
            if opts.Multi then
                selectedValues[val] = not selectedValues[val]
                option.Text = (selectedValues[val] and "☑ " or "☐ ") .. val

                local selectedList = {}
                for k, v in pairs(selectedValues) do
                    if v then table.insert(selectedList, k) end
                end

                button.Text = opts.Title .. ": " .. (#selectedList > 0 and table.concat(selectedList, ", ") or "None")

                if opts.OnChanged then
                    opts.OnChanged(selectedList)
                end
            else
                selectedValues = val
                button.Text = opts.Title .. ": " .. val
                listFrame.Visible = false
                if opts.OnChanged then
                    opts.OnChanged(val)
                end
            end
        end)
    end

    button.MouseButton1Click:Connect(function()
        dropdownOpen = not dropdownOpen
        listFrame.Visible = dropdownOpen
    end)
end

return Fluent
