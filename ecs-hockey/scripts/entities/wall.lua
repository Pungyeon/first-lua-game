local Vector = require("scripts/types/vector")
local Color = require("scripts/types/color")

local Wall = {}

function Wall:new(x, y, width, height, slowdown)
    if slowdown == 0 then
      slowdown = 0.75
    end
    return {
        position   = Vector:new(x, y),
        collision  = { type = "static", width = width, height = height },
        dimensions = { width = width, height = height },
        color      = Color.WHITE,
        render     = { type = "rectangle" },
        tag        = "wall",
        slowdown   = slowdown,
    }
end

return Wall
