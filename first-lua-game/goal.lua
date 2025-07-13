local Node = require('node')
local color = require('color')
local collision = require('collision')

Goal = {}
Goal.__index = Goal
Goal = setmetatable(Goal, { __index = Node })

function Goal:new(x, y, width, height)
    local obj = Node.new(self, x, y, width, height)
		obj.color = color.DARK_GREEN
		obj.can_score = true
		setmetatable(obj, self)
    return obj
end

function Goal:collision(puck) 
	if collision.Simple(self, puck) then
		self:bounce_puck(puck)
		if self.can_score then
			self.can_score = false
			return true
		end
	end

	return false
end

function Goal:bounce_puck(puck)
	if puck.x < self.x then
		puck.vx = puck.vx * -1
	end
	
	if puck.y < self.y then
		puck.vy = puck.vy * -1
	end

	if puck.y > self.y + height then
		puck.vy = puck.vy * -1
	end
end

return Goal