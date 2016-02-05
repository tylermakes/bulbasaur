require("class")
require("bulb_builder_store_item")
require("bulb_store_tool")
require("bulb_color")
local widget = require "widget"

BulbBuilderUI = class(function(c, toolDefinitions, x, y, width, height, itemNumber)
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
end)

function BulbBuilderUI:create(group)
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

	for i=1, #bulbBuilderSettings.types do
		local y = self.y + ((i-1) * self.itemHeight) + self.itemHeight*#tools
		local item = bulbBuilderSettings:getItemById(i)
		local bulbBuilderStoreItem = BulbBuilderStoreItem(0, y, self.width, self.itemHeight, item, self)
		bulbBuilderStoreItem:create(self.scrollView, self.scrollView)
		items[i] = bulbBuilderStoreItem
		i = i + 1
	end
	self.items = items
	self.tools = tools

	group:insert(self.scrollView)
end

function BulbBuilderUI:addEventListener(type, object)
	if (not self.events[type]) then
		self.events[type] = {}
	end
	self.events[type][#self.events[type] + 1] = object
end

function BulbBuilderUI:dispatchEvent(data)
	if (self.events[data.name]) then
		for i=1, #self.events[data.name] do
			self.events[data.name][i][data.name](self.events[data.name][i], data)
		end
	end
end

function BulbBuilderUI:placingTileFunction(item)
	local placingTileEvent = {
		name = "selectTile",
		item = item
	}

	BulbBuilderUI.dispatchEvent(self, placingTileEvent)
end

function BulbBuilderUI:selectTool(type)
	local toolEvent = {
		name = "selectTool",
		type = type
	}

	BulbBuilderUI.dispatchEvent(self, toolEvent)
end

function BulbBuilderUI:removeSelf()
	if (self.tools) then
		for i=1, #self.tools do
			self.tools[i]:removeSelf()
			self.tools[i] = nil
		end
	end
	self.tools = nil
	if (self.items) then
		for k, v in pairs(self.items) do
			self.items[k]:removeSelf()
			self.items[k] = nil
		end
	end
	self.items = nil
	if (self.scrollView) then
		if (self.scrollView) then
			self.scrollView:removeSelf()
			self.scrollView = nil
		end
	end
end