local Player = require('player')

Goalie = {}
Goalie.__index = Player
Goalie = setmetatable(Goalie, { __index = Player })

function Goalie:new(x, y, teamColor, inputComponent)
    local obj = Player:new(x, y, teamColor, inputComponent)

		obj.max_y = y+obj.height + 40
		obj.min_y = y - 40

		setmetatable(obj, self)
    return obj
end	

function Goalie:update(dt, puck) 
	if self.y < puck.y then
		self.y = self.y - (dt * self.speed / 2)
	end

	if self.y > puck.y then 
		self.y = self.y + (dt * self.speed / 2)
	end

	Player.update(self, dt)
end

return Goalie