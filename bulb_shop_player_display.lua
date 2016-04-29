require("class")
local widget = require "widget"

BulbShopPlayerDisplay = class(function(c, x, y, width, height)
	c.x = x
	c.y = y
	c.width = width
	c.height = height
	c.itemView = nil
	c.moneyLabelView = nil
	c.moneyView = nil
	c.displayView = nil
	c.money = bulbGameSettings.playerData.money
end)

function BulbShopPlayerDisplay:create(group)
	local displayView = display.newGroup()

	local itemView = display.newRect( 0, 0, self.width, self.height )
	itemView:setFillColor( 0.3, 0.6, 0.4 )
	itemView.anchorX = 0;
	itemView.anchorY = 0;
	itemView.x = 0;
	itemView.y = 0;
	self.itemView = itemView

	-- ADD NAME TEXT
	local moneyLabelViewOptions = {
		text = "Money:",
		x = 0,
		y = 0,
		width = self.width,
		height = self.height,
		font = native.systemFont,
		fontSize = 36, 
		align = "left"
	}
	local moneyLabelView = display.newText( moneyLabelViewOptions )
	moneyLabelView:setFillColor( 0, 0, 0 )
	moneyLabelView.anchorX = 0;
	moneyLabelView.anchorY = 0;
	moneyLabelView.x = 0;
	moneyLabelView.y = 0;
	self.moneyLabelView = moneyLabelView

	local moneyViewOptions = {
		text = self.money,
		x = 0,
		y = 0,
		width = self.width,
		height = self.height,
		font = native.systemFont,
		fontSize = 36, 
		align = "right"
	}
	local moneyView = display.newText( moneyViewOptions )
	moneyView:setFillColor( 0, 0, 0)
	moneyView.anchorX = 0;
	moneyView.anchorY = 0;
	moneyView.x = 0;
	moneyView.y = 0;
	self.moneyView = moneyView

	displayView:insert(self.itemView)
	displayView:insert(self.moneyLabelView)
	displayView:insert(self.moneyView)
	
	self.displayView = displayView
	self.displayView.x = self.x
	self.displayView.y = self.y

	group:insert(self.displayView)
end

function BulbShopPlayerDisplay:update()
	self.money = bulbGameSettings.playerData.money
	if (self.moneyView) then
		self.moneyView.text = bulbGameSettings.playerData.money
	end
end

function BulbShopPlayerDisplay:removeSelf( )
	if (self.moneyLabelView) then
		self.moneyLabelView:removeSelf()
		self.moneyLabelView = nil
	end
	if (self.moneyView) then
		self.moneyView:removeSelf()
		self.moneyView = nil
	end
	if (self.itemView) then
		self.itemView:removeSelf()
		self.itemView = nil
	end
	if (self.displayView) then
		self.displayView:removeSelf()
		self.displayView = nil
	end
end