require("class")

-- AI Strategy 2
-- bounce player back and forth vertically

BulbAIStrategy2 = class(function(c)
	c.map = nil
	c.enemy = nil
	c.goingLeft = true
end)

function BulbAIStrategy2:create(map, enemy)
	self.map = map
	self.enemy = enemy
end

function BulbAIStrategy2:getNextLocation()
	local newLocation = {i=self.enemy.location.i, j=self.enemy.location.j}
	if (self.goingUp) then
		newLocation.j = newLocation.j - 1
	else
		newLocation.j = newLocation.j + 1
	end

	if (self.map:openToEnemy(newLocation)) then
		return newLocation
	else
		self.goingUp = not self.goingUp
		return self.enemy.location
	end
end