require("class")

BulbStoreItem = class(function(c, x, y, width, height, itemType, plantingFunction)
	c.x = x
	c.y = y
	c.width = width
	c.height = height
	c.itemType = itemType
	c.itemView = nil
	c.plantingFunction = plantingFunction
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
	self.itemView:addEventListener("touch", self)
	group:insert(self.itemView)
end

function BulbStoreItem:touch(event)
	local destination = {}
	if ( event.phase == "began" ) then
		destination.x = event.x;
		destination.y = event.y;
		print("clicking:", self.itemType, bulbGameSettings.types[self.itemType].tileName, bulbGameSettings.types[self.itemType].cost)
		-- self.plantingFunction(self.itemType)
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