require("class")

TMUtilities = class(function(c)
end)

function TMUtilities:doesExist(tbl)
	if (tbl) then
		return "yes"
	else
		return "no"
	end
end

-- CREATE UTILITIES
tmUtils = TMUtilities()
