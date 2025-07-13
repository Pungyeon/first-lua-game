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
		obj.side = side
		setmetatable(obj, self)
    return obj
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
	-- Puck touches bottom of goal from outside
	if puck.y < self.y + self.height and puck.y + (puck.height/2) > self.y + self.height then
		puck.vy = puck.vy * -1
		return false
	end
	
	-- Puck touches back of goal from outside
	if puck.x > self.x and puck.x + (puck.width / 2) < self.x then 
		puck.vx = puck.vx * -1
		return false
	end

	-- Puck touch top of goal from outside
	  if puck.


	if puck.x < self.x then
		puck.speed = puck.speed * 0.2
		puck.vx = puck.vx * -1
	end
	
	if puck.y < self.y then
		puck.speed = puck.speed * 0.2
		puck.vy = puck.vy * -1
	end

	if puck.y > self.y + self.height then
		puck.speed = puck.speed * 0.2
		puck.vy = puck.vy * -1
	end
end

return Goal