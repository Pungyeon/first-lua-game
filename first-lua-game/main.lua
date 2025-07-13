Node = {}
Node.__index = Node

Player = {}
Player.__index = Player

function Node:new(x, y)
    local obj = {
        x = x,
        y = y,
        vx = 0,
        vy = 0,
        size = 50,
        speed = 200
    }
    setmetatable(obj, self)
    return obj
end

function Node:update(dt)
    self.vx, self.vy = 0, 0

    for key, action in pairs(InputMap) do
        if love.keyboard.isDown(key) then
            action(self)
        end
    end

    -- Normalize diagonal movement
    local mag = math.sqrt(self.vx^2 + self.vy^2)
    if mag > 0 then
        self.vx = self.vx / mag
        self.vy = self.vy / mag
    end

    self.x = self.x + self.vx * self.speed * dt
    self.y = self.y + self.vy * self.speed * dt
end

function Node:draw()
		love.graphics.setColor(180, 0, 0)
    love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)
end

-- Input mapping
InputMap = {
    w = function(p) p.vy = p.vy - 1 end,
    s = function(p) p.vy = p.vy + 1 end,
    a = function(p) p.vx = p.vx - 1 end,
    d = function(p) p.vx = p.vx + 1 end
}

-- Love2D callbacks
function love.load()
    player = Node:new(100, 100)
		puck = Node:new(200, 200)
end

function love.update(dt)
    player:update(dt)
		puck:update(dt)
end

function love.draw()
    player:draw()
		puck:draw()
end
