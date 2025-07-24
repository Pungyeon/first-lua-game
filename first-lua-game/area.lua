local function collision(a, b)
    return a.x < b.x + b.width and
        a.x + a.width > b.x and
        a.y < b.y + b.height and
        a.y + a.height > b.y
end

local function is_top_collision(a, b)
    return a.vy < 0
        and a.y < (b.y + b.height)
        and ((a.x < b.x + b.width) or (a.x + a.width > b.x))
end

local function is_bottom_collision(a, b)
    return a.vy > 0
        and a.y + a.height > b.y
        and ((a.x < b.x + b.width) or (a.x + a.width > b.x))
end

local function is_right_collision(a, b)
    return a.vx > 0
        and a.x + a.width > b.x
        and ((a.y < b.y + b.height) or (a.y + a.height > b.y))
end

local function is_left_collision(a, b)
    return a.vx < 0
        and a.x < b.x + b.width
        and ((a.y < b.y + b.height) or (a.y + a.height > b.y))
end

area = {
    CollisionResult = function(a, b)
        return {
            top = is_top_collision(a, b),
            right = is_right_collision(a, b),
            left = is_left_collision(a, b),
            bottom = is_bottom_collision(a, b),
        }
    end,
    Collision = collision,
    Contains = function(outer, inner)
        return inner.x >= outer.x and
            inner.y >= outer.y and
            inner.x + inner.width <= outer.x + outer.width and
            inner.y + inner.height <= outer.y + outer.height
    end
}

return area
