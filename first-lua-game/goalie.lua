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

function Goalie:ding()
	s
end

return Goalie