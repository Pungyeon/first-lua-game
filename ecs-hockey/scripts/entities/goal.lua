local Vector = require("scripts/types/vector")
local Color = require("scripts/types/color")
local Goal = {}

function Goal:new(position, width, height, team) 
  return {
    position   = position,
    collision  = { type = "goal", width = width, height = height },
    dimensions = { width = width, height = height },
    team = team,
    color      = Color.DARK_GREEN,
    render     = { type = "rectangle" },
    tag        = "goal"
  }
end

return Goal
