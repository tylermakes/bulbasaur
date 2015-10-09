require("class")
require("bulb_store_item")

BulbUI = class(function(c, player, x, y, width, height, itemNumber)
	c.x = x
	c.y = y
	c.player = player
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
		local bulbStoreItem = BulbStoreItem(self.x, y, self.width, self.itemHeight, i,
								self.player.itemBag[i].name, self.player.itemBag[i].inventory, self)
		bulbStoreItem:create(group)
		items[#items + 1] = bulbStoreItem
	end
	self.items = items
	self.player:addEventListener("itemUsed", self)
end

function BulbUI:itemUsed(event)
	self.items[event.type]:updateInventory(event.newValue)
end

function BulbUI:addEventListener(type, object)
	if (not self.events[type]) then
		self.events[type] = {}
	end
	self.events[type][#self.events[type] + 1] = object
end

function BulbUI:dispatchEvent(data)
	if (self.events[data.name]) then
		for i=1, #self.events[data.name] do
			self.events[data.name][i][data.name](self.events[data.name][i], data)
		end
	end
end

function BulbUI:plantingFunction(itemType)
	plantEvent = {
		name = "selectPlant",
		type = itemType
	}

	BulbUI.dispatchEvent(self, plantEvent)
end