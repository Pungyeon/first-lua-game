Player = {}
Player.__index = Player

function Player:new(x, y)
    local obj = {
        x = x,
        y = y,
        speed = 200,
        vx = 0,
        vy = 0,
        size = 50
    }
    setmetatable(obj, self)
    return obj
end

function Player:update(dt)
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

function Player:draw()
		love.graphics.setColor("red")
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
    player = Player:new(100, 100)
end

function love.update(dt)
    player:update(dt)
end

function love.draw()
    player:draw()
end
