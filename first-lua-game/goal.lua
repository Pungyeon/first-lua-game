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

		local post_width = height * 0.1
		obj.post_top = Node.new(self, x, y, width, post_width)
		obj.post_bottom = Node.new(self, x, y+height-post_width, width, post_width)
		if side == -1 then
			obj.post_back = Node.new(self, x, y, post_width, height)
		else
			obj.post_back = Node.new(self, x+width-post_width, y, post_width, height)
		end

		setmetatable(obj, self)
    return obj
end

function Goal:draw()
	
end

function Goal:collision(puck) 
	if collision.Simple(self.post_top, puck) then
		puck.vx = puck.vy * -1
		puck.speed = puck.speed * 0.2
	end

	if collision.Simple(self.post_bottom, puck) then
		puck.vx = puck.vy * -1
		puck.speed = puck.speed * 0.2
	end

	if collision.Simple(self.post_back, puck) then
		puck.vx = puck.vx * -1
		puck.speed = puck.speed * 0.2
	end

	if collision.isContained(self, puck) then
		if self.can_score then
			self.can_score = false
			return true
		end
	end

	return false
end

return Goal