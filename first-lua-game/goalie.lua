local Player = require('player')

Goalie = {}
Goalie.__index = Goalie
Goalie = setmetatable(Goalie, { __index = Player })

function Goalie:new(x, y, teamColor, inputComponent)
    local obj = Player.new(self, x, y, teamColor, inputComponent)

		local obj.top = obj.y - 40
		local obj.bottom = obj.y + obj.height + 40

		setmetatable(obj, self)
    return obj
end

function Goalie:move_towards_puck(puck)
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

	if self.y + self.height > self.bottom then
	if 
end

return Goalie