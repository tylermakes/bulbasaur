require("class")
require("bulb_builder_store_item")
require("bulb_store_tool")
require("bulb_color")
local widget = require "widget"

BulbBuilderUI = class(function(c, navigation, x, y, width, height, itemNumber)
	c.x = x
	c.y = y
	c.width = width
	c.height = height
	c.itemNumber = itemNumber
	c.itemHeight = height/itemNumber
	c.items = nil
	c.tools = nil
	c.events = {}
	c.navigation = navigation
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

	local homeView = BulbStoreTool(0, self.y, self.width, self.itemHeight, self.navigation, self)
	homeView:create(self.scrollView, self.scrollView)
	tools[1] = homeView

	local save = {tileName="save", color=BulbColor(0.6, 0.6, 0.4)}
	local saveView = BulbStoreTool(0, self.y + self.itemHeight, self.width, self.itemHeight, save, self)
	saveView:create(self.scrollView, self.scrollView)
	tools[2] = saveView

	local load = {tileName="load", color=BulbColor(0.6, 0.4, 0.6)}
	local loadView = BulbStoreTool(0, self.y + self.itemHeight*#tools, self.width, self.itemHeight, load, self)
	loadView:create(self.scrollView, self.scrollView)
	tools[3] = loadView

	local clear = {tileName="clear", color=BulbColor(0.2, 0.4, 0.2)}
	local clearView = BulbStoreTool(0, self.y + self.itemHeight*#tools, self.width, self.itemHeight, clear, self)
	clearView:create(self.scrollView, self.scrollView)
	tools[4] = clearView

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
	for i=0, #self.tools do
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