-- Node
Node = {}
Node.__index = Node

function Node:new(x, y, width, height)
    local obj = {
        x = x,
        y = y,
        vx = 0,
        vy = 0,
        speed = 200,
				width = width,
				height = height
    }
    setmetatable(obj, self)
    return obj
end

function Node:update(dt)
    self.x = self.x + self.vx * self.speed * dt
    self.y = self.y + self.vy * self.speed * dt
end

function Node:draw()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

-- InputComponent handles keyboard input
InputComponent = {}
InputComponent.__index = InputComponent

function InputComponent:new(inputMap)
    local obj = { map = inputMap }
    setmetatable(obj, self)
    return obj
end

function InputComponent:update(node)
    node.vx, node.vy = 0, 0
    for key, action in pairs(self.map) do
        if love.keyboard.isDown(key) then
            action(node)
        end
    end

    -- Normalize diagonal movement
    local mag = math.sqrt(node.vx^2 + node.vy^2)
    if mag > 0 then
        node.vx = node.vx / mag
        node.vy = node.vy / mag
    end
end

-- Player class inherits from Node and uses InputComponent
Player = {}
Player.__index = Player
Player = setmetatable(Player, { __index = Node })

function Player:new(x, y, inputComponent)
    local obj = Node.new(self, x, y)
    obj.inputComponent = inputComponent
		setmetatable(obj, self)
    return obj
end

function Player:update(dt)
    if self.inputComponent then
        self.inputComponent:update(self)
    end
    Node.update(self, dt)
end

-- Puck class inherits from Node but has no input
Puck = {}
Puck.__index = Puck
Puck = setmetatable(Puck, { __index = Node })

function Puck:new(x, y)
    local obj = Node.new(self, x, y)
		setmetatable(obj, self)
		return obj
end

-- Input map for player controls
local inputMap = {
    w = function(p) p.vy = p.vy - 1 end,
    s = function(p) p.vy = p.vy + 1 end,
    a = function(p) p.vx = p.vx - 1 end,
    d = function(p) p.vx = p.vx + 1 end
}

-- Love2D callbacks
function love.load()
    player = Player:new(100, 100, InputComponent:new(inputMap))
    puck = Puck:new(300, 300)
end

function love.update(dt)
    player:update(dt)
    puck:update(dt)
end

function love.draw()
    player:draw()
    puck:draw()
end
