local Vector = require("scripts/types/vector")
local Color = require("scripts/types/color")

Player = {}

function Player:new(x, y)
    return {
        speed      = 200,
        position   = Vector:new(x, y),
        velocity   = Vector:new(0, 0),
        render     = { type = "rectangle" },
        physics    = { type = "simple" },
        dimensions = { width = 30, height = 30 },
        collision  = { type = "rigid", width = 30, height = 30 },
        color      = Color.RED,
        tag        = "player"
    }
end

return Player
