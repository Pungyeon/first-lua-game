local Vector = require("scripts/types/vector")

local Circle = {}

function Circle:new(x, y, width, height, color)
	return {
		position = Vector:new(x, y),
		render = { type = "circle" },
		dimensions = { width = width, height = height },
		color = color,
		tag = "area",
	}
end

return Circle
