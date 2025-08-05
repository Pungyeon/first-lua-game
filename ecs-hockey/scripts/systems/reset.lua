local EventBus = require("scripts/types/event_bus")
local Teams = require("scripts/types/teams")

local screen_width, screen_height = love.window.getMode()

local ResetSystem = {
  entities = {}
}

function ResetSystem:init(entities)
  self.entities = entities

  EventBus:on("reset", function(none) -- the function doesn't use any input, perhaps at some point, we will
    for _, entity in ipairs(self.entities) do
      if entity.tag == "puck" then
        puck.position = Vector:new(screen_width/2, screen_height/2) -- Make sure that it's actually centered, this isn't
      end
      if entity.tag == "player" then
        entity.travelling_to = entity.reset_position
      end
    end
  end)
end

return ResetSystem
