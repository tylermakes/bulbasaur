require("class")
require("bulb_ui")
require("bulb_player")
require("bulb_living_room")
require("bulb_cauldron")

BulbHome = class(function(c, width, height, composer)
	c.width = width
	c.height = height
	c.player = nil
	c.ui = nil
	c.state = "nothing"
	c.cauldron = nil
	c.cauldronSelector = nil
	c.selectTool = nil
	c.composer = composer
end)

function BulbHome:create(group, params)
	local rows = 15
	local size = self.height/rows
	local livingRoomWidth = self.width/5*4
	local columns = math.floor(livingRoomWidth/size)

	self.livingRoom = BulbLivingRoom(livingRoomWidth, self.height, params.isDead)
	self.livingRoom:create(group)
	self.livingRoom:addEventListener("navigate", self)

	self:makeCauldron(group, livingRoomWidth)

	Runtime:addEventListener("enterFrame", self)
end

function BulbHome:openCauldron( )

end

function BulbHome:makeCauldron( group, livingRoomWidth )
	
	local function touchCauldron(event)
		if ( event.phase == "began" ) then
			self:openCauldron()
			return
		end
	end

	local cauldronSelector = display.newRect(0, 0, 230, 200)
	cauldronSelector:setFillColor(0, 0, 0)
	cauldronSelector.anchorX = 0
	cauldronSelector.anchorY = 0
	cauldronSelector.x = 90
	cauldronSelector.y = 250
	group:insert(cauldronSelector)

	local cauldron = BulbCauldron(40, 40, livingRoomWidth - 80, self.height - 80)
	cauldron:create(group)
	self.cauldron = cauldron

	cauldronSelector:addEventListener("touch", touchCauldron)
	self.cauldronSelector = cauldronSelector
end

function BulbHome:navigate(event)
	self.composer.gotoScene( "bulb_game_scene", "fade", 500 )
end

function BulbHome:entered(group, params)
	-- triggered when the scene is entered or re-entered
	if (not self.ui) then
		local mapWidth = self.width/5*4
		local tools = {}
		tools[1] = {tileName="exit", color=BulbColor(0.6, 0.6, 0.6)}
		--tools[1] = {tileName="garden", color=BulbColor(0.8, 0.4, 1)}
		--tools[2] = {tileName="forest", color=BulbColor(0.7, 0.5, 1)}
		--tools[2] = {tileName="shovel", color=BulbColor(0.6, 0.6, 0.4)}
		self.ui = BulbUI(tools, mapWidth, 0, self.width/5, self.height, 10)
		self.ui:addEventListener("selectPlant", self)
		self.ui:addEventListener("selectTool", self)
		self.ui:create(group)
	end

	self.livingRoom:entered(params.isDead)
	bulbGameSettings.playerData.currentLocation = "home"
--	bulbGameSettings:resetGeneratedMap() -- TODO: fix this!
	bulbGameSettings:saveGame()
end

function BulbHome:left( )
	-- triggered when the scene is entered or re-entered
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
	self.cauldron:selectPlant(data.item)
end

function BulbHome:selectTool(data)
	if (data.type == "garden") then
		self.composer.gotoScene( "bulb_game_scene", "fade", 500 )
	elseif (data.type == "forest") then
		self.composer.gotoScene( "bulb_forest_scene", "fade", 500 )
	elseif (data.type == "exit") then
		self.composer.gotoScene( "bulb_menu_scene", "fade", 500 )
	else
		self.state = "tooling"
		self.selectedTool = data.type
	end
end

function BulbHome:removeSelf()
	Runtime:removeEventListener("enterFrame", self)
	print("removing home")
	if (self.cauldron) then
		self.cauldron:removeSelf()
		self.cauldron = nil
	end
	if (self.cauldronSelector) then
		self.cauldronSelector:removeSelf()
		self.cauldronSelector = nil
	end
	if (self.livingRoom) then
		self.livingRoom:removeSelf()
		self.livingRoom = nil
	end
end