require("class")
require("bulb_store_item")
require("bulb_store_tool")
require("bulb_color")
local widget = require "widget"

BulbUI = class(function(c, toolDefinitions, player, x, y, width, height, itemNumber)
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
	c.toolDefinitions = toolDefinitions
end)

function BulbUI:create(group)
	items = {}
	tools = {}

	local scrollView = widget.newScrollView( {
			width = self.width,
			height = self.height,
			horizontalScrollDisabled = true,
			isBounceEnabled = false
		} )
	scrollView.anchorX = 0
	scrollView.anchorY = 0
	scrollView.x = self.x
	scrollView.y = self.y
	self.scrollView = scrollView

	for j=1, #self.toolDefinitions do
		local toolDefinition = self.toolDefinitions[j]
		local toolView = BulbStoreTool(0, self.y + self.itemHeight*#tools, self.width, self.itemHeight, toolDefinition, self)
		toolView:create(self.scrollView, self.scrollView)
		tools[#tools+1] = toolView
	end

	local i = 0
	for k, v in pairs(self.player.itemBag) do
		local y = self.y + (i * self.itemHeight) + self.itemHeight*#tools
		local item = bulbGameSettings:getItemByName(k)
		local bulbStoreItem = BulbStoreItem(0, y, self.width, self.itemHeight, item,
								self.player.itemBag[item.tileName].inventory, self)
		bulbStoreItem:create(self.scrollView, self.scrollView)
		items[k] = bulbStoreItem
		i = i + 1
	end
	self.items = items
	self.tools = tools

	group:insert(self.scrollView)
	
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
	if (self.player) then
		self.player:removeEventListener("itemUpdated", self)
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
end