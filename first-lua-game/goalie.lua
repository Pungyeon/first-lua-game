Goalie = {}
Goalie.__index = Goalie
Goalie = setmetatable(Goalie, { __index = Node })

function Player:new(x, y, inputComponent)
    local obj = Node.new(self, x, y, 50, 50)
    obj.inputComponent = inputComponent
		obj.color = color.RED
		obj.selected = false
		setmetatable(obj, self)
    return obj
end	