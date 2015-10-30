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

function BulbBuilderMap:update()
	-- for i=1, #self.layers[1] do
	-- 	for j=1, #self.layers[1][i] do
	-- 		self.layers[1][i][j]:update()
	-- 	end
	-- end
end

function BulbBuilderMap:placeTile(i, j, tileInfo)
	self.layers[1][i][j]:removeSelf()
	self.layers[1][i][j] = nil
	self.layers[1][i][j] = BulbForestTile(i, j, (i-1) * self.tileSize, (j-1) * self.tileSize, self.tileSize)
	self.layers[1][i][j]:create(self.tileGroup, tileInfo)
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