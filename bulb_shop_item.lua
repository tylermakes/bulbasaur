require("class")
local widget = require "widget"

BulbShopItem = class(function(c, x, y, width, height, item, inventory, ui)
	c.x = x
	c.y = y
	c.width = width
	c.height = height
	c.item = item
	c.buttonHeight = height/5
	c.ui = ui
	c.name = c.item.tileName
	c.inventory = inventory
	c.itemView = nil
	c.nameView = nil
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

	local buyOrSell = function(event)
		self.ui:buyingOrSellingFunction(self.name, event.target:getLabel(), self.inventory)
	end

	-- create a widget button for buying
	local buyButton = widget.newButton{
		label="BUY",
		labelColor = { default={255}, over={128} },
		fontSize = 36,
		defaultFile="button.png",
		overFile="button-over.png",
		width=self.width, self.buttonHeight,
		onRelease = buyOrSell	-- event listener function
	}
	buyButton.x = self.x + self.width*0.5
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
		width=self.width, self.buttonHeight,
		onRelease = buyOrSell	-- event listener function
	}
	sellButton.x = self.x + self.width*0.5
	sellButton.y = self.y + self.height - self.buttonHeight*2
	self.sellButton = sellButton
	---
	
	self.itemView:addEventListener("touch", self)
	group:insert(self.itemView)
	group:insert(self.nameView)
	group:insert(self.inventoryView)
	group:insert(self.buyButton)
	group:insert(self.sellButton)
end

function BulbShopItem:updateInventory( newValue )
	self.inventoryView.text = newValue
	self.inventory = newValue
end

function BulbShopItem:touch(event)
	local destination = {}
	
	if ( event.phase == "began" ) then
		self.touchStartY = event.y;
	elseif (event.phase == "moved") then
		if (self.scrollView and math.abs(self.touchStartY - event.y) > self.height/2) then
			self.scrollView:takeFocus( event )
		end
	elseif (event.phase == "ended") then
		destination.x = event.x;
		destination.y = event.y;
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