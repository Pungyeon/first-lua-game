local screenWidth, screenHeight = love.window.getMode()
local color = require("color")

Puck = {}
Puck.__index = Puck
Puck = setmetatable(Puck, { __index = Node })

function Puck:new(x, y)
    local obj = Node.new(self, x, y, 20, 20)
    obj.owner = nil
    setmetatable(obj, self)
    return obj
end

function Puck:update(dt)
    if self.speed > 0 then
        self.speed = self.speed * (1 - dt)
    end

    Node.update(self, dt)
end

function Puck:release()
    self.owner = nil
end

function Puck:string()
    if self.owner == nil then
        return "EMPTY"
    end
    return "PICKED_UP"
end

function Puck:pickup(owner)
    if self.owner ~= nil then
        return false
    end
    self.owner = owner
    return true
end

function Puck:bounce(min_x, min_y, max_x, max_y)
    if self.x < min_x or self.x > max_x then
        self.speed = self.speed * 0.8
        self.vx = self.vx * -1
    end

    if self.x < min_x then
        self.x = min_x
    end

    if self.x > max_x then
        self.x = max_x - self.width
    end

    if self.y < min_y or self.y > max_y then
        self.speed = self.speed * 0.8
        self.vy = self.vy * -1
    end

    if self.y < min_y then
        self.y = min_y
    end

    if self.y > max_y then
        self.y = max_y - self.height
    end
end

return Puck
