require("class")
require("sprite_sheet_forest")

BulbForestTile = class(function(c, i, j, x, y, size)
	c.i = i
	c.j = j
	c.x = x
	c.y = y
	c.size = size
	c.tileView = nil
	c.tileInfo = nil
	c.nav = nil
end)

function BulbForestTile:create(group, tileInfo, customData)
	self.tileInfo = tileInfo or bulbBuilderSettings.dirtType
	local tileView
	if (self.tileInfo.tileName == "REPLACE_THIS_LATER") then
		tileView = display.newImage(spriteSheetForest, 1)
	else
		tileView = display.newRect( 0, 0, self.size, self.size )
		tileView:setFillColor( 0.8, 0.6, 0 )
	end
	
	tileView.anchorX = 0;
	tileView.anchorY = 0;
	tileView.x = self.x;
	tileView.y = self.y;
	tileView.width = self.size
	tileView.height	 = self.size
	self.tileView = tileView
	group:insert(self.tileView)

	if (customData) then
		self.nav = customData.nav
	end

	if (tileInfo) then
		tileView:setFillColor( tileInfo.color.r, tileInfo.color.g, tileInfo.color.b )
	end
end

function BulbForestTile:setNavLocation( navLocation )
	if (self.tileInfo.tileName == "nav") then
		self.nav = navLocation
	end
end

function BulbForestTile:update()
	
end

function BulbForestTile:getSaveData()
	return {tileName = self.tileInfo.tileName, customData = {nav = self.nav}}
end

function BulbForestTile:removeSelf()
	if (self.tileView) then
		self.tileView:removeSelf()
		self.tileView = nil
	end
end