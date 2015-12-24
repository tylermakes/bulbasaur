require("class")

BulbEnemy = class(function(c, map, enemyInfo)
	c.events = {}
	c.map = map
	c.enemyView = nil
	c.tileInfo = enemyInfo.tileInfo
	if (map) then
		c.size = map:getTileSize()
		c.location = {i=enemyInfo.i, j=enemyInfo.j}
		c.targetLocation = c.location
	end
	c.aiStrategy = bulbBuilderSettings:getStrategyForEnemy(c.tileInfo.tileName)
	c.aiStrategy:create(map, c)
end)

function BulbEnemy:create(group)
	local displayLocation = self.map:convertMapLocationToDisplayLocation(self.location);
	
	if (self.map) then
		local enemyView = display.newRect( 0, 0, self.size, self.size )
		enemyView:setFillColor( self.tileInfo.color.r, self.tileInfo.color.g, self.tileInfo.color.b )

		enemyView.anchorX = 0;
		enemyView.anchorY = 0;
		enemyView.x = displayLocation.x;
		enemyView.y = displayLocation.y;
		self.enemyView = enemyView
		group:insert(self.enemyView)
	end
end

function BulbEnemy:update(player)
	self.targetLocation = self.aiStrategy:getNextLocation(player)
	--print(self.targetLocation.i, self.targetLocation.j)
	local newLocation = {i=self.location.i, j=self.location.j}
	if (newLocation.i < self.targetLocation.i) then
		newLocation.i = newLocation.i + 1
	elseif (newLocation.i > self.targetLocation.i) then
		newLocation.i = newLocation.i - 1
	elseif (newLocation.j < self.targetLocation.j) then
		newLocation.j = newLocation.j + 1
	elseif (newLocation.j > self.targetLocation.j) then
		newLocation.j = newLocation.j - 1
	end

	if (self.map:openToPlayer(newLocation)) then
		self.location = newLocation
	end
	self:updateViewLocation()
end

function BulbEnemy:updateViewLocation()
	local newLocation = self.map:convertMapLocationToDisplayLocation(self.location)
	self.enemyView.x = newLocation.x
	self.enemyView.y = newLocation.y
end

function BulbEnemy:setTargetLocation(event)
	if (self.location.i == event.x or self.location.j == event.y) then
		self.targetLocation = {i=event.x, j=event.y}
	end
end

function BulbEnemy:addItem(type, num)
	self.itemBag[type].inventory = self.itemBag[type].inventory + num
	itemUsedEvent = {
		name ="itemUpdated",
		status = "added",
		type = type,
		newValue = self.itemBag[type].inventory
	}
	self:dispatchEvent(itemUsedEvent)
end

function BulbEnemy:addEventListener(type, object)
	if (not self.events[type]) then
		self.events[type] = {}
	end
	self.events[type][#self.events[type] + 1] = object
end

function BulbEnemy:removeEventListener(type, object)
	for k, v in pairs(self.events) do
		for i=1, #v do
			self.events[k][i] = nil
		end
		self.events[k] = nil
	end
	self.events = nil
end

function BulbEnemy:dispatchEvent(data)
	if (self.events[data.name]) then
		for i=1, #self.events[data.name] do
			self.events[data.name][i][data.name](self.events[data.name][i], data)
		end
	end
end

function BulbEnemy:removeSelf( )
	if (self.enemyView) then
		self.enemyView:removeSelf()
		self.enemyView = nil
	end
end