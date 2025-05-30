-- MultiDropdown.lua

return function(tab, config)
	local section = tab:AddSection(config.Title or "Multi Select")

	local state = {
		_selected = {},
		_buttons = {},
	}

	-- ✅ สร้างปุ่ม Toggle สำหรับแต่ละค่า
	for _, val in ipairs(config.Values or {}) do
		state._selected[val] = table.find(config.Default or {}, val) ~= nil

		state._buttons[val] = tab:AddToggle("MultiDropdown_" .. val, {
			Title = val,
			Default = state._selected[val],
			Callback = function(toggleState)
				state._selected[val] = toggleState

				local selectedList = {}
				for k, v in pairs(state._selected) do
					if v then table.insert(selectedList, k) end
				end

				-- ✅ เรียก Callback
				if typeof(config.Callback) == "function" then
					config.Callback(selectedList)
				end
			end
		})
	end

	-- ✅ ฟังก์ชันใช้งานเหมือน Fluent ปกติ
	return {
		GetValue = function()
			local result = {}
			for k, v in pairs(state._selected) do
				if v then table.insert(result, k) end
			end
			return result
		end,
		SetValue = function(list)
			for val, button in pairs(state._buttons) do
				local enabled = table.find(list, val) ~= nil
				state._selected[val] = enabled
				if button and button.SetValue then
					button:SetValue(enabled)
				end
			end
		end
	}
end
