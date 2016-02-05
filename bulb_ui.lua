require("class")
require("bulb_store_item")
require("bulb_store_tool")
require("bulb_color")
local widget = require "widget"

BulbUI = class(function(c, toolDefinitions, x, y, width, height, itemNumber, temporary)
	c.x = x
	c.y = y
	c.width = width
	c.height = height
	c.itemNumber = itemNumber
	c.itemHeight = height/itemNumber
	c.items = nil
	c.tools = nil
	c.events = {}
	c.toolDefinitions = toolDefinitions
	c.temporary = temporary
	c.totalUniqueStoreItems = 0
end)

function BulbUI:create(group)

	local scrollView = widget.newScrollView( {
			width = self.width,
			height = self.height,
			horizontalScrollDisabled = true,
			isBounceEnabled = false,
			backgroundColor = { 0.8, 0.8, 0.8 }
		} )
	scrollView.anchorX = 0
	scrollView.anchorY = 0
	scrollView.x = self.x
	scrollView.y = self.y
	self.scrollView = scrollView

	self.tools = {}
	for j=1, #self.toolDefinitions do
		local toolDefinition = self.toolDefinitions[j]
		local toolView = BulbStoreTool(0, self.y + self.itemHeight*#self.tools, self.width, self.itemHeight, toolDefinition, self)
		toolView:create(self.scrollView, self.scrollView)
		self.tools[#self.tools+1] = toolView
	end

	self.items = {}
	local itemHolder = bulbGameSettings.playerData.itemBag
	if (self.temporary) then
		itemHolder = bulbGameSettings.playerData.temporaryItems
	end
	self.totalUniqueStoreItems = 0
	for k, v in pairs(itemHolder) do
		self:addStoreItem(k, v)
		self.totalUniqueStoreItems = self.totalUniqueStoreItems + 1
	end

	group:insert(self.scrollView)
	
	bulbGameSettings.playerData:addEventListener("itemUpdated", self)
end

function BulbUI:addStoreItem(name, inventory)
	local y = self.y + (self.totalUniqueStoreItems * self.itemHeight) + self.itemHeight*#self.tools
	local item = bulbGameSettings:getItemByName(name)
	local bulbStoreItem = BulbStoreItem(0, y, self.width, self.itemHeight, item,
							inventory, self)
	bulbStoreItem:create(self.scrollView, self.scrollView)
	self.items[name] = bulbStoreItem
end

function BulbUI:itemUpdated(event)
	print("updating: temporary?",self.temporary)
	if (not self.items[event.type]) then
		self:addStoreItem(event.type, event.newValue)
	end
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

function BulbUI:removeAllEventListeners( )
	for k, v in pairs(self.events) do
		for i=1, #v do
			self.events[k][i] = nil
		end
		self.events[k] = nil
	end
	self.events = nil
	self.events = {}
end

function BulbUI:removeSelf()
	if (bulbGameSettings.playerData) then
		bulbGameSettings.playerData:removeEventListener("itemUpdated", self)
	end
	for i=1, #self.tools do
		self.tools[i]:removeSelf()
		self.tools[i] = nil
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