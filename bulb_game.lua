require("class")
require("bulb_map")
require("bulb_ui")
require("bulb_player")

BulbGame = class(function(c, width, height, composer)
	c.width = width
	c.height = height
	c.map = nil
	c.player = nil
	c.ui = nil
	c.state = "nothing"
	c.selectedPlant = nil
	c.selectTool = nil
	c.composer = composer
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
	tools[1] = {tileName="shovel", color=BulbColor(0.6, 0.6, 0.4)}
	
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
	-- if (data.type == "home") then
	-- 	self.composer.gotoScene( "bulb_home_scene", "fade", 500 )
	-- else
		self.state = "tooling"
		self.selectedTool = data.type
	-- end
end

function BulbGame:selectTile(event)
	local navigation = self.map:getNavigation(event.i, event.j)
	if (navigation) then
		local options =
		{
			effect = "fade",
			time = 500,
			params =
			{
				previousMapName = "bulb_game_scene",
				mapFileName = "init"
			}
		}
		self.composer.gotoScene( navigation, options )
	elseif (self.state == "planting") then 
		if (self.player.itemBag[self.selectedPlant.tileName].inventory >= 1 and
			self.map:canPlant(event.i, event.j, self.selectedPlant.tileName)) then
			self.map:plant(event.i, event.j, self.selectedPlant.tileName)
			self.player:deductItem(self.selectedPlant.tileName, 1)
		end
	elseif (self.state == "tooling") then
		if (self.map:canHarvest(event.i, event.j)) then
			local typeHarvested = self.map:harvest(event.i, event.j)
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