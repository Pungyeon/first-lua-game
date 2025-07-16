Goalie = {}
Goalie.__index = Player
Goalie = setmetatable(Goalie, { __index = Player })

function Goalie:new(x, y, inputComponent)
    local obj = Node.new(self, x, y, 50, 50)
    obj.inputComponent = inputComponent
		obj.color = color.RED
		obj.selected = false
		setmetatable(obj, self)
    return obj
end	