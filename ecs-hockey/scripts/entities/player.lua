local Vector = require("scripts/types/vector")
local Color = require("scripts/types/color")
local SimplePhysics = require("scripts/components/physics")

Player = {}
Player.__index = Player

function Player:new(x, y, input)
    local obj = {
        speed = 200,
        position = Vector:new(x, y),
        velocity = Vector:new(0, 0),
        input = input,
        physics = SimplePhysics:new(),
        color = Color.RED
    }
    setmetatable(obj, self)
    return obj
end

function Player:draw()
    love.graphics.setColor(self.color.red, self.color.green, self.color.blue)
    love.graphics.rectangle("fill", self.position.x, self.position.y, 30, 30)
end

return Player
