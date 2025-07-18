local Player = require('player')

Goalie = {}
Goalie.__index = Goalie
Goalie = setmetatable(Goalie, { __index = Player })

function Goalie:new(x, y, teamColor, inputComponent)
    local obj = Player.new(self, x, y, teamColor, inputComponent)

		obj.top = obj.y - 40
		obj.bottom = obj.y + 40
		obj.speed = 100

		setmetatable(obj, self)
    return obj
end

function Goalie:move_towards(puck)

	if self:center().y < puck:center().y then
		self.vy = 1
	end 
	if self:center().y > puck:center().y then 
		self.vy = -1
	end
end

function Goalie:update(dt)
	if self.y < self.top then
		self.y = self.top
		self.vy = 0
	end

	if self.y > self.bottom then
		self.y = self.bottom
		self.vy = 0
	end
	
	Player.update(self, dt)
end

return Goalie