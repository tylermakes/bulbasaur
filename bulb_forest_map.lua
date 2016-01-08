require("class")
require("bulb_forest_tile")

BulbForestMap = class(function(c, width, height, rows, columns)
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
	c.playerStartLocation = {}
	c.enemies = {}
	c.navBackLocation = nil
end)

function BulbForestMap:create(group)
	self.tileGroup = display.newGroup()
	self.layerGroups[1] = display.newGroup()
	self.layerGroups[2] = display.newGroup()
	self.layers[1] = {}
	self.layers[2] = {}

	for i=1, self.columns do
		self.layers[1][i] = {}
		self.layers[2][i] = {}
		for j=1, self.rows do
			self.layers[1][i][j] = BulbForestTile(i, j,
				(i-1) * self.tileSize, (j-1) * self.tileSize, self.tileSize)
			self.layers[1][i][j]:create(self.layerGroups[1])

			self.layers[2][i][j] = nil
		end
	end

	self.tileGroup:addEventListener("touch", self)

	for a=1, #self.layerGroups do
		self.tileGroup:insert(self.layerGroups[a])
	end
	group:insert(self.tileGroup)
end


function BulbForestMap:update()
	-- for i=1, #self.layers[1] do
	-- 	for j=1, #self.layers[1][i] do
	-- 		self.layers[1][i][j]:update()
	-- 	end
	-- end
end

function BulbForestMap:loadMapFromData( data, previousScene )
	self.mapName = data.mapName
	self.fileName = data.fileName
	print("==========================")
	for i=1, self.columns do
		for j=1, self.rows do
			local newTile = bulbBuilderSettings:getItemByName(data.layers[1][i][j].tileName)
			local customData = data.layers[1][i][j].customData
			print(newTile.nav, previousScene)
			if (newTile.tileName == "nav" and newTile.nav == previousScene) then
				self.navBackLocation = {i=i, j=j}
			end
			if (newTile.tileName == "player") then
				self.playerStartLocation = {i=i, j=j}
			elseif (newTile.isEnemy) then
				self.enemies[#self.enemies + 1] = {i=i, j=j, tileInfo=newTile}
			else
				self:placeTile(i, j, newTile, customData)
			end
		end
	end
	-- NO START FOUND, USE NAV BACK LOCATION
	if (not (self.playerStartLocation and self.playerStartLocation.i and self.playerStartLocation.j)) then
		if (self.navBackLocation) then
			self.playerStartLocation = self.navBackLocation
		else
			self.playerStartLocation = {i=1, j=1}
		end
	end
end

function BulbForestMap:getEnemies()
	return self.enemies
end

function BulbForestMap:placeTile(i, j, tileInfo, customData)
	self.layers[1][i][j]:removeSelf()
	self.layers[1][i][j] = nil
	self.layers[1][i][j] = BulbForestTile(i, j, (i-1) * self.tileSize, (j-1) * self.tileSize, self.tileSize)
	self.layers[1][i][j]:create(self.layerGroups[1], tileInfo, customData)
end

function BulbForestMap:isNewGridTouch( i, j )
	local returnValue = (i ~= self.lastTouch.i) or (j ~= self.lastTouch.j)
	return returnValue
end

function BulbForestMap:getPlayerStartLocation()
	return self.playerStartLocation
end

function BulbForestMap:getTileSize( )
	return self.tileSize
end

function BulbForestMap:triggerLocation( location )
	local tile = self:getTile(location)
	local locationEvent = nil
	if (tile.tileInfo.nav) then
		locationEvent = {
			name = "navigate",
			nav = tile.nav
		}
	end
	if (locationEvent) then
		self:dispatchEvent(locationEvent)
	end
end

function BulbForestMap:touch(event)
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
			name = "touchTile",
			x = i,
			y = j
		}
		self:dispatchEvent(selectTileEvent)
	end
end

-- locationObject must have i and j
function BulbForestMap:convertMapLocationToDisplayLocation( locationObject )
	local displayLocation = {}
	displayLocation.x = (locationObject.i - 1) * self.tileSize;
	displayLocation.y = (locationObject.j - 1) * self.tileSize;
	return displayLocation;
end

-- locationObject must have x and y
function BulbForestMap:convertDisplayLocationToMapLocation( locationObject )
	local displayLocation = {}
	displayLocation.i = math.floor(locationObject.x / self.tileSize) - 1;
	displayLocation.j = math.floor(locationObject.y / self.tileSize) - 1;
	return displayLocation;
end

function BulbForestMap:getNeighbors( location )
	local newLocations = {}
	newLocations[#newLocations + 1] = {i=location.i-1, j=location.j} --left
	newLocations[#newLocations + 1] = {i=location.i+1, j=location.j} --right
	newLocations[#newLocations + 1] = {i=location.i, j=location.j-1} --up
	newLocations[#newLocations + 1] = {i=location.i, j=location.j+1} --down

	local neighbors = {}
	for i=1, #newLocations do
		if (self:openToPlayer(newLocations[i])) then
			neighbors[#neighbors + 1] = newLocations[i]
		end
	end

	return neighbors
end

function BulbForestMap:getCost( current, next )
	local nextTile = self:getTile(next)
	local cost = 1
	if (nextTile and nextTile.tileInfo) then
		cost = nextTile.tileInfo.walkable
	end

	return cost
end

function BulbForestMap:heuristic( goal, next )
	return math.abs(goal.i - next.i) + math.abs(goal.j - next.j)
end

function BulbForestMap:getTile(location)
	if (location.i < 1 or location.i > self.columns) then
		return nil
	elseif (location.j < 1 or location.j > self.rows) then
		return nil
	end

	return self.layers[1][location.i][location.j]
end

function BulbForestMap:openToPlayer(location)
	local tile = self:getTile(location)
	local open = false
	if (tile ~= nil and tile.tileInfo.walkable) then
		open = tile.tileInfo.walkable > 0
	end

	return open
end

function BulbForestMap:addEventListener(type, object)
	if (not self.events[type]) then
		self.events[type] = {}
	end
	self.events[type][#self.events[type] + 1] = object
end

function BulbForestMap:dispatchEvent(data)
	if (self.events[data.name]) then
		for i=1, #self.events[data.name] do
			self.events[data.name][i][data.name](self.events[data.name][i], data)
		end
	end
end

function BulbForestMap:removeSelf()
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