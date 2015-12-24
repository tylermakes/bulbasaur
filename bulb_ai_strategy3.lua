require("class")

-- AI Strategy 3
-- go to the player's side

BulbAIStrategy3 = class(function(c)
	c.map = nil
	c.enemy = nil
	c.goingLeft = true
	c.reversePath = nil
end)

function BulbAIStrategy3:create(map, enemy)
	self.map = map
	self.enemy = enemy
	self.reversePath = nil
end

function BulbAIStrategy3:getNextLocation(player)
	if (self.reversePath and #self.reversePath >= 1) then
		local newLocation = table.remove(self.reversePath)
		if (self.map:openToPlayer(newLocation)) then

			-- we're already right next to the player
			if (newLocation.i == player.playerLocation.i or newLocation.j == player.playerLocation.j) then
				if (newLocation.i == player.playerLocation.i + 1 or newLocation.i == player.playerLocation.i - 1 or
					newLocation.j == player.playerLocation.j + 1 or newLocation.j == player.playerLocation.j - 1) then
					self.reversePath = nil
				end
			end

			return newLocation
		else
			return self.enemy.location
		end
	else
		self:getPathToPlayer(player)
		return self.enemy.location
	end
end

function BulbAIStrategy3:closestLocationToPlayer(player)
	if (self.map:openToPlayer({i=player.playerLocation.i-1, j=player.playerLocation.j})) then
		return {i=player.playerLocation.i-1, j=player.playerLocation.j}
	elseif  (self.map:openToPlayer({i=player.playerLocation.i+1, j=player.playerLocation.j})) then
		return {i=player.playerLocation.i+1, j=player.playerLocation.j}
	elseif  (self.map:openToPlayer({i=player.playerLocation.i, j=player.playerLocation.j-1})) then
		return {i=player.playerLocation.i, j=player.playerLocation.j-1}
	elseif  (self.map:openToPlayer({i=player.playerLocation.i, j=player.playerLocation.j+1})) then
		return {i=player.playerLocation.i, j=player.playerLocation.j+1}
	else
		print("player is surrounded?")
	end
end

function BulbAIStrategy3:getPathToPlayer(player)
	local closestLocation = self:closestLocationToPlayer(player)

	local path = globalAStar:getPath(self.enemy.location, closestLocation, self.map)
	if (path) then
		self.reversePath = path
	else
		print("enemy could not path to location")
	end
end
