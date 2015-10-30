require("class")

BulbForestTile = class(function(c, i, j, x, y, size)
	c.i = i
	c.j = j
	c.x = x
	c.y = y
	c.size = size
	c.tileView = nil
	c.harvestCounter = 0
	c.harvestCountView = nil
	c.tileInfo = nil
	c.state = "dirt"
end)

function BulbForestTile:create(group, tileInfo)
	self.tileInfo = tileInfo
	local tileView = display.newRect( 0, 0, self.size, self.size )
	tileView:setFillColor( 0.8, 0.6, 0 )
	
	tileView.anchorX = 0;
	tileView.anchorY = 0;
	tileView.x = self.x;
	tileView.y = self.y;
	self.tileView = tileView
	group:insert(self.tileView)

	if (tileInfo) then
		tileView:setFillColor( tileInfo.color.r, tileInfo.color.g, tileInfo.color.b )
	end
end

function BulbForestTile:update()
	
end

function BulbForestTile:removeSelf()
	if (self.tileView) then
		self.tileView:removeSelf()
		self.tileView = nil
	end
end