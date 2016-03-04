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
	c.saveTimer = 0
end)

function BulbGame:create(group)
	local rows = 15
	local size = self.height/rows
	local mapWidth = self.width/5*4
	local columns = math.floor(mapWidth/size)

	self.map = BulbMap(mapWidth, self.height, rows, columns)
	self.map:create(group)
	self.map:addEventListener("selectTile", self)
	
	self.player = BulbPlayer(self.map)

	Runtime:addEventListener("enterFrame", self)
end

function BulbGame:entered(group)
	-- triggered when the scene is entered or re-entered
	if (not self.ui) then
		local mapWidth = self.width/5*4
		local tools = {}
		tools[1] = {tileName="exit", color=BulbColor(0.7, 0.7, 0.7)}
		tools[2] = {tileName="shovel", color=BulbColor(0.6, 0.6, 0.4)}

		self.ui = BulbUI(tools, mapWidth, 0, self.width/5, self.height, 10)
		self.ui:addEventListener("selectPlant", self)
		self.ui:addEventListener("selectTool", self)
		self.ui:create(group)
	end

	bulbGameSettings.playerData.currentLocation = "garden"
	bulbGameSettings:resetGeneratedMap(self.map.navigationTiles[2], "bulb_game_scene")	-- pass in the tile for forest nav
	if (not bulbGameSettings.playerData.diedInForest) then
		bulbGameSettings.playerData:keepTempItems()
		--keepTempItems already calls gameSettings:saveGame(), so we don't have to
	else
		bulbGameSettings:saveGame() -- save game to record current location
	end
end

function BulbGame:left( )
	-- triggered when the scene is entered or re-entered
	if (self.ui) then
		self.ui:removeSelf()
		self.ui = nil
	end
end

function BulbGame:enterFrame()
	self:update()
end

function BulbGame:update()
	self.map:update()
	if (self.saveTimer <= 0) then
		self.saveTimer = 30
		savingContainer:saveFile(self.map:getSaveData(), bulbGameSettings:getGardenFileName())
	else
		self.saveTimer = self.saveTimer - 1
	end
end

function BulbGame:selectPlant(data)
	self.state = "planting"
	self.selectedPlant = data.item
end

function BulbGame:selectTool(data)
	if (data.type == "exit") then
		self.composer.gotoScene( "bulb_menu_scene", "fade", 500 )
	-- else if (data.type == "home") then
	-- 	self.composer.gotoScene( "bulb_home_scene", "fade", 500 )
	else
		self.state = "tooling"
		self.selectedTool = data.type
	end
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
				mapFileName = "generated_map1",
				navLoc = {x = event.i, y = event.j}
			}
		}
		self.composer.gotoScene( navigation, options )
	elseif (self.state == "planting") then 
		if (bulbGameSettings.playerData.itemBag[self.selectedPlant.tileName] >= 1 and
			self.map:canPlant(event.i, event.j, self.selectedPlant.tileName)) then
			self.map:plant(event.i, event.j, self.selectedPlant)
			bulbGameSettings.playerData:deductItem(self.selectedPlant.tileName, 1)
		end
	elseif (self.state == "tooling") then
		if (self.map:canHarvest(event.i, event.j)) then
			local typeHarvested = self.map:harvest(event.i, event.j)
			bulbGameSettings.playerData:addItem(typeHarvested, 2)
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