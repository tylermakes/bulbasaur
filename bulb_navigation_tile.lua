require("class")

BulbNavigationTile = class(function(c, i, j, x, y, size, nav)
	c.i = i
	c.j = j
	c.x = x
	c.y = y
	c.size = size
	c.tileView = nil
	c.nav = nav
end)

function BulbNavigationTile:create(group)
	local tileView = display.newRect( 0, 0, self.size, self.size )
	tileView:setFillColor( 0.4, 0.4, 0.4 )
	
	tileView.anchorX = 0;
	tileView.anchorY = 0;
	tileView.x = self.x;
	tileView.y = self.y;
	self.tileView = tileView
	group:insert(self.tileView)
end

function BulbNavigationTile:update()
end

function BulbNavigationTile:removeSelf()
	if (self.tileView) then
		self.tileView:removeSelf()
		self.tileView = nil
	end
end