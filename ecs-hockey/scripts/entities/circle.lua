local Vector = require("scripts/types/vector")

local Circle = {}

function Circle:new(x, y, radius, color)
	return {
		position = Vector:new(x, y),
		render = { type = "circle" },
    radius = radius,
		color = color,
		tag = "circle",
	}
end

return Circle
