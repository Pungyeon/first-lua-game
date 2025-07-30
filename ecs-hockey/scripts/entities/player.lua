local Vector = require("scripts/types/vector")
local Color = require("scripts/types/color")

Player = {}

function Player:new(x, y, team)
    return {
        team       = team,
        speed      = 200,
        reset_position = Vector:new(x, y),
        position   = Vector:new(x, y),
        velocity   = Vector:new(0, 0),
        render     = { type = "rectangle" },
        physics    = { type = "simple" },
        dimensions = { width = 30, height = 30 },
        collision  = { type = "rigid", width = 30, height = 30, bounce = 0 },
        tag        = "player"
    }
end

return Player
