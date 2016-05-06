require("class")
require("priority_queue")

-- A Star Pathing
-- Based on the Red Blob Tutorial:
-- http://www.redblobgames.com/pathfinding/a-star/introduction.html

BulbAStarClosest = class(function(c)
	c.frontier = PriorityQueue()
	c.cameFrom = {}
	c.costSoFar = {}
end)

function BulbAStarClosest:reset()
	self.frontier = PriorityQueue()
	self.cameFrom = {}
	self.costSoFar = {}
end

function BulbAStarClosest:insertLocationIntoTable(table, location, value)
	if (not table[location.i]) then
		table[location.i] = {}
	end
	table[location.i][location.j] = value
end

function BulbAStarClosest:getLocationFromTable(table, location)
	if (not table[location.i]) then
		return nil
	end
	return table[location.i][location.j]
end

function BulbAStarClosest:getPath(start, goal, map, isPlayer)
	self:reset()

	self.frontier:put(start,0)
	self:insertLocationIntoTable(self.costSoFar, start, 0)
	self:insertLocationIntoTable(self.cameFrom, start, "none")

	local current = self.frontier:pop().v

	while (current ~= nil) do
		for i,nextNeighbor in ipairs(map:getNeighbors(current, isPlayer)) do
			local newCost = self:getLocationFromTable(self.costSoFar, current) + map:getCost(current, nextNeighbor)
			local neighborCostSoFar = self:getLocationFromTable(self.costSoFar, nextNeighbor)
			if ((neighborCostSoFar == nil) or newCost < neighborCostSoFar) then
				self:insertLocationIntoTable(self.costSoFar, nextNeighbor, newCost)
				local priority = newCost + map:heuristic(goal, nextNeighbor)
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

	-- didn't find path to location, try to find closes path
	-- FUTURE PROJECT, NOT DONE YET
	-- local leftDistance = 1
	-- local rightDistance = 1
	-- local upDistance = 1
	-- local leftDistance = 1
	-- local iterations = 0
	-- while(iterations <= 100)
	-- 	goal - leftDistance -> goal + rightDistance
	-- 	goal -
	-- 	self.cameFrom[]

	-- end


	return nil
end

function BulbAStarClosest:getActualPath(start, goal)
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