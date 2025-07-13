local Node = require('node')
local color = require('color')
local collision = require('collision')

Goal = {}
Goal.__index = Goal
Goal = setmetatable(Goal, { __index = Node })

function Goal:new(x, y, width, height)
    local obj = Node.new(self, x, y, width, height)
		obj.color = color.DARK_GREEN
		setmetatable(obj, self)
    return obj
end

function Goal:collision(puck) 
	if collision.Simple(self, puck) then
		
	end

	return false
end

return Goal