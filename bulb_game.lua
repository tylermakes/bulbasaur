require("class")
require("bulb_map")
require("bulb_ui")
require("bulb_player")

BulbGame = class(function(c, width, height)
	c.width = width
	c.height = height
	c.map = nil
	c.player = nil
	c.ui = nil
	c.state = "nothing"
	c.selectedPlantType = nil
end)

function BulbGame:create(group)
	local rows = 15
	local size = self.height/rows
	local mapWidth = self.width/5*4
	local columns = math.floor(mapWidth/size)

	self.player = BulbPlayer()

	self.map = BulbMap(mapWidth, self.height, rows, columns)
	self.map:create(group)
	self.map:addEventListener("selectTile", self)

	self.ui = BulbUI(self.player, mapWidth, 0, self.width/5, self.height, 10)
	self.ui:addEventListener("selectPlant", self)
	self.ui:create(group)
end

function BulbGame:selectPlant(data)
	self.state = "planting"
	self.selectedPlantType = data.type
end

function BulbGame:selectTile(event)
	if (self.state == "planting") then 
		if (self.player.itemBag[self.selectedPlantType].inventory >= 1) then
			self.map:plant(event.x, event.y, self.selectedPlantType)
			self.player:deductItem(self.selectedPlantType, 1)
		end
	end
end

function BulbGame:setPlanting(plantType)
	print("trying to plant:"..plantType)
end

function BulbGame:removeSelf()
	if (self.map) then
		self.map:removeSelf()
	end
end