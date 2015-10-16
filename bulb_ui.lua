require("class")
require("bulb_store_item")
require("bulb_store_tool")
require("bulb_color")

BulbUI = class(function(c, navigation, player, x, y, width, height, itemNumber)
	c.x = x
	c.y = y
	c.player = player
	c.width = width
	c.height = height
	c.itemNumber = itemNumber
	c.itemHeight = height/itemNumber
	c.items = nil
	c.tools = nil
	c.events = {}
	c.navigation = navigation
end)

function BulbUI:create(group)
	items = {}
	tools = {}

	local homeView = BulbStoreTool(self.x, self.y, self.width, self.itemHeight, self.navigation, self)
	homeView:create(group)
	tools[1] = homeView

	local shovel = {tileName="shovel", color=BulbColor(0.6, 0.6, 0.4)}
	local shovelView = BulbStoreTool(self.x, self.y + self.itemHeight, self.width, self.itemHeight, shovel, self)
	shovelView:create(group)
	tools[2] = shovelView

	local i = 0
	for k, v in pairs(self.player.itemBag) do
		local y = self.y + (i * self.itemHeight) + self.itemHeight*2
		local item = bulbGameSettings:getItemByName(k)
		local bulbStoreItem = BulbStoreItem(self.x, y, self.width, self.itemHeight, item,
								self.player.itemBag[item.tileName].inventory, self)
		bulbStoreItem:create(group)
		items[k] = bulbStoreItem
		i = i + 1
	end
	self.items = items
	self.tools = tools
	self.player:addEventListener("itemUpdated", self)
end

function BulbUI:itemUpdated(event)
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

function BulbUI:plantingFunction(item)
	plantEvent = {
		name = "selectPlant",
		item = item
	}

	BulbUI.dispatchEvent(self, plantEvent)
end

function BulbUI:selectTool(type)
	toolEvent = {
		name = "selectTool",
		type = type
	}

	BulbUI.dispatchEvent(self, toolEvent)
end

function BulbUI:removeSelf()
	for i=0, #self.tools do
		self.tools[i]:removeSelf()
		self.tools[i] = nil
	end
	for k, v in pairs(self.items) do
		self.items[k]:removeSelf()
		self.items[k] = nil
	end
end