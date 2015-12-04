require("class")
require("bulb_forest_tile")

BulbForestMap = class(function(c, width, height, rows, columns)
	c.width = width
	c.height = height
	c.rows = rows
	c.columns = columns
	c.tileSize = c.height/rows
	c.layers = {}
	c.events = {}
	c.lastTouch = {}
	c.tileGroup = nil
	c.playerStartLocation = {}
	c.enemies = {}
end)

function BulbForestMap:create(group)
	self.tileGroup = display.newGroup()
	self.layers[1] = {}
	for i=1, self.columns do
		self.layers[1][i] = {}
		for j=1, self.rows do
			self.layers[1][i][j] = BulbForestTile(i, j, (i-1) * self.tileSize, (j-1) * self.tileSize, self.tileSize)
			self.layers[1][i][j]:create(self.tileGroup)
		end
	end

	self.tileGroup:addEventListener("touch", self)
	group:insert(self.tileGroup)
end


function BulbForestMap:update()
	-- for i=1, #self.layers[1] do
	-- 	for j=1, #self.layers[1][i] do
	-- 		self.layers[1][i][j]:update()
	-- 	end
	-- end
end

function BulbForestMap:loadMapFromData( data )
	self.mapName = data.mapName
	self.fileName = data.fileName
	for i=1, self.columns do
		for j=1, self.rows do
			if (data.layers[1][i][j].tileName == "player") then
				self.playerStartLocation = {i=i, j=j}
			elseif (data.layers[1][i][j].isEnemy) then
				self.enemies[#self.enemies + 1] = {i=i, j=j, tileInfo=data.layers[1][i][j]}
			else
				self:placeTile(i, j, data.layers[1][i][j])
			end
		end
	end
end

function BulbForestMap:getEnemies()
	return self.enemies
end

function BulbForestMap:placeTile(i, j, tileInfo)
	self.layers[1][i][j]:removeSelf()
	self.layers[1][i][j] = nil
	self.layers[1][i][j] = BulbForestTile(i, j, (i-1) * self.tileSize, (j-1) * self.tileSize, self.tileSize)
	self.layers[1][i][j]:create(self.tileGroup, tileInfo)
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

function BulbForestMap:openToPlayer(location)
	-- TALK ABOUT THIS ON NEXT STREAM
	-- PLAYERS ARE CONSTRAINED BY WHERE THEY CAN CLICK, ENEMIES AREN'T
	-- IF IT'S OUT OF BOUNDS, THE ANSWER IS NO
	if (location.i < 1 or location.i > self.columns) then
		return false
	elseif (location.j < 1 or location.j > self.rows) then
		return false
	end

	local goalTile = self.layers[1][location.i][location.j].tileInfo
	return goalTile.walkable
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
	if (self.layers[1]) then
		for i=1, #self.layers[1] do
			for j=1, #self.layers[1][i] do
				self.layers[1][i][j]:removeSelf()
				self.layers[1][i][j] = nil
			end
		end
	end
end