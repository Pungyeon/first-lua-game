local love = require("love")
local EventBus = require("scripts/types/event_bus")
local Color = require("scripts/types/color")
local Teams = require("scripts/types/teams")
local Vector = require("scripts/types/vector")
local Assert = require("scripts/assert/assert")

local Square = {}

function Square:new(i, j, square_width, square_height)
  return {
    x = (i - 1) * square_width,
    y = (j - 1) * square_height,
    width = square_width,
    height = square_height,
    contains = 0,
    home = 0,
    away = 0,
  }
end

local function get_best_square(pos, squares)
    local best = nil
    for _, square in ipairs(squares) do
        if not best then
            best = square
        end
        -- TODO :
        -- * maybe we can make the position a little relative?
        -- * we should also look at square neighbours, to consider where the action isrunning
        -- * we should also consider whether the player is attacking or defending, but
        --    I actually think that we can just assume that they are attacking if we are looking at this?
        if square.contains < best.contains then
            best = square
        end
    end
    return best
end

function is_within_square(pos, square)
    return pos.x > square.x
        and pos.x < square.x + square.width
        and pos.y > square.y
        and pos.y < square.y + square.height
end

local AISystem = {
    possession = nil,
    puck = nil,
    squares = {},
    home_team = {},
    away_team = {}
}

function AISystem:init(entities)
    for _, entity in ipairs(entities) do
        if entity.tag == "puck" then
            self.puck = entity
        end
        if entity.tag == "player" then
            if entity.team.id == Teams.HOME then
                table.insert(self.home_team, entity)
            elseif entity.team.id == Teams.AWAY then
                table.insert(self.away_team, entity)
            else
                error(string.format("illegal team id value: %d", entity.team.id))
            end
        end
    end

    Assert.NotNil(self.puck, "no puck found for AISystem")

    EventBus:on("collision", function(collision_data)
        Assert.NotNil(collision_data)
        Assert.NotNil(collision_data.entity)
        Assert.NotNil(collision_data.velocity)
        Assert.NotNil(collision_data.static)

        local player = collision_data.entity
        if player.selected then
            return -- We don't want to do anything to our selected player
        end

        local static = collision_data.static
        if static.team and static.team.id ~= player.team.id then
            -- Tackle opponent ?
        end

        self:travel_to(
            player,
            player.position:add(collision_data.velocity:multiply(100))
        )
        -- self:reroute(player)
    end)

    EventBus:on("possession", function(entity)
        for _, player in ipairs(self.home_team) do
            player.travelling_to = nil
        end
        for _, player in ipairs(self.away_team) do
            player.travelling_to = nil
        end
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
    for i = 1, columns do
        for j = 1, rows do
            table.insert(squares, Square:new(i, j, square_width, square_height))
        end
    end

    for _, player in ipairs(self.home_team) do
        for i = 1, #squares do
            if is_within_square(player.position, squares[i]) then
                squares[i].contains = squares[i].contains + 1
                squares[i].home = squares[i].home + 1
            end
        end
    end

    for _, player in ipairs(self.away_team) do
        for i = 1, #squares do
            if is_within_square(player.position, squares[i]) then
                squares[i].contains = squares[i].contains + 1
                squares[i].away = squares[i].away + 1
            end
        end
    end


    self.squares = squares
end

function AISystem:is_travelling(player)
    if player.travelling_to then
        local distance = player.position:distance_to(player.travelling_to)
        if distance.direct > 50 then
            if player.attached and not player.selected then
                local should_shoot = love.math.random(1, 100) == 1
                if should_shoot then
                    EventBus:emit("shoot", player)
                end
                -- local should_pass = love.math.random(1, 100) == 1
                -- if should_pass then
                --     EventBus:emit("pass", player)
                -- end
            end
            return true
        end
        player.travelling_to = nil
        player.velocity = Vector:new(0, 0)
    end
    return false
end

function AISystem:reroute(player)
    local s = get_best_square(player, self.squares)
    local travel_to = Vector:new(
        love.math.random(s.x, s.x + s.width),
        love.math.random(s.y, s.y + s.height)
    )
    self:travel_to(player, travel_to)
end

function AISystem:travel_to(player, travel_to)
    local distance = travel_to:distance_to(player.position)
    player.travelling_to = travel_to
    player.velocity = Vector:new(
        distance.x / distance.direct,
        distance.y / distance.direct
    )
    player.direction = player.velocity:direction()
end

function AISystem:handle_team(dt, team, opponents, team_id)
    if not self.possession then
        for i = 1, #team do
            local player = team[i]
            if player.selected or player.travelling_to then
                goto continue
            end

            local distance = self.puck.position:distance_to(player.position)
            player.velocity = Vector:new(
                distance.x / distance.direct,
                distance.y / distance.direct
            )
            ::continue::
        end
        return
    end

    if self.possession.team.id == team_id then
        for _, player in ipairs(team) do
            if self:is_travelling(player) or player.selected then
                goto continue
            end

            self:reroute(player)
            ::continue::
        end
        return
    end

    if self.possession.team.id ~= team_id then
        local j = 1
        for i = 1, #team do
            local player = team[i]
            if self:is_travelling(player) or player.selected then
                goto continue
            end

            local distance = self.puck.position:distance_to(player.position)
            if distance.direct < 200 or j > #opponents then -- TODO : Fix this hacky bullshit
            else
                local opponent = opponents[j]
                distance = opponent.position:distance_to(player.position)
                j = j + 1
            end
            player.velocity = Vector:new(
                distance.x / distance.direct,
                distance.y / distance.direct
            )
            ::continue::
        end
    end
end

function AISystem:handle(dt)
    self:calculate_spatial_map()

    self:handle_team(dt, self.home_team, self.away_team, Teams.HOME)
    self:handle_team(dt, self.away_team, self.home_team, Teams.AWAY)
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
        love.graphics.print(
            string.format("%d (%d, %d)", square.contains, square.home, square.away),
            square.x + square.width / 2, square.y + square.height / 2)
    end

    for _, player in ipairs(self.home_team) do
        if player.travelling_to then
            love.graphics.rectangle("fill", player.travelling_to.x, player.travelling_to.y, 20, 20)
        end
    end
    for _, player in ipairs(self.away_team) do
        if player.travelling_to then
            love.graphics.rectangle("fill", player.travelling_to.x, player.travelling_to.y, 20, 20)
        end
    end
end

return AISystem
