local color = require('color')

Player = {}
Player.__index = Player
Player = setmetatable(Player, { __index = Node })

function Player:new(x, y, teamColor, inputComponent)
    local obj = Node.new(self, x, y, 50, 50)
    obj.inputComponent = inputComponent
    obj.color = teamColor
    obj.selected = false
    obj.bounce_time = 0
    obj.debug_msg = ""
    setmetatable(obj, self)
    return obj
end

function Player:draw()
    if self.selected then
        local border = 5
        local selected = Node:new(
            self.x - border,
            self.y - border,
            self.width + (border * 2),
            self.height + (border * 2)
        )
        selected.color = color.BLUE
        Node.draw(selected)
    end
    Node.draw(self)
end

function Player:handle_input(puck, goal)
    -- If a player is being bounced, then input does not matter.
    -- Essentially, you cannot do anything about a bounce
    if self.bounce_time > 0 then
        self.bounce_time = self.bounce_time - 1
        return
    end

    if self.inputComponent and self.selected then
        self.inputComponent:update(self)
        return
    else
        -- TODO: Make sure that player doesn't get stuck in net / similar.
        -- TODO: We need to ensure that we aren't chasing down our own players
        if puck.owner ~= nil and puck.owner.teamColor == self.teamColor then
            -- TODO : We still need to do something more intelligent
            -- here at some time, though, that is not now.
            self:move_towards({
                x = goal:center().x + 100 + math.random(20),
                y = goal:center().y
            })
            return
        end
    end
    self:move_towards(puck)
end

function Player:move_towards(puck)
    -- chase after puck
    -- TODO: We might have to check if distance to x is less than 1
    local diff = {
        x = puck.x - self.x,
        y = puck.y - self.y
    }

    if abs(diff.x) > abs(diff.y) then
        self.vx = sign(diff.x)
        self.vy = diff.y / abs(diff.x)
    else
        self.vx = diff.x / abs(diff.y)
        self.vy = sign(diff.y)
    end
end

-- TODO : move this into a library
function abs(n)
    if n < 0 then
        return n * -1
    end
    return n
end

-- TODO : move this into a library
function sign(n)
    if n < 0 then
        return -1
    end
    return 1
end

function Player:on_collision(result)
    self.bounce_time = 10
    if result.top then
        self.debug_msg = "top bounce"
        self.vy = 1
    end
    if result.bottom then
        self.debug_msg = "bottom bounce"
        self.vy = -1
    end
    if result.right then
        self.vx = -1
    end
    if result.left then
        self.vx = 1
    end
end

function Player:rollback(dt)
    Node.rollback(self, dt)

    -- TODO : we can simplify this a lot by putting this logic on the puck
    -- 	instead of having it here in the player (where it really doesn't belong)
    if self.carrying ~= nil then
        if self.vx < 0 then
            self.carrying.x = self.x + (self.carrying.width)
        end
        if self.vx > 0 then
            self.carrying.x = self.x - (self.width)
        end

        self.carrying.y = self.y - (self.height - self.carrying.height)
        self.carrying.vx = self.vx
        self.carrying.vy = self.vy
    end
end

function Player:update(dt)
    Node.update(self, dt)

    if self.carrying ~= nil then
        if self.vx < 0 then
            self.carrying.x = self.x - (self.carrying.width)
        end
        if self.vx > 0 then
            self.carrying.x = self.x + (self.width)
        end

        self.carrying.y = self.y + (self.height - self.carrying.height)
        self.carrying.vx = self.vx
        self.carrying.vy = self.vy
    end
end

function Player:pickup(puck)
    local was_picked_up = puck:pickup(self)
    if was_picked_up then
        self.carrying = puck
        self.carrying.speed = 0
    end
    return was_picked_up
end

function Player:shoot()
    if self.carrying ~= nil then
        self.carrying.speed = 1000
        self.carrying:release()
    end

    self.carrying = nil
end

function Player:select()
    if self.inputComponent == nil then
        return
    end
    self.selected = true
end

function Player:deselect()
    if self.inputComponent == nil then
        return
    end
    self.vx = 0
    self.vy = 0
    self.selected = false
end

return Player
