local Vector = require("scripts/types/vector")
local Color = require("scripts/types/color")

Player = {}

function Player:new(x, y)
    return {
        speed      = 200,
        position   = Vector:new(x, y),
        velocity   = Vector:new(0, 0),
        selected   = {}, -- TODO : Make this nil by default
        render     = { type = "rectangle" },
        physics    = { "simple" },
        dimensions = { width = 30, height = 30 },
        collision  = { width = 30, height = 30 },
        color      = Color.RED,
        tag        = "player"
    }
end

return Player
