return function(parent, config)
	local UIS = game:GetService("UserInputService")
	local selectedValues = {}
	local dropdownOpen = false

	-- ✅ Main container
	local holder = Instance.new("Frame")
	holder.Name = config.Id or "MultiDropdownHolder"
	holder.Size = UDim2.new(1, 0, 0, 36)
	holder.BackgroundTransparency = 1
	holder.Parent = parent

	-- ✅ Main Button
	local button = Instance.new("TextButton")
	button.AnchorPoint = Vector2.new(0, 0)
	button.Position = UDim2.new(0, 0, 0, 0)
	button.Size = UDim2.new(1, 0, 0, 36)
	button.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
	button.BorderSizePixel = 0
	button.AutoButtonColor = false
	button.TextColor3 = Color3.fromRGB(240, 240, 240)
	button.Font = Enum.Font.GothamSemibold
	button.TextSize = 14
	button.TextXAlignment = Enum.TextXAlignment.Left
	button.Text = config.Title or "เลือกหลายค่า"
	button.ClipsDescendants = true
	button.Parent = holder

	local uicorner = Instance.new("UICorner", button)
	uicorner.CornerRadius = UDim.new(0, 6)

	-- ✅ Dropdown List
	local listFrame = Instance.new("Frame")
	listFrame.Position = UDim2.new(0, 0, 1, 4)
	listFrame.Size = UDim2.new(1, 0, 0, #config.Values * 32)
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

	-- ✅ Options
	for _, val in ipairs(config.Values or {}) do
		local isDefault = table.find(config.Default or {}, val) ~= nil
		selectedValues[val] = isDefault

		local opt = Instance.new("TextButton")
		opt.Size = UDim2.new(1, -12, 0, 28)
		opt.Position = UDim2.new(0, 6, 0, 0)
		opt.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		opt.BorderSizePixel = 0
		opt.TextColor3 = Color3.fromRGB(220, 220, 220)
		opt.Font = Enum.Font.Gotham
		opt.TextSize = 13
		opt.TextXAlignment = Enum.TextXAlignment.Left
		opt.Text = (isDefault and "☑ " or "☐ ") .. val
		opt.Parent = listFrame

		local optCorner = Instance.new("UICorner", opt)
		optCorner.CornerRadius = UDim.new(0, 4)

		opt.MouseButton1Click:Connect(function()
			selectedValues[val] = not selectedValues[val]
			opt.Text = (selectedValues[val] and "☑ " or "☐ ") .. val

			-- ✅ Update Main Text
			local selected = {}
			for k,v in pairs(selectedValues) do if v then table.insert(selected, k) end end
			button.Text = config.Title .. ": " .. (#selected > 0 and table.concat(selected, ", ") or "None")

			-- ✅ Trigger Callback
			if config.Callback then
				config.Callback(selected)
			end
		end)
	end

	-- ✅ Dropdown toggle
	button.MouseButton1Click:Connect(function()
		dropdownOpen = not dropdownOpen
		listFrame.Visible = dropdownOpen
	end)

	-- ✅ Public API
	return {
		GetValue = function()
			local result = {}
			for k, v in pairs(selectedValues) do
				if v then table.insert(result, k) end
			end
			return result
		end,
		SetValue = function(values)
			for k in pairs(selectedValues) do
				selectedValues[k] = false
			end
			for _, v in ipairs(values) do
				selectedValues[v] = true
			end

			for _, child in ipairs(listFrame:GetChildren()) do
				if child:IsA("TextButton") then
					local label = child.Text:match("☑ (.+)") or child.Text:match("☐ (.+)")
					if label then
						child.Text = (selectedValues[label] and "☑ " or "☐ ") .. label
					end
				end
			end

			local selected = {}
			for k, v in pairs(selectedValues) do
				if v then table.insert(selected, k) end
			end
			button.Text = config.Title .. ": " .. (#selected > 0 and table.concat(selected, ", ") or "None")
		end
	}
end
