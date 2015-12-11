require("class")

-- AI Strategy 1
-- bounce player back and forth horizontally

BulbAIStrategy1 = class(function(c)
	c.map = nil
	c.enemy = nil
	c.goingLeft = true
end)

function BulbAIStrategy1:create(map, enemy)
	self.map = map
	self.enemy = enemy
end

function BulbAIStrategy1:getNextLocation()
	local newLocation = {i=self.enemy.location.i, j=self.enemy.location.j}
	if (self.goingLeft) then
		newLocation.i = newLocation.i - 1
	else
		newLocation.i = newLocation.i + 1
	end

	if (self.map:openToPlayer(newLocation)) then
		return newLocation
	else
		self.goingLeft = not self.goingLeft
		return self.enemy.location
	end
end