require("class")
require("bulb_map")
require("bulb_ui")
require("bulb_player")

BulbGame = class(function(c, width, height, storyboard)
	c.width = width
	c.height = height
	c.map = nil
	c.player = nil
	c.ui = nil
	c.state = "nothing"
	c.selectedPlant = nil
	c.selectTool = nil
	c.storyboard = storyboard
end)

function BulbGame:create(group)
	local rows = 15
	local size = self.height/rows
	local mapWidth = self.width/5*4
	local columns = math.floor(mapWidth/size)


	self.map = BulbMap(mapWidth, self.height, rows, columns)
	self.map:create(group)
	self.map:addEventListener("selectTile", self)

	local tools = {}
	tools[1] = {tileName="home", color=BulbColor(0.8, 0.4, 1)}
	tools[2] = {tileName="shovel", color=BulbColor(0.6, 0.6, 0.4)}
	
	self.player = BulbPlayer(self.map)
	
	self.ui = BulbUI(tools, self.player, mapWidth, 0, self.width/5, self.height, 10)
	self.ui:addEventListener("selectPlant", self)
	self.ui:addEventListener("selectTool", self)
	self.ui:create(group)

	Runtime:addEventListener("enterFrame", self)
end

function BulbGame:enterFrame()
	self:update()
end

function BulbGame:update()
	self.map:update()
end

function BulbGame:selectPlant(data)
	self.state = "planting"
	self.selectedPlant = data.item
end

function BulbGame:selectTool(data)
	if (data.type == "home") then
		self.storyboard.gotoScene( "bulb_home_scene", "fade", 500 )
	else
		self.state = "tooling"
		self.selectedTool = data.type
	end
end

function BulbGame:selectTile(event)
	if (self.state == "planting") then 
		if (self.player.itemBag[self.selectedPlant.tileName].inventory >= 1 and
			self.map:canPlant(event.x, event.y, self.selectedPlant.tileName)) then
			self.map:plant(event.x, event.y, self.selectedPlant.tileName)
			self.player:deductItem(self.selectedPlant.tileName, 1)
		end
	elseif (self.state == "tooling") then
		if (self.map:canHarvest(event.x, event.y)) then
			local typeHarvested = self.map:harvest(event.x, event.y)
			self.player:addItem(typeHarvested, 2)
		end
	end
end

function BulbGame:setPlanting(plantType)
	print("trying to plant:"..plantType)
end

function BulbGame:removeSelf()
	Runtime:removeEventListener("enterFrame", self)
	if (self.map) then
		self.map:removeSelf()
		self.map = nil
	end
	if (self.ui) then
		self.ui:removeSelf()
		self.ui = nil
	end
	if (self.player) then
		self.player:removeSelf()
		self.player = nil
	end
end