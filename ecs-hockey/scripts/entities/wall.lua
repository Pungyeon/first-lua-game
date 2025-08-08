local Vector = require("scripts/types/vector")
local Color = require("scripts/types/color")

local Wall = {}

local function  or_default(v, d)
  if not v then
    return d
  end
  if v == 0 then
    return d
  end
  return v
end

function Wall:new(x, y, width, height, slowdown)
	return {
		position = Vector:new(x, y),
		collision = { type = "static", width = width, height = height },
		dimensions = { width = width, height = height },
		color = Color.WHITE,
		render = { type = "rectangle" },
		tag = "wall",
		slowdown = or_default(slowdown, 0.75),
	}
end

return Wall
