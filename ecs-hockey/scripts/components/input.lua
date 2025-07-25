local Vector = require("scripts/types/vector")

Input = {}
Input.__index = Input

function Input:new()
    local obj = {}
    setmetatable(obj, self)
    return obj
end

function Input:handle(entity)
    if entity.velocity then
        entity.velocity = Vector:new(0, 0)
        if love.keyboard.isDown("w") then
            entity.velocity.y = -1
        end
        if love.keyboard.isDown("s") then
            entity.velocity.y = 1
        end
        if love.keyboard.isDown("a") then
            entity.velocity.x = -1
        end
        if love.keyboard.isDown("d") then
            entity.velocity.x = 1
        end
    end
end

return Input
