local Vector = require("scripts/types/vector")
local Color = require("scripts/types/color")

local Wall = {}

function Wall:new(x, y, width, height)
    return {
        position   = Vector:new(x, y),
        collision  = { type = "static", width = width, height = height },
        dimensions = { width = width, height = height },
        color      = Color.WHITE,
        render     = { type = "rectangle" },
        tag        = "wall"
    }
end

return Wall
