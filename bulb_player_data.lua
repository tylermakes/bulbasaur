require("class")

BulbPlayerData = class(function(c, map)
	c.temporaryItems = {}
	c.itemBag = {}
	c.itemBag["blueberries"] = 5

	c.events ={}

	-- for k, v in pairs(bulbGameSettings.types) do
	-- 	c.itemBag[k] = { name=k, inventory=math.random(30) }
	-- end
end)

function BulbPlayerData:setupFromGameData(playerData)
	self.itemBag = playerData.inventory
	self.temporaryItems = playerData.temporaryItems
end

function BulbPlayerData:update()
end

function BulbPlayerData:getGameData()
	return {inventory=self.itemBag, temporaryItems=self.temporaryItems}
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

	savingContainer:save()
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
	
	savingContainer:save()
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