require("class")
require("sprite_sheet_forest")

BulbFarmTile = class(function(c, i, j, x, y, size)
	c.i = i
	c.j = j
	c.x = x
	c.y = y
	c.size = size
	c.tileView = nil
	c.plantedAt = nil
	c.plantInfo = nil
	c.state = "dirt"
	c.grp = nil
end)

function BulbFarmTile:create(group, plantInfo, saveData)
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
		if (saveData and saveData.customData.plantedAt) then
			self.plantedAt = saveData.customData.plantedAt
		else
			self.plantedAt = os.time()
		end

		local currentTime = os.time()
		local diffTime = os.difftime(currentTime, self.plantedAt)
		if (diffTime >= self.plantInfo.harvestTime) then
			self.state = "harvestable"
		else
			self.state = "growing"
		end
		self:updateImage(diffTime)
		-- tileView:setFillColor( plant.color.r, plant.color.g, plant.color.b )
	end
end

function BulbFarmTile:update()
	if (self.state == "growing") then
		local currentTime = os.time()
		local diffTime = os.difftime(currentTime, self.plantedAt)
		if (diffTime >= self.plantInfo.harvestTime) then
			self.state = "harvestable"
		end
		self:updateImage(diffTime)
	end
end

function BulbFarmTile:getSaveData()
	local saveData = { tileName = "none"}
	if (self.plantInfo) then
		saveData = {tileName = self.plantInfo.tileName, customData = {plantedAt = self.plantedAt}}
	end
	return saveData
end

function BulbFarmTile:updateImage(diffTime)
	local tileView
	if (self.state == "growing") then
		if (diffTime < math.floor(self.plantInfo.harvestTime/3)) then
			tileView = display.newImage(spriteSheetForest, self.plantInfo.artStates[1])
		elseif (diffTime < math.floor(self.plantInfo.harvestTime*2/3)) then
			tileView = display.newImage(spriteSheetForest, self.plantInfo.artStates[2])
		else
			tileView = display.newImage(spriteSheetForest, self.plantInfo.artStates[3])
		end
	elseif (self.state == "harvestable") then
		tileView = display.newImage(spriteSheetForest, self.plantInfo.artStates[4])
	else 
		tileView = display.newImage(spriteSheetForest, 1)	-- dirt state
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
end