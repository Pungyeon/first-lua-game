local Vector = require("scripts/types/vector")
local Color = require("scripts/types/color")

Puck = {}

function Puck:new(x, y, width, height)
    return {
        speed = 1000,
        position = Vector:new(x, y),
        velocity = Vector:new(0, 0),
        collision = { type = "particle", width = width, height = height},
        physics = { type = "particle" },
        dimensions = { width = width, height = height },
        color = Color.WHITE,
        render = { type = "rectangle" },
        tag = "puck"
    }
end

return Puck
