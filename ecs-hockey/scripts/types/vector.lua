Vector = {}

function Vector:new(x, y)
    local obj = {
        x = x,
        y = y,
    }
    setmetatable(obj, self)
    self.__index = self

    return obj
end

function Vector:string()
    return string.format("{ x: %f, y: %f }", self.x, self.y)
end

function Vector:distance_to(vector)
    local x = self.x - vector.x
    local y = self.y - vector.y
    return {
        x = x,
        y = y,
        direct = math.sqrt((x * x) + (y * y))
    }
end

return Vector
