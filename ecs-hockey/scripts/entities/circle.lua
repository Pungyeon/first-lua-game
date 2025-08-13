local Vector = require("scripts/types/vector")

local Circle = {}

function Circle:new(fill, x, y, radius, color)
	return {
		position = Vector:new(x, y),
		render = { type = "circle", fill = fill },
    radius = radius,
		color = color,
		tag = "circle",
	}
end

return Circle
