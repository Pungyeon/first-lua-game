local Vector = require("scripts/types/vector")
local Rectangle = {}

function Rectangle:new(x, y, width, height)
    local obj = {
      x = x,
      y = y,
      width = width,
      height = height,
    }
    setmetatable(obj, self)
    self.__index = self

    return obj
end

function Rectangle:center()
  return Vector:new(
    self.x + self.width / 2,
    self.y + self.height / 2
  )
end

return Rectangle
