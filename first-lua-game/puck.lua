local screenWidth, screenHeight = love.window.getMode()

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
		-- self.vx = self.vx * (0.2 * dt)
		-- self.vy = self.vy * (0.2 * dt)
		
		Node.update(self, dt)
end

function Puck:bounce(dt)
	
	self.vx = self.vx * -1
	self.vy = self.vy * -1
end

return Puck