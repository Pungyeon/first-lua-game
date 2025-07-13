
-- Puck class inherits from Node but has no input
Puck = {}
Puck.__index = Puck
Puck = setmetatable(Puck, { __index = Node })

function Puck:new(x, y)
    local obj = Node.new(self, x, y, 20, 20)
		obj.vx = 1
		obj.vy = 2
		setmetatable(obj, self)
		return obj
end

function Puck:update(dt)
		if self.vx > 0 then 
			self.vx 
		end 

		Node:update(self, dt)
end

return Puck