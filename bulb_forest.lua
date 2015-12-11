require("class")
require("bulb_forest_map")
require("bulb_ui")
require("bulb_player")
require("bulb_enemy")

BulbForest = class(function(c, width, height, storyboard, buildingMapName)
	c.width = width
	c.height = height
	c.map = nil
	c.player = nil
	c.ui = nil
	c.selectTool = nil
	c.buildingMapName = buildingMapName
	c.storyboard = storyboard
	c.enemies = {}
end)

function BulbForest:create(group)
	local rows = 15
	local size = self.height/rows
	local mapWidth = self.width/5*4
	local columns = math.floor(mapWidth/size)

	self.map = BulbForestMap(mapWidth, self.height, rows, columns)
	self.map:create(group)
	self.map:addEventListener("touchTile", self)

	local tools = {}
	print("building forest:", self.buildingMapName)
	if (self.buildingMapName) then
		tools[1] = {tileName="build", color=BulbColor(0.8, 0.4, 1)}
		
		local loadedData = savingContainer:loadFile(self.buildingMapName)
		if (loadedData.failure) then
			print("FAILED TO LOAD DATA FROM:", self.buildingMapName)	-- probably filename doesn't exist
		else
			self.map:loadMapFromData(loadedData)
		end
	else
		tools[1] = {tileName="home", color=BulbColor(0.8, 0.4, 1)}
	end

	self.player = BulbPlayer(self.map)
	self.player:create(group)

	local mapEnemies = self.map:getEnemies()
	for i=1, #mapEnemies do
		local newEnemy = BulbEnemy(self.map, mapEnemies[i])
		newEnemy:create(group) 
		self.enemies[#self.enemies + 1] = newEnemy
	end

	self.ui = BulbUI(tools, self.player, mapWidth, 0, self.width/5, self.height, 10)
	self.ui:addEventListener("selectTool", self)
	self.ui:create(group)

	Runtime:addEventListener("enterFrame", self)
end

function BulbForest:enterFrame()
	self:update()
end

function BulbForest:update()
	self.map:update()
	self.player:update()
	for i=1, #self.enemies do
		self.enemies[i]:update() 
	end
end

function BulbForest:selectTool(data)
	if (data.type == "build") then
		self.storyboard.gotoScene( "bulb_builder_scene", "fade", 500 )
	elseif (data.type == "home") then
		self.storyboard.gotoScene( "bulb_home_scene", "fade", 500 )
	else
		print("unknown item:", data.type)
	end
end

function BulbForest:touchTile(event)
	self.player:setTargetLocation(event)
end

function BulbForest:removeSelf()
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