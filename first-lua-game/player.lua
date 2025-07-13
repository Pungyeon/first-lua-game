local color = require('color')

-- Player class inherits from Node and uses InputComponent
Player = {}
Player.__index = Player
Player = setmetatable(Player, { __index = Node })

function Player:new(x, y, inputComponent)
    local obj = Node.new(self, x, y, 50, 50)
    obj.inputComponent = inputComponent
		obj.color = color.RED
		setmetatable(obj, self)
    return obj
end

function Player:update(dt)
    if self.inputComponent then
        self.inputComponent:update(self)
    end
    Node.update(self, dt)
end

return Player