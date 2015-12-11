require("class")

-- A Star Pathing

BulbAStar = class(function(c)
	c.frontier ={}
	c.cameFrom = {}
end)

function BulbAStar:reset()
	self.frontier = {}
	self.cameFrom = {}
end

function BulbAStar:insertIntoCameFrom(location, value)
	if (not self.cameFrom[location.i]) then
		self.cameFrom[location.i] = {}
	end
	self.cameFrom[location.i][location.j] = value
end

function BulbAStar:getPath(start, goal, map)
	self:reset()

	self.frontier[#self.frontier + 1] = start
	self:insertIntoCameFrom(start, "none")

	while (#self.frontier >= 1) do
		local current = table.remove(self.frontier, 1)
		for i,nextNeighbor in ipairs(map:getNeighbors(current)) do
			if (not self.cameFrom[nextNeighbor.i] or not self.cameFrom[nextNeighbor.i][nextNeighbor.j]) then
				self.frontier[#self.frontier + 1] = nextNeighbor
				self:insertIntoCameFrom(nextNeighbor, current)
				if (nextNeighbor.i == goal.i and nextNeighbor.j == goal.j) then
					return self:getActualPath(start, nextNeighbor)
				end
			end
		end
	end

	return nil
end

function BulbAStar:getActualPath(start, goal)
	local path = {}
	local current = goal
	path[#path + 1] = current
	while (current.i ~= start.i or current.j ~= start.j) do
		current = self.cameFrom[current.i][current.j]
		path[#path + 1] = current
	end
	-- NOTE: PATH IS RETURNED IN REVERSE!!!
	return path
end

-- frontier = Queue()
-- frontier.put(start)
-- came_from = {}
-- came_from[start] = None

-- while not frontier.empty():
--    current = frontier.get()
--    for next in graph.neighbors(current):
--       if next not in came_from:
--          frontier.put(next)
--          came_from[next] = current