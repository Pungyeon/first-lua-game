local color = require('color')
local Node = require('node')
local Player = require('player')

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
-- Puck class inherits from Node but has no input
Puck = {}
Puck.__index = Puck
Puck = setmetatable(Puck, { __index = Node })

function Puck:new(x, y)
    local obj = Node.new(self, x, y, 20, 20)
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

function checkCollision(a, b)
    return a.x < b.x + b.width and
           a.x + a.width > b.x and
           a.y < b.y + b.height and
           a.y + a.height > b.y
end

-- Love2D callbacks
function love.load()
    player = Player:new(100, 100, InputComponent:new(inputMap))
    puck = Puck:new(300, 300)
end

function love.update(dt)
    player:update(dt)
    puck:update(dt)

		if checkCollision(player, puck) then
			-- TODO : @pungyeon - we should have the player push the puck somehow
			--  Or simply just pick up and carry the puck like a normal ice-hockey
			--  game.  
			puck.color = color.GREEN
		else 
			puck.color = color.WHITE
		end
end

function love.draw()
    player:draw()
    puck:draw()
end
