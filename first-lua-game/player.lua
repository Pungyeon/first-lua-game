local color = require('color')

Player = {}
Player.__index = Player
Player = setmetatable(Player, { __index = Node })

function Player:new(x, y, inputComponent)
    local obj = Node.new(self, x, y, 50, 50)
    obj.inputComponent = inputComponent
		obj.color = color.RED
		obj.selected = false
		setmetatable(obj, self)
    return obj
end

function Player:draw()
	if self.selected then
		local border = 5
		local selected = Node:new(
			self.x-border,
			self.y-border,
			self.width+(border*2),
			self.height+(border*2)
		)
		selected.color = color.BLUE
		Node.draw(selected)
	end
	Node.draw(self)
end

function Player:update(dt)
    if self.inputComponent and self.selected then
        self.inputComponent:update(self)
    end

    Node.update(self, dt)

		if self.carrying ~= nil then 
			if self.vx < 0 then 
				self.carrying.x = self.x - (self.carrying.width)
			end
			if self.vx > 0 then
				self.carrying.x = self.x + (self.width)
			end
			
			self.carrying.y = self.y + (self.height-self.carrying.height)
			self.carrying.vx = self.vx
			self.carrying.vy = self.vy
		end
end

function Player:pickup(puck)
	self.color = {
		red = 200,
		green = 0,
		blue = 0
	}
	self.carrying = puck
	self.carrying.speed = 0 
end

function Player:shoot()
	if self.carrying ~= nil then
		self.carrying.speed = 1000
	end

	self.carrying = nil 
end

function Player:select()
	self.selected = true
end

function Player:deselect()
	self.vx = 0
	self.vy = 0
	self.selected = false
end

return Player