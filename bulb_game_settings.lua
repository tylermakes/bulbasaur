require("class")
require("bulb_color")

BulbGameSettings = class(function(c)
	local types = {}
	types["strawberry"] = { id=1, tileName="strawberry", cost=1001, color=BulbColor(1,0,0) }
	types["orange"] = { id=2, tileName="orange", cost=1002, color=BulbColor(1,0.6,0) }
	types["avocado"] = { id=3, tileName="avocado", cost=1003, color=BulbColor(0,0.6,0) }
	types["blueberries"] = { id=4, tileName="blueberries", cost=1004, color=BulbColor(0,0,1) }
	types["lemon"] = { id=5, tileName="lemon", cost=1005, color=BulbColor(1,1,0.6) }
	types["carrots"] = { id=6, tileName="carrots", cost=1007, color=BulbColor(1,0.8,0) }
	types["beets"] = { id=7, tileName="beets", cost=10010, color=BulbColor(0.8,0,.5) }
	types["peas"] = { id=8, tileName="peas", cost=1009, color=BulbColor(0,0.8,0) }
	-- types["asparagus"] = { id=7, tileName="asparagus", cost=1008, color=BulbColor(0.3,0.6,0.3) }
	-- types["pineapple"] = { id=9, tileName="pineapple", cost=1006, color=BulbColor(1,1,0) }
	c.types = types
	print("working here:", #types)
end)

function BulbGameSettings:getItemByID(id)
	for k, v in pairs(self.types) do
		if (v.id == id) then
			return v
		end
	end
end

function BulbGameSettings:getItemByName(name)
	return self.types[name]
end