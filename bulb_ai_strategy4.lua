require("class")

-- AI Strategy 4
-- go to the player's side

BulbAIStrategy4 = class(function(c)
	c.map = nil
	c.enemy = nil
	c.goingLeft = true
	c.reversePath = nil
end)

function BulbAIStrategy4:create(map, enemy)
	self.map = map
	self.enemy = enemy
	self.reversePath = nil
end

function BulbAIStrategy4:getNextLocation(player)
	if (self.reversePath and #self.reversePath >= 1) then
		local newLocation = table.remove(self.reversePath)
		if (self.map:openToEnemy(newLocation)) then

			-- TODO: Figure out why we were stopping the enemies next to the player...
			-- we're already right next to the player
			-- if (newLocation.i == player.playerLocation.i or newLocation.j == player.playerLocation.j) then
			-- 	if (newLocation.i == player.playerLocation.i + 1 or newLocation.i == player.playerLocation.i - 1 or
			-- 		newLocation.j == player.playerLocation.j + 1 or newLocation.j == player.playerLocation.j - 1) then
			-- 		self.reversePath = nil
			-- 	end
			-- end

			return newLocation
		else
			return self.enemy.location
		end
	else
		self:getRandomPath(player)
		return self.enemy.location
	end
end

function BulbAIStrategy4:getRandomPath(player)
	local path = globalAStar:getPath(self.enemy.location, 
									{i=math.floor(math.random()*self.map.columns+1),
										j=math.floor(math.random()*self.map.rows+1)},
									self.map, false)
	if (path) then
		self.reversePath = path
	else
		-- print("enemy could not path to location")
	end
end
