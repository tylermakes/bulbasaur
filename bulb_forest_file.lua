require("class")
require("bulb_forest_map")
require("bulb_ui")
require("bulb_player")
require("bulb_enemy")

BulbForestFile = class(function(c, width, height, composer, buildingMapName, previousMapName)
	c.width = width
	c.height = height
	c.map = nil
	c.player = nil
	c.ui = nil
	c.selectTool = nil
	c.lastPlayerLocation = nil
	c.buildingMapName = buildingMapName
	c.previousMapName = previousMapName
	c.composer = composer
	c.enemies = {}
end)

function BulbForestFile:create(group)
	local rows = 15
	local size = self.height/rows
	local mapWidth = self.width/5*4
	local columns = math.floor(mapWidth/size)

	self.map = BulbForestMap(mapWidth, self.height, rows, columns)
	self.map:create(group)
	self.map:addEventListener("touchTile", self)
	self.map:addEventListener("triggerTile", self)

	if (self.buildingMapName) then
		local loadedData = savingContainer:loadFile(self.buildingMapName)
		if (loadedData.failure) then
			print("FAILED TO LOAD DATA FROM:", self.buildingMapName)	-- probably filename doesn't exist
			print("HAVE YOU SAVED YOUR INIT FILE?")
			return;
		else
			self.map:loadMapFromData(loadedData, self.previousMapName)
		end
	else
		local loadedData = savingContainer:loadFile(bulbGameSettings.forestCurrentMap)
		if (loadedData.failure) then
			print("FAILED TO LOAD DATA FROM:", bulbGameSettings.forestCurrentMap)	-- probably filename doesn't exist
		else
			self.map:loadMapFromData(loadedData, self.previousMapName)
		end
	end

	self.player = BulbPlayer(self.map)
	self.player:create(group)
	self.lastPlayerLocation = self.player.playerLocation

	local mapEnemies = self.map:getEnemies()
	for i=1, #mapEnemies do
		local newEnemy = BulbEnemy(self.map, mapEnemies[i])
		newEnemy:create(group) 
		self.enemies[#self.enemies + 1] = newEnemy
	end


	Runtime:addEventListener("enterFrame", self)
end

function BulbForestFile:entered(group)
	-- triggered when the scene is entered or re-entered

	if (not self.ui) then
		local mapWidth = self.width/5*4
		local tools = {}
		if (self.buildingMapName) then
			if (globalBuildMode) then
				tools[1] = {tileName="build", color=BulbColor(0.8, 0.4, 1)}
			else
				tools[1] = {tileName="exit", color=BulbColor(0.6, 0.6, 0.6)}
			end
		else
			tools[1] = {tileName="exit", color=BulbColor(0.6, 0.6, 0.6)}
			--tools[1] = {tileName="home", color=BulbColor(0.8, 0.4, 1)}
		end

		print("players items:")
		for k, v in pairs(bulbGameSettings.playerData.temporaryItems) do
			print("temp items:", k, v)
		end

		self.ui = BulbUI(tools, mapWidth, 0, self.width/5, self.height, 10, true)
		self.ui:addEventListener("selectTool", self)
		self.ui:create(group)
	end

	bulbGameSettings.playerData.currentLocation = "forest"
	bulbGameSettings:saveGame()
end

function BulbForestFile:left( )
	-- triggered when the scene is entered or re-entered
	if (self.ui) then
		self.ui:removeSelf()
		self.ui = nil
	end
end

function BulbForestFile:enterFrame()
	self:update()
end

function BulbForestFile:update()
	self.map:update()
	self.player:update()
	for i=1, #self.enemies do
		self.enemies[i]:update(self.player) 
	end
	if (self.player.playerLocation.i ~= self.lastPlayerLocation.i or
		self.player.playerLocation.j ~= self.lastPlayerLocation.j) then
		self.lastPlayerLocation = self.player.playerLocation
		self.map:triggerLocation(self.player.playerLocation)
	end
end

----------------------------------
-- BEGIN CUSTOM EVENT HANDLERS
----------------------------------
function BulbForestFile:selectTool(data)
	if (data.type == "build") then
		self.composer.gotoScene( "bulb_builder_scene", "fade", 500 )
	elseif (data.type == "exit") then
		self.composer.gotoScene( "bulb_menu_scene", "fade", 500 )
	-- elseif (data.type == "home") then
	-- 	self.composer.gotoScene( "bulb_home_scene", "fade", 500 )
	else
		print("unknown item:", data.type)
	end
end

function BulbForestFile:touchTile(event)
	self.player:setTargetLocation(event)
end

function BulbForestFile:triggerTile(event)
	if (event.subtype == "navigate") then
		self:navigate(event)
	elseif (event.subtype == "seeds") then
		self:gatherSeeds(event)
	else
		print("unknown tile subtype triggered")
	end
end

function BulbForestFile:gatherSeeds(event)
	bulbGameSettings.playerData:addItem(event.seedType, 1, true)
	local tileInfo = bulbBuilderSettings.dirtType
	self.map:placeTile(event.location.i, event.location.j, tileInfo)
end

function BulbForestFile:navigate(event)
	if ( string.find(event.nav, '_scene')) then
		if (globalBuildMode and
			(event.nav == "bulb_home_scene" or
				event.nav == "bulb_game_scene")) then
			self.composer.gotoScene( "bulb_builder_scene", "fade", 500 )
		else
			self.composer.gotoScene( event.nav, "fade", 500 )
		end
	else
		local options =
		{
			effect = "fade",
			time = 500,
			params =
			{
				previousMapName = self.buildingMapName,
				mapFileName = event.nav
			}
		}
		self.composer.gotoScene( "bulb_forest_scene", options )
	end
end
----------------------------------
-- END CUSTOM EVENT HANDLERS
----------------------------------

function BulbForestFile:removeSelf()
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

	for i=1, #self.enemies do
		self.enemies[i]:removeSelf()
		self.enemies[i] = nil 
	end
	self.enemies = nil
	self.lastPlayerLocation = nil
end