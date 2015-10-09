require("class")

BulbTile = class(function(c, i, j, x, y, size)
	c.i = i
	c.j = j
	c.x = x
	c.y = y
	c.size = size
	c.tileView = nil
end)

function BulbTile:create(group, type)
	local tileView = display.newRect( 0, 0, self.size, self.size )
	
	if (type) then
		tileView:setFillColor( 1/type, 1/type, 1/type )
	else 
		tileView:setFillColor( 0, 1, 0 )
	end
	tileView.anchorX = 0;
	tileView.anchorY = 0;
	tileView.x = self.x;
	tileView.y = self.y;

	self.tileView = tileView
	group:insert(self.tileView)
end

function BulbTile:removeSelf()
	if (self.tileView) then
		self.tileView:removeSelf()
		self.tileView = nil
	end
end