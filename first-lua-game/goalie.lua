local Player = require('player')

Goalie = {}
Goalie.__index = Player
Goalie = setmetatable(Goalie, { __index = Player })

function Goalie:new(x, y, teamColor, inputComponent)
    local obj = Node.new(self, x, y, 50, 50)
    obj.inputComponent = inputComponent
		obj.color = teamColor
		obj.selected = false
		setmetatable(obj, self)
    return obj
end

function Goalie:ding()
	self.y = 0
end

return Goalie