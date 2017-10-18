function loadModels()
	for itemName in pairs(getItemNames()) do
		if doesItemHaveTexture(itemName) then
			local textureName = getItemTextureName(itemName)
			local model = getItemModel(itemName)
			engineImportTXD(engineLoadTXD("model/items/txd/"..textureName..".txd"), model)
			engineReplaceModel(engineLoadDFF("model/items/dff/"..textureName..".dff"), model)
		end
	end
end
addEventHandler("onClientResourceStart", resourceRoot, loadModels)
