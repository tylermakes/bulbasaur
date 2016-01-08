require("class")
require("bulb_forest_tile")

BulbBuilderMap = class(function(c, width, height, rows, columns)
	c.width = width
	c.height = height
	c.rows = rows
	c.columns = columns
	c.tileSize = c.height/rows
	c.layers = {}
	c.events = {}
	c.lastTouch = {}
	c.tileGroup = nil
	c.mapName = nil
	c.fileName = nil
end)

function BulbBuilderMap:create(group)
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

function BulbBuilderMap:getSaveData()
	local saveData = {}
	saveData.mapName = self.mapName
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

function BulbBuilderMap:loadMapFromData( data )
	self.mapName = data.mapName
	self.fileName = data.fileName
	for i=1, self.columns do
		for j=1, self.rows do
			local tileInfo = bulbBuilderSettings:getItemByName(data.layers[1][i][j].tileName)
			local customData = data.layers[1][i][j].customData
			self:placeTile(i, j, tileInfo, customData)
		end
	end
end

function BulbBuilderMap:update()
	-- for i=1, #self.layers[1] do
	-- 	for j=1, #self.layers[1][i] do
	-- 		self.layers[1][i][j]:update()
	-- 	end
	-- end
end

function BulbBuilderMap:clear()
	for i=1, self.columns do
		for j=1, self.rows do
			self:placeTile(i, j, nil)
		end
	end
end

-- function to handle all special tile types... validate/cleanup
function BulbBuilderMap:handleSpecialTile(i, j, tileInfo)
	if (tileInfo and tileInfo.tileName == "player") then
		for i=1, self.columns do
			for j=1, self.rows do
				if (self.layers[1][i][j].tileInfo.tileName == "player") then
					self:placeTile(i, j, nil)
				end	
			end
		end
	end
end

function BulbBuilderMap:placeTile(i, j, tileInfo, customData)
	self:handleSpecialTile(i, j, tileInfo)
	self.layers[1][i][j]:removeSelf()
	self.layers[1][i][j] = nil
	self.layers[1][i][j] = BulbForestTile(i, j, (i-1) * self.tileSize, (j-1) * self.tileSize, self.tileSize)
	self.layers[1][i][j]:create(self.tileGroup, tileInfo, customData)
end

function BulbBuilderMap:isNewGridTouch( i, j )
	local returnValue = (i ~= self.lastTouch.i) or (j ~= self.lastTouch.j)
	return returnValue
end

function BulbBuilderMap:touch(event)
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
			name = "placeTile",
			x = i,
			y = j
		}
		self:dispatchEvent(selectTileEvent)
	end
end

function BulbBuilderMap:setNavLocation( location, navLocation )
	local tile = self:getTile(location)
	tile:setNavLocation(navLocation)
end

function BulbBuilderMap:getTile(location)
	if (location.i < 1 or location.i > self.columns) then
		return nil
	elseif (location.j < 1 or location.j > self.rows) then
		return nil
	end

	return self.layers[1][location.i][location.j]
end

function BulbBuilderMap:addEventListener(type, object)
	if (not self.events[type]) then
		self.events[type] = {}
	end
	self.events[type][#self.events[type] + 1] = object
end

function BulbBuilderMap:dispatchEvent(data)
	if (self.events[data.name]) then
		for i=1, #self.events[data.name] do
			self.events[data.name][i][data.name](self.events[data.name][i], data)
		end
	end
end

function BulbBuilderMap:removeSelf()
	if (self.layers[1]) then
		for i=1, #self.layers[1] do
			for j=1, #self.layers[1][i] do
				self.layers[1][i][j]:removeSelf()
				self.layers[1][i][j] = nil
			end
		end
	end
end