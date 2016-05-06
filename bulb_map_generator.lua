require("class")
require("bulb_map_strategy1")
require("bulb_map_strategy2")
require("bulb_map_strategy3")
require("bulb_map_strategy4")

BulbMapGenerator = class(function(c)
end)

-- previousLocation = {x, y (tile where you navigated from), name (map name)}
-- currentLocation = {x, y (the meta tile location you're generating)}
function BulbMapGenerator:generateMap( rows, columns, tileSize, previousLocation, currentLocation )

	local distance = math.abs(currentLocation.x - 1) + math.abs(currentLocation.y - 1)
	if (distance < 2) then
		print("strategy: 1")
		local strategy = BulbMapStrategy1()
		return strategy:generateMap( self, rows, columns, tileSize, previousLocation, currentLocation )
	elseif (distance < 4) then
		print("strategy: 2")
		local strategy = BulbMapStrategy2()
		return strategy:generateMap( self, rows, columns, tileSize, previousLocation, currentLocation )
	elseif (distance < 6) then
		print("strategy: 3")
		local strategy = BulbMapStrategy3()
		return strategy:generateMap( self, rows, columns, tileSize, previousLocation, currentLocation )
	else
		print("strategy: 4")
		local strategy = BulbMapStrategy4()
		return strategy:generateMap( self, rows, columns, tileSize, previousLocation, currentLocation )
	end
	
	--return self:generateSpecialMap( rows, columns, tileSize, previousLocation, currentLocation )
-- 	print("generated a map")
-- 	print("\tprev:", previousLocation.x, previousLocation.y, previousLocation.name)
-- 	print("\tcur:", currentLocation.x, currentLocation.y)
-- 	local map = {}
-- 	local forestTile = {}

-- 	map.layers = {}
-- 	map.layers[1] = {}
-- 	for i=1, columns do
-- 		map.layers[1][i] = {}
-- 		for j=1, rows do
-- 			--map.layers[1][i][j] = {tileName = self.tileInfo.tileName, customData = {nav = self.nav}}
-- 			map.layers[1][i][j] = {tileName = self:randomTile().tileName, customData = {}}
-- 		end
-- 	end

-- 	--self:buildRandomNavs(map, rows, columns, previousLocation, currentLocation)
-- 	self:buildNavPoints(map, rows, columns, previousLocation, currentLocation)

-- 	return map
end

function BulbMapGenerator:generateDifferentiatedMap( rows, columns, tileSize, previousLocation, currentLocation )
	local map = {}
	local forestTile = {}

	local validTypes = {}
	if (currentLocation.x % 2 == 0) then
		validTypes[1] = 6
	else
		validTypes[1] = 9
	end
	if (currentLocation.y % 2 == 0) then
		validTypes[2] = 10
	else
		validTypes[2] = 13
	end

	map.layers = {}
	map.layers[1] = {}
	for i=1, columns do
		map.layers[1][i] = {}
		for j=1, rows do
			--map.layers[1][i][j] = {tileName = self.tileInfo.tileName, customData = {nav = self.nav}}
			map.layers[1][i][j] = {tileName = self:randomTile(validTypes).tileName, customData = {}}
		end
	end

	--self:buildRandomNavs(map, rows, columns, previousLocation, currentLocation)
	self:buildNavPoints(map, rows, columns, previousLocation, currentLocation)

	return map
end

function BulbMapGenerator:buildNavPoints(map, rows, columns, previousLocation, currentLocation)
	function hasNavToCurrentLocation(x, y)
		local tempNextDoor = bulbGameSettings:getTemporaryMap(x, y)
		return tempNextDoor and
			bulbGameSettings:hasNavTo(tempNextDoor, currentLocation.x, currentLocation.y)
	end

	math.randomseed(os.time())
	function randomNav()
		local val = math.floor(math.random()*4) ~= 1
		return val
	end

	local hasLeft = hasNavToCurrentLocation(currentLocation.x - 1, currentLocation.y) --left
	local hasRight = hasNavToCurrentLocation(currentLocation.x + 1, currentLocation.y) --right
	local hasTop = hasNavToCurrentLocation(currentLocation.x, currentLocation.y - 1) --top
	local hasBottom = hasNavToCurrentLocation(currentLocation.x, currentLocation.y + 1) --bottom

	hasLeft = hasLeft or randomNav()
	hasRight = hasRight or randomNav()
	hasTop = hasTop or randomNav()
	hasBottom = hasBottom or randomNav()

	-- 1,1 to 1,0 is ALWAYS the exit to the garden
	if (currentLocation.x == 1 and currentLocation.y == 1) then
		hasBottom = false
		map.layers[1][math.floor(columns/2)][rows] =
		{tileName = "nav", customData =
			{nav = "bulb_game_scene",
			metaLocation = {x = currentLocation.x, y = currentLocation.y - 1}}}
	end


	function prevLocationOrNil(from)
		if from then 
			return previousLocation.name
		else
			return nil -- "bulb_forest_scene"
		end
	end

	if (hasTop) then
		map.layers[1][math.floor(columns/2)][1] =
		{tileName = "nav", customData =
			{nav = prevLocationOrNil(fromBottom),
			metaLocation = {x = currentLocation.x, y = currentLocation.y + 1}}}
	end
	if (hasBottom) then
		map.layers[1][math.floor(columns/2)][rows] =
		{tileName = "nav", customData =
			{nav = prevLocationOrNil(fromTop),
			metaLocation = {x = currentLocation.x, y = currentLocation.y - 1}}}
	end
	if (hasLeft) then
		map.layers[1][1][math.floor(rows/2)] =
		{tileName = "nav", customData =
			{nav = prevLocationOrNil(fromRight),
			metaLocation = {x = currentLocation.x - 1, y = currentLocation.y}}}
	end
	if (hasRight) then
		map.layers[1][columns][math.floor(rows/2)] =
		{tileName = "nav", customData =
			{nav = prevLocationOrNil(fromLeft),
			metaLocation = {x = currentLocation.x + 1, y = currentLocation.y}}}
	end
end

-- build random navigation points, but always have one leading back to where you came from
function BulbMapGenerator:buildRandomNavs(map, rows, columns, previousLocation, currentLocation)
	local fromBottom = previousLocation.y == rows
	local fromTop = previousLocation.y == 1
	local fromRight = previousLocation.x == columns
	local fromLeft = previousLocation.x == 1

	local hasTop = previousLocation.y == rows or math.floor(math.random()*4) == 1
	local hasBottom = previousLocation.y == 1 or math.floor(math.random()*4) == 1
	local hasLeft = previousLocation.x == columns or math.floor(math.random()*4) == 1
	local hasRight = previousLocation.x == 1 or math.floor(math.random()*4) == 1

	hasTop = true
	hasBottom = true
	hasLeft = true
	hasRight = true

	function prevLocationOrNil(from)
		if from then 
			return previousLocation.name
		else
			return nil -- "bulb_forest_scene"
		end
	end

	--	map.layers[1][math.floor(columns/2)][rows] = {tileName = "nav", customData = {nav = "bulb_game_scene"}}
	if (hasTop) then
		map.layers[1][math.floor(columns/2)][1] =
		{tileName = "nav", customData =
			{nav = prevLocationOrNil(fromBottom),
			metaLocation = {x = currentLocation.x, y = currentLocation.y + 1}}}
	end
	if (hasBottom) then
		map.layers[1][math.floor(columns/2)][rows] =
		{tileName = "nav", customData =
			{nav = prevLocationOrNil(fromTop),
			metaLocation = {x = currentLocation.x, y = currentLocation.y - 1}}}
	end
	if (hasLeft) then
		map.layers[1][1][math.floor(rows/2)] =
		{tileName = "nav", customData =
			{nav = prevLocationOrNil(fromRight),
			metaLocation = {x = currentLocation.x - 1, y = currentLocation.y}}}
	end
	if (hasRight) then
		map.layers[1][columns][math.floor(rows/2)] =
		{tileName = "nav", customData =
			{nav = prevLocationOrNil(fromLeft),
			metaLocation = {x = currentLocation.x + 1, y = currentLocation.y}}}
	end
end

function BulbMapGenerator:randomTile(specialValidTypes)
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

	validTypes = specialValidTypes or validTypes

	return bulbBuilderSettings.types[validTypes[math.floor(math.random() * #validTypes) + 1]]
end