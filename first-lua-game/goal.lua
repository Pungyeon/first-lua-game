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
		puck:bounce(self.x, self.y, 10000, 10000)
		if self.can_score then
			self.can_score = false
			return true
		end
	end

	return false
end

return Goal