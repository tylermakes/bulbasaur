require("class")

BulbMapStrategy2 = class(function(c)
end)

function BulbMapStrategy2:generateMap( baseMap, rows, columns, tileSize, previousLocation, currentLocation )
	local map = {}
	local forestTile = {}

	local notWalkableTypes = {}
	-- notWalkableTypes[1] = 2
	-- notWalkableTypes[2] = 3
	notWalkableTypes[1] = 3
	notWalkableTypes[2] = 15

	local regularTerrainTypes = {}
	-- regularTerrainTypes[1] = 13
	-- regularTerrainTypes[2] = 10
	regularTerrainTypes[1] = 10

	local enemyTypes = {}
	-- enemyTypes[1] = 4
	-- enemyTypes[2] = 5
	-- enemyTypes[3] = 11
	-- enemyTypes[4] = 14
	enemyTypes[1] = 5

	local entireTileSet = {}
	for m=1, columns*rows do
		if (m < (math.random()*4)) then
			entireTileSet[m] = {tileName = baseMap:randomTile(enemyTypes).tileName, customData = {}}
		elseif (m < 16*3) then
			entireTileSet[m] = {tileName = baseMap:randomTile(notWalkableTypes).tileName, customData = {}}
		else
			entireTileSet[m] = {tileName = baseMap:randomTile(regularTerrainTypes).tileName, customData = {}}
		end
	end

	map.layers = {}
	map.layers[1] = {}
	for i=1, columns do
		map.layers[1][i] = {}
		for j=1, rows do
			--map.layers[1][i][j] = {tileName = self.tileInfo.tileName, customData = {nav = self.nav}}
			--map.layers[1][i][j] = {tileName = self:randomTile(validTypes).tileName, customData = {}}
			local tileNum = math.floor(math.random() * #entireTileSet) + 1
			map.layers[1][i][j] = entireTileSet[tileNum]
			table.remove(entireTileSet, tileNum)
		end
	end

	--baseMap:buildRandomNavs(map, rows, columns, previousLocation, currentLocation)
	baseMap:buildNavPoints(map, rows, columns, previousLocation, currentLocation)

	return map
end