require("class")

BulbPlayer = class(function(c)
	c.itemBag = {}

	for k, v in pairs(bulbGameSettings.types) do
	    c.itemBag[k] = { name=k, inventory=math.random(30) }
	end
	
	c.events = {}
end)

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

function BulbPlayer:dispatchEvent(data)
	if (self.events[data.name]) then
		for i=1, #self.events[data.name] do
			self.events[data.name][i][data.name](self.events[data.name][i], data)
		end
	end
end