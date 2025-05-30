return function(parent, config)
	local UIS = game:GetService("UserInputService")
	local Players = game:GetService("Players")

	local selectedValues = {}
	local dropdownOpen = false

	-- ✅ Main button
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0, 260, 0, 36)
	button.Position = UDim2.new(0, 20, 0, 20)
	button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	button.BorderSizePixel = 0
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Text = config.Title or "เลือกหลายค่า"
	button.Font = Enum.Font.GothamBold
	button.TextSize = 14
	button.TextXAlignment = Enum.TextXAlignment.Left
	button.Parent = parent

	-- ✅ Dropdown list
	local listFrame = Instance.new("Frame")
	listFrame.Position = UDim2.new(0, 20, 0, 58)
	listFrame.Size = UDim2.new(0, 260, 0, #config.Values * 28 + 6)
	listFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	listFrame.BorderSizePixel = 0
	listFrame.Visible = false
	listFrame.ClipsDescendants = true
	listFrame.Parent = parent

	local layout = Instance.new("UIListLayout", listFrame)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 4)

	-- ✅ Create options
	for _, val in ipairs(config.Values or {}) do
		local isDefault = table.find(config.Default or {}, val) ~= nil
		selectedValues[val] = isDefault

		local option = Instance.new("TextButton")
		option.Size = UDim2.new(1, -8, 0, 24)
		option.Position = UDim2.new(0, 4, 0, 0)
		option.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		option.TextColor3 = Color3.new(1,1,1)
		option.BorderSizePixel = 0
		option.TextSize = 12
		option.Font = Enum.Font.Gotham
		option.TextXAlignment = Enum.TextXAlignment.Left
		option.Text = (isDefault and "☑ " or "☐ ") .. val
		option.Parent = listFrame

		option.MouseButton1Click:Connect(function()
			selectedValues[val] = not selectedValues[val]
			option.Text = (selectedValues[val] and "☑ " or "☐ ") .. val

			-- ✅ Update text
			local selected = {}
			for k,v in pairs(selectedValues) do if v then table.insert(selected, k) end end
			button.Text = config.Title .. ": " .. (#selected > 0 and table.concat(selected, ", ") or "None")

			if config.Callback then config.Callback(selected) end
		end)
	end

	-- ✅ Toggle Dropdown
	button.MouseButton1Click:Connect(function()
		dropdownOpen = not dropdownOpen
		listFrame.Visible = dropdownOpen
	end)

	return {
		GetValue = function()
			local selected = {}
			for k,v in pairs(selectedValues) do if v then table.insert(selected, k) end end
			return selected
		end,
		SetValue = function(values)
			for k,_ in pairs(selectedValues) do selectedValues[k] = false end
			for _, v in ipairs(values) do selectedValues[v] = true end
			-- update label
			local selected = {}
			for k,v in pairs(selectedValues) do if v then table.insert(selected, k) end end
			button.Text = config.Title .. ": " .. (#selected > 0 and table.concat(selected, ", ") or "None")
		end
	}
end
