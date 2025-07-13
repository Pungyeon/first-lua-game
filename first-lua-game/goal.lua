local Node = require('node')

Goal = {}
Goal = setmetatable(Goal, { __index = Node })

function Goal:new(x, y, width, height)
    local obj = Node.new(self, x, y, width, height)
		obj.color = color.DARK_GREEN
		setmetatable(obj, self)
    return obj
end

return Goal