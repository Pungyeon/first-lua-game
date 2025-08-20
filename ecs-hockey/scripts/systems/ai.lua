local love = require("love")
local EventBus = require("scripts/types/event_bus")
local Color = require("scripts/types/color")
local Teams = require("scripts/types/teams")
local Rectangle = require("scripts/types/rectangle")
local Vector = require("scripts/types/vector")
local Assert = require("scripts/assert/assert")

local State = {
  InPossession = "in_possession",
  OutOfPosession = "out_of_possession",
  NonePossession = "none_posession"
}

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

local function get_best_square(player, squares, state)
    local relevant_squares = {}
    if state == State.InPossession then
      if player.team.id == Teams.HOME then
        relevant_squares = { 5,  6,  7,  8, 9, 10, 11, 12 }
      else
        relevant_squares = { 9, 10, 11, 12, 13, 14, 15, 16 }
      end
    end
    local best = nil
    for _, square_idx in ipairs(relevant_squares) do
        local square = squares[square_idx]
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

local function is_within_square(pos, square)
    return pos.x > square.x
        and pos.x < square.x + square.width
        and pos.y > square.y
        and pos.y < square.y + square.height
end

local AISystem = {
    pause = false,
    possession = nil,
    puck = nil,
    squares = {},
    home_team = {},
    away_team = {},
    goals = {},
    goalies = {}
}

function AISystem:init(entities)
    for _, entity in ipairs(entities) do
        if entity.tag == "puck" then
            self.puck = entity
        end
        if entity.tag == "goal" then
          self.goals[entity.team.id] = entity
        end
        if entity.tag == "goalie" then
          self.goalies[entity.team.id] = entity
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

    EventBus:on("goal", function(_)
      self.pause = true
    end)
    EventBus:on("reset", function(data)
      print(string.format("ai system pausing: %s", not data.complete))
      self.pause = not data.complete
    end)

    EventBus:on("collision", function(collision_data)
        Assert.NotNil(collision_data)
        Assert.NotNil(collision_data.entity)
        Assert.NotNil(collision_data.velocity)
        Assert.NotNil(collision_data.static)

        -- TODO : we need to handle the goalies here.

        local player = collision_data.entity
        if player.selected then
            return -- We don't want to do anything to our selected player
        end

        local static = collision_data.static
        if static.team and static.team.id ~= player.team.id then
            -- Tackle opponent
            EventBus:emit("tackle", { actor = player, victim = static })
            return
        end

        self:travel_to(
            player,
            player.position:add(collision_data.velocity:multiply(100))
        )
    end)

    EventBus:on("possession", function(entity)
        for _, player in ipairs(self.home_team) do
            player.travelling_to = nil
            player.velocity = Vector:new(0, 0)
        end
        for _, player in ipairs(self.away_team) do
            player.travelling_to = nil
            player.velocity = Vector:new(0, 0)
        end
        self.possession = entity
    end)
end

local columns = 5
local rows = 4
local screen_width, screen_height = love.window.getMode()
local square_width = screen_width / columns
local square_height = screen_height / rows

function AISystem:get_square(position)
  local sw = math.ceil(position.x / square_width);
  local sh = math.ceil(position.y / square_height);

  local index = sh + (columns * sw)
  return self.squares[index]
end

function AISystem:calculate_spatial_map()
    -- TODO : initialise this in initialise instead.

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

function lineLineIntersect(x1, y1, x2, y2, x3, y3, x4, y4)
  local denominator = (y4-y3)*(x2 -x1) - (x4-x3)*(y2-y1)
  if denominator == 0 then
    return false
  end
  local uA = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / denominator
  local uB = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / denominator

  if uA >= 0 and uA <= 1 and uB >= 0 and uB <= 1 then
    return true
  end
  return false
end

function lineRectIntersect(x1, y1, x2, y2, r)
  local left   = lineLineIntersect(x1, y1, x2, y2, r.x, r.y, r.x, r.y + r.height)
  local right  = lineLineIntersect(x1, y1, x2, y2, r.x + r.width, r.y, r.x + r.width, r.y + r.height)
  local top    = lineLineIntersect(x1, y1, x2, y2, r.x, r.y, r.x + r.width, r.y)
  local bottom = lineLineIntersect(x1, y1, x2, y2, r.x, r.y + r.height, r.x + r.width, r.y + r.height)

  return left or right or top or bottom
