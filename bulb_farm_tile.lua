require("class")
require("sprite_sheet_forest")

BulbFarmTile = class(function(c, i, j, x, y, size)
	c.i = i
	c.j = j
	c.x = x
	c.y = y
	c.size = size
	c.tileView = nil
	c.harvestCounter = 0
	c.harvestCountView = nil
	c.plantInfo = nil
	c.state = "dirt"
	c.grp = nil
end)

function BulbFarmTile:create(group, plantInfo)
	self.grp = group
	self.plantInfo = plantInfo
	local plant
	if (plantInfo) then
		plant = bulbGameSettings.types[plantInfo.tileName]
	end

	local tileView
	if (plantInfo) then
		-- tileView = display.newRect( 0, 0, self.size, self.size )
		-- tileView:setFillColor( 0.8, 0.6, 0 )
		tileView = display.newImage(spriteSheetForest, 2)
	else
		tileView = display.newImage(spriteSheetForest, 1)
	end
	
	tileView.anchorX = 0;
	tileView.anchorY = 0;
	tileView.x = self.x;
	tileView.y = self.y;
	tileView.width = self.size
	tileView.height	 = self.size
	self.tileView = tileView
	group:insert(self.tileView)

	if (plantInfo and plantInfo.tileName) then
		self.state = "growing"
		self.growingState = 0
		self.harvestCounter = plantInfo.harvestTime
		-- tileView:setFillColor( plant.color.r, plant.color.g, plant.color.b )
		
		-- ADD HARVEST COUNT TEXT
		-- local harvestCountViewOptions = {
		-- 	text = self.harvestCounter,
		-- 	x = 0,
		-- 	y = 0,
		-- 	width = self.size,
		-- 	height = self.size,
		-- 	font = native.systemFont,
		-- 	fontSize = 24, 
		-- 	align = "left"
		-- }
		-- local harvestCountView = display.newText( harvestCountViewOptions )
		-- harvestCountView:setFillColor( 0, 0, 0)
		-- harvestCountView.anchorX = 0;
		-- harvestCountView.anchorY = 0;
		-- harvestCountView.x = self.x;
		-- harvestCountView.y = self.y;
		-- self.harvestCountView = harvestCountView
		-- group:insert(self.harvestCountView)
	end
end

function BulbFarmTile:update()
	if (self.state == "growing") then
		if (self.harvestCounter >= 1) then
			self.harvestCounter = self.harvestCounter - 1
			-- self.harvestCountView.text = self.harvestCounter
		else
			self.state = "harvestable"
			-- self.harvestCountView.text = "HARVEST"
		end
		self:updateImage()
	end
end

function BulbFarmTile:updateImage()
	local tileView
	if (self.state == "growing") then
		if (self.harvestCounter < math.floor(self.plantInfo.harvestTime/3)) then
			tileView = display.newImage(spriteSheetForest, 4)
		elseif (self.harvestCounter < math.floor(self.plantInfo.harvestTime*2/3)) then
			tileView = display.newImage(spriteSheetForest, 3)
		else
			tileView = display.newImage(spriteSheetForest, 2)
		end
	elseif (self.state == "harvestable") then
		tileView = display.newImage(spriteSheetForest, 5)
	else 
		tileView = display.newImage(spriteSheetForest, 1)
	end

	tileView.anchorX = 0;
	tileView.anchorY = 0;
	tileView.x = self.x;
	tileView.y = self.y;
	tileView.width = self.size
	tileView.height	 = self.size

	-- remove old tile view
	if (self.tileView) then
		self.tileView:removeSelf()
		self.tileView = nil
	end

	-- add new image to scene
	self.tileView = tileView
	self.grp:insert(self.tileView)
end

function BulbFarmTile:removeSelf()
	self.grp = nil
	if (self.tileView) then
		self.tileView:removeSelf()
		self.tileView = nil
	end
	if (self.harvestCountView) then
		self.harvestCountView:removeSelf()
		self.harvestCountView = nil
	end
end