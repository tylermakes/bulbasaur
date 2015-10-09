require("class")

BulbPlayer = class(function(c)
	c.itemBag = {}
	c.itemBag[1] = { name="test1", inventory=1 }
	c.itemBag[2] = { name="test2", inventory=23 }
	c.itemBag[3] = { name="test3", inventory=34 }
	c.itemBag[4] = { name="test4", inventory=4 }
	c.itemBag[5] = { name="test5", inventory=54 }
	c.itemBag[6] = { name="test6", inventory=3 }
	c.itemBag[7] = { name="test7", inventory=25 }
	c.itemBag[8] = { name="test8", inventory=63 }
	c.itemBag[9] = { name="test9", inventory=28 }
	c.itemBag[10] = { name="test10", inventory=8 }
	c.events = {}
end)

function BulbPlayer:deductItem(type, num)
	self.itemBag[type].inventory = self.itemBag[type].inventory - num
	itemUsedEvent = {
		name ="itemUsed",
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