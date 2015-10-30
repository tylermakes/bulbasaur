require("class")

BulbFileNamePopup = class(function(c, label)
	c.x = 50
	c.y = 100
	c.width = 600
	c.height = 400
	c.label = label
	c.itemView = nil
	c.nameView = nil
	c.labelView = nil
	c.acceptButton = nil
	c.cancelButton = nil
end)

function BulbFileNamePopup:create(group)
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
		height = 50,
		font = native.systemFont,
		fontSize = 24, 
		align = "left"
	}
	local labelView = display.newText( labelViewOptions )
	labelView:setFillColor( 1, 1, 1 )
	labelView.anchorX = 0;
	labelView.anchorY = 0;
	labelView.x = self.x + 10;
	labelView.y = self.y + 10;
	self.labelView = labelView

	-- ADD NAME TEXT
	local nameView = native.newTextField( 0, 0, self.width - 20, 50 )
	nameView.anchorX = 0;
	nameView.anchorY = 0;
	nameView.x = self.x + 10;
	nameView.y = self.y + 50;
	self.nameView = nameView

	-- local a = self
	-- local accept = function(event)
	-- 	print("accepting!")
	-- 	a:accept()
	-- end
	-- local cancel = function(event)
	-- 	print("accepting!")
	-- 	this:accept()
	-- end

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

	-- acceptButton:addEventListener("touch", accept)
	-- cancelButton:addEventListener("touch", cancel)

	group:insert(self.itemView)
	group:insert(self.nameView)
	group:insert(self.labelView)
	group:insert(self.cancelButton)
	group:insert(self.acceptButton)
end

function BulbFileNamePopup:accept()
	print("accepting2")
	print("new name:"..self.label)
	print("new name:"..self.nameView.text)
end

function BulbFileNamePopup:accept()
end

function BulbFileNamePopup:addEventListener(type, object)
	if (not self.events[type]) then
		self.events[type] = {}
	end
	self.events[type][#self.events[type] + 1] = object
end

function BulbFileNamePopup:dispatchEvent(data)
	if (self.events[data.name]) then
		for i=1, #self.events[data.name] do
			self.events[data.name][i][data.name](self.events[data.name][i], data)
		end
	end
end

function BulbFileNamePopup:removeSelf()
	if (self.labelView) then
		self.labelView:removeSelf()
		self.labelView = nil
	end
	if (self.nameView) then
		self.nameView:removeSelf()
		self.nameView = nil
	else 
		print("no name view")
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
end