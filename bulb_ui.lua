require("class")
require("bulb_store_item")

BulbUI = class(function(c, x, y, width, height, itemNumber)
	c.x = x
	c.y = y
	c.width = width
	c.height = height
	c.itemNumber = itemNumber
	c.itemHeight = height/itemNumber
	c.items = nil
	c.events = {}
end)

function BulbUI:create(group)
	items = {}
	for i=1, self.itemNumber do
		local y = self.y + ((i-1) * self.itemHeight)
		local bulbStoreItem = BulbStoreItem(self.x, y, self.width, self.itemHeight, i, self.plantingFunction)
		bulbStoreItem:create(group)
	end
	local plantEvent = {
		name = "select_plant",
		test = "winning!"
	}
	self:dispatchEvent(plantEvent)
end

function BulbUI:addEventListener(type, object)
	if (not self.events[type]) then
		self.events[type] = {}
	end
	self.events[type][#self.events[type] + 1] = object
end

function BulbUI:dispatchEvent(data)
	print("dispatching...", data.name)
	if (self.events[data.name]) then
		for i=1, #self.events[data.name] do
			self.events[data.name][i][data.name]({test=1})
		end
	end
end