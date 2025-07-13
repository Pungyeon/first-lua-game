local screenWidth, screenHeight = love.window.getMode()
local color = require("color")

Puck = {}
Puck.__index = Puck
Puck = setmetatable(Puck, { __index = Node })

function Puck:new(x, y)
    local obj = Node.new(self, x, y, 20, 20)
		obj.vx = 0.5
		obj.vy = 1
		setmetatable(obj, self)
		return obj
end

function Puck:update(dt)
		if self.speed > 0 then
			self.speed = self.speed * (1 - dt)
		end

		self:bounce()
		
		Node.update(self, dt)
end

function Puck:bounce()
	if self.x < 0 or self.x > screenWidth then
		self.speed = self.speed * 0.8
		self.vx = self.vx * -1
	end

	if self.x < 0 then
	end
	
	if self.y < 0 or self.y > screenHeight then
		self.speed = self.speed * 0.8
		self.vy = self.vy * -1
	end
end

return Puck