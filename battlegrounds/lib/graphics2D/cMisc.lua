function guiComboBoxAdjustHeight(combobox, itemcount)
	if getElementType(combobox) ~= "gui-combobox" or type(itemcount) ~= "number" then
		error("Invalid arguments @ 'guiComboBoxAdjustHeight'", 2)
	end
	local width = guiGetSize(combobox, false)
	return guiSetSize(combobox, width, (itemcount*20) + 20, false)
end
