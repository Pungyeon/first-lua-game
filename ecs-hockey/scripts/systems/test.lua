local Vector = require("scripts/types/vector")
local Rectangle = require("scripts/types/rectangle")
local SystemTests = {}

function SystemTests:run()
  local start, stop = Vector:new(10, 10), Vector:new(100, 10)
  local rectangle = Rectangle:new(50, 5, 20, 20)
  local intersect = lineRectIntersect(start.x, start.y, stop.x, stop.y, rectangle)

  print(string.format("Testing Line/Rectangle intersect: (expected: true, actual: %s)", intersect))
  assert(intersect)
end

return SystemTests
