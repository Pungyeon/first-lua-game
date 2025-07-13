local Node = require('node')
local color = require('color')
local collision = require('collision')

Goal = {}
Goal.__index = Goal
Goal = setmetatable(Goal, { __index = Node })

function Goal:new(side, x, y, width, height)
    local obj = Node.new(self, x, y, width, height)
		obj.color = color.DARK_GREEN
		obj.can_score = true

		obj.top_post = Node.new(self, x, y, width, height*0.1)
		obj.bottom_post = Node.new(self, )
		obj.side = side
		setmetatable(obj, self)
    return obj
end

function Goal:draw()
	
end

function Goal:collision(puck) 
	if collision.Simple(self, puck) then
		if self:bounce_puck(puck) and self.can_score then
			self.can_score = false
			return true
		end
	end

	return false
end

function Goal:bounce_puck(puck)
	
end

return Goal