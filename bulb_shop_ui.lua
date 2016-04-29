require("class")
require("bulb_shop_item")
require("bulb_shop_player_display")
require("bulb_shop_popup")
require("bulb_color")
local widget = require "widget"

BulbShopUI = class(function(c, x, y, width, height, columns, rows)
	c.x = x
	c.y = y
	c.width = width
	c.height = height
	c.rows = rows
	c.columns = columns
	c.itemWidth = width/columns
	c.itemHeight = height/rows
	c.items = nil
	c.shopPopup = nil
	c.playerDisplay = nil
	c.uiDisplayGroup = nil
	c.events = {}
end)

function BulbShopUI:create(group)
	self.uiDisplayGroup = display.newGroup()

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
	for i, v in ipairs(itemHolder) do
		self:addShopItem(v, i)
	end

	self.uiDisplayGroup:insert(self.scrollView)
	group:insert(self.uiDisplayGroup)

	local playerDisplay = BulbShopPlayerDisplay(self.width - 400, self.height - 50, 400, 50)
	playerDisplay:create(group)
	self.playerDisplay = playerDisplay
	
	bulbGameSettings.playerData:addEventListener("itemUpdated", self)
end

function BulbShopUI:addShopItem(name, numberInStore)
	local itemColumn = numberInStore % self.rows
	local itemRow = math.floor(numberInStore / self.rows)
	local y = self.y + itemColumn * self.itemHeight
	local x = self.x + itemRow * self.itemWidth
	local item = bulbGameSettings:getItemByName(name)
	local inventory = bulbGameSettings.playerData.itemBag[name] or 0
	local bulbShopItem = BulbShopItem(x, y, self.itemWidth, self.itemHeight,
							item, inventory, self)
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

function BulbShopUI:acceptShopPopup(evt)
	self:clearShopPopup()
	if (evt.amount > 0) then
		if (evt.action == "SELL") then
			bulbGameSettings.playerData:addMoney(evt.amount * evt.worth)
			bulbGameSettings.playerData:deductItem(evt.item, evt.amount)
		elseif (evt.action == "BUY") then
			bulbGameSettings.playerData:subtractMoney(evt.amount * evt.cost)
			bulbGameSettings.playerData:addItem(evt.item, evt.amount)
		end
		self:updatePlayerDisplay()
	end
end

function BulbShopUI:updatePlayerDisplay()
	self.playerDisplay:update()
end

function BulbShopUI:clearShopPopup()
	if (self.shopPopup) then
		self.shopPopup:removeSelf()
		self.shopPopup = nil
	end
end

function BulbShopUI:buyingOrSellingFunction(item, action, total, cost, worth)
	print(action, ":", item, ", ", total, " c:", cost, " w:", worth)

	local popupTitle = action..": "..item.."?"

	self:clearShopPopup()
	self.shopPopup = BulbShopPopup(self.width, self.height, popupTitle, item, action, total, cost, worth)
	self.shopPopup:create(self.uiDisplayGroup)
	self.shopPopup:addEventListener("acceptShopPopup", self)
	self.shopPopup:addEventListener("clearShopPopup", self)

	-- plantEvent = {
	-- 	name = "selectPlant",
	-- 	item = item
	-- }

	-- BulbShopUI.dispatchEvent(self, plantEvent)
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
	if (self.playerDisplay) then
		self.playerDisplay:removeSelf()
		self.playerDisplay = nil
	end
	if (self.uiDisplayGroup) then
		self.uiDisplayGroup:removeSelf()
		self.uiDisplayGroup = nil
	end
	self:removeAllEventListeners()
end