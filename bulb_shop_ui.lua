require("class")
require("bulb_shop_item")
require("bulb_color")
local widget = require "widget"

BulbShopUI = class(function(c, x, y, width, height, itemNumber)
	c.x = x
	c.y = y
	c.width = width
	c.height = height
	c.itemNumber = itemNumber
	c.itemWidth = width/itemNumber
	c.items = nil
	c.events = {}
	c.totalUniqueShopItems = 0
end)

function BulbShopUI:create(group)

	local scrollView = widget.newScrollView( {
			width = self.width,
			height = self.height,
			verticalScrollDisabled = true,
			isBounceEnabled = false,
			backgroundColor = { 0.8, 0.4, 0.2 }
		} )
	scrollView.anchorX = 0
	scrollView.anchorY = 0
	scrollView.x = self.x
	scrollView.y = self.y
	self.scrollView = scrollView

	self.items = {}
	local itemHolder = bulbGameSettings.playerData.shopItemsAvailable
	print(#itemHolder)
	self.totalUniqueShopItems = 0
	for i, v in ipairs(itemHolder) do
		self:addShopItem(v, 9)
		self.totalUniqueShopItems = self.totalUniqueShopItems + 1
	end

	group:insert(self.scrollView)
	
	bulbGameSettings.playerData:addEventListener("itemUpdated", self)
end

function BulbShopUI:addShopItem(name, inventory)
	local x = self.x + (self.totalUniqueShopItems * self.itemWidth) + self.itemWidth
	local item = bulbGameSettings:getItemByName(name)
	local bulbShopItem = BulbShopItem(x, 0, self.itemWidth, self.height, item,
							inventory, self)
	bulbShopItem:create(self.scrollView, self.scrollView)
	self.items[name] = bulbShopItem
end

function BulbShopUI:itemUpdated(event)
	if (not self.items[event.type]) then
		self:addShopItem(event.type, event.newValue)
	end
	self.items[event.type]:updateInventory(event.newValue)
end

function BulbShopUI:addEventListener(type, object)
	if (not self.events[type]) then
		self.events[type] = {}
	end
	self.events[type][#self.events[type] + 1] = object
end

function BulbShopUI:dispatchEvent(data)
	if (self.events[data.name]) then
		for i=1, #self.events[data.name] do
			self.events[data.name][i][data.name](self.events[data.name][i], data)
		end
	end
end

function BulbShopUI:plantingFunction(item)
	plantEvent = {
		name = "selectPlant",
		item = item
	}

	BulbShopUI.dispatchEvent(self, plantEvent)
end

function BulbShopUI:removeAllEventListeners( )
	for k, v in pairs(self.events) do
		for i=1, #v do
			self.events[k][i] = nil
		end
		self.events[k] = nil
	end
	self.events = nil
	self.events = {}
end

function BulbShopUI:removeSelf()
	if (bulbGameSettings.playerData) then
		bulbGameSettings.playerData:removeEventListener("itemUpdated", self)
	end
	for k, v in pairs(self.items) do
		self.items[k]:removeSelf()
		self.items[k] = nil
	end
	if (self.scrollView) then
		self.scrollView:removeSelf()
		self.scrollView = nil
	end
	self:removeAllEventListeners()
end