require("class")

BulbPlayer = class(function(c, map)
	c.itemBag = {}

	for k, v in pairs(bulbGameSettings.types) do
	    c.itemBag[k] = { name=k, inventory=math.random(30) }
	end
	
	c.events = {}
	c.map = map
	c.playerView = nil
	if (map) then
		c.playerSize = map:getTileSize()
		c.playerLocation = map:getPlayerStartLocation()
		c.playerTargetLocation = c.playerLocation
	end
end)

function BulbPlayer:create(group)
	local playerDisplayLocation = self.map:convertMapLocationToDisplayLocation(self.playerLocation);
	
	if (self.map) then
		local playerView = display.newRect( 0, 0, self.playerSize, self.playerSize )
		playerView:setFillColor( 1, 0.8, 0 )
		
		playerView.anchorX = 0;
		playerView.anchorY = 0;
		playerView.x = playerDisplayLocation.x;
		playerView.y = playerDisplayLocation.y;
		self.playerView = playerView
		group:insert(self.playerView)
	end
end

function BulbPlayer:update()
	--print(self.playerTargetLocation.i, self.playerTargetLocation.j)
	local newLocation = {i=self.playerLocation.i, j=self.playerLocation.j}
	if (newLocation.i < self.playerTargetLocation.i) then
		newLocation.i = newLocation.i + 1
	elseif (newLocation.i > self.playerTargetLocation.i) then
		newLocation.i = newLocation.i - 1
	elseif (newLocation.j < self.playerTargetLocation.j) then
		newLocation.j = newLocation.j + 1
	elseif (newLocation.j > self.playerTargetLocation.j) then
		newLocation.j = newLocation.j - 1
	end

	if (self.map:openToPlayer(newLocation)) then
		self.playerLocation = newLocation
	end
	self:updateViewLocation()
end

function BulbPlayer:updateViewLocation()
	local newLocation = self.map:convertMapLocationToDisplayLocation(self.playerLocation)
	self.playerView.x = newLocation.x
	self.playerView.y = newLocation.y
end

function BulbPlayer:setTargetLocation(event)
	print("trying to go to:", event.x, event.y)
	if (self.playerLocation.i == event.x or self.playerLocation.j == event.y) then
		self.playerTargetLocation = {i=event.x, j=event.y}
	end
end

function BulbPlayer:deductItem(type, num)
	self.itemBag[type].inventory = self.itemBag[type].inventory - num
	itemUsedEvent = {
		name ="itemUpdated",
		status = "deducted",
		type = type,
		newValue = self.itemBag[type].inventory
	}
	self:dispatchEvent(itemUsedEvent)
end

function BulbPlayer:addItem(type, num)
	self.itemBag[type].inventory = self.itemBag[type].inventory + num
	itemUsedEvent = {
		name ="itemUpdated",
		status = "added",
		type = type,
		newValue = self.itemBag[type].inventory
	}
	self:dispatchEvent(itemUsedEvent)
end

function BulbPlayer:addEventListener(type, object)
	if (not self.events[type]) then
		self.events[type] = {}
	end
	self.events[type][#self.events[type] + 1] = object
end

function BulbPlayer:removeEventListener(type, object)
	for k, v in pairs(self.events) do
		for i=1, #v do
			self.events[k][i] = nil
		end
		self.events[k] = nil
	end
	self.events = nil
end

function BulbPlayer:dispatchEvent(data)
	if (self.events[data.name]) then
		for i=1, #self.events[data.name] do
			self.events[data.name][i][data.name](self.events[data.name][i], data)
		end
	end
end

function BulbPlayer:removeSelf( )
	if (self.playerView) then
		self.playerView:removeSelf()
		self.playerView = nil
	end
end