require("class")

BulbMapGenerator = class(function(c)
end)

function BulbMapGenerator:generateMap( rows, columns, tileSize, previousLocation )
	print("generated a map")
	local map = {}
	local forestTile = {}

	map.layers = {}
	map.layers[1] = {}
	for i=1, columns do
		map.layers[1][i] = {}
		for j=1, rows do
			--map.layers[1][i][j] = {tileName = self.tileInfo.tileName, customData = {nav = self.nav}}
			map.layers[1][i][j] = {tileName = self:randomTile().tileName, customData = {}}
		end
	end

	self:buildRandomNavs(map, rows, columns, previousLocation)

	return map
end

function BulbMapGenerator:buildRandomNavs(map, rows, columns, previousLocation)
	local hasTop = previousLocation.y == rows or math.floor(math.random()*4) == 1
	local hasBottom = previousLocation.y == 1 or math.floor(math.random()*4) == 1
	local hasLeft = previousLocation.x == columns or math.floor(math.random()*4) == 1
	local hasRight = previousLocation.x == 1 or math.floor(math.random()*4) == 1

	--	map.layers[1][math.floor(columns/2)][rows] = {tileName = "nav", customData = {nav = "bulb_game_scene"}}
	if (hasTop) then
		map.layers[1][math.floor(columns/2)][1] = {tileName = "nav", customData = {nav = previousLocation.name}}
	end
	if (hasBottom) then
		map.layers[1][math.floor(columns/2)][rows] = {tileName = "nav", customData = {nav = previousLocation.name}}
	end
	if (hasLeft) then
		map.layers[1][1][math.floor(rows/2)] = {tileName = "nav", customData = {nav = previousLocation.name}}
	end
	if (hasRight) then
		map.layers[1][columns][math.floor(rows/2)] = {tileName = "nav", customData = {nav = previousLocation.name}}
	end

end

function BulbMapGenerator:randomTile()
	local validTypes = {}
	validTypes[1] = 6
	validTypes[2] = 9
	-- validTypes[1] = 2
	-- validTypes[2] = 3
	-- validTypes[3] = 6
	-- validTypes[4] = 7
	-- validTypes[5] = 8
	-- validTypes[6] = 9
	-- validTypes[7] = 10
	-- validTypes[8] = 11

	return bulbBuilderSettings.types[validTypes[math.floor(math.random() * #validTypes) + 1]]
end