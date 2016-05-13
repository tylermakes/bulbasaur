require("class")
require("bulb_cauldron_slot")

BulbCauldron = class(function(c, x, y, width, height)
	c.x = x
	c.y = y
	c.width = width
	c.height = height
	c.rows = 3
	c.columns = 3
	c.buffer = 15
	c.tileSize = {w = (width - (c.buffer * (c.rows+1)))/c.rows,
					h = (height - (c.buffer * (c.columns+1)))/c.columns }
	print("TILE SIZE:", c.tileSize.w, ", ", c.tileSize.h)
	print("W:", width, ", H:", height)
	c.cauldron = nil
	c.slots = {}
	c.slotGroup = nil
	c.selectedPlant = nil
end)

function BulbCauldron:create(group)
	
	local cauldron = display.newRect(0, 0, self.width, self.height)
	cauldron:setFillColor(0, 0, 0)
	cauldron.alpha = 0.75
	cauldron.anchorX = 0
	cauldron.anchorY = 0
	cauldron.x = self.x
	cauldron.y = self.y
	group:insert(cauldron)

	local slotGroup = display.newGroup()
	for i=1, self.rows do
		self.slots[i] = {}
		for j=1, self.columns do
			local slot = BulbCauldronSlot((i-1)*(self.tileSize.w + self.buffer) + self.buffer,
										(j-1)*(self.tileSize.h + self.buffer) + self.buffer,
										self.tileSize.w,
										self.tileSize.h,
										i, j)
			slot:create(slotGroup)
			slot:addEventListener("selectTile", self)
			self.slots[i][j] = slot
		end
	end
	slotGroup.x = self.x
	slotGroup.y = self.y
	self.slotGroup = slotGroup

	group:insert(slotGroup)
end

function BulbCauldron:selectPlant( plant )
	self.selectedPlant = plant
end

function BulbCauldron:selectTile(event)
	print("test:", self.selectedPlant)
	if (bulbGameSettings.playerData.itemBag[self.selectedPlant.tileName] >= 1) then
		self.slots[event.i][event.j]:insertPlant(self.selectedPlant)
		print("adding plant to cauldron:", self.selectedPlant.tileName)
		--bulbGameSettings.playerData:deductItem(self.selectedPlant.tileName, 1)
	end
end

function BulbCauldron:removeSelf()
	print("removing cauldron")
	for i=0, #self.slots do
		for j=0, #i do
			self.slots[i][j]:removeSelf()
			self.slots[i][j] = nil
		end
		self.slots[i] = nil
	end
	self.slots = nil

	if (self.slotGroup) then
		self.slotGroup:removeSelf()
		self.slotGroup = nil
	end
	if (self.cauldron) then
		self.cauldron:removeSelf()
		self.cauldron = nil
	end
end