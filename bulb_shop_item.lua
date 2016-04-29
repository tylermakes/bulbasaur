require("class")
local widget = require "widget"

BulbShopItem = class(function(c, x, y, width, height, item, inventory, ui)
	c.x = x
	c.y = y
	c.width = width
	c.height = height
	c.item = item
	c.cost = item.cost
	c.worth = item.cost/2
	c.buttonHeight = height/5
	c.ui = ui
	c.name = c.item.tileName
	c.inventory = inventory
	c.itemView = nil
	c.nameView = nil
	c.costView = nil
	c.worthView = nil
	c.inventoryView = nil
	c.buyButton = nil
	c.sellButton = nil
	-- c.events = {}
	c.touchStartY = 0
	c.scrollView = nil
end)

function BulbShopItem:create(group, scrollView)
	self.scrollView = scrollView

	local itemView = display.newRect( 0, 0, self.width, self.height )
	itemView:setFillColor( self.item.color.r, self.item.color.g, self.item.color.b )
	itemView.anchorX = 0;
	itemView.anchorY = 0;
	itemView.x = self.x;
	itemView.y = self.y;
	self.itemView = itemView


	-- ADD NAME TEXT
	local nameViewOptions = {
		text = self.item.tileName,
		x = 0,
		y = 0,
		width = self.width,
		height = self.height,
		font = native.systemFont,
		fontSize = 24, 
		align = "left"
	}
	local nameView = display.newText( nameViewOptions )
	nameView:setFillColor( 0, 0, 0 )
	nameView.anchorX = 0;
	nameView.anchorY = 0;
	nameView.x = self.x;
	nameView.y = self.y;
	self.nameView = nameView


	-- ADD INVENTORY TEXT
	local inventoryViewOptions = {
		text = self.inventory,
		x = 0,
		y = 0,
		width = self.width,
		height = self.height,
		font = native.systemFont,
		fontSize = 24, 
		align = "right"
	}
	local inventoryView = display.newText( inventoryViewOptions )
	inventoryView:setFillColor( 0, 0, 0)
	inventoryView.anchorX = 0;
	inventoryView.anchorY = 0;
	inventoryView.x = self.x;
	inventoryView.y = self.y;
	self.inventoryView = inventoryView

	-- ADD COST TEXT
	local costViewOptions = {
		text = self.cost,
		x = 0,
		y = 0,
		width=150, height=50,
		font = native.systemFont,
		fontSize = 24, 
		align = "right"
	}
	local costView = display.newText( costViewOptions )
	costView:setFillColor( 0, 0, 0)
	costView.x = self.x + self.width*0.5;
	costView.y = self.y + self.height - self.buttonHeight;
	self.costView = costView

	-- ADD WORTH TEXT
	local worthViewOptions = {
		text = self.worth,
		x = 0,
		y = 0,
		width=150, height=50,
		font = native.systemFont,
		fontSize = 24, 
		align = "right"
	}
	local worthView = display.newText( worthViewOptions )
	worthView:setFillColor( 0, 0, 0)
	worthView.x = self.x + self.width*0.5;
	worthView.y = self.y + self.height - self.buttonHeight*2;
	self.worthView = worthView

	-- CREATE WIDGETS FOR BUYING AND SELLING
	local buyOrSell = function(event)
		self.ui:buyingOrSellingFunction(self.name,
			event.target:getLabel(),
			self.inventory,
			self.cost,
			self.worth)
		return true
	end

	-- create a widget button for buying
	local buyButton = widget.newButton{
		label="BUY",
		labelColor = { default={255}, over={128} },
		fontSize = 36,
		defaultFile="button.png",
		overFile="button-over.png",
		width=150, height=50,
		onRelease = buyOrSell	-- event listener function
	}
	buyButton.x = self.x + self.width*0.3
	buyButton.y = self.y + self.height - self.buttonHeight
	self.buyButton = buyButton
	---

	-- create a widget button for selling
	local sellButton = widget.newButton{
		label="SELL",
		labelColor = { default={255}, over={128} },
		fontSize = 36,
		defaultFile="button.png",
		overFile="button-over.png",
		width=150, height=50,
		onRelease = buyOrSell	-- event listener function
	}
	sellButton.x = self.x + self.width*0.3
	sellButton.y = self.y + self.height - self.buttonHeight*2
	self.sellButton = sellButton
	---
	
	-- self.itemView:addEventListener("touch", self)
	group:insert(self.itemView)
	group:insert(self.nameView)
	group:insert(self.inventoryView)
	group:insert(self.costView)
	group:insert(self.worthView)
	group:insert(self.buyButton)
	group:insert(self.sellButton)
end

function BulbShopItem:updateInventory( newValue )
	self.inventory = newValue
	self.inventoryView.text = newValue
end

function BulbShopItem:touch(event)
	local destination = {}
	
	if ( event.phase == "began" ) then
		self.touchStartY = event.y
		self.isFocused = true
	elseif (event.phase == "moved") then
		if (self.scrollView and math.abs(self.touchStartY - event.y) > self.height/2) then
			self.scrollView:takeFocus( event )
			self.isFocused = false
			print("move focus")
		end
	elseif (event.phase == "ended") then
		destination.x = event.x
		destination.y = event.y
		if (not self.isFocused or
			(self.scrollView and math.abs(self.touchStartY - event.y) > self.height/2)) then
			self.scrollView:takeFocus( event )
			print("end focus")
		end
	end
	return true
end


function BulbShopItem:removeSelf( )
	if (self.nameView) then
		self.nameView:removeSelf()
		self.nameView = nil
	end
	if (self.inventoryView) then
		self.inventoryView:removeSelf()
		self.inventoryView = nil
	end
	if (self.costView) then
		self.costView:removeSelf()
		self.costView = nil
	end
	if (self.worthView) then
		self.worthView:removeSelf()
		self.worthView = nil
	end
	if (self.itemView) then
		self.itemView:removeSelf()
		self.itemView = nil
	end
	if (self.buyButton) then
		self.buyButton:removeSelf()
		self.buyButton = nil
	end
	if (self.sellButton) then
		self.sellButton:removeSelf()
		self.sellButton = nil
	end
	if (self.scrollView) then
		self.scrollView = nil
	end
end

-- function BulbShopItem:addEventListener(type, object)
-- 	if (not self.events[type]) then
-- 		self.events[type] = {}
-- 	end
-- 	self.events[type][#self.events[type] + 1] = object
-- end

-- function BulbShopItem:dispatchEvent(type, data)
-- 	if (self.events[type] then
-- 		for i=1, #self.events[type] do
-- 			self.events[type][i][type](data)
-- 		end
-- 	end
-- end