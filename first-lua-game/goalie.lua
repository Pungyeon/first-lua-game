local Player = require('player')

Goalie = {}
Goalie.__index = Player
Goalie = setmetatable(Goalie, { __index = Player })

function Goalie:new(x, y, teamColor, inputComponent)
    local obj = Player.new(self, x, y, teamColor, inputComponent)
		setmetatable(obj, self)
    return obj
end

function Goalie:ding()
	self.y = 0
end

return Goalie