require("class")
require("bulb_map")
require("bulb_ui")

BulbGame = class(function(c, width, height)
	c.width = width
	c.height = height
	c.map = nil
	c.player = nil
	c.ui = nil
	c.state = "nothing"
end)

function BulbGame:create(group)
	local rows = 15
	local size = self.height/rows
	local mapWidth = self.width/5*4
	local columns = math.floor(mapWidth/size)

	self.map = BulbMap(mapWidth, self.height, rows, columns)
	self.map:create(group)

	self.ui = BulbUI(mapWidth, 0, self.width/5, self.height, 10)
	self.ui:addEventListener("select_plant", self)
	self.ui:create(group)
end

function BulbGame:select_plant(data)
	if (not data) then
		print("NO DATA!")
	end
	print("something's happening")
end

function BulbGame:setPlanting(plantType)
	print("trying to plant:"..plantType)
end

function BulbGame:removeSelf()
	if (self.map) then
		self.map:removeSelf()
	end
end