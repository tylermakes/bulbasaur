require("class")
require("bulb_shop_ui")
require("bulb_player")

BulbShop = class(function(c, width, height, composer)
	c.width = width
	c.height = height
	c.player = nil
	c.ui = nil
	c.state = "nothing"
	c.selectedPlant = nil
	c.selectTool = nil
	c.composer = composer
end)

function BulbShop:create(group, params)
	local rows = 15
	local size = self.height/rows
	local mapWidth = self.width/5*4
	local columns = math.floor(mapWidth/size)

	Runtime:addEventListener("enterFrame", self)
end

function BulbShop:navigate(event)
	self.composer.gotoScene( "bulb_game_scene", "fade", 500 )
end

function BulbShop:createTemporaryExitButton(group)
	local t = self.composer
	function leave()
		t.gotoScene("bulb_game_scene")
	end

	local itemView = display.newRect( 0, 0, 100, 100 )
	itemView.anchorX = 0;
	itemView.anchorY = 0;
	itemView.x = self.x;
	itemView.y = self.y;
	self.itemView = itemView
	self.itemView:addEventListener("touch", leave)

	-- ADD NAME TEXT
	local nameViewOptions = {
		text = "exit",
		x = 0,
		y = 0,
		width = self.width,
		height = self.height,
		font = native.systemFont,
		fontSize = 24, 
		align = "left"
	}
	local nameView = display.newText( nameViewOptions )
	nameView:setFillColor( 0, 0, 0 )
	nameView.anchorX = 0;
	nameView.anchorY = 0;
	nameView.x = self.x;
	nameView.y = self.y;
	self.nameView = nameView
	group:insert(itemView)
	group:insert(nameView)
end

function BulbShop:entered(group, params)
	-- triggered when the scene is entered or re-entered
	if (not self.ui) then
		local mapWidth = self.width/5*4
		self.ui = BulbShopUI(0, 0, self.width, self.height, 10)
		self.ui:addEventListener("selectPlant", self)
		self.ui:addEventListener("selectTool", self)
		self.ui:create(group)
		self:createTemporaryExitButton(group)
	end

	bulbGameSettings.playerData.currentLocation = "shop"
--	bulbGameSettings:resetGeneratedMap() -- TODO: fix this!
	bulbGameSettings:saveGame()
end

function BulbShop:left( )
	-- triggered when the scene is entered or re-entered
	if (self.ui) then
		self.ui:removeSelf()
		self.ui = nil
	end
end

function BulbShop:enterFrame()
	self:update()
end

function BulbShop:update()
end

function BulbShop:selectPlant(data)
	self.state = "planting"
	self.selectedPlant = data.item
end

function BulbShop:selectTool(data)
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

function BulbShop:removeSelf()
	Runtime:removeEventListener("enterFrame", self)
	print("removing Shop")
	if (self.livingRoom) then
		self.livingRoom:removeSelf()
		self.livingRoom = nil
	end
end