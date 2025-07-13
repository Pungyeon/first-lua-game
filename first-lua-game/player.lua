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

		if self.carrying ~= nil then 
			self.carrying.speed = 0
			if self.vx < 0 then 
				
			else 
			end
		end

    Node.update(self, dt)
end

function Player:pickup(puck)
	self.color = {
		red = 200,
		green = 0,
		blue = 0
	}
	self.carrying = puck
end

function Player:shoot()
	if self.carrying ~= nil then
		self.carrying.speed = 1000
	end


	self.carrying = nil 
end

return Player