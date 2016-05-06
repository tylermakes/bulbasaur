require("class")
require("bulb_astar")

BulbPlayer = class(function(c, map)
	c.events = {}
	c.map = map
	c.playerView = nil
	c.aStar = BulbAStar()
	c.playerReversePath = nil
	if (map) then
		c.playerSize = map:getTileSize()
		c.playerLocation = map:getPlayerStartLocation()
		c.playerTargetLocation = c.playerLocation
	end
	c.oldLocation = c.playerLocation
	c.transitioning = 0;
	c.transitionStep = 0;
	c.TRANSITION_SPEED = 5;
end)

function BulbPlayer:create(group)
	local playerDisplayLocation = self.map:convertMapLocationToDisplayLocation(self.playerLocation);
	
	if (self.map) then
		local playerView = display.newRect( 0, 0, self.playerSize, self.playerSize )
		playerView:setFillColor( 1, 0.8, 0 )
		
		playerView.anchorX = 0;
		playerView.anchorY = 0;
		playerView.x = playerDisplayLocation.x;
		playerView.y = playerDisplayLocation.y;
		self.playerView = playerView
		group:insert(self.playerView)
	end
end

function BulbPlayer:update()
	if (self.transitioning ~= 0) then
		self:transition()
	else
		if (self.playerReversePath and #self.playerReversePath >= 1) then
			local newLocation = table.remove(self.playerReversePath)
			if (self.map:openToPlayer(newLocation)) then
				self.oldLocation = self.playerLocation
				self.playerLocation = newLocation
				if (self.map:getTile(newLocation).tileInfo.enemyWalkable == nil) then
					self.playerView:setFillColor(0.5, 0.4, 0)
				else 
					self.playerView:setFillColor(1, 0.8, 0)
				end
				self:startTransition()
			end
			--self:updateViewLocation()
		end
	end
	--print(self.playerTargetLocation.i, self.playerTargetLocation.j)
	-- local newLocation = {i=self.playerLocation.i, j=self.playerLocation.j}
	-- if (newLocation.i < self.playerTargetLocation.i) then
	-- 	newLocation.i = newLocation.i + 1
	-- elseif (newLocation.i > self.playerTargetLocation.i) then
	-- 	newLocation.i = newLocation.i - 1
	-- elseif (newLocation.j < self.playerTargetLocation.j) then
	-- 	newLocation.j = newLocation.j + 1
	-- elseif (newLocation.j > self.playerTargetLocation.j) then
	-- 	newLocation.j = newLocation.j - 1
	-- end
end

function BulbPlayer:startTransition()
	self.transitioning = self.TRANSITION_SPEED
	local oldLocation = self.map:convertMapLocationToDisplayLocation(self.oldLocation)
	local newLocation = self.map:convertMapLocationToDisplayLocation(self.playerLocation)
	
	self.transitionStep = {x = (newLocation.x - oldLocation.x)/self.TRANSITION_SPEED,
							y = (newLocation.y - oldLocation.y)/self.TRANSITION_SPEED}
	self:transition()
end

function BulbPlayer:transition()
	if (self.transitioning > 0) then
		self.transitioning = self.transitioning - 1
		self:updateViewLocation()
	else
		self:endTransition()
	end
end

function BulbPlayer:endTransition()
	self.transitioning = 0
	self.transitionStep = 0
end

function BulbPlayer:updateViewLocation()
	local newLocation = self.map:convertMapLocationToDisplayLocation(self.playerLocation)
	self.playerView.x = newLocation.x - (self.transitionStep.x * self.transitioning)
	self.playerView.y = newLocation.y - (self.transitionStep.y * self.transitioning)
end

-- function BulbPlayer:updateViewLocation()
-- 	local newLocation = self.map:convertMapLocationToDisplayLocation(self.playerLocation)
-- 	self.playerView.x = newLocation.x
-- 	self.playerView.y = newLocation.y
-- end

function BulbPlayer:setTargetLocation(event)
	local targetLocation = {i=event.x, j=event.y}
	local path = self.aStar:getPath(self.playerLocation, targetLocation, self.map, true)
	if (path) then
		self.playerTargetLocation = targetLocation
		self.playerReversePath = path
	else
		print("could not path to location")
	end
end

function BulbPlayer:removeSelf( )
	if (self.playerView) then
		self.playerView:removeSelf()
		self.playerView = nil
	end
end