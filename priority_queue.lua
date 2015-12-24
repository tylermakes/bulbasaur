PriorityQueue = {
    __index = {
        put = function(self, v, p)
            local q = self[p]
            if not q then
                q = {}
                self[p] = q
            end
            q[#q + 1] = v
        end,
        pop = function(self)
        	local lowestP = nil
        	local lowestQ = nil
            for p, q in pairs(self) do
            	if (lowestP == nil or p < lowestP) then
            		lowestP = p
            		lowestQ = q
            	end
            end
            if (lowestQ) then
	        	local v = table.remove(lowestQ, 1)
	            if #lowestQ <= 0 then
	            	self[lowestP] = nil
	            end
	            return {p=lowestP, v=v}
	        end
            return nil
        end
    },
    __call = function(cls)
        return setmetatable({}, cls)
    end
}
 
setmetatable(PriorityQueue, PriorityQueue)