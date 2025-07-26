local Vector = require("scripts/types/vector")
local Color = require("scripts/types/color")

Player = {}
Player.__index = Player

function Player:new(x, y)
    local obj = {
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
    setmetatable(obj, self)
    return obj
end

return Player
