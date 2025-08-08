local Vector = require("scripts/types/vector")

local Area = {}

function Area:new(x, y, width, height, color)
	return {
		position = Vector:new(x, y),
		render = { type = "rectangle" },
		dimensions = { width = width, height = height },
		color = color,
		tag = "area",
	}
end

return Area
