require("class")
require("bulb_tile")

BulbMap = class(function(c, width, height, rows, columns)
	c.width = width
	c.height = height
	c.rows = rows
	c.columns = columns
	c.tileSize = c.height/rows
	c.layers = {}
end)

function BulbMap:create(group)
	self.tileGroup = display.newGroup()
	self.layers[1] = {}
	for i=1, self.columns do
		self.layers[1][i] = {}
		for j=1, self.rows do
			self.layers[1][i][j] = BulbTile(i, j, (i-1) * self.tileSize, (j-1) * self.tileSize, self.tileSize)
			self.layers[1][i][j]:create(group)
		end
	end
end

function BulbMap:removeSelf()
	if (self.layers[1]) then
		for i=1, #self.layers[1] do
			for j=1, #self.layers[1][i] do
				self.layers[1][i][j]:removeSelf()
			end
		end
	end
end