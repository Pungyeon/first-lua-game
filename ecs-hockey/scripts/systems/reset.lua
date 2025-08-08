local EventBus = require("scripts/types/event_bus")
local Vector = require("scripts/types/vector")
local love = require("love")

local screen_width, screen_height = love.window.getMode()

local ResetSystem = {
  in_progress = false,
  countdown = 0,
  entities = {}
}

function ResetSystem:init(entities)
  self.entities = entities

  EventBus:on("reset", function(data) -- the function doesn't use any input, perhaps at some point, we will
    print(string.format("reset system: { in_progress = %s }", not data.complete))
    self.in_progress = not data.complete
    if data.complete then
      return
    end

    for _, entity in ipairs(self.entities) do
      if entity.tag == "puck" then
        entity.position = Vector:new(screen_width/2, screen_height/2) -- Make sure that it's actually centered, this isn't
        entity.attached = nil
        entity.velocity = Vector:new(0, 0)
      end
      if entity.tag == "player" then
        entity.selected = nil
        entity.attached = nil
        print(string.format("resetting: { id = %s, home = %s }", entity.id, entity.reset_position:string()))
        local travel_to = entity.reset_position
        local distance = travel_to:distance_to(entity.position)
        entity.travelling_to = travel_to
        entity.velocity = Vector:new(
            distance.x / distance.direct,
            distance.y / distance.direct
        )
        entity.direction = entity.velocity:direction()
      end
    end
  end)
end

function ResetSystem:is_travelling(player)
    if player.travelling_to then
        local distance = player.position:distance_to(player.travelling_to)
        if distance.direct > 3 then
            return true
        end
        player.travelling_to = nil
        player.velocity = Vector:new(0, 0)
    end
    return false
end

function ResetSystem:handle(_)
  if not self.in_progress then
    return
  end

  if self.countdown > 0 then
    self.countdown = self.countdown - 1
    if self.countdown == 0 then
      print("FACE OFF!")
      EventBus:emit("reset", { complete = true })
    end
    return
  end

  local in_progress = false
  for _, entity in ipairs(self.entities) do
    if entity.tag == "player" then
      if self:is_travelling(entity) then
        in_progress = true
      end
    end
  end

  if not in_progress then
    self.countdown = 50
  end
end

return ResetSystem
