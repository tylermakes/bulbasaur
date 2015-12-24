require("class")
require("priority_queue")

-- A Star Pathing
-- Based on the Red Blob Tutorial:
-- http://www.redblobgames.com/pathfinding/a-star/introduction.html

BulbGreedyBestFirstSearch = class(function(c)
	c.frontier = PriorityQueue()
	c.cameFrom = {}
end)

function BulbGreedyBestFirstSearch:reset()
	self.frontier = PriorityQueue()
	self.cameFrom = {}
end

function BulbGreedyBestFirstSearch:insertLocationIntoTable(table, location, value)
	if (not table[location.i]) then
		table[location.i] = {}
	end
	table[location.i][location.j] = value
end

function BulbGreedyBestFirstSearch:getLocationFromTable(table, location)
	if (not table[location.i]) then
		return nil
	end
	return table[location.i][location.j]
end

function BulbGreedyBestFirstSearch:getPath(start, goal, map)
	self:reset()

	self.frontier:put(start,0)
	self:insertLocationIntoTable(self.cameFrom, start, "none")

	local current = self.frontier:pop().v

	while (current ~= nil) do
		for i,nextNeighbor in ipairs(map:getNeighbors(current)) do
			if (not self:getLocationFromTable(self.cameFrom, nextNeighbor)) then
				local priority = map:heuristic(goal, nextNeighbor)
				self.frontier:put(nextNeighbor, priority)
				self:insertLocationIntoTable(self.cameFrom, nextNeighbor, current)
				if (nextNeighbor.i == goal.i and nextNeighbor.j == goal.j) then
					return self:getActualPath(start, nextNeighbor)
				end
			end
		end
		local nextStep = self.frontier:pop()
		if (nextStep) then
			current = nextStep.v
		else
			current = nil
		end
	end

	return nil
end

function BulbGreedyBestFirstSearch:getActualPath(start, goal)
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