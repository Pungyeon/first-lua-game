local Node = require('node')
local color = require('color')
local area = require('area')

Goal = {}
Goal.__index = Goal
Goal = setmetatable(Goal, { __index = Node })

function Goal:new(side, x, y, width, height)
    local obj = Node.new(self, x, y, width, height)
    obj.color = color.DARK_GREEN
    obj.can_score = true

    local post_width = height * 0.1
    obj.post_top = Node.new(self, x, y, width, post_width)
    obj.post_top.color = color.BLUE
    obj.post_bottom = Node.new(self, x, y + height - post_width, width, post_width)
    obj.post_bottom.color = color.BLUE
    if side == -1 then
        obj.post_back = Node.new(self, x, y, post_width, height)
    else
        obj.post_back = Node.new(self, x + width - post_width, y, post_width, height)
    end
    obj.post_back.color = color.BLUE

    setmetatable(obj, self)
    return obj
end

function Goal:draw()
    Node.draw(self)
    Node.draw(self.post_top)
    Node.draw(self.post_bottom)
    Node.draw(self.post_back)
end

function Goal:collision(dt, puck)
    if area.Collision(self.post_top, puck) then
        puck.vy = puck.vy * -1
        Node.update(puck, dt)
        puck.speed = puck.speed * 0.2
    end

    if area.Collision(self.post_bottom, puck) then
        puck.vy = puck.vy * -1
        Node.update(puck, dt)
        puck.speed = puck.speed * 0.2
    end

    if area.Collision(self.post_back, puck) then
        puck.vx = puck.vx * -1
        Node.update(puck, dt)
        puck.speed = puck.speed * 0.2
    end

    if area.Contains(self, puck) then
        if self.can_score then
            puck.speed = puck.speed * 0.1
            self.can_score = false
            return true
        end
    end

    return false
end

return Goal
