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

function Vector:add(vec)
    return Vector:new(self.x + vec.x, self.y + vec.y)
end

function Vector:multiply(n)
    return Vector:new(self.x * n, self.y * n)
end

function Vector:copy()
    return Vector:new(self.x, self.y)
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

function Vector:round()
    if self.x < 0 
end

return Vector
