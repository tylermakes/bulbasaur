require("class")
require("bulb_map")
require("bulb_ui")
require("bulb_player")
require("bulb_living_room")

BulbHome = class(function(c, width, height, composer)
	c.width = width
	c.height = height
	c.player = nil
	c.ui = nil
	c.state = "nothing"
	c.selectedPlant = nil
	c.selectTool = nil
	c.composer = composer
end)

function BulbHome:create(group)
	local rows = 15
	local size = self.height/rows
	local mapWidth = self.width/5*4
	local columns = math.floor(mapWidth/size)

	self.livingRoom = BulbLivingRoom(mapWidth, self.height)
	self.livingRoom:create(group)
	self.livingRoom:addEventListener("navigate", self)


	Runtime:addEventListener("enterFrame", self)
end

function BulbHome:navigate(event)
	self.composer.gotoScene( "bulb_game_scene", "fade", 500 )
end

function BulbHome:entered(group)
	-- triggered when the scene is entered or re-entered
	-- savingContainer:save()
	if (not self.ui) then
		local mapWidth = self.width/5*4
		local tools = {}
		--tools[1] = {tileName="garden", color=BulbColor(0.8, 0.4, 1)}
		--tools[2] = {tileName="forest", color=BulbColor(0.7, 0.5, 1)}
		--tools[2] = {tileName="shovel", color=BulbColor(0.6, 0.6, 0.4)}
		self.ui = BulbUI(tools, mapWidth, 0, self.width/5, self.height, 10)
		self.ui:addEventListener("selectPlant", self)
		self.ui:addEventListener("selectTool", self)
		self.ui:create(group)
	end
end

function BulbHome:left( )
	-- triggered when the scene is entered or re-entered
	-- savingContainer:save()
	if (self.ui) then
		self.ui:removeSelf()
		self.ui = nil
	end
end

function BulbHome:enterFrame()
	self:update()
end

function BulbHome:update()
	self.livingRoom:update()
end

function BulbHome:selectPlant(data)
	self.state = "planting"
	self.selectedPlant = data.item
end

function BulbHome:selectTool(data)
	if (data.type == "garden") then
		self.composer.gotoScene( "bulb_game_scene", "fade", 500 )
	elseif (data.type == "forest") then
		self.composer.gotoScene( "bulb_forest_scene", "fade", 500 )
	else
		self.state = "tooling"
		self.selectedTool = data.type
	end
end

function BulbHome:removeSelf()
	Runtime:removeEventListener("enterFrame", self)
	print("removing home")
	if (self.livingRoom) then
		self.livingRoom:removeSelf()
		self.livingRoom = nil
	end
end