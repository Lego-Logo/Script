-- MultiSelectDropdown.lua

return function(parentGui, config)
	local UIS = game:GetService("UserInputService")

	local dropdownFrame = Instance.new("Frame")
	dropdownFrame.Name = config.Id or "MultiDropdown"
	dropdownFrame.Size = UDim2.new(1, 0, 0, 40)
	dropdownFrame.BackgroundTransparency = 1
	dropdownFrame.Parent = parentGui

	local mainButton = Instance.new("TextButton")
	mainButton.Size = UDim2.new(1, 0, 1, 0)
	mainButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	mainButton.BorderSizePixel = 0
	mainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	mainButton.Font = Enum.Font.GothamBold
	mainButton.TextSize = 14
	mainButton.TextXAlignment = Enum.TextXAlignment.Left
	mainButton.Text = config.Title or "Select Items"
	mainButton.Parent = dropdownFrame

	local selectedValues = {}
	local dropdownOpen = false

	local dropdownList = Instance.new("ScrollingFrame")
	dropdownList.Size = UDim2.new(1, 0, 0, 120)
	dropdownList.Position = UDim2.new(0, 0, 1, 2)
	dropdownList.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	dropdownList.BorderSizePixel = 0
	dropdownList.ScrollBarThickness = 4
	dropdownList.Visible = false
	dropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
	dropdownList.AutomaticCanvasSize = Enum.AutomaticSize.Y
	dropdownList.Parent = dropdownFrame

	local UIList = Instance.new("UIListLayout")
	UIList.Parent = dropdownList
	UIList.SortOrder = Enum.SortOrder.LayoutOrder

	local function updateMainButtonText()
		local keys = {}
		for _, val in ipairs(config.Values) do
			if selectedValues[val] then
				table.insert(keys, val)
			end
		end
		mainButton.Text = (config.Title or "Select") .. ": " .. (#keys > 0 and table.concat(keys, ", ") or "None")
	end

	for _, val in ipairs(config.Values or {}) do
		local option = Instance.new("TextButton")
		option.Size = UDim2.new(1, -4, 0, 30)
		option.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		option.BorderSizePixel = 0
		option.TextColor3 = Color3.fromRGB(255, 255, 255)
		option.Font = Enum.Font.Gotham
		option.TextSize = 13
		option.Text = "☐ " .. val
		option.LayoutOrder = 0
		option.Parent = dropdownList

		selectedValues[val] = table.find(config.Default or {}, val) ~= nil
		if selectedValues[val] then
			option.Text = "☑ " .. val
		end

		option.MouseButton1Click:Connect(function()
			selectedValues[val] = not selectedValues[val]
			option.Text = (selectedValues[val] and "☑ " or "☐ ") .. val
			updateMainButtonText()

			-- ✅ Trigger Callback
			if config.Callback then
				local result = {}
				for k, v in pairs(selectedValues) do
					if v then table.insert(result, k) end
				end
				config.Callback(result)
			end
		end)
	end

	mainButton.MouseButton1Click:Connect(function()
		dropdownOpen = not dropdownOpen
		dropdownList.Visible = dropdownOpen
	end)

	UIS.InputBegan:Connect(function(input)
		if dropdownOpen and input.UserInputType == Enum.UserInputType.MouseButton1 then
			local mouse = game:GetService("Players").LocalPlayer:GetMouse()
			if not dropdownFrame:IsAncestorOf(mouse.Target) then
				dropdownList.Visible = false
				dropdownOpen = false
			end
		end
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
			for _, child in ipairs(dropdownList:GetChildren()) do
				if child:IsA("TextButton") then
					local key = string.match(child.Text, "☑ (.+)") or string.match(child.Text, "☐ (.+)")
					local enabled = table.find(values, key) ~= nil
					selectedValues[key] = enabled
					child.Text = (enabled and "☑ " or "☐ ") .. key
				end
			end
			updateMainButtonText()
		end
	}
end
