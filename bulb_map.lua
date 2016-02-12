require("class")
require("bulb_farm_tile")
require("bulb_navigation_tile")

BulbMap = class(function(c, width, height, rows, columns)
	c.width = width
	c.height = height
	c.rows = rows
	c.columns = columns
	c.tileSize = c.height/rows
	c.layers = {}
	c.layerGroups = {}
	c.events = {}
	c.lastTouch = {}
	c.tileGroup = nil
	c.navigationTiles = {}
	c.navigationTiles[1] = {i=1, j=8, nav="bulb_home_scene"}
	c.navigationTiles[2] = {i=9, j=1, nav="bulb_forest_scene"}
end)

function BulbMap:create(group)
	self.tileGroup = display.newGroup()
	self.layerGroups[1] = display.newGroup()
	self.layerGroups[2] = display.newGroup()
	self.layers[1] = {}
	self.layers[2] = {}


	local loadedData = savingContainer:loadFile(bulbGameSettings.gardenFileName)	
	self:loadMapFromData(loadedData)

	for k=1, #self.navigationTiles do
		local tile = self.navigationTiles[k]
		self.layers[2][tile.i][tile.j] = BulbNavigationTile(tile.i, tile.j,
			(tile.i-1) * self.tileSize, (tile.j-1) * self.tileSize,
			self.tileSize, tile.nav)
		self.layers[2][tile.i][tile.j]:create(self.layerGroups[2])
	end

	self.tileGroup:addEventListener("touch", self)

	for a=1, #self.layerGroups do
		self.tileGroup:insert(self.layerGroups[a])
	end
	group:insert(self.tileGroup)
end

function BulbMap:loadMapFromData( data )
	local hasData = not data.failure

	for i=1, self.columns do
		self.layers[1][i] = {}
		self.layers[2][i] = {}
		for j=1, self.rows do
			local tileInfo = nil
			local saveData = nil
			if (hasData) then
				tileInfo = bulbGameSettings:getItemByName(data.layers[1][i][j].tileName)
				saveData = data.layers[1][i][j]
			end

			self.layers[1][i][j] = BulbFarmTile(i, j,
				(i-1) * self.tileSize,(j-1) * self.tileSize, self.tileSize)
			self.layers[1][i][j]:create(self.layerGroups[1], tileInfo, saveData)

			self.layers[2][i][j] = nil
		end
	end
end

function BulbMap:update()
	for k=1, #self.layers do
		for i=1, #self.layers[k] do
			for j=1, #self.layers[k][i] do
				if (self.layers[k][i][j]) then
					self.layers[k][i][j]:update()
				end
			end
		end
	end
end

function BulbMap:getSaveData()
	local saveData = {}
	saveData.layers = {}
	saveData.layers[1] = {}
	for i=1, self.columns do
		saveData.layers[1][i] = {}
		for j=1, self.rows do
			saveData.layers[1][i][j] = self.layers[1][i][j]:getSaveData()
		end
	end

	return saveData
end

function BulbMap:getTileSize( )
	return self.tileSize
end

function BulbMap:getPlayerStartLocation()
	return self.playerStartLocation
end

-- locationObject must have i and j
function BulbMap:convertMapLocationToDisplayLocation( locationObject )
	local displayLocation = {}
	displayLocation.x = (locationObject.i - 1) * self.tileSize;
	displayLocation.y = (locationObject.j - 1) * self.tileSize;
	return displayLocation;
end

-- locationObject must have x and y
function BulbMap:convertDisplayLocationToMapLocation( locationObject )
	local displayLocation = {}
	displayLocation.i = math.floor(locationObject.x / self.tileSize) - 1;
	displayLocation.j = math.floor(locationObject.y / self.tileSize) - 1;
	return displayLocation;
end

function BulbMap:plant(i, j, plantInfo)
	self.layers[1][i][j]:removeSelf()
	self.layers[1][i][j] = nil
	self.layers[1][i][j] = BulbFarmTile(i, j, (i-1) * self.tileSize, (j-1) * self.tileSize, self.tileSize)
	self.layers[1][i][j]:create(self.layerGroups[1], plantInfo)
end

function BulbMap:canPlant(i, j, type)
	return self.layers[1][i][j].type == nil
end

function BulbMap:canHarvest(i, j)
	return self.layers[1][i][j].state == "harvestable"
end

function BulbMap:harvest(i, j)
	local plantType = self.layers[1][i][j].plantInfo.tileName
	self:plant(i, j, nil)
	return plantType
end

function BulbMap:getNavigation(i, j)
	for k=1, #self.navigationTiles do
		if (i == self.navigationTiles[k].i and
			j == self.navigationTiles[k].j) then
			return self.navigationTiles[k].nav
		end
	end
end

function BulbMap:isNewGridTouch( i, j )
	local returnValue = (i ~= self.lastTouch.i) or (j ~= self.lastTouch.j)
	return returnValue
end

function BulbMap:touch(event)
	local i = math.floor(event.x/self.tileSize) + 1
	local j = math.floor(event.y/self.tileSize) + 1
	if ( event.phase == "began" or
			(event.phase == "moved" and
				self:isNewGridTouch(i, j))) then
		self.lastTouch = {
			i = i,
			j = j
		}
		selectTileEvent = {
			name = "selectTile",
			i = i,
			j = j
		}
		self:dispatchEvent(selectTileEvent)
	end
end

function BulbMap:addEventListener(type, object)
	if (not self.events[type]) then
		self.events[type] = {}
	end
	self.events[type][#self.events[type] + 1] = object
end

function BulbMap:dispatchEvent(data)
	if (self.events[data.name]) then
		for i=1, #self.events[data.name] do
			self.events[data.name][i][data.name](self.events[data.name][i], data)
		end
	end
end

function BulbMap:removeSelf()
	for k=1, #self.layers do
		for i=1, #self.layers[k] do
			for j=1, #self.layers[k][i] do
				if (self.layers[k][i][j]) then
					self.layers[k][i][j]:removeSelf()
				end
				self.layers[k][i][j] = nil
			end
			self.layers[k][i] = nil
		end
		self.layers[k] = nil
	end
	self.layers = nil
	
	for a=1, #self.layerGroups do
		self.layerGroups[a]:removeSelf()
		self.layerGroups[a] = nil
	end
	self.layerGroups = nil

	self.tileGroup:removeSelf()
	self.tileGroup = nil
end
