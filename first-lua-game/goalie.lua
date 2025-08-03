local Player = require('player')
local color = require('color')

Goalie = {}
Goalie.__index = Goalie
Goalie = setmetatable(Goalie, { __index = Player })

function Goalie:new(x, y, teamColor, inputComponent)
    local obj = Player.new(self, x, y, teamColor, inputComponent)

    obj.top = obj.y - 40
    obj.bottom = obj.y + 40
    obj.speed = 100
    obj.puck_time = 0

    setmetatable(obj, self)
    return obj
end

function Goalie:pickup(puck)
    if self.carrying == nil then
        self.puck_time = 60
        self.vy = 0
    end

    Player.pickup(self, puck)
end

function Goalie:move_towards(dt, puck)
    if self.carrying ~= nil then
        self.puck_time = self.puck_time - 1
        if self.puck_time < 0 then
            self.carrying.vx = 1
            self.carrying.vy = -1
            self.carrying.speed = 1000
            self.carrying:release()
            self.carrying:update(dt)
            self.carrying = nil
        end
        return
    end

    if self:center().y < puck:center().y and self.y < self.bottom then
        self.vy = 1
    end
    if self:center().y > puck:center().y and self.y > self.top then
        self.vy = -1
    end
end

function Goalie:update(dt)
    if self.y < self.top then
        self.y = self.top
        self.vy = 0
    end

    if self.y > self.bottom then
        self.y = self.bottom
        self.vy = 0
    end

    Player.update(self, dt)
end

return Goalie
