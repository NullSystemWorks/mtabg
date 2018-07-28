local function loadModels()
	for itemName in pairs(getItemNames()) do
		if doesItemHaveTexture(itemName) then
			local textureName = getItemTextureName(itemName)
			local modelName = getItemModel(itemName)
			local txd = engineLoadTXD("model/items/txd/" ..textureName.. ".txd")
			local dff = engineLoadDFF("model/items/dff/" ..textureName.. ".dff")
			engineImportTXD(txd, modelName)
			engineReplaceModel(dff, modelName)
		end
	end
end
addEventHandler("onClientResourceStart", resourceRoot, loadModels)
