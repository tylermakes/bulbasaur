require("class")
local widget = require "widget"

BulbShopPopup = class(function(c, width, height, label, item, action, total, cost, worth)
	c.x = width*0.05
	c.y = height*0.05
	c.width = width*0.9
	c.height = height*0.9
	c.buttonHeight = 20
	c.label = label
	c.item = item
	c.amount = 0
	c.total = total
	print("item:", cost, ",", worth)
	c.cost = cost
	c.worth = worth
	c.itemView = nil
	c.labelView = nil
	c.amountView = nil
	c.acceptButton = nil
	c.cancelButton = nil
	c.events = {}
	c.action = action
end)

function BulbShopPopup:create(group)
	local itemView = display.newRect( 0, 0, self.width, self.height )
	itemView:setFillColor( 0, 0, 0 )
	itemView.anchorX = 0;
	itemView.anchorY = 0;
	itemView.x = self.x;
	itemView.y = self.y;
	self.itemView = itemView

	-- ADD LABEL TEXT
	local labelViewOptions = {
		text = self.label,
		x = 0,
		y = 0,
		width = self.width,
		height = 100,
		font = native.systemFont,
		fontSize = 72, 
		align = "left"
	}
	local labelView = display.newText( labelViewOptions )
	labelView:setFillColor( 1, 1, 1 )
	labelView.anchorX = 0;
	labelView.anchorY = 0;
	labelView.x = self.x + 20;
	labelView.y = self.y + 20;
	self.labelView = labelView

	-- ADD AMOUNT TEXT
	local amountViewOptions = {
		text = self.amount,
		x = 0,
		y = 0,
		width = self.width,
		height = 200,
		font = native.systemFont,
		fontSize = 144, 
		align = "left"
	}
	local amountView = display.newText( amountViewOptions )
	amountView:setFillColor( 1, 1, 1 )
	amountView.anchorX = 0;
	amountView.anchorY = 0;
	amountView.x = self.x + 200;
	amountView.y = self.y + 200;
	self.amountView = amountView

	local add = function()
		if (self.action == "SELL") then
			if (self.amount < self.total) then
				self:alterAmount(1)
			end
		elseif (self.action == "BUY") then
			if ((self.amount + 1) * self.cost < bulbGameSettings.playerData.money) then
				self:alterAmount(1)
			end
		else
			self:alterAmount(1)
		end
	end

	-- create a widget button for raising the amount to buy/sell
	local addButton = widget.newButton{
		label="^",
		labelColor = { default={255}, over={128} },
		fontSize = 36,
		defaultFile="button.png",
		overFile="button-over.png",
		width=self.width, self.buttonHeight,
		onRelease = add
	}
	addButton.x = self.x + 600
	addButton.y = self.y + 300
	self.addButton = addButton
	---

	local decrease = function()
		if (self.amount > 0) then
			self:alterAmount(-1)
		end
	end

	-- create a widget button for lowering the amount to buy/sell
	local decreaseButton = widget.newButton{
		label="v",
		labelColor = { default={255}, over={128} },
		fontSize = 36,
		defaultFile="button.png",
		overFile="button-over.png",
		width=self.width, self.buttonHeight,
		onRelease = decrease
	}
	decreaseButton.x = self.x + 600
	decreaseButton.y = self.y + 400
	self.decreaseButton = decreaseButton
	---
	

	local accept = function(event)
		self:accept()
		return true
	end

	local cancel = function(event)
		self:cancel()
		return true
	end

	local endTouch = function(event)
		--stop clicks from falling through to elements behind it
		return true
	end

	-- ADD BUTTON FOR ACCEPTING
	local acceptButton = display.newCircle(0, 0, 25)
	acceptButton:setFillColor(0, 1, 0)
	acceptButton.x = self.x + self.width - 50
	acceptButton.y = self.y + self.height - 50 - 10
	self.acceptButton = acceptButton

	-- ADD BUTTON FOR CANCELING
	local cancelButton = display.newCircle(0, 0, 25)
	cancelButton:setFillColor(1, 0, 0)
	cancelButton.x = self.x + self.width - 100 - 40
	cancelButton.y = self.y + self.height - 50 - 10
	self.cancelButton = cancelButton

	acceptButton:addEventListener("touch", accept)
	cancelButton:addEventListener("touch", cancel)
	itemView:addEventListener("touch", endTouch)

	group:insert(self.itemView)
	group:insert(self.labelView)
	group:insert(self.amountView)
	group:insert(self.cancelButton)
	group:insert(self.acceptButton)
end

function BulbShopPopup:alterAmount(change)
	self.amount = self.amount + change
	self.amountView.text = self.amount
end

function BulbShopPopup:accept()
	local acceptStoreActionEvent = {
		name = "acceptShopPopup",
		item = self.item,
		cost = self.cost,
		worth = self.worth,
		amount = self.amount,
		action = self.action,
	}

	self:dispatchEvent(acceptStoreActionEvent);
end

function BulbShopPopup:cancel()
	local cancelStoreActionEvent = {
		name = "clearShopPopup"
	}

	self:dispatchEvent(cancelStoreActionEvent);
end

function BulbShopPopup:addEventListener(type, object)
	if (not self.events[type]) then
		self.events[type] = {}
	end
	self.events[type][#self.events[type] + 1] = object
end

function BulbShopPopup:dispatchEvent(data)
	if (self.events[data.name]) then
		for i=1, #self.events[data.name] do
			self.events[data.name][i][data.name](self.events[data.name][i], data)
		end
	end
end

function BulbShopPopup:removeSelf()
	if (self.labelView) then
		self.labelView:removeSelf()
		self.labelView = nil
	end
	if (self.amountView) then
		self.amountView:removeSelf()
		self.amountView = nil
	end
	if (self.itemView) then
		self.itemView:removeSelf()
		self.itemView = nil
	end
	if (self.acceptButton) then
		self.acceptButton:removeSelf()
		self.acceptButton = nil
	end
	if (self.cancelButton) then
		self.cancelButton:removeSelf()
		self.cancelButton = nil
	end
	if (self.addButton) then
		self.addButton:removeSelf()
		self.addButton = nil
	end
	if (self.decreaseButton) then
		self.decreaseButton:removeSelf()
		self.decreaseButton = nil
	end
	for k, v in pairs(self.events) do
		for i=1, #v do
			self.events[k][i] = nil
		end
		self.events[k] = nil
	end
	self.events = nil
	self.events = {}
end