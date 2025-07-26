local Vector = require("scripts/types/vector")
local Color = require("scripts/types/color")

Puck = {}

function Puck:new(x, y)
    return {
        speed = 1000,
        position = Vector:new(x, y),
        velocity = Vector:new(0.2, 0.4),
        collision = { type = "particle", width = 10, height = 10 },
        physics = { type = "particle" },
        dimensions = { width = 10, height = 10 },
        color = Color.WHITE,
        render = { type = "rectangle" },
        tag = "puck"
    }
end

return Puck
