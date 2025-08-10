local love = require("love")
local Rectangle = require("scripts/types/rectangle")
local Teams = require("scripts/types/teams")
local Color = require("scripts/types/color")

local LineCollisionDebugSystem = {
    goals = {},
    home_team = {},
    away_team = {}
}

function LineCollisionDebugSystem:init(entities)
    for _, entity in ipairs(entities) do
        if entity.tag == "goal" then
            self.goals[entity.team.id] = entity
            goto continue
        end
        if entity.tag == "player" then
          if entity.team.id == Teams.AWAY then
            table.insert(self.away_team, entity)
          else
            table.insert(self.home_team, entity)
          end
        end

        ::continue::
    end
end


local function lineLineIntersect(x1, y1, x2, y2, x3, y3, x4, y4)
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

local function lineRectIntersect(x1, y1, x2, y2, r)
  local left   = lineLineIntersect(x1, y1, x2, y2, r.x, r.y, r.x, r.y + r.height)
  local right  = lineLineIntersect(x1, y1, x2, y2, r.x + r.width, r.y, r.x + r.width, r.y + r.height)
  local top    = lineLineIntersect(x1, y1, x2, y2, r.x, r.y, r.x + r.width, r.y)
  local bottom = lineLineIntersect(x1, y1, x2, y2, r.x, r.y + r.height, r.x + r.width, r.y + r.height)

  return left or right or top or bottom
end

function LineCollisionDebugSystem:trigger_behaviour(player, opponents)
  local goal = self.goals[player.team.id] -- Retrieve the target goal
	local from = Rectangle:from_entity(player):center()
  local target = Rectangle:from_entity(goal):center()
  local obstruction = false
  for _, op in ipairs(opponents) do
    local intersect = lineRectIntersect(
      from.x,
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
    local c = Color.RED
    love.graphics.setColor(c.red, c.green, c.blue)
  end
  love.graphics.setLineWidth(5)
  love.graphics.line(player.position.x, player.position.y, target.x, target.y)
end

function LineCollisionDebugSystem:handle(dt)
end

function LineCollisionDebugSystem:draw()
    for _, player in ipairs(self.home_team) do
        if player.attached then
            self:trigger_behaviour(player, self.away_team)
        end
    end
    for _, player in ipairs(self.away_team) do
        if player.attached then
            self:trigger_behaviour(player, self.home_team)
        end
    end 
end

return LineCollisionDebugSystem