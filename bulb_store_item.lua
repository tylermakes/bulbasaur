require("class")

BulbStoreItem = class(function(c, x, y, width, height, itemType, name, inventory, ui)
	c.x = x
	c.y = y
	c.width = width
	c.height = height
	c.itemType = itemType
	c.ui = ui
	c.name = name
	c.inventory = inventory
	c.itemView = nil
	c.nameView = nil
	c.inventoryView = nil
	c.events = {}
end)

function BulbStoreItem:create(group)
	local itemView = display.newRect( 0, 0, self.width, self.height )
	itemView:setFillColor( 1/self.itemType, 1/self.itemType, 1/self.itemType )
	itemView.anchorX = 0;
	itemView.anchorY = 0;
	itemView.x = self.x;
	itemView.y = self.y;
	self.itemView = itemView


	-- ADD NAME TEXT
	local nameViewOptions = {
		text = self.name,
		x = 0,
		y = 0,
		width = self.width,
		height = self.height,
		font = native.systemFont,
		fontSize = 24, 
		align = "left"
	}
	local nameView = display.newText( nameViewOptions )
	nameView:setFillColor( 1-(1/self.itemType), 1-(1/self.itemType), 1 )
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
	inventoryView:setFillColor( 1, 1-1/self.itemType, 1-1/self.itemType )
	inventoryView.anchorX = 0;
	inventoryView.anchorY = 0;
	inventoryView.x = self.x;
	inventoryView.y = self.y;
	self.inventoryView = inventoryView

	self.itemView:addEventListener("touch", self)
	group:insert(self.itemView)
	group:insert(self.nameView)
	group:insert(self.inventoryView)
end

function BulbStoreItem:updateInventory( newValue )
	self.inventoryView.text = newValue
	self.inventory = newValue
end

function BulbStoreItem:touch(event)
	local destination = {}
	if ( event.phase == "began" ) then
		destination.x = event.x;
		destination.y = event.y;
		self.ui:plantingFunction(self.itemType)
	end
end

-- function BulbStoreItem:addEventListener(type, object)
-- 	if (not self.events[type]) then
-- 		self.events[type] = {}
-- 	end
-- 	self.events[type][#self.events[type] + 1] = object
-- end

-- function BulbStoreItem:dispatchEvent(type, data)
-- 	if (self.events[type] then
-- 		for i=1, #self.events[type] do
-- 			self.events[type][i][type](data)
-- 		end
-- 	end
-- end