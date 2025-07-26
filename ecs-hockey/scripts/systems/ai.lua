local EventBus = require("scripts/types/event_bus")
local Color = require("scripts/types/color")
local Assert = require("scripts/assert/assert")

AISystem = {
    possession = nil,
    puck = nil,
    squares = {}
}

function AISystem:initialise(entities)
    self.team_to_players = {}
    for _, entity in ipairs(entities) do
        if entity.tag == "puck" then
            self.puck = entity
        end
        if entity.tag == "player" then
            local key = entity.team.id
            if self.team_to_players[key] == nil then
                self.team_to_players[key] = {}
            end
            table.insert(self.team_to_players[key], entity)
        end
    end

    Assert.NotNil(self.puck, "no puck found for AISystem")

    EventBus:on("possession", function(entity)
        self.possession = entity
    end)
end

function AISystem:calculate_spatial_map()
    -- TODO : initialise this in initialise instead.
    local columns = 3
    local rows = 2
    local screen_width, screen_height = love.window.getMode()
    local square_width = screen_width / columns
    local square_height = screen_height / rows

    local squares = {}
    local current_x = 0
    local current_y = 0
    for i = 1, columns do
        for j = 1, rows do
            table.insert(squares, {
                x = (i - 1) * square_width,
                y = (j - 1) * square_height,
                width = square_width,
                height = square_height,
                contains = 0
            })
        end
    end

    for team, players in ipairs(self.team_to_players) do
        for _, player in ipairs(players) do
            for i = 1, #squares do
                if is_within_square(player.position, squares[i]) then
                    squares[i].contains = squares[i].contains + 1
                end
            end
        end
    end

    self.squares = squares
end

function is_within_square(pos, square)
    return pos.x > square.x
        and pos.x < square.x + square.width
        and pos.y > square.y
        and pos.y < square.y + square.height
end

function get_best_square(pos, squares)
    -- TODO : implement me
end

function AISystem:handle(dt)
    self:calculate_spatial_map()

    for team, players in ipairs(self.team_to_players) do
        for _, player in ipairs(players) do
            -- TODO : skip if the player is traveling (or within distance of travel goal)
            if player.selected == nil then
                if self.possession and self.possession.team.id == team then
                    -- TODO : try to find space.
                    -- get the best square
                    -- set player.travelling = { x, y }
                else
                    local distance = self.puck.position:distance_to(player.position)
                    -- local distance = player.position:distance_to(self.puck.position)
                    player.velocity = Vector:new(
                        distance.x / distance.direct,
                        distance.y / distance.direct
                    )
                end
            end
        end
    end
end

function AISystem:debug()
    -- TODO : draw the square map
    for _, square in ipairs(self.squares) do
        love.graphics.setColor(Color.WHITE.red, Color.WHITE.green, Color.WHITE.blue)
        love.graphics.setLineWidth(5)
        love.graphics.line(
            square.x, square.y,
            square.x + square.width, square.y,
            square.x + square.width, square.y + square.height
        )
        love.graphics.print(square.contains, square.x + square.width / 2, square.y + square.height / 2)
    end
end

return AISystem
