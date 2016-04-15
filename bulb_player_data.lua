require("class")

BulbPlayerData = class(function(c, map)
	c.temporaryItems = {}
	c.itemBag = {}
	c.itemBag["blueberries"] = 5
	c.currentLocation = "garden"
	c.tileLocation = {x=1, y=1}
	c.shopItemsAvailable = {}
	c.shopItemsAvailable[1] = "strawberry"
	c.shopItemsAvailable[2] = "orange"
	c.shopItemsAvailable[3] = "avocado"
	c.shopItemsAvailable[4] = "blueberries"
	c.shopItemsAvailable[5] = "lemon"
	c.shopItemsAvailable[6] = "carrots"
	c.shopItemsAvailable[7] = "beets"
	c.shopItemsAvailable[8] = "peas"
	c.shopItemsAvailable[9] = "pineapple"
	c.shopItemsAvailable[10] = "asparagus"

	c.events ={}

	c.diedInForest = false;

	-- for k, v in pairs(bulbGameSettings.types) do
	-- 	c.itemBag[k] = { name=k, inventory=math.random(30) }
	-- end
end)

function BulbPlayerData:setupFromGameData(playerData)
	self.itemBag = playerData.inventory
	self.temporaryItems = playerData.temporaryItems
	self.currentLocation = playerData.currentLocation
	self.tileLocation = playerData.tileLocation
	self.shopItemsAvailable = playerData.shopItemsAvailable
end

function BulbPlayerData:updateLocation( location )
	self.tileLocation = location
	bulbGameSettings:saveGame()
end

function BulbPlayerData:update()
end

function BulbPlayerData:getGameData()
	return {inventory = self.itemBag,
			temporaryItems = self.temporaryItems,
			currentLocation = self.currentLocation,
			tileLocation = self.tileLocation,
			shopItemsAvailable = self.shopItemsAvailable}
end

function BulbPlayerData:keepTempItems()
	for k, v in pairs(self.temporaryItems) do
		if (self.itemBag[k]) then
			self.itemBag[k] = self.itemBag[k] + self.temporaryItems[k]
		else
			self.itemBag[k] = self.temporaryItems[k]
		end
		itemUsedEvent = {
			name ="itemUpdated",
			status = "added",
			type = k,
			temporary = false,
			newValue = self.itemBag[k]
		}
		
		self:dispatchEvent(itemUsedEvent)
	end
	self.temporaryItems = {}
	bulbGameSettings:saveGame()
end

function BulbPlayerData:deductItem(type, num, temporary)
	local newValue = -1
	if (temporary) then
		if (not self.temporaryItems[type]) then
			self.temporaryItems[type] = 0
		end
		self.temporaryItems[type] = self.temporaryItems[type] - num
		newValue = self.temporaryItems[type]
	else
		self.itemBag[type] = self.itemBag[type] - num
		newValue = self.itemBag[type]
	end
	itemUsedEvent = {
		name ="itemUpdated",
		status = "deducted",
		type = type,
		temporary = temporary,
		newValue = newValue
	}

	bulbGameSettings:saveGame()
	self:dispatchEvent(itemUsedEvent)
end

function BulbPlayerData:addItem(type, num, temporary)
	local newValue = -1
	if (temporary) then
		if (not self.temporaryItems[type]) then
			self.temporaryItems[type] = 0
			print("adding new temp items type")
		end
		self.temporaryItems[type] = self.temporaryItems[type] + num
		newValue = self.temporaryItems[type]
	else
		self.itemBag[type] = self.itemBag[type] + num
		newValue = self.itemBag[type]
	end
	itemUsedEvent = {
		name ="itemUpdated",
		status = "added",
		type = type,
		temporary = temporary,
		newValue = newValue
	}
	
	bulbGameSettings:saveGame()
	self:dispatchEvent(itemUsedEvent)
end

function BulbPlayerData:addEventListener(type, object)
	if (not self.events[type]) then
		self.events[type] = {}
	end
	self.events[type][#self.events[type] + 1] = object
end

function BulbPlayerData:removeEventListener(type, object)
	for k, v in pairs(self.events) do
		for i=1, #v do
			if (self.events[k][i] == object) then
				self.events[k][i] = nil
			end
		end
	end
end

function BulbPlayerData:dispatchEvent(data)
	if (self.events[data.name]) then
		for i=1, #self.events[data.name] do
			self.events[data.name][i][data.name](self.events[data.name][i], data)
		end
	end
end

function BulbPlayerData:removeAllEventListeners( )
	for k, v in pairs(self.events) do
		for i=1, #v do
			self.events[k][i] = nil
		end
		self.events[k] = nil
	end
	self.events = nil
	self.events = {}
end

function BulbPlayerData:removeSelf( )
	self:removeAllEventListeners()
end