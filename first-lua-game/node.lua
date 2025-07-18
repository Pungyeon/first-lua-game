local color = require('color')

-- Node
Node = {}
Node.__index = Node

function Node:new(x, y, width, height)
    local obj = {
        x = x,
        y = y,
        vx = 0,
        vy = 0,
        speed = 200,
				width = width,
				height = height,
				color = color.WHITE
    }
    setmetatable(obj, self)
    return obj
end

function Node:center() 
	return {
		x = self.y + self.height/2,
		y = 
end

function Node:update(dt)
    self.x = self.x + self.vx * self.speed * dt
    self.y = self.y + self.vy * self.speed * dt
end

function Node:draw()
		love.graphics.setColor(self.color.red, self.color.green, self.color.blue)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

return Node