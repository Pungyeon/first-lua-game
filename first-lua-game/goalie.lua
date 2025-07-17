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

return Goalie