require("class")
require("sprite_sheet_forest")

BulbCauldronSlot = class(function(c, x, y, width, height, i, j)
	c.x = x
	c.y = y
	c.i = i
	c.j = j
	c.width = width
	c.height = height
	c.events = {}
	c.slot = nil
	c.plant = nil
	c.plantView = nil
	c.slotGroup = nil
end)

function BulbCauldronSlot:create(group)
	self.slotGroup = display.newGroup()
	
	local slot = display.newRect(0, 0, self.width, self.height)
	slot:setFillColor(1,1,1)
	slot.alpha = 0.5
	slot.anchorX = 0
	slot.anchorY = 0
	slot.x = self.x
	slot.y = self.y

	slot:addEventListener("touch", self)
	
	self.slot = slot
	
	self.slotGroup:insert(slot)
	group:insert(self.slotGroup)
end

function BulbCauldronSlot:touch( event )
	
	if ( event.phase == "began" ) then
		local selectTileEvent = {
			name = "selectTile",
			i = self.i,
			j = self.j
		}
		self:dispatchEvent(selectTileEvent)
	end
end

function BulbCauldronSlot:insertPlant( plant )
	self.plant = plant

	if (self.plantView) then
		self.plantView:removeSelf()
		self.plantView = nil
	end

	local plantView
	plantView = display.newImage(spriteSheetForest, plant.artStates[4])
	plantView.anchorX = 0;
	plantView.anchorY = 0;
	plantView.x = self.x;
	plantView.y = self.y;
	plantView.width = self.width
	plantView.height	 = self.height
	self.plantView = plantView
	self.slotGroup:insert(self.plantView)
end

function BulbCauldronSlot:addEventListener(type, object)
	if (not self.events[type]) then
		self.events[type] = {}
	end
	self.events[type][#self.events[type] + 1] = object
end

function BulbCauldronSlot:dispatchEvent(data)
	if (self.events[data.name]) then
		for i=1, #self.events[data.name] do
			self.events[data.name][i][data.name](self.events[data.name][i], data)
		end
	end
end

function BulbCauldronSlot:removeSelf()
	print("removing slot")
	if (self.plantView) then
		self.plantView:removeSelf()
		self.plantView = nil
	end
	if (self.slot) then
		self.slot:removeSelf()
		self.slot = nil
	end
	if (self.slotGroup) then
		self.slotGroup:removeSelf()
		self.slotGroup = nil
	end
end