end

function AISystem:trigger_behaviour(player, opponents)
  local should_shoot = love.math.random(1, 20) == 1
  if not should_shoot then
    return
  end
  local goal = self.goals[player.team.id] -- Retrieve the target goal
  local target = Rectangle:from_entity(goal):center()
  local obstruction = false
  for _, op in ipairs(opponents) do
    local intersect = lineRectIntersect(
      player.position.x,
      player.position.y,
      target.x,
      target.y,
      Rectangle:from_entity(op)
    )
    if intersect then
      obstruction = true
    end
    print(string.format("intersect: %s, a.id: %d, b.id: %d", intersect, player.id, op.id))
  end

  if obstruction then
    print("Deciding to pass the puck!")
    EventBus:emit("pass", player)
  else
    EventBus:emit("shoot", player)
  end
end

-- TODO : Maybe we should rename this to 'handle_travelling?'
function AISystem:is_travelling(player, opponents)
    if player.travelling_to then
        local distance = player.position:distance_to(player.travelling_to)
        if distance.direct > 1 then
            if player.attached and not player.selected then
              AISystem:trigger_behaviour(player, opponents)
            end
            return true
        end
        player.travelling_to = nil
        player.velocity = Vector:new(0, 0)
    end
    return false
end

function AISystem:reroute(player, state)
    local s = get_best_square(player, self.squares, state)
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

-- Possession result constants
local NONE = 1
local IN_POSSESSION = 2
local OUT_OF_POSSESSION = 3

function AISystem:get_possession(team_id)
    if not self.possession then
        return NONE
    end
    if self.possession.team.id == team_id then
        return IN_POSSESSION
    end
    return OUT_OF_POSSESSION
end

function AISystem:should_ignore(player, opponents)
	return player.selected or self:is_travelling(player, opponents)
end

function AISystem:handle_none_possession(team, opponents)
    for i = 1, #team do
        local player = team[i]
        if self:should_ignore(player, opponents) then
            goto continue
        end

        local distance = self.puck.position:distance_to(player.position)
        player.velocity = Vector:new(
            distance.x / distance.direct,
            distance.y / distance.direct
        )
        ::continue::
    end
end

function AISystem:handle_in_possession(team, opponents)
for _, player in ipairs(team) do
    if self:should_ignore(player, opponents) then
            goto continue
        end

        self:reroute(player, State.InPossession)
        ::continue::
    end
end

function AISystem:handle_out_of_possession(team, opponents)
    local j = 1
    for i = 1, #team do
        local player = team[i]
        if self:should_ignore(player, opponents) then
            goto continue
        end

        local distance = self.puck.position:distance_to(player.position)
        if distance.direct < 200 or j > #opponents then -- TODO : Fix this hacky bullshit
          -- TODO : Possible to check for tackle here.
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

function AISystem:handle_team(_, team, opponents, team_id)
    local possession = self:get_possession(team_id)
    if possession == NONE then
        self:handle_none_possession(team, opponents)
    end
    if possession == IN_POSSESSION then
       self:handle_in_possession(team, opponents)
    end

    if possession == OUT_OF_POSSESSION then
        self:handle_out_of_possession(team, opponents)
    end
end

function AISystem:handle(dt)
    if self.pause then
      return
    end
    self:calculate_spatial_map()

    self:handle_team(dt, self.home_team, self.away_team, Teams.HOME)
    self:handle_team(dt, self.away_team, self.home_team, Teams.AWAY)

    local puck_center = Rectangle:from_entity(self.puck):center()
    for _, goalie in ipairs(self.goalies) do
      local goalie_center = Rectangle:from_entity(goalie):center()
      local goal = self.goals[goalie.team.id]
      local within_upper_bounds = goalie.position.y > goal.position.y
      local within_lower_bounds = goalie.position.y + goalie.dimensions.height < goal.position.y + goal.dimensions.height

      if goalie_center.y < puck_center and within_lower_bounds then
        goalie.velocity.y = 1
      elseif goalie_center.y  > puck_center and within_upper_bounds then
        goalie.velocity.y = -1
      else
        goalie.velocity.y = 0
      end
    end
end

function AISystem:debug()
    -- TODO : draw the square map
    for _, square in ipairs(self.squares) do
        love.graphics.setColor(Color.GRAY.red, Color.GRAY.green, Color.GRAY.blue)
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
